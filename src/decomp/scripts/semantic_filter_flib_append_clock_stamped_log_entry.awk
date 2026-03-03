BEGIN {
    has_entry = 0
    has_return_entry = 0
    has_spinlock_gate = 0
    saw_size_cmp = 0
    saw_size_branch = 0
    has_hour_minute_div = 0
    has_sprintf_timestamp = 0
    has_append_chain = 0
    has_alloc_new_buffer = 0
    has_replace_owned_string = 0
    has_deallocate_old_buffer = 0
    has_spinlock_clear = 0
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

    if (uline ~ /^FLIB_APPENDCLOCKSTAMPEDLOGENTRY:/) has_entry = 1
    if (uline ~ /^FLIB_APPENDCLOCKSTAMPEDLOGENTRY_RETURN:/) has_return_entry = 1
    if (uline ~ /ESQPARS2_LOGAPPENDSPINLOCK/) has_spinlock_gate = 1
    if (uline ~ /CMPI\.W #\$2710,D0/) saw_size_cmp = 1
    if (uline ~ /BLE\.S \.LAB_0CB7/) saw_size_branch = 1
    if (uline ~ /CLOCK_CACHEHOUR/ || uline ~ /CLOCK_CACHEMINUTEORSECOND/) has_hour_minute_div = 1
    if (uline ~ /GROUP_AW_JMPTBL_WDISP_SPRINTF/) has_sprintf_timestamp = 1
    if (uline ~ /GROUP_AR_JMPTBL_STRING_APPENDATNULL/) has_append_chain = 1
    if (uline ~ /NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY/) has_alloc_new_buffer = 1
    if (uline ~ /ESQPARS_REPLACEOWNEDSTRING/) has_replace_owned_string = 1
    if (uline ~ /NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_deallocate_old_buffer = 1
    if (uline ~ /CLR\.L ESQPARS2_LOGAPPENDSPINLOCK/) has_spinlock_clear = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_size_limit_guard = (saw_size_cmp && saw_size_branch) ? 1 : 0

    print "HAS_ENTRY=" has_entry
    print "HAS_RETURN_ENTRY=" has_return_entry
    print "HAS_SPINLOCK_GATE=" has_spinlock_gate
    print "HAS_SIZE_LIMIT_GUARD=" has_size_limit_guard
    print "HAS_HOUR_MINUTE_DIV=" has_hour_minute_div
    print "HAS_SPRINTF_TIMESTAMP=" has_sprintf_timestamp
    print "HAS_APPEND_CHAIN=" has_append_chain
    print "HAS_ALLOC_NEW_BUFFER=" has_alloc_new_buffer
    print "HAS_REPLACE_OWNED_STRING=" has_replace_owned_string
    print "HAS_DEALLOCATE_OLD_BUFFER=" has_deallocate_old_buffer
    print "HAS_SPINLOCK_CLEAR=" has_spinlock_clear
    print "HAS_RETURN=" has_return
}
