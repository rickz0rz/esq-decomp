BEGIN {
    has_abs_execbase_ref = 0
    has_exec_version_cmp = 0
    has_coldreboot_call = 0
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
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /ABSEXECBASE/) has_abs_execbase_ref = 1
    if (uline ~ /#\$?24,20\(A[0-7]\)/ || uline ~ /#0X24,20\(A[0-7]\)/ || uline ~ /#36,20\(A[0-7]\)/ || uline ~ /#\$?24/) has_exec_version_cmp = 1
    if (uline ~ /LVOCOLDREBOOT/ || uline ~ /_LVOCOLDREBOOT/) has_coldreboot_call = 1
}

END {
    print "HAS_ABSEXECBASE_REF=" has_abs_execbase_ref
    print "HAS_EXEC_VERSION_CMP=" has_exec_version_cmp
    print "HAS_COLDREBOOT_CALL=" has_coldreboot_call
}
