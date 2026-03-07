BEGIN {
    has_entry=0
    has_graphics_read=0
    has_andi2=0
    init_calls=0
    has_c304=0
    has_8304=0
    has_4304=0
    has_c300=0
    has_4300=0
    has_idx0=0
    has_idx8=0
    has_rts=0
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

    if (u ~ /^TLIBA3_INITRUNTIMEENTRIES:/ || u ~ /^TLIBA3_INITRUNTIMEENTRIE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /GLOBALREFGRAPHICSLIBRARY/ && (u ~ /206\(A0\)/ || u ~ /\$CE\(A0\)/ || u ~ /\(A0\)/)) has_graphics_read=1
    if (u ~ /ANDI\.W #2/ || u ~ /ANDI\.W #\$2/ || n ~ /ANDIW2D7/ || n ~ /MOVEQL2D0/ || n ~ /ANDLD0D7/) has_andi2=1
    if (n ~ /TLIBA3INITRUNTIMEENTRY/) init_calls++
    if (u ~ /C304/ || u ~ /\$C304/) has_c304=1
    if (u ~ /8304/ || u ~ /\$8304/) has_8304=1
    if (u ~ /4304/ || u ~ /\$4304/) has_4304=1
    if (u ~ /C300/ || u ~ /\$C300/) has_c300=1
    if (u ~ /4300/ || u ~ /\$4300/) has_4300=1
    if (u ~ /PEA 0\.W/ || u ~ /PEA \(\$0\)\.W/ || n ~ /MOVEQL0D0/ || n ~ /CLRL[A7]/ || u ~ /CLR\.L -\(A7\)/) has_idx0=1
    if (u ~ /PEA 8\.W/ || u ~ /PEA \(\$8\)\.W/ || n ~ /MOVEQL8D0/) has_idx8=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GRAPHICS_WORD_READ="has_graphics_read
    print "HAS_ANDI_2="has_andi2
    print "HAS_INIT_CALLS_GE_9="(init_calls >= 9 ? 1 : 0)
    print "HAS_C304="has_c304
    print "HAS_8304="has_8304
    print "HAS_4304="has_4304
    print "HAS_C300="has_c300
    print "HAS_4300="has_4300
    print "HAS_INDEX_0="has_idx0
    print "HAS_INDEX_8="has_idx8
    print "HAS_RTS="has_rts
}
