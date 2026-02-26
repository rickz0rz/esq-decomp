BEGIN {
    has_fmt_setup = 0
    has_args_setup = 0
    has_common_dispatch = 0
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

    if (u ~ /MOVEA?\.L[[:space:]]+4\(A7\),A0/ || u ~ /MOVE\.L[[:space:]]+\(8,A5\),-\(SP\)/) has_fmt_setup = 1
    if (u ~ /LEA[[:space:]]+8\(A7\),A1/ || u ~ /^PEA[[:space:]]+\(12,A5\)/) has_args_setup = 1
    if (u ~ /(BRA|JRA|BSR|JSR)[[:space:]].*PARALLEL_RAWDOFMTCOMMON/ || u ~ /^PARALLEL_RAWDOFMTCOMMON:/) has_common_dispatch = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_FMT_SETUP=" has_fmt_setup
    print "HAS_ARGS_SETUP=" has_args_setup
    print "HAS_COMMON_DISPATCH=" has_common_dispatch
    print "HAS_RTS=" has_rts
}
