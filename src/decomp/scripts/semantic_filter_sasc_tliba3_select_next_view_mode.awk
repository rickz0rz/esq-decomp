BEGIN {
    has_entry=0
    has_load_current=0
    has_inc=0
    has_mod9=0
    has_store_current=0
    has_push_neg1=0
    has_push_zero=0
    has_build_context=0
    has_store_context=0
    has_overlay_call=0
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

    if (u ~ /^TLIBA3_SELECTNEXTVIEWMODE:/ || u ~ /^TLIBA3_SELECTNEXTVIEWM[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TLIBA1CURRENTVIEWMODEINDEX/ && n ~ /MOVED0|MOVE[A-Z0-9]*D0/) has_load_current=1
    if (u ~ /ADDQ\.L #1,D0/ || u ~ /ADDQ\.L #\$1,D0/) has_inc=1
    if ((n ~ /MATHDIVS32/ || n ~ /CXD33/) && (u ~ /#9/ || u ~ /#\$9/ || n ~ /MOVEQ9D1/)) has_mod9=1
    if (n ~ /TLIBA1CURRENTVIEWMODEINDEX/ && (n ~ /MOVED1TLIBA1CURRENTVIEWMODEINDEXA4/ || n ~ /MOVED0TLIBA1CURRENTVIEWMODEINDEXA4/)) has_store_current=1
    if (u ~ /PEA \(\$FFFFFFFF\)\.W/ || u ~ /PEA -1\.W/) has_push_neg1=1
    if (u ~ /CLR\.L -\(A7\)/) has_push_zero=1
    if (n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIEWMODE/ || n ~ /TLIBA3BUILDDISPLAYCONTEXTFORVIE/) has_build_context=1
    if (n ~ /WDISPDISPLAYCONTEXTBASE/) has_store_context=1
    if (n ~ /TLIBA3DRAWVIEWMODEOVERLAY/) has_overlay_call=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_LOAD_CURRENT="has_load_current
    print "HAS_INCREMENT="has_inc
    print "HAS_MOD9_PATH="has_mod9
    print "HAS_STORE_CURRENT="has_store_current
    print "HAS_PUSH_NEG1="has_push_neg1
    print "HAS_PUSH_ZERO="has_push_zero
    print "HAS_BUILD_CONTEXT_CALL="has_build_context
    print "HAS_STORE_CONTEXT="has_store_context
    print "HAS_OVERLAY_CALL="has_overlay_call
    print "HAS_RTS="has_rts
}
