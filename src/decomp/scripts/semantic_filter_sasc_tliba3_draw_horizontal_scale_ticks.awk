BEGIN {
    has_entry=0
    has_move=0
    has_draw=0
    has_div25_or_mod25=0
    has_div5_or_mod5=0
    has_sprintf=0
    has_text_length=0
    has_text=0
    has_mulu=0
    has_fmt=0
    has_plus20=0
    has_plus25=0
    has_plus10=0
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

    if (u ~ /^TLIBA3_DRAWHORIZONTALSCALETICKS:/ || u ~ /^TLIBA3_DRAWHORIZONTALSCALETICK[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVOMOVE/) has_move=1
    if (n ~ /LVODRAW/) has_draw=1
    if (n ~ /MATHDIVS32/ || u ~ /#25([^0-9]|$)/ || u ~ /#\$19/) has_div25_or_mod25=1
    if (n ~ /MATHDIVS32/ || u ~ /#5([^0-9]|$)/ || u ~ /#\$5/ || u ~ /\(\$5\)/) has_div5_or_mod5=1
    if (n ~ /WDISPSPRINTF/) has_sprintf=1
    if (n ~ /LVOTEXTLENGTH/) has_text_length=1
    if (n ~ /LVOTEXT/) has_text=1
    if (n ~ /MATHMULU32/) has_mulu=1
    if (n ~ /TLIBA1FMTPCT03LDHORIZONTALSCALETICK/ || n ~ /TLIBA1FMTPCT03LDHORIZONTALSCA/) has_fmt=1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\$14/) has_plus20=1
    if (u ~ /#25([^0-9]|$)/ || u ~ /#\$19/) has_plus25=1
    if (u ~ /#10([^0-9]|$)/ || u ~ /#\$A/) has_plus10=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MOVE_CALL="has_move
    print "HAS_DRAW_CALL="has_draw
    print "HAS_DIV25_OR_MOD25="has_div25_or_mod25
    print "HAS_DIV5_OR_MOD5="has_div5_or_mod5
    print "HAS_SPRINTF_CALL="has_sprintf
    print "HAS_TEXT_LENGTH_CALL="has_text_length
    print "HAS_TEXT_CALL="has_text
    print "HAS_MULU_CALL="has_mulu
    print "HAS_FMT_SYMBOL="has_fmt
    print "HAS_PLUS_20="has_plus20
    print "HAS_PLUS_25="has_plus25
    print "HAS_PLUS_10="has_plus10
    print "HAS_RTS="has_rts
}
