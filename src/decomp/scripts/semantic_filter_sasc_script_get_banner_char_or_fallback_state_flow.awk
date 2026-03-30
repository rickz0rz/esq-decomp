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
    squashed = uline
    gsub(/[^A-Z0-9]/, "", squashed)

    if (uline ~ /^SCRIPT_GETBANNERCHARORFALLBACK:/ || uline ~ /^SCRIPT_GETBANNERCHARORFALLBAC[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (squashed ~ /TEXTDISPBANNERCHARSELECTED/) {
        mark("LOAD_SELECTED")
    }

    if (uline ~ /^MOVEQ(\.L)? #100,D[01]$/ || uline ~ /^MOVEQ(\.L)? #\$64,D[01]$/ ||
        uline ~ /^CMPI?\.B .*#100/ || uline ~ /^CMPI?\.B .*#\$64/ || uline ~ /^CMP\.B D1,D0$/) {
        mark("COMPARE_SENTINEL_100")
    }

    if (uline ~ /^MOVE\.B .*TEXTDISP_BANNERCHARSELECTED/ || squashed ~ /^MOVEBTEXTDISPBANNERCHARSELECTEDD0$/) {
        mark("USE_SELECTED_VALUE")
    }

    if (uline ~ /^MOVE\.B .*TEXTDISP_BANNERCHARFALLBACK/ || squashed ~ /^MOVEBTEXTDISPBANNERCHARFALLBACKD0$/) {
        mark("LOAD_FALLBACK")
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
