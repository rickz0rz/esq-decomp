BEGIN {
    has_entry = 0
    has_script_primary = 0
    has_script_secondary = 0
    has_primary_entry_select = 0
    has_secondary_entry_select = 0
    has_compare00 = 0
    has_compare11 = 0
    has_wildcard_match = 0
    has_fallback_type3 = 0
    has_select_by_label = 0
    has_default_selected_brush = 0
    setrast_calls = 0
    has_select_brush_slot = 0
    has_palette_mode_gate = 0
    has_plane_mask_copy = 0
    has_restore_palette = 0
    has_preserve_first12 = 0
    has_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^ESQFUNC_SELECTANDAPPLYBRUSHFORCURRENTENTRY:/ || uline ~ /^ESQFUNC_SELECTANDAPPLYBRUSHFORCU/) has_entry = 1
    if (uline ~ /BRUSH_SCRIPTPRIMARYSELECTION/) has_script_primary = 1
    if (uline ~ /BRUSH_SCRIPTSECONDARYSELECTION/) has_script_secondary = 1
    if (uline ~ /TEXTDISP_ACTIVEGROUPID/ || uline ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/) has_primary_entry_select = 1
    if (uline ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/) has_secondary_entry_select = 1
    if (uline ~ /ESQFUNC_TAG_00/) has_compare00 = 1
    if (uline ~ /ESQFUNC_TAG_11/) has_compare11 = 1
    if (uline ~ /ESQSHARED_JMPTBL_ESQ_WILDCARDMATCH/ || uline ~ /ESQSHARED_JMPTBL_ESQ_WILDCARDMAT/) has_wildcard_match = 1
    if (uline ~ /ESQFUNC_FALLBACKTYPE3BRUSHNODE/) has_fallback_type3 = 1
    if ((uline ~ /ESQIFF_JMPTBL_STRING_COMPAREN/ && uline ~ /\$21\(A[015]\)/) ||
        uline ~ /LEA \$21\(A5\),A1/ || uline ~ /ADDA\.W #\$21,A1/) has_select_by_label = 1
    if (uline ~ /BRUSH_SELECTEDNODE/ && (uline ~ /MOVE\.L/ || uline ~ /MOVEA\.L/)) has_default_selected_brush = 1
    if (uline ~ /_LVOSETRAST/) setrast_calls++
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHSLOT/ || uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHS/) has_select_brush_slot = 1
    if (uline ~ /TST\.L 328\(A0\)/ || uline ~ /LEA \$148\(A5\),A0/ || uline ~ /PALETTEMODE/) has_palette_mode_gate = 1
    if (uline ~ /BRUSH_PLANEMASKFORINDEX/ || uline ~ /ESQPARS_JMPTBL_BRUSH_PLANEMASKFORINDEX/ ||
        uline ~ /WDISP_PALETTETRIPLESRBASE/ || uline ~ /#\$E8/) has_plane_mask_copy = 1
    if (uline ~ /ESQIFF_RESTOREBASEPALETTETRIPLES/) has_restore_palette = 1
    if (uline ~ /MOVEQ #12,D0/ || uline ~ /MOVEQ\.L #\$C,D1/ || uline ~ /ESQFUNC_BASEPALETTERGBTRIPLES/) has_preserve_first12 = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SCRIPT_PRIMARY=" has_script_primary
    print "HAS_SCRIPT_SECONDARY=" has_script_secondary
    print "HAS_PRIMARY_ENTRY_SELECT=" has_primary_entry_select
    print "HAS_SECONDARY_ENTRY_SELECT=" has_secondary_entry_select
    print "HAS_COMPARE00=" has_compare00
    print "HAS_COMPARE11=" has_compare11
    print "HAS_WILDCARD_MATCH=" has_wildcard_match
    print "HAS_FALLBACK_TYPE3=" has_fallback_type3
    print "HAS_SELECT_BY_LABEL=" has_select_by_label
    print "HAS_DEFAULT_SELECTED_BRUSH=" has_default_selected_brush
    print "HAS_TWO_SETRAST_CALLS=" (setrast_calls >= 2 ? 1 : 0)
    print "HAS_SELECT_BRUSH_SLOT=" has_select_brush_slot
    print "HAS_PALETTE_MODE_GATE=" has_palette_mode_gate
    print "HAS_PLANE_MASK_COPY=" has_plane_mask_copy
    print "HAS_RESTORE_PALETTE=" has_restore_palette
    print "HAS_PRESERVE_FIRST12=" has_preserve_first12
    print "HAS_RETURN=" has_return
}
