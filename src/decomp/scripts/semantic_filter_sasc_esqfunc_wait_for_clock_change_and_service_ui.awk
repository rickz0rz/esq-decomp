BEGIN {
    has_entry = 0
    has_monitor = 0
    has_test = 0
    has_service = 0
    has_loop = 0
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
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI:/ || uline ~ /^ESQFUNC_WAITFORCLOCKCHANGEANDS[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_MONITORCLOCKCHANGE/ || uline ~ /ESQFUNC_JMPTBL_PARSEINI_MONITORCLOC/ || uline ~ /ESQFUNC_JMPTBL_PARSEINI_MONITORC/) has_monitor = 1
    if (uline ~ /^TST\.W D0$/ || uline ~ /^TST\.L D0$/) has_test = 1
    if (uline ~ /BSR\.W ESQFUNC_SERVICEUITICKIFRUNNING/ || uline ~ /BSR\.W ESQFUNC_SERVICEUITICKIFRUNN/) has_service = 1
    if (uline ~ /^BRA\.S ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI$/ || uline ~ /^BRA\.W ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI$/ || uline ~ /^BRA\.B ESQFUNC_WAITFORCLOCKCHANGEANDS/ || uline ~ /^BRA\.S ESQFUNC_WAITFORCLOCKCHANGEANDS/ || uline ~ /^BRA\.B ___ESQFUNC_WAITFORCLOCKCHANGEANDSER__1$/ || uline ~ /^BRA\.B ___ESQFUNC_WAITFORCLOCKCHANGEANDS/) has_loop = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MONITOR=" has_monitor
    print "HAS_TEST=" has_test
    print "HAS_SERVICE=" has_service
    print "HAS_LOOP=" has_loop
    print "HAS_RETURN=" has_return
}
