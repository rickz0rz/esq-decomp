BEGIN {
    has_label = 0
    has_save = 0
    has_arg = 0
    has_alloc_call = 0
    has_link_setup = 0
    has_create_proc = 0
    has_store_proc = 0
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
    u = toupper(line)

    if (u ~ /^CTASKS_STARTCLOSETASKPROCESS[A-Z0-9_]*:/) has_label = 1
    if (u ~ /MOVEM.L D2-D4\/D7,-\(A7\)/ || u ~ /MOVEM.L D[0-7].*,-\(A7\)/) has_save = 1
    if (u ~ /MOVE.L 20\(A7\),D7/ || u ~ /MOVE.L \$14\(A7\),D[0-7]/ || u ~ /MOVE.L \$10\(A7\),D[0-7]/ || u ~ /USESTACKLONG MOVE.L,1,D7/) has_arg = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/) has_alloc_call = 1
    if (u ~ /CTASKS_CLOSETASKSEGLISTBPTR/) has_link_setup = 1
    if (u ~ /_LVOCREATEPROC/) has_create_proc = 1
    if (u ~ /MOVE.L D0,CTASKS_CLOSETASKPROCPTR/ || u ~ /CTASKS_CLOSETASKPROCPTR/) has_store_proc = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_ARG=" has_arg
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_LINK_SETUP=" has_link_setup
    print "HAS_CREATE_PROC=" has_create_proc
    print "HAS_STORE_PROC=" has_store_proc
    print "HAS_RETURN=" has_return
}
