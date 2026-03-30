BEGIN {
    prev = ""
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) { seen[tag] = 1 }

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^WDISP_HANDLEWEATHERSTATUSCOMMAND[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if ((u ~ /#48/ || u ~ /#\$30/) && !seen["CMD48"]) {
        mark("CMD48")
    }

    if ((u ~ /#51/ || u ~ /#\$33/) && !seen["CMD51"]) {
        mark("CMD51")
    }

    if (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ || n ~ /TEXTDISPRESETSELECTIONANDREFRES/) {
        mark("RESET_REFRESH")
    }

    if (n ~ /TLIBA3CLEARVIEWMODERASTPORT/) {
        mark("CLEAR_VIEW")
    }

    if ((n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIEWMODE/ || n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIE/) &&
        !seen["BUILD_CTX_MODE4_A"]) {
        mark("BUILD_CTX_MODE4_A")
    } else if ((n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIEWMODE/ || n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIE/) &&
               !seen["BUILD_CTX_MODE3"]) {
        mark("BUILD_CTX_MODE3")
    } else if ((n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIEWMODE/ || n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIE/) &&
               !seen["BUILD_CTX_MODE4_B"]) {
        mark("BUILD_CTX_MODE4_B")
    }

    if (n ~ /ESQSETCOPPEREFFECTONENABLEHIGHLIGHT/ || n ~ /ESQSETCOPPEREFFECTONENABLEHIGH/) {
        mark("ENABLE_HIGHLIGHT")
    }

    if (n ~ /ESQIFFRESTOREBASEPALETTETRIPLES/) {
        mark("RESTORE_BASE_PALETTE")
    }

    if (n ~ /ESQIFFRUNCOPPERDROPTRANSITION/ || n ~ /ESQIFFRUNCOPPERDRO/) {
        mark("DROP_TRANSITION")
    }

    if (n ~ /LVOSETDRMD/) {
        mark("SET_DRMODE")
    }

    if (n ~ /LVOSETAPEN/) {
        mark("SET_APEN")
    }

    if (n ~ /LVOSETFONT/) {
        mark("SET_FONT")
    }

    if (n ~ /WDISPDRAWWEATHERSTATUSOVERLAY/) {
        mark("DRAW_OVERLAY")
    }

    if (n ~ /WDISPDRAWWEATHERSTATUSSUMMARY/) {
        mark("DRAW_SUMMARY")
    }

    if (n ~ /ACCUMULATORROW0CAPTUREVALUE/) {
        mark("CAPTURE0")
    }

    if (n ~ /ACCUMULATORROW1CAPTUREVALUE/) {
        mark("CAPTURE1")
    }

    if (n ~ /ACCUMULATORROW2CAPTUREVALUE/) {
        mark("CAPTURE2")
    }

    if (n ~ /ACCUMULATORROW3CAPTUREVALUE/) {
        mark("CAPTURE3")
    }

    if (n ~ /WDISPACCUMULATORCAPTUREACTIVE/) {
        mark("CAPTURE_ACTIVE")
    }

    if (n ~ /ACCUMULATORROW0SUM/ ||
        n ~ /ACCUMULATORROW1SUM/ ||
        n ~ /ACCUMULATORROW2SUM/ ||
        n ~ /ACCUMULATORROW3SUM/) {
        mark("ZERO_SUMS")
    }

    if (n ~ /ACCUMULATORROW0SATURATEFLAG/ ||
        n ~ /ACCUMULATORROW1SATURATEFLAG/ ||
        n ~ /ACCUMULATORROW2SATURATEFLAG/ ||
        n ~ /ACCUMULATORROW3SATURATEFLAG/) {
        mark("ZERO_SAT_FLAGS")
    }

    if (n ~ /ESQIFFRUNCOPPERRISETRANSITION/ || n ~ /ESQIFFRUNCOPPERRISETRANSIT/ ||
        n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSITION/ || n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSIT/) {
        mark("RISE_TRANSITION")
    }

    if (u == "RTS") {
        mark("RTS")
    }

    prev = u
}

END {
    split("ENTRY CMD48 CMD51 CLEAR_VIEW BUILD_CTX_MODE4_A ENABLE_HIGHLIGHT RESTORE_BASE_PALETTE DROP_TRANSITION BUILD_CTX_MODE3 SET_DRMODE SET_APEN SET_FONT DRAW_OVERLAY DRAW_SUMMARY BUILD_CTX_MODE4_B CAPTURE0 CAPTURE1 CAPTURE2 CAPTURE3 CAPTURE_ACTIVE ZERO_SUMS ZERO_SAT_FLAGS RISE_TRANSITION RTS", ordered, " ")

    line_no = 0
    for (i = 1; i <= length(ordered); i++) {
        tag = ordered[i]
        if (seen[tag] == 1) {
            line_no++
            print line_no ":" tag
        }
    }

    print "HAS_RESET_REFRESH=" (seen["RESET_REFRESH"] == 1 ? 1 : 0)
}
