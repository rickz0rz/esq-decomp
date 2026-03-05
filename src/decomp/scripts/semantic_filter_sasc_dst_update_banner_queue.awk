BEGIN {
    updsel = 0
    addoff = 0
    alloc = 0
    refresh = 0
    write_rtc = 0
    pri = 0
    sec = 0
    mode = 0
    day = 0
    c89 = 0
    c1 = 0
    cm1 = 0
    has_rts_or_jmp = 0
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

    if (u ~ /DATETIME_UPDATESELECTIONFIELD|DATETIME_UPDATESELECTIONFIEL/) updsel = 1
    if (u ~ /DST_ADDTIMEOFFSET/) addoff = 1
    if (u ~ /DST_ALLOCATEBANNERSTRUCT|DST_ALLOCATEBANNERSTRUC/) alloc = 1
    if (u ~ /DST_REFRESHBANNERBUFFER|DST_REFRESHBANNERBUFFE/) refresh = 1
    if (u ~ /DST_WRITERTCFROMGLOBALS|DST_WRITERTCFROMGLOBAL/) write_rtc = 1
    if (u ~ /DST_PRIMARYCOUNTDOWN/) pri = 1
    if (u ~ /DST_SECONDARYCOUNTDOWN/) sec = 1
    if (u ~ /ESQ_SECONDARYSLOTMODEFLAGCHAR/) mode = 1
    if (u ~ /CLOCK_DAYSLOTINDEX|CLOCK_DAYSLOTINDE/) day = 1
    if (u ~ /#\$59|#89|89\.W/) c89 = 1
    if (u ~ /#\$1|#1|1\.W/) c1 = 1
    if (u ~ /#-1|#\$FFFF|#\$FF|-1\.W|\(\$FFFFFFFF\)\.W/) cm1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_UPDATE_SELECTION_CALL=" updsel
    print "HAS_ADD_OFFSET_CALL=" addoff
    print "HAS_ALLOC_CALL=" alloc
    print "HAS_REFRESH_CALL=" refresh
    print "HAS_WRITE_RTC_CALL=" write_rtc
    print "HAS_PRIMARY_COUNTDOWN_REF=" pri
    print "HAS_SECONDARY_COUNTDOWN_REF=" sec
    print "HAS_SECONDARY_MODE_REF=" mode
    print "HAS_DAY_SLOT_REF=" day
    print "HAS_CONST_89=" c89
    print "HAS_CONST_1=" c1
    print "HAS_CONST_NEG1=" cm1
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
