BEGIN {
    label = 0
    has_compare_n_call = 0
    has_copy_pad_nul_call = 0
    has_find_pred_call = 0
    has_next_offset = 0
    has_alias_strings = 0
    has_selected_store = 0
    has_script_store = 0
    has_return = 0
}

/^BRUSH_SelectBrushByLabel:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /STRING_COMPAREN/) has_compare_n_call = 1
    if (line ~ /STRING_COPYPADNUL/) has_copy_pad_nul_call = 1
    if (line ~ /BRUSH_FINDBRUSHBYPREDICATE/) has_find_pred_call = 1
    if (line ~ /368\(/ || line ~ /\(368,/ || line ~ /#\$170/ || line ~ /#368/) has_next_offset = 1
    if (line ~ /BRUSH_STR_ALIAS_CODE_00|BRUSH_STR_ALIAS_CODE_11|BRUSH_STR_ALIAS_CODE_DT/) has_alias_strings = 1
    if (line ~ /BRUSH_SELECTEDNODE/) has_selected_store = 1
    if (line ~ /BRUSH_SCRIPTPRIMARYSELECTION|BRUSH_SCRIPTSECONDARYSELECTION/) has_script_store = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_compare_n_call) print "HAS_COMPARE_N_CALL"
    if (has_copy_pad_nul_call) print "HAS_COPY_PAD_NUL_CALL"
    if (has_find_pred_call) print "HAS_FIND_PREDICATE_CALL"
    if (has_next_offset) print "HAS_NEXT_OFFSET_368"
    if (has_alias_strings) print "HAS_ALIAS_STRINGS"
    if (has_selected_store) print "HAS_SELECTED_NODE_STORE"
    if (has_script_store) print "HAS_SCRIPT_SELECTION_STORES"
    if (has_return) print "HAS_RTS"
}
