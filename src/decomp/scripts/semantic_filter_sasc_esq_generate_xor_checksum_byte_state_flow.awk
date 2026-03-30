BEGIN {
    step_count = 0
    saw_cached_checksum = 0
    saw_cached_flag = 0
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

    if (uline ~ /^ESQ_GENERATEXORCHECKSUMBYTE[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (uline ~ /ESQIFF_RECORDCHECKSUMBYTE/) {
        saw_cached_checksum = 1
        mark("LOAD_CACHED_CHECKSUM")
    }

    if (uline ~ /ESQIFF_USECACHEDCHECKSUMFLAG/) {
        saw_cached_flag = 1
        mark("CHECK_CACHED_FLAG")
    } else if (saw_cached_flag && uline ~ /^TST\.[BW] D[0-7]$/) {
        mark("CHECK_CACHED_FLAG")
    }

    if (uline ~ /^B(N?E|RA)\./ || uline ~ /^B(N?E|RA) /) {
        if (seen["CHECK_CACHED_FLAG"] && !seen["RETURN_CACHED_RESULT"]) {
            mark("RETURN_CACHED_RESULT")
        }
    }

    if (uline ~ /EORI\.[BWL] #\$?FF,D[0-7]/ || uline ~ /^NOT\.B D[0-7]$/) {
        mark("INVERT_SEED")
    }

    if (uline ~ /ANDI\.[BWL] #\$?FF,D[0-7]/ || uline ~ /^AND\.[BWL] D[0-7],D[0-7]$/) {
        mark("MASK_RESULT")
    }

    if (uline == "RTS") {
        mark("RETURN")
    }
}

END {
    for (i = 1; i <= step_count; i++) {
        print i ":" steps[i]
    }

    if (saw_cached_checksum) {
        print "FLAG:HAS_CACHED_CHECKSUM_REF"
    }
    if (saw_cached_flag) {
        print "FLAG:HAS_CACHED_FLAG_REF"
    }
}
