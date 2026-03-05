BEGIN {
    has_abs_execbase_ref = 0
    has_exec_version_cmp = 0
    has_coldreboot_call = 0
    has_via_label = 0
    has_via_symbol = 0
    has_supervisor_call = 0
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
    if (uline ~ /^ESQ_COLDREBOOTVIASUPERVISOR:/ || uline ~ /^ESQ_COLDREBOOTVIASUPER[A-Z0-9_]*:/) has_via_label = 1
    if (uline ~ /ESQ_SUPERVISORCOLDREBOOT/) has_via_symbol = 1
    if (uline ~ /LVOSUPERVISOR/ || uline ~ /_LVOSUPERVISOR/) has_supervisor_call = 1
}

END {
    print "HAS_ABSEXECBASE_REF=" has_abs_execbase_ref
    print "HAS_EXEC_VERSION_CMP=" has_exec_version_cmp
    print "HAS_COLDREBOOT_CALL=" has_coldreboot_call
    print "HAS_VIA_LABEL=" has_via_label
    print "HAS_VIA_SYMBOL=" has_via_symbol
    print "HAS_SUPERVISOR_CALL=" has_supervisor_call
}
