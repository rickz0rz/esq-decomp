BEGIN {
    has_stack_arg_ptr = 0
    has_scratch_ref = 0
    has_format_call = 0
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

    if (u ~ /LEA 12\(A[0-7]\),A[0-7]/ || u ~ /PEA \(12,A[0-7]\)/ || u ~ /ADDQ\.L #4,A[0-7]/ || u ~ /MOVE\.L A[0-7],-\((A7|SP)\)/) has_stack_arg_ptr = 1
    if (u ~ /FORMAT_SCRATCHBUFFER/) has_scratch_ref = 1
    if (u ~ /JSR .*FORMAT_FORMATTOBUFFER2/ || u ~ /JSR .*FORMAT_FORMATTOBUFFER2\(PC\)/) has_format_call = 1
    if (u ~ /JSR .*PARALLEL_RAWDOFMTSTACKARGS/ || u ~ /JSR .*PARALLEL_RAWDOFMTSTACKARGS\(PC\)/) has_rawdofmt_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_STACK_ARG_PTR=" has_stack_arg_ptr
    print "HAS_SCRATCH_REF=" has_scratch_ref
    print "HAS_FORMAT_CALL=" has_format_call
    print "HAS_RAWDOFMT_CALL=" has_rawdofmt_call
    print "HAS_RTS=" has_rts
}
