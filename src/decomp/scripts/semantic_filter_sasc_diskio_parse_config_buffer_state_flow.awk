BEGIN {
    step_count = 0
    prev = ""
    prev2 = ""
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    if (!seen[tag]) {
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

    if (u ~ /^DISKIO_PARSECONFIGBUFF[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /CONFIG_ENSUREPC1GFXASSIGNEDFLAG/ &&
        (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("PC1_FLAG_STORE")
    }

    if (u ~ /DISKIO_ENSUREPC1MOUNTEDANDGFXASS/ ||
        u ~ /DISKIO_ENSUREPC1MOUNTEDANDGFXASSIGNED/) {
        mark("PC1_CALL")
    }

    if ((u ~ /CONFIG_MSNRUNTIMEMODESELECTORCHAR_LRBN/ ||
         u ~ /CONFIG_MSNRUNTIMEMODESELECTORCHA/) &&
        (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("LRBN_SELECTOR_STORE")
    }

    if (u ~ /STR_FINDCHARPTR/ && (prev ~ /DISKIO_TAG_LRBN/ || prev2 ~ /DISKIO_TAG_LRBN/)) {
        mark("LRBN_LOOKUP")
    }

    if (u ~ /CONFIG_LRBN_FLAGCHAR/ && (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("LRBN_FLAG_STORE")
    }

    if (u ~ /SCRIPT_BEGINBANNERCHARTRANSITION/ ||
        u ~ /GROUP_AG_JMPTBL_SCRIPT_BEGINBANN/) {
        mark("BANNER_TRANSITION")
    }

    if (seen["BANNER_TRANSITION"] &&
        u ~ /CONFIG_LRBN_FLAGCHAR/ &&
        (u ~ /#78/ || u ~ /#\$4E/ || u ~ /#'N'/)) {
        mark("LRBN_FLAG_RESET_N")
    }

    if (u ~ /CONFIG_MSN_FLAGCHAR/ && (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("MSN_FLAG_STORE")
    }

    if (u ~ /STR_FINDCHARPTR/ && (prev ~ /DISKIO_TAG_MSN/ || prev2 ~ /DISKIO_TAG_MSN/)) {
        mark("MSN_LOOKUP")
    }

    if (u ~ /CONFIG_MSN_FLAGCHAR/ && (u ~ /#78/ || u ~ /#\$4E/ || u ~ /#'N'/)) {
        mark("MSN_DEFAULT_N")
    }

    if (u ~ /CTASKS_STR_1/ && (u ~ /^MOVE\.B / || u ~ /^CLR\.B /)) {
        mark("TASKMODE_STORE")
    }

    if (u ~ /ESQFUNC_UPDATEREFRESHMODESTATE/ ||
        u ~ /GROUP_AG_JMPTBL_ESQFUNC_UPDATERE/) {
        mark("REFRESH_UPDATE")
    }

    if (u ~ /MATH_MULU32/ || u ~ /GROUP_AG_JMPTBL_MATH_MULU32/) {
        mark("REFRESH_MULU")
    }

    if (u ~ /CONFIG_REFRESHINTERVALSECONDS/ && u ~ /^MOVE\.L /) {
        mark("REFRESH_SECONDS_STORE")
    }

    if (u == "RTS") {
        mark("RTS")
    }

    prev2 = prev
    prev = u
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
