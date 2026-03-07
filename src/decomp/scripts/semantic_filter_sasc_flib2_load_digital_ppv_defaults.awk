BEGIN {
    has_entry=0
    replace_calls=0
    has_enable=0
    has_workflow=0
    has_detail_flag=0
    has_listings_ptr=0
    has_period_ptr=0
    has_row_span=0
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

    if (u ~ /^FLIB2_LOADDIGITALPPVDEFAULTS:/ || u ~ /^FLIB2_LOADDIGITALPPVDEFA[A-Z0-9_]*:/) has_entry=1
    if ((u ~ /^(JSR|BSR|JMP)(\.[A-Z])?[ \t]/) && n ~ /ESQPARSREPLACEOWNEDSTRING/) replace_calls++
    if (n ~ /GCOMMANDDIGITALPPVENABLEDFLAG/) has_enable=1
    if (n ~ /GCOMMANDPPVSHOWTIMESWORKFLOWMOD/) has_workflow=1
    if (n ~ /GCOMMANDPPVDETAILLAYOUTFLAG/) has_detail_flag=1
    if (n ~ /GCOMMANDPPVLISTINGSTEMPLATEPTR/) has_listings_ptr=1
    if (n ~ /GCOMMANDPPVPERIODTEMPLATEPTR/) has_period_ptr=1
    if (n ~ /GCOMMANDPPVSHOWTIMESROWSPAN/) has_row_span=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "REPLACE_CALLS="replace_calls
    print "HAS_ENABLE_FLAG_GLOBAL="has_enable
    print "HAS_WORKFLOW_GLOBAL="has_workflow
    print "HAS_DETAILFLAG_GLOBAL="has_detail_flag
    print "HAS_LISTINGS_PTR_GLOBAL="has_listings_ptr
    print "HAS_PERIOD_PTR_GLOBAL="has_period_ptr
    print "HAS_ROWSPAN_GLOBAL="has_row_span
    print "HAS_RTS="has_rts
}
