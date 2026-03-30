BEGIN {
    step_count = 0
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

    if (u ~ /^ESQDISP_DRAWSTATUSBANNER_IMP[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /_LVOSETAPEN/) {
        mark("SETAPEN")
    }

    if (u ~ /ESQFUNC_JMPTBL_ESQ_GETHALFHOUR/ || u ~ /ESQ_GETHALFHOUR/) {
        mark("HALFHOUR_SLOT")
    }

    if (u ~ /ESQDISP_STATUSBANNERCLAMPGATEF/ &&
        (u ~ /^TST\.W / || u ~ /^MOVE\.W /)) {
        mark("CLAMP_GATE")
    }

    if (u ~ /ESQFUNC_JMPTBL_ESQ_CLAMPBANNERCH/ || u ~ /ESQ_CLAMPBANNERCH/) {
        mark("CLAMP_CALL")
    }

    if (u ~ /ESQFUNC_JMPTBL_LADFUNC_UPDATEHIG/ || u ~ /LADFUNC_UPDATEHIG/) {
        mark("HIGHLIGHT_UPDATE")
    }

    if (u ~ /BANNER_RESETPENDINGFLAG/) {
        mark("RESET_PENDING")
    }

    if (u ~ /TEXTDISP_PRIMARYGROUPCODE/ && !seen["PRIMARY_GROUP"]) {
        mark("PRIMARY_GROUP")
    }

    if (u ~ /TEXTDISP_SECONDARYGROUPCODE/ && !seen["SECONDARY_GROUP"]) {
        mark("SECONDARY_GROUP")
    }

    if (u ~ /CLOCK_CACHEYEAR/ && !seen["LEAP_WRAP_CHECK"]) {
        mark("LEAP_WRAP_CHECK")
    }

    if (u ~ /ESQDISP_LASTPRIMARYCOUNTDOWNVALU/) {
        mark("COUNTDOWN_CACHE")
    }

    if (u ~ /ESQDISP_SECONDARYPERSISTARMGATEF/ &&
        (u ~ /^CLR\.W / || u ~ /^MOVE\.W /) &&
        !seen["CLEAR_PERSIST_ARM_SLOT3"]) {
        mark("CLEAR_PERSIST_ARM_SLOT3")
    }

    if (u ~ /ESQDISP_SECONDARYPROPAGATIONDONE/ &&
        (u ~ /^CLR\.W / || u ~ /^MOVE\.W /) &&
        !seen["CLEAR_PROP_DONE"]) {
        mark("CLEAR_PROP_DONE")
    }

    if (u ~ /CLOCK_CURRENTDAYOFYEAR/ && !seen["STATUS_SCAN"]) {
        mark("STATUS_SCAN")
    }

    if ((u ~ /#\\$100/ || (u ~ /^MOVEQ\.L #\\$40,D1$/ || u ~ /^MOVEQ #64,D1$/) || u ~ /^ADDI\.L #\\$100,D0$/) &&
        seen["STATUS_SCAN"] && !seen["WRAP_DAY_MATCH"]) {
        mark("WRAP_DAY_MATCH")
    }

    if (u ~ /WDISP_STATUSDAYENTRY0\\+\\$14/ ||
        u ~ /WDISP_STATUSDAYENTRY0\\+\\$28/ ||
        u ~ /WDISP_STATUSDAYENTRY0\\+\\$3C/) {
        mark("SHIFT_STATUS_ROWS")
    }

    if (u ~ /TLIBA1_STATUSBANNERPROPAGATEGUAR/) {
        mark("PROPAGATE_GUARD")
    }

    if (u ~ /ESQDISP_SECONDARYPERSISTREQUESTF/) {
        mark("PERSIST_REQUEST")
    }

    if (u ~ /ESQDISP_PROPAGATEPRIMARYTITLEMET/) {
        mark("PROPAGATE_METADATA")
    }

    if (u ~ /ESQFUNC_JMPTBL_LOCAVAIL_SYNCSECO/ || u ~ /LOCAVAIL_SYNCSECO/) {
        mark("SYNC_FILTER")
    }

    if (u ~ /ESQFUNC_JMPTBL_P_TYPE_ENSURESECO/ || u ~ /P_TYPE_ENSURESECO/) {
        mark("ENSURE_SECONDARY")
    }

    if (u == "RTS") {
        mark("RTS")
    }
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
