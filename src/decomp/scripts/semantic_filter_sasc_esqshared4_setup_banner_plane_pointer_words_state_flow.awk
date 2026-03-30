BEGIN {
    seen_entry = 0
    seen_threshold = 0
    seen_setbase = 0
    seen_rts = 0
    plane = -1

    for (i = 0; i < 3; ++i) {
        seen_base[i] = 0
        seen_snap_scratch[i] = 0
        seen_alt_scratch[i] = 0
        seen_dst_ptr[i] = 0
        seen_reset_ptr[i] = 0
        seen_sweep_src[i] = 0
        seen_sweep_reset[i] = 0
        emitted_dst_reset[i] = 0
        emitted_sweep_reset[i] = 0
    }
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function emit_once(key, text) {
    if (!(key in emitted)) {
        emitted[key] = 1
        print text
    }
}

function maybe_emit_plane_groups(i) {
    if (!emitted_dst_reset[i] && seen_dst_ptr[i] && seen_reset_ptr[i]) {
        emitted_dst_reset[i] = 1
        emit_once("dst_reset" i, "PLANE" i "_DST_AND_RESET_READY")
    }
    if (!emitted_sweep_reset[i] && seen_sweep_src[i] && seen_sweep_reset[i]) {
        emitted_sweep_reset[i] = 1
        emit_once("sweep_reset" i, "PLANE" i "_SWEEP_AND_RESET_READY")
    }
}

function set_plane_from_line(u) {
    if (u ~ /BANNERROWSCRATCHRASTERBASE0/ || u ~ /BANNERROWSCRATCHRASTER\(A4\)/) {
        if (!seen_base[0]) {
            plane = 0
            seen_base[0] = 1
            emit_once("base0", "PLANE0_BASE")
            return 1
        } else if (!seen_base[1]) {
            plane = 1
            seen_base[1] = 1
            emit_once("base1", "PLANE1_BASE")
            return 1
        } else if (!seen_base[2]) {
            plane = 2
            seen_base[2] = 1
            emit_once("base2", "PLANE2_BASE")
            return 1
        }
    }
    if (u ~ /BANNERROWSCRATCHRASTERBASE1/) {
        plane = 1
        if (!seen_base[1]) {
            seen_base[1] = 1
            emit_once("base1", "PLANE1_BASE")
        }
        return 1
    }
    if (u ~ /BANNERROWSCRATCHRASTERBASE2/) {
        plane = 2
        if (!seen_base[2]) {
            seen_base[2] = 1
            emit_once("base2", "PLANE2_BASE")
        }
        return 1
    }
    return 0
}

{
    u = norm($0)
    if (u == "") {
        next
    }

    if (u ~ /^ESQSHARED4_SETUPBANNERPLANEPOINTERWORDS:/ || u ~ /^ESQSHARED4_SETUPBANNERPLANEPOINT[A-Z0-9_]*:/) {
        seen_entry = 1
        emit_once("entry", "ENTRY")
        next
    }

    set_plane_from_line(u)

    if (plane >= 0) {
        if (!seen_snap_scratch[plane] &&
            (u ~ ("BANNERPLANE" plane "SNAPSHOTSCRATCHPTR") ||
             u ~ ("BANNERPLANE" plane "SNAPSHOTSCRATCHP"))) {
            seen_snap_scratch[plane] = 1
            emit_once("snap_scratch" plane, "PLANE" plane "_SNAPSHOT_SCRATCH")
        }

        if (!seen_alt_scratch[plane] &&
            (u ~ ("BANNERPLANE" plane "SCRATCHPTRALT") ||
             u ~ ("BANNERPLANE" plane "SCRATCHPTRALT_"))) {
            seen_alt_scratch[plane] = 1
            emit_once("alt_scratch" plane, "PLANE" plane "_ALT_SCRATCH")
        }

        if (!seen_dst_ptr[plane] &&
            (u ~ ("BANNERSNAPSHOTPLANE" plane "DSTPTR") ||
             u ~ ("BANNERSNAPSHOTPLANE" plane "DST"))) {
            seen_dst_ptr[plane] = 1
            maybe_emit_plane_groups(plane)
        }

        if (!seen_reset_ptr[plane] &&
            ((plane < 2 && u ~ ("BANNERROWOFFSETRESETPTRPLANE" plane)) ||
             (plane == 2 && (u ~ /BANNERROWOFFSETRESETPTRPLANE2TABLE/ || u ~ /BANNERROWOFFSETRESETPTR/)) ||
             u ~ ("BANNERPLANE" plane "DSTPTRRESET"))) {
            seen_reset_ptr[plane] = 1
            maybe_emit_plane_groups(plane)
        }

        if (!seen_sweep_src[plane] &&
            (u ~ ("BANNERSWEEPSRCPLANE" plane "PTR_HI") ||
             u ~ ("BANNERSWEEPSRCPLANE" plane "PTR_LO") ||
             u ~ ("BANNERSWEEPSRCPLANE" plane "PTR_HIWO") ||
             u ~ ("BANNERSWEEPSRCPLANE" plane "PTR_LOWO") ||
             u ~ ("BANNERSWEEPSRCPLANE" plane "PTRRESET"))) {
            seen_sweep_src[plane] = 1
            maybe_emit_plane_groups(plane)
        }

        if (!seen_sweep_reset[plane] &&
            (u ~ ("BANNERSWEEPSRCPLANE" plane "PTRRESET") ||
             u ~ ("BANNERSWEEPSRCPLANE" plane "PTRRESET_"))) {
            seen_sweep_reset[plane] = 1
            maybe_emit_plane_groups(plane)
        }
    }

    if (!seen_threshold &&
        (u ~ /ESQPARS2_BANNERCOLORTHRESHOLD/ ||
         (u ~ /^MOVE\.W .*?,D0$/ && prev ~ /ESQPARS2_BANNERCOLORTHRESHOLD/) ||
         u ~ /^MOVE\.W .*?,D7$/)) {
        seen_threshold = 1
        emit_once("threshold", "COLOR_THRESHOLD")
    }

    if (!seen_setbase &&
        (u ~ /ESQSHARED4_SETBANNERCOLORBASEANDLIMIT/ ||
         u ~ /ESQSHARED4_SETBANNERCOLORBASEAND$/)) {
        seen_setbase = 1
        emit_once("setbase", "CALL_SETBASE")
    }

    if (!seen_rts && u == "RTS") {
        seen_rts = 1
        emit_once("rts", "RTS")
    }

    prev = u
}
