BEGIN {
    has_entry=0
    has_mulu=0
    has_vm_table=0
    has_offset10=0
    has_setfont=0
    has_setrast=0
    has_setdrmd=0
    has_setapen=0
    has_setbpen=0
    has_guides=0
    has_sprintf=0
    has_fmt=0
    has_centered=0
    has_const90=0
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

    if (u ~ /^TLIBA3_DRAWVIEWMODEOVERLAY:/ || u ~ /^TLIBA3_DRAWVIEWMODEOVERLA[A-Z0-9_]*:/) has_entry=1
    if (n ~ /MATHMULU32/) has_mulu=1
    if (n ~ /TLIBA3VMARRAYRUNTIMETABLE/) has_vm_table=1
    if (u ~ /10\(A0\)/ || u ~ /\$A\(A[0-7]\)/ || u ~ /#10([^0-9]|$)/ || u ~ /\$A/) has_offset10=1
    if (n ~ /LVOSETFONT/) has_setfont=1
    if (n ~ /LVOSETRAST/) has_setrast=1
    if (n ~ /LVOSETDRMD/) has_setdrmd=1
    if (n ~ /LVOSETAPEN/) has_setapen=1
    if (n ~ /LVOSETBPEN/) has_setbpen=1
    if (n ~ /TLIBA3DRAWVIEWMODEGUIDES/) has_guides=1
    if (n ~ /WDISPSPRINTF/) has_sprintf=1
    if (n ~ /TLIBA1FMTVIEWMODEPCTLD/) has_fmt=1
    if (n ~ /TLIBA3DRAWCENTEREDWRAPPEDTEXTLINES/ || n ~ /TLIBA3DRAWCENTEREDWRAPPEDTEXTLI/) has_centered=1
    if (u ~ /#90([^0-9]|$)/ || u ~ /#\$5A/ || u ~ /\(\$5A\)/ || u ~ /90\.W/) has_const90=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MULU_CALL="has_mulu
    print "HAS_VM_TABLE="has_vm_table
    print "HAS_OFFSET_10="has_offset10
    print "HAS_SET_FONT="has_setfont
    print "HAS_SET_RAST="has_setrast
    print "HAS_SET_DRMD="has_setdrmd
    print "HAS_SET_APEN="has_setapen
    print "HAS_SET_BPEN="has_setbpen
    print "HAS_DRAW_GUIDES_CALL="has_guides
    print "HAS_SPRINTF_CALL="has_sprintf
    print "HAS_FMT_SYMBOL="has_fmt
    print "HAS_CENTERED_WRAPPED_CALL="has_centered
    print "HAS_CONST_90="has_const90
    print "HAS_RTS="has_rts
}
