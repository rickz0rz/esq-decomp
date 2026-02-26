BEGIN {
    has_raw_dofmt_ref = 0
    has_return = 0
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

    if (u ~ /PARALLEL_RAWDOFMT/ || u ~ /LAB_JMPTBL_PARALLEL_RAWDOFMT/ || u ~ /RAWDOFMT/) has_raw_dofmt_ref = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_RAW_DOFMT_REF=" has_raw_dofmt_ref
    print "HAS_RETURN=" has_return
}
