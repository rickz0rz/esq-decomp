BEGIN {
    has_label = 0
    has_remintserver = 0
    has_dealloc = 0
    has_size = 0
    has_line = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_CLEARVERTBINTERRUPTSERVER[A-Z0-9_]*:/ || u ~ /^CLEANUP_CLEARVERTBINTERRUPTSERVE[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOREMINTSERVER/) has_remintserver = 1
    if (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOC/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_dealloc = 1
    if (u ~ /#22/ || u ~ /#\$16/ || u ~ /PEA 22\.W/ || u ~ /PEA \(\$16\)\.W/ || u ~ /STRUCT_INTERRUPT_SIZE/) has_size = 1
    if (u ~ /#57/ || u ~ /#\$39/ || u ~ /PEA 57\.W/ || u ~ /PEA \(\$39\)\.W/) has_line = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_REMINTSERVER=" has_remintserver
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_SIZE=" has_size
    print "HAS_LINE=" has_line
    print "HAS_RETURN=" has_return
}
