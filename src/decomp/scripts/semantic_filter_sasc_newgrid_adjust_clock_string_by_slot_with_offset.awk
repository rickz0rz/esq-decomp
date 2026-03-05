BEGIN {
    has_entry=0
    has_normalize_call=0
    has_div_call=0
    has_mul_call=0
    has_seconds_to_struct_call=0
    has_slot_call=0
    has_const21=0
    has_const30=0
    has_const60=0
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

    if (u ~ /^NEWGRID_ADJUSTCLOCKSTRINGBYSLOTWITHOFFSET:/ || u ~ /^NEWGRID_ADJUSTCLOCKSTRINGBYSLOTWITHOFFSE[A-Z0-9_]*:/ || u ~ /^NEWGRID_ADJUSTCLOCKSTRINGBYSLOTW[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDJMPTBLDATETIMENORMALIZESTRUCTTOSECONDS/ || n ~ /NEWGRIDJMPTBLDATETIMENORMALIZESTRUCTTOSECO/ || n ~ /NEWGRIDJMPTBLDATETIMENORMALIZ/) has_normalize_call=1
    if (n ~ /NEWGRIDJMPTBLMATHDIVS32/) has_div_call=1
    if (n ~ /NEWGRIDJMPTBLMATHMULU32/) has_mul_call=1
    if (n ~ /NEWGRIDJMPTBLDATETIMESECONDSTOSTRUCT/ || n ~ /NEWGRIDJMPTBLDATETIMESECONDSTOSTRUC/ || n ~ /NEWGRIDJMPTBLDATETIMESECONDST/) has_seconds_to_struct_call=1
    if (n ~ /NEWGRIDCOMPUTEDAYSLOTFROMCLOCKWITHOFFSET/ || n ~ /NEWGRIDCOMPUTEDAYSLOTFROMCLOCKWITHOFFSE/ || n ~ /NEWGRIDCOMPUTEDAYSLOTFROMCLOCKW/) has_slot_call=1
    if (u ~ /#21([^0-9]|$)/ || u ~ /#\$15/ || u ~ /21\.[Ww]/ || u ~ /#22([^0-9]|$)/ || u ~ /#\$16/) has_const21=1
    if (u ~ /#30([^0-9]|$)/ || u ~ /#\$1E/ || u ~ /30\.[Ww]/ || u ~ /\(\$1E\)/) has_const30=1
    if (u ~ /#60([^0-9]|$)/ || u ~ /#\$3C/ || u ~ /60\.[Ww]/ || u ~ /\(\$3C\)/) has_const60=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_NORMALIZE_CALL="has_normalize_call
    print "HAS_DIV_CALL="has_div_call
    print "HAS_MUL_CALL="has_mul_call
    print "HAS_SECONDS_TO_STRUCT_CALL="has_seconds_to_struct_call
    print "HAS_SLOT_CALL="has_slot_call
    print "HAS_CONST_21="has_const21
    print "HAS_CONST_30="has_const30
    print "HAS_CONST_60="has_const60
    print "HAS_RETURN="has_return
}
