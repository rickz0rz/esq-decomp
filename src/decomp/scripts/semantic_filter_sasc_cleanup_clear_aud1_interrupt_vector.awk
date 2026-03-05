BEGIN {
    has_label = 0
    has_intena = 0
    has_setintvector = 0
    has_dealloc = 0
    has_size_22 = 0
    has_line_74 = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_CLEARAUD1INTERRUPTVECTOR[A-Z0-9_]*:/) has_label = 1
    if (u ~ /INTENA/ || u ~ /#\$100/ || u ~ /#256/) has_intena = 1
    if (u ~ /_LVOSETINTVECTOR/) has_setintvector = 1
    if (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOC/) has_dealloc = 1
    if (u ~ /#22/ || u ~ /#\$16/ || u ~ /PEA 22\.W/ || u ~ /PEA \(\$16\)\.W/) has_size_22 = 1
    if (u ~ /#74/ || u ~ /#\$4A/ || u ~ /PEA 74\.W/ || u ~ /PEA \(\$4A\)\.W/) has_line_74 = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_INTENA=" has_intena
    print "HAS_SETINTVECTOR=" has_setintvector
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_SIZE_22=" has_size_22
    print "HAS_LINE_74=" has_line_74
    print "HAS_RETURN=" has_return
}
