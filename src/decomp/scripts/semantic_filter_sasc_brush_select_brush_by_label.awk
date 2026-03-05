BEGIN {
    has_entry = 0
    has_compare_n_call = 0
    has_copy_pad_nul_call = 0
    has_find_pred_call = 0
    has_next_offset = 0
    has_alias_strings = 0
    has_selected_store = 0
    has_script_store = 0
    has_rts = 0
}

function trim(s,    t) {
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
    u = toupper(line)

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /STRING_COMPAREN/ || u ~ /_GROUP_AA_JMPTBL_STRING_COMPAREN/ || u ~ /GROUP_AA_JMPTBL_STRING_COMPAR/ || u ~ /_GROUP_AA_JMPTBL_STRING_COMPAR/) has_compare_n_call = 1
    if (u ~ /STRING_COPYPADNUL/ || u ~ /_GROUP_AG_JMPTBL_STRING_COPYPADNUL/ || u ~ /GROUP_AG_JMPTBL_STRING_COPYPAD/ || u ~ /_GROUP_AG_JMPTBL_STRING_COPYPAD/) has_copy_pad_nul_call = 1
    if (u ~ /BRUSH_FINDBRUSHBYPREDICATE/ || u ~ /_BRUSH_FINDBRUSHBYPREDICATE/ || u ~ /BRUSH_FINDBRUSHBYPRED/ || u ~ /_BRUSH_FINDBRUSHBYPRED/) has_find_pred_call = 1
    if (u ~ /368\(/ || u ~ /\(368,/ || u ~ /#\$170/ || u ~ /#368/ || u ~ /\$170\([AD][0-7]\)/) has_next_offset = 1
    if (u ~ /BRUSH_STR_ALIAS_CODE_00|BRUSH_STR_ALIAS_CODE_11|BRUSH_STR_ALIAS_CODE_DT/ || u ~ /BRUSH_STR_ALIAS_CODE_0/ || u ~ /BRUSH_STR_ALIAS_CODE_D/) has_alias_strings = 1
    if (u ~ /BRUSH_SELECTEDNODE/) has_selected_store = 1
    if (u ~ /BRUSH_SCRIPTPRIMARYSELECTION|BRUSH_SCRIPTSECONDARYSELECTION/) has_script_store = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_COMPARE_N_CALL=" has_compare_n_call
    print "HAS_COPY_PAD_NUL_CALL=" has_copy_pad_nul_call
    print "HAS_FIND_PREDICATE_CALL=" has_find_pred_call
    print "HAS_NEXT_OFFSET_368=" has_next_offset
    print "HAS_ALIAS_STRINGS=" has_alias_strings
    print "HAS_SELECTED_NODE_STORE=" has_selected_store
    print "HAS_SCRIPT_SELECTION_STORES=" has_script_store
    print "HAS_RTS=" has_rts
}
