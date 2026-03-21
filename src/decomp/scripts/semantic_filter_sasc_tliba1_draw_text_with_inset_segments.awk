BEGIN {
    has_entry=0
    has_alloc=0
    has_dealloc=0
    has_find=0
    has_move=0
    has_text=0
    has_draw_inset=0
    has_const19=0
    has_const20=0
    has_return=0
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

    if (u ~ /^TLIBA1_DRAWTEXTWITHINSETSEGMENTS:/ || u ~ /^TLIBA1_DRAWTEXTWITHINSETSEGME[A-Z0-9_]*:/) has_entry=1
    if (n ~ /MEMORYALLOCATEMEMORY/) has_alloc=1
    if (n ~ /MEMORYDEALLOCATEMEMORY/) has_dealloc=1
    if (n ~ /STRFINDCHARPTR/) has_find=1
    if (n ~ /LVOMOVE/) has_move=1
    if (n ~ /LVOTEXT/) has_text=1
    if (n ~ /SCRIPTDRAWINSETTEXTWITHFRAME/) has_draw_inset=1
    if (u ~ /#19([^0-9]|$)/ || u ~ /#\$13/) has_const19=1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\$14/) has_const20=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ALLOC="has_alloc
    print "HAS_DEALLOC="has_dealloc
    print "HAS_FIND="has_find
    print "HAS_MOVE="has_move
    print "HAS_TEXT="has_text
    print "HAS_DRAW_INSET="has_draw_inset
    print "HAS_CONST_19="has_const19
    print "HAS_CONST_20="has_const20
    print "HAS_RETURN="has_return
}
