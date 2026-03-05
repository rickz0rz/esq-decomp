BEGIN {
    has_entry = 0
    has_forbid = 0
    has_permit = 0
    has_inprogress = 0
    has_load_call = 0
    has_dealloc_call = 0
    has_norm_call = 0
    has_next_desc = 0
    has_next_tail = 0
    has_parsed_head_clear = 0
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

    if (u ~ /LVOFORBID/ || u ~ /_LVOFORBID/) has_forbid = 1
    if (u ~ /LVOPERMIT/ || u ~ /_LVOPERMIT/) has_permit = 1
    if (u ~ /BRUSH_LOADINPROGRESSFLAG/) has_inprogress = 1
    if (u ~ /BRUSH_LOADBRUSHASSET/ || u ~ /_BRUSH_LOADBRUSHASSET/ || u ~ /BRUSH_LOADBRUSHAS/ || u ~ /_BRUSH_LOADBRUSHAS/) has_load_call = 1
    if (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/ || u ~ /_GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_dealloc_call = 1
    if (u ~ /BRUSH_NORMALIZEBRUSHNAMES/ || u ~ /_BRUSH_NORMALIZEBRUSHNAMES/ || u ~ /BRUSH_NORMALIZEBRUSHNA/ || u ~ /_BRUSH_NORMALIZEBRUSHNA/) has_norm_call = 1
    if (u ~ /234\(/ || u ~ /\(234,/ || u ~ /#\$EA/ || u ~ /#234/ || u ~ /\$EA\([AD][0-7]\)/) has_next_desc = 1
    if (u ~ /368\(/ || u ~ /\(368,/ || u ~ /#\$170/ || u ~ /#368/ || u ~ /\$170\([AD][0-7]\)/) has_next_tail = 1
    if (u ~ /PARSEINI_PARSEDDESCRIPTORLISTHEAD/ || u ~ /PARSEINI_PARSEDDESCRIPTORLISTHEA/) has_parsed_head_clear = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_FORBID_CALL=" has_forbid
    print "HAS_PERMIT_CALL=" has_permit
    print "HAS_INPROGRESS_FLAG_STORES=" has_inprogress
    print "HAS_LOAD_CALL=" has_load_call
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_NORMALIZE_CALL=" has_norm_call
    print "HAS_NEXT_DESC_OFFSET_234=" has_next_desc
    print "HAS_TAIL_OFFSET_368=" has_next_tail
    print "HAS_PARSED_HEAD_CLEAR=" has_parsed_head_clear
    print "HAS_RTS=" has_rts
}
