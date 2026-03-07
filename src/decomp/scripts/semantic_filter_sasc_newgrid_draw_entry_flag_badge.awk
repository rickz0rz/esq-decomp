BEGIN {
    has_entry=0
    has_set_layout=0
    has_bit4_check=0
    has_test_flag=0
    has_select_anim=0
    has_update_flags=0
    has_build_layout=0
    has_fallback_layout=0
    has_fmt_str=0
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

    if (u ~ /^NEWGRID_DRAWENTRYFLAGBADGE:/ || u ~ /^NEWGRID_DRAWENTRYFLAGBADG[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYO/) has_set_layout=1
    if (u ~ /BTST #\$?4,/) has_bit4_check=1
    if (n ~ /NEWGRID2JMPTBLCLEANUPTESTENTR/) has_test_flag=1
    if (n ~ /NEWGRID2JMPTBLCOISELECTANIMFI/) has_select_anim=1
    if (n ~ /NEWGRID2JMPTBLCLEANUPUPDATEEN/) has_update_flags=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTBUILDLA/) has_build_layout=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTA/) has_fallback_layout=1
    if (n ~ /NEWGRIDENTRYDETAILFMTSTR/) has_fmt_str=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SET_LAYOUT_CALL="has_set_layout
    print "HAS_BIT4_CHECK="has_bit4_check
    print "HAS_TEST_FLAG_CALL="has_test_flag
    print "HAS_SELECT_ANIM_CALL="has_select_anim
    print "HAS_UPDATE_FLAGS_CALL="has_update_flags
    print "HAS_BUILD_LAYOUT_CALL="has_build_layout
    print "HAS_FALLBACK_LAYOUT_CALL="has_fallback_layout
    print "HAS_FMT_STRING="has_fmt_str
    print "HAS_RTS="has_rts
}
