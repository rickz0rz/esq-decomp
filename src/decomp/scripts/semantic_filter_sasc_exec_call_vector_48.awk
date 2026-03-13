BEGIN {
    has_label = 0
    has_libbase_load = 0
    has_private_call = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    upper = toupper(line)

    if (upper ~ /^EXEC_CALLVECTOR_48[A-Z0-9_]*:/) {
        has_label = 1
    }
    if (upper ~ /INPUTDEVICE_LIBRARYBASEFROMCONSO/ || upper ~ /MOVEA\.L .*A6/ || upper ~ /MOVE\.L .*INPUTDEVICE_.*A6/) {
        has_libbase_load = 1
    }
    if (upper ~ /EXECPRIVATE3/ || upper ~ /LVOEXECPRIVATE3/ || upper ~ /JSR \$FFFFFFD0\(A6\)/ || upper ~ /JSR \$FFFFFFD0 \(A6\)/) {
        has_private_call = 1
    }
    if (upper == "RTS") {
        has_return = 1
    }
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LIBBASE_LOAD=" has_libbase_load
    print "HAS_PRIVATE_CALL=" has_private_call
    print "HAS_RETURN=" has_return
}
