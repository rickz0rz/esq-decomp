BEGIN {
    has_writechar_ptr = 0
    has_exec_base = 0
    has_rawdofmt_call = 0
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

    if (u ~ /PARALLEL_WRITECHARHW/ || u ~ /LEA .*A2/ || u ~ /MOVEA?\.L .*A2/) has_writechar_ptr = 1
    if (u ~ /ABSEXECBASE/ || u ~ /MOVEA?\.L .*A6/) has_exec_base = 1
    if (u ~ /LVORAWDOFMT/ || u ~ /JSR .*RAWDOFMT/ || u ~ /JSR .*\(A6\)/) has_rawdofmt_call = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_WRITECHAR_PTR=" has_writechar_ptr
    print "HAS_EXEC_BASE=" has_exec_base
    print "HAS_RAWDOFMT_CALL=" has_rawdofmt_call
    print "HAS_RTS=" has_rts
}
