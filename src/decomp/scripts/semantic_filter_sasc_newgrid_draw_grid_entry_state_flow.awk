BEGIN {
    step_count = 0
    prev = ""
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

    if (u ~ /^NEWGRID_DRAWGRIDENTRY[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /SCRIPT_PTRNODATAPLACEHOLDER/ ||
        u ~ /\.DRAW_MISSING_ENTRY/ ||
        u ~ /___NEWGRID_DRAWGRIDENTRY__6/) {
        mark("MISSING_GUARD")
    }

    if ((u ~ /MOVEQ(\.L)? #\$?3,D[01]/ && prev ~ /MOVE\.L .*D0/) ||
        u ~ /CMP\.L D1,D0/) {
        mark("CLOCKFMT_GATE")
    }

    if ((u ~ /CMP\.B \(A0\),D0/ || u ~ /CMP\.B \$3\(A0\),D0/) &&
        seen["CLOCKFMT_GATE"]) {
        mark("TIME_PREFIX_CHECK")
    }

    if (u ~ /NEWGRID_APPLY24HOURFORMATTING/) {
        mark("APPLY_24H")
    }

    if ((u ~ /BTST #\$?1,\$7\(A[023],D[07]\.L\)/ ||
         u ~ /BTST #\$?1,7\(A0,D7\.W\)/) &&
        !seen["ENTRY_FLAGS_GATE"]) {
        mark("ENTRY_FLAGS_GATE")
    }

    if ((u ~ /BTST #\$?4,\$1B\(A0\)/ || u ~ /BTST #\$?4,27\(A2\)/) &&
        seen["ENTRY_FLAGS_GATE"]) {
        mark("ENTRY_EMPTY_GATE")
    }

    if (u ~ /DISPTEXT_LAYOUTANDAPPENDTOBUFFER/ &&
        prev ~ /MOVE\.L NEWGRID_ENTRYTEXTSCRATCHPTR/) {
        mark("DRAW_EMPTY_ENTRY")
    }

    if (u ~ /COI_RENDERCLOCKFORMATENTRYVARIAN/ ||
        u ~ /NEWGRID2_JMPTBL_COI_RENDERCLOCKFORMATENTRYVARIANT/) {
        mark("RENDER_VARIANT")
    }

    if ((u ~ /PEA \(\$22\)\.W/ || u ~ /PEA 34\.W/) && !seen["QUOTE_SEARCH"]) {
        mark("QUOTE_SEARCH")
    }

    if ((u ~ /STR_FINDANYCHARPTR/ || u ~ /PARSEINI_JMPTBL_STR_FINDANYCHARPTR/) &&
        prev ~ /MOVE\.L D0/) {
        mark("DELIM_SCAN")
    }

    if ((u ~ /CLR\.B \(A0\)\+/ || u ~ /CLR\.L \$30\(A7\)/ || u ~ /CLR\.L -4\(A5\)/) &&
        seen["DELIM_SCAN"]) {
        mark("PRIMARY_SPLIT")
    }

    if (u ~ /DISPTEXT_LAYOUTANDAPPENDTOBUFFER/ &&
        prev ~ /MOVE\.L NEWGRID_ENTRYTEXTSCRATCHPTR/) {
        mark("DRAW_PRIMARY")
    }

    if (u ~ /PEA \(\$28\)\.W/ || u ~ /PEA 40\.W/) {
        mark("SECONDARY_PAREN")
    }

    if (u ~ /CMP\.B \$5\(A0\),D1/ || u ~ /CMP\.B 5\(A0\),D1/) {
        mark("SECONDARY_CLOSE")
    }

    if (u ~ /DISPTEXT_LAYOUTSOURCETOLINES/ &&
        prev ~ /MOVE\.L \$24\(A7\),-\(A7\)/) {
        mark("SECONDARY_LAYOUT")
    }

    if (u ~ /DISPTEXT_LAYOUTANDAPPENDTOBUFFER/ &&
        prev ~ /MOVE\.L \$24\(A7\),-\(A7\)/) {
        mark("SECONDARY_APPEND")
    }

    if (u ~ /STR_SKIPCLASS3CHARS/ || u ~ /NEWGRID2_JMPTBL_STR_SKIPCLASS3CHARS/) {
        mark("SUBTITLE_SKIP")
    }

    if (u ~ /PEA \(\$2C\)\.W/ || u ~ /PEA 44\.W/) {
        mark("SUBTITLE_COMMA")
    }

    if (u ~ /PEA \(\$2E\)\.W/ || u ~ /PEA 46\.W/) {
        mark("SUBTITLE_PERIOD")
    }

    if (u ~ /MOVE\.B #\$2E,\(A0\)/ || u ~ /MOVE\.B #46,\(A0\)/) {
        mark("SUBTITLE_REWRITE")
    }

    if (u ~ /DISPTEXT_LAYOUTSOURCETOLINES/ &&
        prev ~ /MOVE\.L \$28\(A7\),-\(A7\)/) {
        mark("SUBTITLE_LAYOUT")
    }

    if (u ~ /^CLR\.B \$1\(A0\)$/ || u ~ /^CLR\.B 1\(A0\)$/) {
        mark("SUBTITLE_FALLBACK_TERM")
    }

    if (u ~ /ADDQ\.L #\$?2,\$18\(A7\)/ || u ~ /LEA \$?2\(A0\),A1/) {
        mark("SUBTITLE_FALLBACK_SKIP")
    }

    if (u ~ /DISPTEXT_LAYOUTSOURCETOLINES/ &&
        prev ~ /MOVE\.L \$18\(A7\),-\(A7\)/) {
        mark("SUBTITLE_ALT_LAYOUT")
    }

    if ((u ~ /PEA \$38\(A7\)/ || u ~ /PEA -19\(A5\)/) && !seen["TAIL_DELIM_SCAN"]) {
        mark("TAIL_DELIM_SCAN")
    }

    if (u ~ /\.SPLIT_LOOP/ || u ~ /___NEWGRID_DRAWGRIDENTRY__66/) {
        mark("TAIL_DELIM_LOOP")
    }

    if (u ~ /DISPTEXT_LAYOUTANDAPPENDTOBUFFER/ &&
        prev ~ /MOVE\.L \$24\(A7\),-\(A7\)/) {
        mark("TAIL_APPEND")
    }

    if ((u ~ /MOVEQ(\.L)? #\$?FF,D0/ || u ~ /MOVEQ #\-1,D1/ || u ~ /CMP\.L .*#\$?FF/) &&
        !seen["FINAL_VARIANT_GATE"]) {
        mark("FINAL_VARIANT_GATE")
    }

    if (u ~ /^CLR\.B \(A0\)$/ && seen["FINAL_VARIANT_GATE"]) {
        mark("FINAL_SCRATCH_CLEAR")
    }

    if (u ~ /COI_RENDERCLOCKFORMATENTRYVARIAN/ &&
        seen["FINAL_VARIANT_GATE"] && seen["FINAL_SCRATCH_CLEAR"]) {
        mark("FINAL_VARIANT_RENDER")
    }

    if (u == "RTS") {
        mark("RTS")
    }

    prev = u
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }
}
