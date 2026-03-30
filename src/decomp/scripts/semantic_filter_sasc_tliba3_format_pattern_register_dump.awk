BEGIN {
    has_entry=0
    fmt_call_count=0
    has_diag_header=0
    has_diwstrt=0
    has_diwstop=0
    has_diwstop_extend=0
    has_ddfstrt=0
    has_ddfstop=0
    has_bpl1mod=0
    has_bpl2mod=0
    has_bplcon0=0
    has_bplcon1=0
    has_bplcon2=0
    has_bpl1pth=0
    has_bpl1ptl=0
    has_bpl2pth=0
    has_bpl2ptl=0
    has_bpl3pth=0
    has_bpl3ptl=0
    has_bpl4pth=0
    has_bpl4ptl=0
    has_bpl5pth=0
    has_bpl5ptl=0
    has_diag_offsets=0
    has_separator=0
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
    if (u ~ /^XREF / || u ~ /^XDEF / || u ~ /^ END$/ || u ~ /^END$/) next
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TLIBA3_FORMATPATTERNREGISTERDUMP:/ || u ~ /^TLIBA3_FORMATPATTERNREGISTERDUM[A-Z0-9_]*:/) has_entry=1
    if (n ~ /FORMATRAWDOFMTWITHSCRATCHBUFFER/ || n ~ /FORMATRAWDOFMTWITHSCRATCHBUFF/) fmt_call_count++
    if (n ~ /TLIBA1DIAGDIWOFFSET/ || n ~ /TLIBA1DIAGDDFOFFSET/ || n ~ /TLIBA1DIAGBPLCON1VALUE/) has_diag_offsets=1
    if (n ~ /TLIBA1FMTPCTSCOLONDIWOFFSET/ || n ~ /TLIBA1FMTPCTSCOLO?NDIWOFFSET/) has_diag_header=1
    if (n ~ /TLIBA1FMTDIWSTRTCOLON0XPCT/) has_diwstrt=1
    if (n ~ /TLIBA1FMTDIWSTOPCOLON0XPCT/) has_diwstop=1
    if (n ~ /TLIBA1FMTDDFSTRTCOLON0XPCT/) has_ddfstrt=1
    if (n ~ /TLIBA1FMTDDFSTOPCOLON0XPCT/) has_ddfstop=1
    if (n ~ /TLIBA1FMTBPL1MODCOLON0XPCT/) has_bpl1mod=1
    if (n ~ /TLIBA1FMTBPL2MODCOLON0XPCT/) has_bpl2mod=1
    if (n ~ /TLIBA1FMTBPLCON0COLON0XPCT/) has_bplcon0=1
    if (n ~ /TLIBA1FMTBPLCON1COLON0XPCT/) has_bplcon1=1
    if (n ~ /TLIBA1FMTBPLCON2COLON0XPCT/) has_bplcon2=1
    if (n ~ /TLIBA1FMTBPL1PTHCOLON0XPCT/) has_bpl1pth=1
    if (n ~ /TLIBA1FMTBPL1PTLCOLON0XPCT/) has_bpl1ptl=1
    if (n ~ /TLIBA1FMTBPL2PTHCOLON0XPCT/) has_bpl2pth=1
    if (n ~ /TLIBA1FMTBPL2PTLCOLON0XPCT/) has_bpl2ptl=1
    if (n ~ /TLIBA1FMTBPL3PTHCOLON0XPCT/) has_bpl3pth=1
    if (n ~ /TLIBA1FMTBPL3PTLCOLON0XPCT/) has_bpl3ptl=1
    if (n ~ /TLIBA1FMTBPL4PTHCOLON0XPCT/) has_bpl4pth=1
    if (n ~ /TLIBA1FMTBPL4PTLCOLON0XPCT/) has_bpl4ptl=1
    if (n ~ /TLIBA1FMTBPL5PTHCOLON0XPCT/) has_bpl5pth=1
    if (n ~ /TLIBA1FMTBPL5PTLCOLON0XPCT/) has_bpl5ptl=1
    if (u ~ /#\$100/ || u ~ /#100/) has_diwstop_extend=1
    if (n ~ /TLIBA1STRPATTERNDUMPSEPARATORNEWLINE/ || n ~ /TLIBA1STRPATTERNDUMPSEPARATOR/) has_separator=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "FMT_CALL_COUNT=" fmt_call_count
    print "HAS_DIAG_HEADER=" has_diag_header
    print "HAS_DIAG_OFFSETS=" has_diag_offsets
    print "HAS_DIWSTRT=" has_diwstrt
    print "HAS_DIWSTOP=" has_diwstop
    print "HAS_DIWSTOP_EXTEND=" has_diwstop_extend
    print "HAS_DDFSTRT=" has_ddfstrt
    print "HAS_DDFSTOP=" has_ddfstop
    print "HAS_BPL1MOD=" has_bpl1mod
    print "HAS_BPL2MOD=" has_bpl2mod
    print "HAS_BPLCON0=" has_bplcon0
    print "HAS_BPLCON1=" has_bplcon1
    print "HAS_BPLCON2=" has_bplcon2
    print "HAS_BPL1PTH=" has_bpl1pth
    print "HAS_BPL1PTL=" has_bpl1ptl
    print "HAS_BPL2PTH=" has_bpl2pth
    print "HAS_BPL2PTL=" has_bpl2ptl
    print "HAS_BPL3PTH=" has_bpl3pth
    print "HAS_BPL3PTL=" has_bpl3ptl
    print "HAS_BPL4PTH=" has_bpl4pth
    print "HAS_BPL4PTL=" has_bpl4ptl
    print "HAS_BPL5PTH=" has_bpl5pth
    print "HAS_BPL5PTL=" has_bpl5ptl
    print "HAS_SEPARATOR=" has_separator
    print "HAS_RTS=" has_rts
}
