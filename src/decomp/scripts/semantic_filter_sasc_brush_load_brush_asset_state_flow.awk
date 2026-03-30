BEGIN {
    has_label = 0

    file_stage = 0
    has_file_decode_flow = 0
    has_close_after_file_stage = 0

    clamp_stage = 0
    has_mode_clamp = 0

    oversize_stage = 0
    has_oversize_alert_flow = 0

    node_stage = 0
    has_node_setup_flow = 0

    plane_alloc_stage = 0
    has_plane_alloc_flow = 0

    alert_stage = 0
    has_plane_alert_flow = 0

    cleanup_stage = 0
    has_partial_cleanup_flow = 0

    decode_stage = 0
    has_decode_restore_flow = 0

    clone_stage = 0
    has_type11_clone_flow = 0

    finish_stage = 0
    has_finish_flow = 0

    saw_file_open = 0
    saw_file_read = 0
    saw_form_compare = 0
    saw_seek_reset = 0
    saw_decode_alloc = 0
    saw_ilbm_call = 0
    saw_mode_btst = 0
    saw_alt_depth_assign = 0
    saw_alt_width_assign = 0
    saw_type11_cmp = 0
    saw_clone_alloc = 0
    saw_clone_type_store = 0
    saw_clone_dims_copy = 0
    saw_clone_field148 = 0
    saw_clone_zero368 = 0
    saw_state_copy = 0
    saw_row_words_calc = 0
    saw_packbits = 0
    saw_plane_restore = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function advance_stage(stage, target) {
    if (stage == target - 1) {
        return target
    }
    return stage
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^BRUSH_LOADBRUSHASSET[A-Z0-9_]*:/) {
        has_label = 1
    }

    if (u ~ /DOS_OPENFILEWITHMODE/ || u ~ /GROUP_AG_JMPTBL_DOS_OPENFILEWITHMO/ || u ~ /GROUP_AG_JMPTBL_DOS_OPENFILEWITH/) {
        saw_file_open = 1
        file_stage = advance_stage(file_stage, 1)
    }
    if (u ~ /_LVOREAD|LVOREAD/) {
        saw_file_read = 1
        if (file_stage >= 1) {
            file_stage = advance_stage(file_stage, 2)
        }
    }
    if ((u ~ /GROUP_AA_JMPTBL_STRING_COMPAR/ || u ~ /STRING_COMPAREN/) &&
        (u ~ /BRUSH_STR_IFF_FORM|IFF_FORM|FORM/ || saw_file_read)) {
        saw_form_compare = 1
        if (file_stage >= 2) {
            file_stage = advance_stage(file_stage, 3)
        }
    }
    if (u ~ /_LVOSEEK|LVOSEEK/) {
        saw_seek_reset = 1
        if (file_stage >= 3) {
            file_stage = advance_stage(file_stage, 4)
        }
    }
    if ((u ~ /130000|#\$1FBD0/) && (u ~ /GLOBAL_STR_BRUSH_C_10/ || saw_seek_reset)) {
        saw_decode_alloc = 1
        if (file_stage >= 4) {
            file_stage = advance_stage(file_stage, 5)
        }
    }
    if (u ~ /BITMAP_PROCESSILBMIMAGE|BITMAP_PROCESSILBMIMAG/) {
        saw_ilbm_call = 1
        if (file_stage >= 5) {
            file_stage = advance_stage(file_stage, 6)
        }
    }
    if (u ~ /_LVOCLOSE|LVOCLOSE/) {
        has_close_after_file_stage = 1
        if (file_stage >= 3) {
            has_file_decode_flow = 1
        }
    }

    if (u ~ /BTST[[:space:]]+#7|BTST[[:space:]]+#\$7/) {
        saw_mode_btst = 1
        clamp_stage = advance_stage(clamp_stage, 1)
    }
    if (u ~ /#640|#\$280/ ||
        u ~ /MOVEQ(\.L)? #\$50,D0/ ||
        u ~ /MOVEQ(\.L)? #80,D0/ ||
        u ~ /LSL\.L #\$3,D0/ ||
        u ~ /LSL\.L #3,D0/) {
        saw_alt_width_assign = 1
    }
    if (u ~ /MOVEQ(\.L)? #4,D[05]/ ||
        u ~ /MOVEQ(\.L)? #\$4,D[05]/ ||
        u ~ /MOVE\.L D0,-54\(A5\)/ ||
        u ~ /MOVE\.L D0,D5/) {
        saw_alt_depth_assign = 1
    }
    if (u ~ /_LVOFORBID|LVOFORBID/) {
        oversize_stage = advance_stage(oversize_stage, 1)
    }
    if (oversize_stage >= 1 &&
        (u ~ /BRUSH_PENDINGALERTCODE/ || u ~ /MOVEQ(\.L)? #2,D[012]/ || u ~ /MOVEQ(\.L)? #3,D[012]/ || u ~ /SCC D1/ || u ~ /SUB\.B D1,D2/)) {
        oversize_stage = advance_stage(oversize_stage, 2)
    }
    if (oversize_stage >= 2 &&
        (u ~ /BRUSH_SNAPSHOTWIDTH/ || u ~ /BRUSH_SNAPSHOTDEPTH/)) {
        oversize_stage = advance_stage(oversize_stage, 3)
    }
    if (oversize_stage >= 3 &&
        (u ~ /BRUSH_SNAPSHOTHEADER/ || u ~ /MOVE\.B \(A0\),\(A1\)\+/ || u ~ /MOVE\.B \(A0\)\+\,D0/)) {
        oversize_stage = advance_stage(oversize_stage, 4)
    }
    if (oversize_stage >= 4 && (u ~ /_LVOPERMIT|LVOPERMIT/)) {
        has_oversize_alert_flow = 1
    }

    if ((u ~ /GLOBAL_STR_BRUSH_C_11/ || u ~ /#372|#\$174/) && node_stage == 0) {
        node_stage = advance_stage(node_stage, 1)
    }
    if (node_stage >= 1 &&
        (u ~ /ADD\.W #\$B0,A0|ADDA\.W #176,A0|LEA \$B0\(A0\),A1/)) {
        node_stage = advance_stage(node_stage, 2)
    }
    if (node_stage >= 2 &&
        (u ~ /ADDA\.W #196,A0|ADD\.W #\$C4,A1|LEA \$170\(A0\),A1|CLR\.L 368\(A0\)|CLR\.L \(A1\)/)) {
        node_stage = advance_stage(node_stage, 3)
    }
    if (node_stage >= 3 && (u ~ /_LVOINITBITMAP|LVOINITBITMAP/)) {
        node_stage = advance_stage(node_stage, 4)
    }
    if (node_stage >= 4 &&
        (u ~ /LEA 200\(A0\),A2|ADD\.W #\$C8,A0|LEA \$C8\(A0\),A1/)) {
        node_stage = advance_stage(node_stage, 5)
    }
    if (node_stage >= 5 &&
        (u ~ /214\(A3\)|\$D6\(A5\)|348\(A0\)|\$15C\(A0\)|218\(A3\)|\$DA\(A5\)|352\(A0\)|\$160\(A0\)/)) {
        has_node_setup_flow = 1
    }

    if (u ~ /GRAPHICS_ALLOCRASTER|GROUP_AA_JMPTBL_GRAPHICS_ALLOCRA/) {
        plane_alloc_stage = advance_stage(plane_alloc_stage, 1)
    }
    if (plane_alloc_stage >= 1 &&
        (u ~ /MOVE\.L D0,-42\(A5,D1\.L\)|MOVE\.L D0,\$24\(A7,D2\.L\)|LEA \$90\(A0\),A1|MOVE\.L D0,\(A1\)/)) {
        plane_alloc_stage = advance_stage(plane_alloc_stage, 2)
    }
    if (plane_alloc_stage >= 2 &&
        (u ~ /ADDQ\.L #1,D6|ADDQ\.L #1,\$50\(A7\)|BRA\.W ___BRUSH_LOADBRUSHASSET__44/)) {
        has_plane_alloc_flow = 1
    }

    if (u ~ /TST\.L BRUSH_PENDINGALERTCODE/) {
        alert_stage = advance_stage(alert_stage, 1)
    }
    if (alert_stage >= 1 &&
        (u ~ /MOVEQ(\.L)? #1,D0/ || u ~ /BRUSH_PENDINGALERTCODE/)) {
        alert_stage = advance_stage(alert_stage, 2)
    }
    if (alert_stage >= 2 &&
        (u ~ /BRUSH_SNAPSHOTHEADER/ || u ~ /MOVE\.B \(A0\),\(A1\)\+/ || u ~ /MOVE\.B \(A0\)\+\,D0/)) {
        alert_stage = advance_stage(alert_stage, 3)
    }
    if (alert_stage >= 3 && (u ~ /_LVOPERMIT|LVOPERMIT/)) {
        has_plane_alert_flow = 1
    }

    if (u ~ /GRAPHICS_FREERASTER|GROUP_AB_JMPTBL_GRAPHICS_FREERAS/) {
        cleanup_stage = advance_stage(cleanup_stage, 1)
    }
    if (cleanup_stage >= 1 &&
        (u ~ /GLOBAL_STR_BRUSH_C_14|#1205|#\$4B5/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/)) {
        cleanup_stage = advance_stage(cleanup_stage, 2)
    }
    if (cleanup_stage >= 2 &&
        (u ~ /MOVE\.L A0,\$5C\(A7\)|MOVE\.L D0,-16\(A5\)|SUB\.L A0,A0/)) {
        has_partial_cleanup_flow = 1
    }

    if (u ~ /_LVOINITRASTPORT|LVOINITRASTPORT/) {
        decode_stage = advance_stage(decode_stage, 1)
    }
    if (u ~ /#\$E8|ADDI?\.L #\$E8|ADD\.L #\$E8/ || u ~ /MOVEQ(\.L)? #\$60,D[01]/ || u ~ /MOVEQ #96,D0/) {
        saw_state_copy = 1
    }
    if (decode_stage >= 1 &&
        (u ~ /#\$E8|ADDI?\.L #\$E8|ADD\.L #\$E8/ || u ~ /MOVEQ(\.L)? #\$60,D[01]/ || u ~ /MOVEQ #96,D0/)) {
        decode_stage = advance_stage(decode_stage, 2)
    }
    if (u ~ /GROUP_AG_JMPTBL_MATH_DIVS32|MATH_DIVS32/ || u ~ /PEA \(\$10\)\.W/ || u ~ /MOVEQ(\.L)? #\$F,D1/) {
        saw_row_words_calc = 1
    }
    if (decode_stage >= 2 &&
        (u ~ /GROUP_AG_JMPTBL_MATH_DIVS32|MATH_DIVS32/ || u ~ /PEA \(\$10\)\.W/ || u ~ /MOVEQ(\.L)? #\$F,D1/)) {
        decode_stage = advance_stage(decode_stage, 3)
    }
    if (u ~ /ESQ_PACKBITSDECODE|PACKBITSDECODE/) {
        saw_packbits = 1
    }
    if (decode_stage >= 3 && (u ~ /ESQ_PACKBITSDECODE|PACKBITSDECODE/)) {
        decode_stage = advance_stage(decode_stage, 4)
    }
    if (u ~ /MOVE\.L \$24\(A7,D0\.L\),\(A1\)/ ||
        u ~ /MOVE\.L -42\(A5,D0\.L\),0\(A0,D0\.L\)/ ||
        u ~ /MOVE\.L -42\(A5,D0\.L\),0\(A0,D1\.L\)/ ||
        u ~ /MOVE\.L -42\(A5,D0\.L\),\(A1\)/ ||
        u ~ /MOVE\.L \$24\(A7,D0\.L\),0\(A0,D0\.L\)/ ||
        u ~ /LEA \$90\(A0\),A1/) {
        saw_plane_restore = 1
    }
    if (u ~ /MOVEQ(\.L)? #\$B,D0|MOVEQ(\.L)? #11,D0|CMP\.B .*190\(A3\)|CMP\.B \$BE\(A5\),D0/) {
        saw_type11_cmp = 1
    }
    if (saw_type11_cmp &&
        (u ~ /GLOBAL_STR_BRUSH_C_15|#1220|#\$4C4/)) {
        saw_clone_alloc = 1
        clone_stage = advance_stage(clone_stage, 1)
    }
    if (u ~ /MOVE\.B \$BE\(A5\),\$20\(A0\)|MOVE\.B 190\(A3\),32\(A0\)/) {
        saw_clone_type_store = 1
    }
    if (clone_stage >= 1 &&
        (u ~ /MOVE\.B \$BE\(A5\),\$20\(A0\)|MOVE\.B 190\(A3\),32\(A0\)/)) {
        clone_stage = advance_stage(clone_stage, 2)
    }
    if (u ~ /ADD\.W #\$B0,A0|ADDA\.W #176,A0|LEA \$B0\(A0\),A1|LEA 176\(A0\),A1|LEA 128\(A3\),A2/) {
        saw_clone_dims_copy = 1
    }
    if (clone_stage >= 2 &&
        (u ~ /ADD\.W #\$B0,A0|ADDA\.W #176,A0|LEA \$B0\(A0\),A1/)) {
        clone_stage = advance_stage(clone_stage, 3)
    }
    if (u ~ /ADDA\.W #196,A0|ADD\.W #\$C4,A1/) {
        saw_clone_field148 = 1
    }
    if (u ~ /LEA \$170\(A0\),A1|CLR\.L 368\(A0\)|CLR\.L \(A1\)|MOVE\.L A0,368\(A1\)/) {
        saw_clone_zero368 = 1
    }
    if ((u ~ /GLOBAL_STR_BRUSH_C_16|#1236|#\$4D4/) &&
        (u ~ /130000|#\$1FBD0/ || finish_stage >= 0)) {
        finish_stage = advance_stage(finish_stage, 1)
    }
    if (finish_stage >= 1 &&
        (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/ || u ~ /MEMORY_DEALLOCATEMEMORY/)) {
        finish_stage = advance_stage(finish_stage, 2)
    }
    if (finish_stage >= 2 &&
        (u ~ /MOVE\.L \$5C\(A7\),D0|MOVE\.L -16\(A5\),D0/)) {
        finish_stage = advance_stage(finish_stage, 3)
    }
    if (finish_stage >= 3 && u == "RTS") {
        has_finish_flow = 1
    }
}

END {
    has_mode_clamp = (saw_mode_btst && saw_alt_depth_assign && saw_alt_width_assign) ? 1 : 0
    has_decode_restore_flow = (decode_stage >= 4 &&
        saw_state_copy &&
        saw_row_words_calc &&
        saw_packbits &&
        saw_plane_restore) ? 1 : 0
    has_type11_clone_flow = (saw_type11_cmp &&
        saw_clone_alloc &&
        saw_clone_type_store &&
        saw_clone_dims_copy &&
        saw_clone_field148 &&
        saw_clone_zero368) ? 1 : 0

    print "HAS_LABEL=" has_label
    print "HAS_FILE_DECODE_FLOW=" has_file_decode_flow
    print "HAS_CLOSE_AFTER_FILE_STAGE=" has_close_after_file_stage
    print "HAS_MODE_CLAMP=" has_mode_clamp
    print "HAS_OVERSIZE_ALERT_FLOW=" has_oversize_alert_flow
    print "HAS_NODE_SETUP_FLOW=" has_node_setup_flow
    print "HAS_PLANE_ALLOC_FLOW=" has_plane_alloc_flow
    print "HAS_PLANE_ALERT_FLOW=" has_plane_alert_flow
    print "HAS_PARTIAL_CLEANUP_FLOW=" has_partial_cleanup_flow
    print "HAS_DECODE_RESTORE_FLOW=" has_decode_restore_flow
    print "HAS_TYPE11_CLONE_FLOW=" has_type11_clone_flow
    print "HAS_FINISH_FLOW=" has_finish_flow
}
