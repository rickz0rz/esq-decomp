BEGIN {
    has_abs_execbase_load = 0
    has_exec_version_cmp = 0
    has_coldreboot_jump = 0
    has_via_label = 0
    has_via_lea = 0
    has_supervisor_jsr = 0
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

    if (uline ~ /^MOVEA\.L ABSEXECBASE,A6$/ || uline ~ /^MOVE\.L ABSEXECBASE,A6$/ || uline ~ /^MOVEA\.L 4,A6$/ || uline ~ /^MOVE\.L 4,A6$/) has_abs_execbase_load = 1
    if (uline ~ /^CMPI\.W #\$?24,20\(A6\)$/ || uline ~ /^CMP\.W #\$?24,20\(A6\)$/ || uline ~ /^CMPI\.W #0X24,20\(A6\)$/ || uline ~ /^CMP\.W #0X24,20\(A6\)$/ || uline ~ /^CMP\.W #36,20\(A6\)$/ || uline ~ /^CMPI\.W #36,20\(A6\)$/) has_exec_version_cmp = 1
    if (uline ~ /LVOCOLDREBOOT\(A6\)/) has_coldreboot_jump = 1
    if (uline ~ /^ESQ_COLDREBOOTVIASUPERVISOR:/) has_via_label = 1
    if (uline ~ /^LEA ESQ_SUPERVISORCOLDREBOOT\(PC\),A5$/ || uline ~ /^LEA ESQ_SUPERVISORCOLDREBOOT\(%PC\),A5$/ || uline ~ /^LEA ESQ_SUPERVISORCOLDREBOOT\(A7\),A5$/) has_via_lea = 1
    if (uline ~ /LVOSUPERVISOR\(A6\)/) has_supervisor_jsr = 1
}

END {
    print "HAS_ABSEXECBASE_LOAD=" has_abs_execbase_load
    print "HAS_EXEC_VERSION_CMP=" has_exec_version_cmp
    print "HAS_COLDREBOOT_JUMP=" has_coldreboot_jump
    print "HAS_VIA_LABEL=" has_via_label
    print "HAS_VIA_LEA=" has_via_lea
    print "HAS_SUPERVISOR_JSR=" has_supervisor_jsr
}
