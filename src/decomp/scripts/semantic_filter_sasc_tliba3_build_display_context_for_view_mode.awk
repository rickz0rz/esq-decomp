BEGIN {
    has_entry=0
    has_current_view_mode=0
    has_init_guard=0
    has_init_call=0
    has_pattern_table=0
    has_runtime_table=0
    has_pattern_mul=0
    has_runtime_mul=0
    has_flag_8004=0
    has_flag_8000=0
    has_flag_0004=0
    has_viewmode_zero=0
    has_bplcon0_patch=0
    has_template0=0
    has_template1=0
    has_apply_highlight=0
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

    if (u ~ /^TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE:/ || u ~ /^TLIBA3_BUILDDISPLAYCONTEXTFORV[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TLIBA1CURRENTVIEWMODEINDEX/) has_current_view_mode=1
    if (n ~ /TLIBA1PATTERNTABLEINITGUARD/) has_init_guard=1
    if (n ~ /TLIBA3INITPATTERNTABLE/) has_init_call=1
    if (n ~ /TLIBA3VMARRAYPATTERNTABLE/) has_pattern_table=1
    if (n ~ /TLIBA3VMARRAYRUNTIMETABLE/) has_runtime_table=1
    if (n ~ /MULU32/) has_pattern_mul=1
    if (u ~ /#154/ || u ~ /#\$9A/ || u ~ /VMRUNTIMESTRIDE/) has_runtime_mul=1
    if (u ~ /\$8004/ || u ~ /32772/) has_flag_8004=1
    if (u ~ /\$8000/ || u ~ /32768/) has_flag_8000=1
    if (u ~ /\$8004/ || u ~ /\$0004/ || u ~ /0X0004/ || u ~ /BTST #\$2/ || u ~ /BTST #2,\$1\(A[0-7]\)/ || u ~ /BTST #2,1\(A[0-7]\)/) has_flag_0004=1
    if (n ~ /VIEWMODE0/ || u ~ /TST.L D7/ || u ~ /VIEWMODE == 0/) has_viewmode_zero=1
    if (u ~ /\$8FFF/ || n ~ /BPLCON0/ || u ~ /7000/) has_bplcon0_patch=1
    if (n ~ /ESQCOPPEREFFECTTEMPLATEROWSSET0/) has_template0=1
    if (n ~ /ESQCOPPEREFFECTTEMPLATEROWSSET1/) has_template1=1
    if (n ~ /TLIBA3JMPTBLGCOMMANDAPPLYHIGH/) has_apply_highlight=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_CURRENT_VIEW_MODE="has_current_view_mode
    print "HAS_INIT_GUARD="has_init_guard
    print "HAS_INIT_CALL="has_init_call
    print "HAS_PATTERN_TABLE="has_pattern_table
    print "HAS_RUNTIME_TABLE="has_runtime_table
    print "HAS_PATTERN_MUL="has_pattern_mul
    print "HAS_RUNTIME_MUL="has_runtime_mul
    print "HAS_FLAG_8004="has_flag_8004
    print "HAS_FLAG_8000="has_flag_8000
    print "HAS_FLAG_0004="has_flag_0004
    print "HAS_VIEWMODE_ZERO_SPECIAL="has_viewmode_zero
    print "HAS_BPLCON0_PATCH="has_bplcon0_patch
    print "HAS_TEMPLATE_SET0="has_template0
    print "HAS_TEMPLATE_SET1="has_template1
    print "HAS_APPLY_HIGHLIGHT="has_apply_highlight
    print "HAS_RTS="has_rts
}
