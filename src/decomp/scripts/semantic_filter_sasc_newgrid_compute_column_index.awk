BEGIN {
    has_entry=0
    has_row_height=0
    has_sel_char_check=0
    has_div_call=0
    has_shift_quarter=0
    has_result_return=0
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

    if (u ~ /^NEWGRID_COMPUTECOLUMNINDEX:/ || u ~ /^NEWGRID_COMPUTECOLUMNINDE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDROWHEIGHTPX/) has_row_height=1
    if (u ~ /CMPI\.B .*54\(A[0-7]\)/ || u ~ /CMPI\.B #\$40,\(A[0-7]\)/ || u ~ /CMP\.B #\$40/) has_sel_char_check=1
    if (n ~ /NEWGRIDJMPTBLMATHDIVS32/) has_div_call=1
    if (u ~ /ASR\.L #2,D[0-7]/ || u ~ /ASR\.L #\$2,D[0-7]/ || u ~ /LSR\.L #2,D[0-7]/ || u ~ /LSR\.L #\$2,D[0-7]/) has_shift_quarter=1
    if (u ~ /^MOVE\.L D[0-7],D0$/) has_result_return=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ROW_HEIGHT_GLOBAL="has_row_height
    print "HAS_SELECTION_CHAR_CHECK="has_sel_char_check
    print "HAS_DIV_CALL="has_div_call
    print "HAS_QUARTER_SHIFT="has_shift_quarter
    print "HAS_RESULT_MOVE_TO_D0="has_result_return
    print "HAS_RTS="has_rts
}
