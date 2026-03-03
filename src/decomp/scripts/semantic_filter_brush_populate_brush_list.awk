BEGIN {
    label = 0
    has_forbid = 0
    has_permit = 0
    has_inprogress = 0
    has_load_call = 0
    has_dealloc_call = 0
    has_norm_call = 0
    has_next_desc = 0
    has_next_tail = 0
    has_parsed_head_clear = 0
    has_return = 0
}

/^BRUSH_PopulateBrushList:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /LVOFORBID/) has_forbid = 1
    if (line ~ /LVOPERMIT/) has_permit = 1
    if (line ~ /BRUSH_LOADINPROGRESSFLAG/) has_inprogress = 1
    if (line ~ /BRUSH_LOADBRUSHASSET/) has_load_call = 1
    if (line ~ /MEMORY_DEALLOCATEMEMORY/) has_dealloc_call = 1
    if (line ~ /BRUSH_NORMALIZEBRUSHNAMES/) has_norm_call = 1
    if (line ~ /234\(/ || line ~ /\(234,/ || line ~ /#\$EA/ || line ~ /#234/) has_next_desc = 1
    if (line ~ /368\(/ || line ~ /\(368,/ || line ~ /#\$170/ || line ~ /#368/) has_next_tail = 1
    if (line ~ /PARSEINI_PARSEDDESCRIPTORLISTHEAD/) has_parsed_head_clear = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_forbid) print "HAS_FORBID_CALL"
    if (has_permit) print "HAS_PERMIT_CALL"
    if (has_inprogress) print "HAS_INPROGRESS_FLAG_STORES"
    if (has_load_call) print "HAS_LOAD_CALL"
    if (has_dealloc_call) print "HAS_DEALLOC_CALL"
    if (has_norm_call) print "HAS_NORMALIZE_CALL"
    if (has_next_desc) print "HAS_NEXT_DESC_OFFSET_234"
    if (has_next_tail) print "HAS_TAIL_OFFSET_368"
    if (has_parsed_head_clear) print "HAS_PARSED_HEAD_CLEAR"
    if (has_return) print "HAS_RTS"
}
