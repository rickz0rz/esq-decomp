BEGIN {
    has_lf_check = 0
    has_wait_loop = 0
    has_ddrb_write = 0
    has_prb_write = 0
    has_rts = 0
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

    if (u ~ /(CMPI|CMP)\.B[[:space:]]+#\$?A,/ || u ~ /(CMPI|CMP)\.B[[:space:]]+#10,/) has_lf_check = 1
    if (u ~ /BTST[[:space:]]+#0,/ || u ~ /ANDI\.L[[:space:]]+#1,/ || u ~ /AND\.L[[:space:]]+#1,/) has_wait_loop = 1
    if (u ~ /CIAA_DDRB/) has_ddrb_write = 1
    if (u ~ /CIAA_PRB/) has_prb_write = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_LF_CHECK=" has_lf_check
    print "HAS_WAIT_LOOP=" has_wait_loop
    print "HAS_DDRB_WRITE=" has_ddrb_write
    print "HAS_PRB_WRITE=" has_prb_write
    print "HAS_RTS=" has_rts
}
