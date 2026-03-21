BEGIN {
    compress = 0
    stereo = 0
    movie = 0
    tv = 0
    rts = 0
}

function norm(line) {
    sub(/;.*/, "", line)
    sub(/^[ \t]+/, "", line)
    sub(/[ \t]+$/, "", line)
    gsub(/[ \t]+/, " ", line)
    return toupper(line)
}

{
    line = norm($0)
    if (line == "") {
        next
    }

    if (line ~ /ESQSHARED_COMPRESSCLOSEDCAPTION/) {
        compress = 1
    }
    if (line ~ /ESQSHARED_NORMALIZEINSTEREOTAG/) {
        stereo = 1
    }
    if (line ~ /ESQSHARED_REPLACEMOVIERATINGTOK/) {
        movie = 1
    }
    if (line ~ /ESQSHARED_REPLACETVRATINGTOKEN/) {
        tv = 1
    }
    if (line == "RTS") {
        rts = 1
    }
}

END {
    print "HAS_COMPRESS=" compress
    print "HAS_STEREO=" stereo
    print "HAS_MOVIE=" movie
    print "HAS_TV=" tv
    print "HAS_RTS=" rts
}
