BEGIN {
    has_entry=0
    has_fmt_call=0
    has_diag_offsets=0
    has_diw_ddf=0
    has_bplmods=0
    has_bplcon=0
    has_bplptrs=0
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
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TLIBA3_FORMATPATTERNREGISTERDUMP:/ || u ~ /^TLIBA3_FORMATPATTERNREGISTERDUM[A-Z0-9_]*:/) has_entry=1
    if (n ~ /FORMATRAWDOFMTWITHSCRATCHBUFFER/ || n ~ /FORMATRAWDOFMTWITHSCRATCHBUFF/) has_fmt_call=1
    if (n ~ /TLIBA1DIAGDIWOFFSET/ || n ~ /TLIBA1DIAGDDFOFFSET/ || n ~ /TLIBA1DIAGBPLCON1VALUE/) has_diag_offsets=1
    if (n ~ /TLIBA1FMTDIWSTRT/ || n ~ /TLIBA1FMTDIWSTOP/ || n ~ /TLIBA1FMTDDFSTRT/ || n ~ /TLIBA1FMTDDFSTOP/) has_diw_ddf=1
    if (n ~ /TLIBA1FMTBPL1MOD/ || n ~ /TLIBA1FMTBPL2MOD/) has_bplmods=1
    if (n ~ /TLIBA1FMTBPLCON0/ || n ~ /TLIBA1FMTBPLCON1/ || n ~ /TLIBA1FMTBPLCON2/) has_bplcon=1
    if (n ~ /TLIBA1FMTBPL1PTH/ || n ~ /TLIBA1FMTBPL1PTL/ || n ~ /TLIBA1FMTBPL5PTH/ || n ~ /TLIBA1FMTBPL5PTL/) has_bplptrs=1
    if (n ~ /TLIBA1STRPATTERNDUMPSEPARATORNEWLINE/ || n ~ /TLIBA1STRPATTERNDUMPSEPARATOR/) has_separator=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FMT_CALL=" has_fmt_call
    print "HAS_DIAG_OFFSETS=" has_diag_offsets
    print "HAS_DIW_DDF_LINES=" has_diw_ddf
    print "HAS_BPLMOD_LINES=" has_bplmods
    print "HAS_BPLCON_LINES=" has_bplcon
    print "HAS_BPL_POINTER_LINES=" has_bplptrs
    print "HAS_SEPARATOR=" has_separator
    print "HAS_RTS=" has_rts
}
