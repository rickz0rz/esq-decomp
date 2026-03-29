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
    if (!(tag in seen)) {
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
    uline = toupper(line)

    if (uline ~ /^ESQIFF_HANDLEBRUSHINIRELOADHOTKE/) {
        mark("ENTRY")
    }

    if (uline ~ /^CMPI?\.B .*#97/ || uline ~ /^CMP\.B D0,D7$/ || uline ~ /^CMP\.B D1,D0$/ || uline ~ /^MOVEQ(\.L)? #\$61,D1$/) {
        mark("HOTKEY_GUARD")
    }

    if (uline ~ /^BNE(\.[A-Z]+)? / || uline ~ /^BNE$/) {
        mark("HOTKEY_MISMATCH_BRANCH")
    }

    if (uline ~ /DISKIO_FORCEUIREFRESHIFIDLE/ || uline ~ /ESQIFF_JMPTBL_DISKIO_FORCEUIREFRESHIFIDLE/) {
        mark("FORCE_REFRESH")
    }

    if (uline ~ /BRUSH_FREEBRUSHLIST/ || uline ~ /ESQIFF_JMPTBL_BRUSH_FREEBRUSHLIST/) {
        mark("FREE_LIST")
    }

    if (uline ~ /PARSEINI_PARSEINIBUFFERANDDISPAT/ || uline ~ /GROUP_AK_JMPTBL_PARSEINI_PARSEINIBUFFERANDDISPATCH/) {
        mark("PARSE_INI")
    }

    if (uline ~ /BRUSH_POPULATEBRUSHLIST/ || uline ~ /GROUP_AU_JMPTBL_BRUSH_POPULATEBRUSHLIST/) {
        mark("POPULATE_LIST")
    }

    if (uline ~ /BRUSH_SELECTBRUSHBYLABEL/ || uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHBYLABEL/) {
        mark("SELECT_DT")
    }

    if (uline ~ /^TST\.L BRUSH_SELECTEDNODE/ || uline ~ /^TST\.L BRUSH_SELECTEDNODE\(A4\)$/) {
        mark("TEST_SELECTED_NODE")
    }

    if (uline ~ /BRUSH_FINDBRUSHBYPREDICATE/ || uline ~ /ESQIFF_JMPTBL_BRUSH_FINDBRUSHBYPREDICATE/) {
        mark("FIND_DITHER")
    }

    if (uline ~ /MOVE\.L D0,BRUSH_SELECTEDNODE/ || uline ~ /MOVE\.L D0,BRUSH_SELECTEDNODE\(A4\)/) {
        mark("STORE_SELECTED_NODE")
    }

    if (uline ~ /BRUSH_FINDTYPE3BRUSH/ || uline ~ /ESQIFF_JMPTBL_BRUSH_FINDTYPE3BRUSH/) {
        mark("FIND_TYPE3")
    }

    if (uline ~ /ESQFUNC_FALLBACKTYPE3BRUSHNODE/) {
        mark("STORE_TYPE3")
    }

    if (uline ~ /DISKIO_RESETCTRLINPUTSTATEIFIDLE/ || uline ~ /ESQIFF_JMPTBL_DISKIO_RESETCTRLINPUTSTATEIFIDLE/) {
        mark("RESET_CTRL")
    }

    if (uline ~ /^MOVE\.L \(A7\)\+,D7$/) {
        mark("RESTORE_D7")
    }

    if (uline == "RTS") {
        mark("RTS")
    }
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
