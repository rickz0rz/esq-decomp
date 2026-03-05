BEGIN {
    has_entry=0
    has_skipclass3_call=0
    has_copyuntil_call=0
    has_textlength_call=0
    has_move_call=0
    has_text_call=0
    has_single_space=0
    has_word_spacer=0
    has_return_spacer=0
    has_const50=0
    has_const1=0
    has_const0=0
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

    if (u ~ /^NEWGRID_DRAWWRAPPEDTEXT:/ || u ~ /^NEWGRID_DRAWWRAPPEDTEX[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3CHARS/ || n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3/) has_skipclass3_call=1
    if (n ~ /NEWGRIDJMPTBLSTRCOPYUNTILANYDELIMN/ || n ~ /NEWGRIDJMPTBLSTRCOPYUNTILA/) has_copyuntil_call=1
    if (n ~ /LVOTEXTLENGTH/ || n ~ /TEXTLENGTH/) has_textlength_call=1
    if (n ~ /LVOMOVE/) has_move_call=1
    if (n ~ /LVOTEXT/) has_text_call=1
    if (n ~ /GLOBALSTRINGLESPACE/ || n ~ /GLOBALSTRSINGLESP/) has_single_space=1
    if (n ~ /NEWGRIDWRAPWORDSPACER/ || n ~ /NEWGRIDWRAPWORDSP/) has_word_spacer=1
    if (n ~ /NEWGRIDWRAPRETURNSPACER/ || n ~ /NEWGRIDWRAPRETURNSP/) has_return_spacer=1
    if (u ~ /#50([^0-9]|$)/ || u ~ /#\$32/ || u ~ /50\.[Ww]/ || u ~ /\(\$32\)\.[Ww]/) has_const50=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)\.[Ww]/) has_const1=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || n ~ /CLR/) has_const0=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SKIPCLASS3_CALL="has_skipclass3_call
    print "HAS_COPYUNTIL_CALL="has_copyuntil_call
    print "HAS_TEXTLENGTH_CALL="has_textlength_call
    print "HAS_MOVE_CALL="has_move_call
    print "HAS_TEXT_CALL="has_text_call
    print "HAS_SINGLE_SPACE_GLOBAL="has_single_space
    print "HAS_WORD_SPACER="has_word_spacer
    print "HAS_RETURN_SPACER="has_return_spacer
    print "HAS_CONST_50="has_const50
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_0="has_const0
    print "HAS_RETURN="has_return
}
