BEGIN {
    has_get = 0
    has_begin = 0
    has_pending = 0
    has_speed = 0
    has_head = 0
    has_read_latch = 0
    has_read_flags = 0
    has_neg2 = 0
    has_neg1 = 0
    has_terminal = 0
}

function trim(s,    t) {
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /SCRIPT3JMPTBLGCOMMANDGETBANNERCHAR/) has_get = 1
    if (n ~ /SCRIPTBEGINBANNERCHARTRANSITION/) has_begin = 1
    if (n ~ /SCRIPTPENDINGBANNERTARGETCHAR/) has_pending = 1
    if (n ~ /SCRIPTPENDINGBANNERSPEEDMS/) has_speed = 1
    if (n ~ /CONFIGBANNERCOPPERHEADBYTE/) has_head = 1
    if (n ~ /SCRIPTREADMODEACTIVELATCH/) has_read_latch = 1
    if (n ~ /ESQPARS2READMODEFLAGS/) has_read_flags = 1
    if (u ~ /-2/) has_neg2 = 1
    if (u ~ /-1/) has_neg1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_GET=" has_get
    print "HAS_BEGIN=" has_begin
    print "HAS_PENDING=" has_pending
    print "HAS_SPEED=" has_speed
    print "HAS_HEAD=" has_head
    print "HAS_READ_LATCH=" has_read_latch
    print "HAS_READ_FLAGS=" has_read_flags
    print "HAS_NEG2=" has_neg2
    print "HAS_NEG1=" has_neg1
    print "HAS_TERMINAL=" has_terminal
}
