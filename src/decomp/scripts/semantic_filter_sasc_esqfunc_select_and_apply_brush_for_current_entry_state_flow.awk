BEGIN {
    step_count = 0
    setrast_calls = 0
    restore_calls = 0
    has_script_selection_hit = 0
    pending_tag00 = 0
    pending_tag11 = 0
    pending_label_compare = 0
    pending_script_selected = 0
    pending_default_selected = 0
    pending_blit_guard = 0
    palette_copy_window = 0
    palette_copy_dst = 0
    palette_copy_src = 0
    preserve_window = 0
    preserve_dst = 0
    preserve_src = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (seen[tag] != 1) {
        seen[tag] = 1
        steps[++step_count] = tag
    }
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^ESQFUNC_SELECTANDAPPLYBRUSHFORCURRENTENTRY[A-Z0-9_]*:/ ||
        u ~ /^ESQFUNC_SELECTANDAPPLYBRUSHFORCU[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /BRUSH_SCRIPTPRIMARYSELECTION/) {
        mark("SCRIPT_PRIMARY_SLOT")
        pending_script_selected = 1
    }

    if (u ~ /BRUSH_SCRIPTSECONDARYSELECTION/) {
        mark("SCRIPT_SECONDARY_SLOT")
        pending_script_selected = 1
    }

    if (u ~ /MOVE\.L -24\(A5\),-4\(A5\)/ ||
        u ~ /MOVE\.L A3,A5/ ||
        (pending_script_selected && u ~ /FOUNDBRUSH = ESQFUNC_TRUE/)) {
        has_script_selection_hit = 1
        pending_script_selected = 0
    }

    if (u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/) {
        mark("PRIMARY_ENTRY_PTR")
    }

    if (u ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/) {
        mark("SECONDARY_ENTRY_PTR")
    }

    if (u ~ /ESQFUNC_TAG_00/) {
        pending_tag00 = 1
    }

    if (pending_tag00 && u ~ /COMPAREN/) {
        mark("COMPARE_TAG00")
        pending_tag00 = 0
    }

    if (u ~ /ESQFUNC_TAG_11/) {
        pending_tag11 = 1
    }

    if (pending_tag11 && u ~ /COMPAREN/) {
        mark("COMPARE_TAG11")
        pending_tag11 = 0
    }

    if (u ~ /WILDCARDMATCH/ || u ~ /WILDCARDMAT$/) {
        mark("WILDCARD_MATCH")
    }

    if (u ~ /ESQFUNC_FALLBACKTYPE3BRUSHNODE/) {
        mark("TYPE3_FALLBACK")
    }

    if (u ~ /LEA \$21\(A[015]\),A1/ ||
        u ~ /ADDA\.W #\$21,A1/ ||
        u ~ /BRUSH_LABEL_OFFSET/) {
        pending_label_compare = 1
    }

    if ((u ~ /COMPAREN/ && u ~ /\$21\(A[015]\)/) ||
        (pending_label_compare && u ~ /COMPAREN/)) {
        mark("LABEL_COMPARE")
        pending_label_compare = 0
    }

    if (u ~ /TST\.L D[56]/) {
        pending_default_selected = 1
        pending_blit_guard = 1
    }

    if (pending_default_selected &&
        (u ~ /MOVE\.L BRUSH_SELECTEDNODE,-4\(A5\)/ ||
         u ~ /MOVE\.L BRUSH_SELECTEDNODE\(A4\),A5/ ||
         u ~ /BRUSHNODE = BRUSH_SELECTEDNODE/)) {
        mark("DEFAULT_SELECTED_BRUSH")
        pending_default_selected = 0
    }

    if (pending_blit_guard &&
        (u ~ /TST\.L BRUSH_SELECTEDNODE/ ||
         u ~ /TST\.L BRUSH_SELECTEDNODE\(A4\)/ ||
         u ~ /BRUSH_SELECTEDNODE != \(ESQFUNC_BRUSHNODE \*\)0/)) {
        mark("BLIT_GUARD_SELECTED_NODE")
    }

    if (pending_blit_guard &&
        (u ~ /TST\.L D[56]/ ||
         u ~ /FOUNDBRUSH != ESQFUNC_FALSE/)) {
        mark("BLIT_GUARD_FOUND_MATCH")
    }

    if (u ~ /_LVOSETRAST/) {
        setrast_calls++
        if (setrast_calls == 1) {
            mark("CLEAR_RAST_PRIMARY")
        } else if (setrast_calls == 2) {
            mark("CLEAR_RAST_SECONDARY")
        }
    }

    if (u ~ /BRUSH_SELECTBRUSHSLOT/ || u ~ /BRUSH_SELECTBRUSHS$/) {
        mark("BLIT_BRUSH")
        pending_blit_guard = 0
    }

    if (u ~ /TST\.L 328\(A0\)/ ||
        u ~ /MOVE\.L 328\(A0\),D0/ ||
        u ~ /LEA \$148\(A5\),A0/ ||
        u ~ /MOVE\.L \(A0\),D5/) {
        mark("PALETTE_MODE_READ")
        palette_copy_window = 1
    }

    if (u ~ /BRUSH_PLANEMASKFORINDEX/ && seen["PALETTE_MODE_READ"]) {
        mark("PALETTE_COPY_BOUNDS")
    }

    if (palette_copy_window && u ~ /WDISP_PALETTETRIPLESRBASE/) {
        palette_copy_dst = 1
    }

    if (palette_copy_window &&
        (u ~ /#\$E8/ || u ~ /\$E8\(/ || u ~ /\$E8,D1/ || u ~ /BRUSH_PALETTE_BYTES_OFFSET/)) {
        palette_copy_src = 1
    }

    if (palette_copy_dst && palette_copy_src) {
        mark("PALETTE_COPY_LOOP")
        palette_copy_window = 0
    }

    if (u ~ /MOVEQ #12,D0/ || u ~ /MOVEQ\.L #\$C,D1/) {
        preserve_window = 1
    }

    if (preserve_window && u ~ /WDISP_PALETTETRIPLESRBASE/) {
        preserve_dst = 1
    }

    if (preserve_window && u ~ /ESQFUNC_BASEPALETTERGBTRIPLES/) {
        preserve_src = 1
    }

    if (preserve_src && preserve_dst) {
        mark("PRESERVE_FIRST12")
        preserve_window = 0
    }

    if (u ~ /ESQIFF_RESTOREBASEPALETTETRIPLES/) {
        restore_calls++
        if (restore_calls == 1) {
            mark("RESTORE_BASE_MODE1")
        } else if (restore_calls == 2) {
            mark("RESTORE_BASE_NO_BRUSH")
        }
    }

    if (u == "RTS") {
        mark("RTS")
    }
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
    print "HAS_SCRIPT_SELECTION_HIT=" has_script_selection_hit
}
