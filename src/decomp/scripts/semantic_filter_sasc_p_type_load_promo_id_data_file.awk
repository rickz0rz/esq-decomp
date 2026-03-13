BEGIN {
    label=0
    loadf=0
    find=0
    parse=0
    alloc=0
    freef=0
    dealloc=0
    direct_dealloc=0
    class_tbl=0
    c406=0
    one=0
    rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^P_TYPE_LOADPROMOIDDATAFILE:/) label=1
    if (n ~ /PARSEINIJMPTBLDISKIOLOADFILETOWORKBUFFER/ ||
        n ~ /PARSEINIJMPTBLDISKIOLOADFILET/ ||
        n ~ /DISKIOLOADFILETOWORKBUFFER/ ||
        n ~ /DISKIOLOADFILETOWORKB/) loadf=1
    if (n ~ /PTYPEJMPTBLSTRINGFINDSUBSTRING/ || n ~ /PTYPEJMPTBLSTRINGFINDSUBSTRI/ || n ~ /STRINGFINDSUBSTRING/ || n ~ /STRINGFINDSUBSTRI/) find=1
    if (n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDLONGSKIPCLASS3ALT/ ||
        n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDL/ ||
        n ~ /PARSEREADSIGNEDLONGSKIPCLASS3ALT/ ||
        n ~ /PARSEREADSIGNEDLONGSKIPCLASS3A/) parse=1
    if (n ~ /P_TYPEALLOCATEENTRY/ || n ~ /PTYPEALLOCATEENTRY/) alloc=1
    if (n ~ /P_TYPEFREEENTRY/ || n ~ /PTYPEFREEENTRY/) freef=1
    if (n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEMEMORY/ ||
        n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEM/ ||
        n ~ /MEMORYDEALLOCATEMEMORY/ ||
        n ~ /MEMORYDEALLOCATEM/) dealloc=1
    if (n ~ /MEMORYDEALLOCATEMEMORY/ || n ~ /MEMORYDEALLOCATEM/) direct_dealloc=1
    if (n ~ /WDISPCHARCLASSTABLE/) class_tbl=1
    if (u ~ /#406([^0-9]|$)/ || u ~ /#\$196/ || u ~ /406\.[Ww]/ || n ~ /PEA196W/) c406=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$1([^0-9]|$)/ || u ~ /MOVEQ #1/ || n ~ /MOVEQ1D0/) one=1
    if (u == "RTS") rts=1
}

END {
    print "HAS_LABEL="label
    print "HAS_LOAD_CALL="loadf
    print "HAS_FIND_CALL="find
    print "HAS_PARSE_CALL="parse
    print "HAS_ALLOC_CALL="alloc
    print "HAS_FREE_CALL="freef
    print "HAS_DEALLOC_CALL="dealloc
    print "HAS_CHARCLASS_TABLE="class_tbl
    print "HAS_CONST_406="(c406 || direct_dealloc)
    print "HAS_CONST_1="one
    print "HAS_RTS="rts
}
