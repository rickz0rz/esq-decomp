BEGIN {
    has_entry=0
    has_selection_field=0
    has_flag16=0
    has_flag32=0
    has_flag34p=0
    has_flag34a=0
    has_flag35=0
    has_flag4849=0
    has_niche=0
    has_mplex=0
    has_ppv=0
    has_const16=0
    has_const89=0
    has_zero_write=0
    has_selection_write=0
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

    if (u ~ /^NEWGRID_VALIDATESELECTIONCODE:/ || u ~ /^NEWGRID_VALIDATESELECTIONCOD[A-Z0-9_]*:/) has_entry=1
    if (u ~ /54\(A[0-7]\)/ || n ~ /SELECTIONCODE/) has_selection_field=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE16ENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE16EN/) has_flag16=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE32ENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE32EN/) has_flag32=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE34PRIMARYENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE34PRI/) has_flag34p=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE34ALTENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE34ALT/) has_flag34a=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE35ENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE35EN/) has_flag35=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE4849ENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE4849/) has_flag4849=1
    if (n ~ /GCOMMANDDIGITALNICHEENABLEDFLAG/) has_niche=1
    if (n ~ /GCOMMANDDIGITALMPLEXENABLEDFLAG/) has_mplex=1
    if (n ~ /GCOMMANDDIGITALPPVENABLEDFLAG/) has_ppv=1
    if (u ~ /#16([^0-9]|$)/ || u ~ /#\$10/) has_const16=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/) has_const89=1
    if (u ~ /CLR\.B (54|\$36)\(A[0-7]\)/ || n ~ /SELECTIONCODE0/) has_zero_write=1
    if (u ~ /MOVE\.B D[027],(54|\$36)\(A[0-7]\)/ || n ~ /SELECTIONCODECODE/) has_selection_write=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SELECTION_FIELD="has_selection_field
    print "HAS_FLAG16="has_flag16
    print "HAS_FLAG32="has_flag32
    print "HAS_FLAG34_PRIMARY="has_flag34p
    print "HAS_FLAG34_ALT="has_flag34a
    print "HAS_FLAG35="has_flag35
    print "HAS_FLAG48_49="has_flag4849
    print "HAS_NICHE_FLAG="has_niche
    print "HAS_MPLEX_FLAG="has_mplex
    print "HAS_PPV_FLAG="has_ppv
    print "HAS_CONST16="has_const16
    print "HAS_CONST89="has_const89
    print "HAS_ZERO_WRITE="has_zero_write
    print "HAS_SELECTION_WRITE="has_selection_write
    print "HAS_RTS="has_rts
}
