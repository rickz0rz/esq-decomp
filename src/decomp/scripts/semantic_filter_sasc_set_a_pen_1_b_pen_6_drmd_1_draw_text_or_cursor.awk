BEGIN {
    has_entry=0
    has_set_apen1=0
    has_set_bpen6=0
    has_set_drmd1=0
    has_text_symbol=0
    has_cursor_symbol=0
    has_display=0
    has_x296=0
    has_y390=0
    has_set_bpen2=0
    has_set_drmd0=0
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

    if (u ~ /^SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR:/ || u ~ /^SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURS[A-Z0-9_]*:/ || u ~ /^SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_:/) has_entry=1
    if (n ~ /SETAPEN/ && (u ~ /#\$1/ || u ~ /#1([^0-9]|$)/ || u ~ /\(\$1\)/)) has_set_apen1=1
    if (n ~ /SETBPEN/ && (u ~ /#\$6/ || u ~ /#6([^0-9]|$)/ || u ~ /\(\$6\)/)) has_set_bpen6=1
    if (n ~ /SETDRMD/ && (u ~ /#\$1/ || u ~ /#1([^0-9]|$)/ || u ~ /\(\$1\)/)) has_set_drmd1=1
    if (n ~ /GLOBALSTRTEXT/) has_text_symbol=1
    if (n ~ /GLOBALSTRCURSOR/) has_cursor_symbol=1
    if (n ~ /DISPLAYTEXTATPOSITION/) has_display=1
    if (u ~ /296/ || u ~ /\$128/) has_x296=1
    if (u ~ /390/ || u ~ /\$186/) has_y390=1
    if (n ~ /SETBPEN/ && (u ~ /#\$2/ || u ~ /#2([^0-9]|$)/ || u ~ /\(\$2\)/)) has_set_bpen2=1
    if (n ~ /SETDRMD/ && (u ~ /#\$0/ || u ~ /#0([^0-9]|$)/ || u ~ /\(\$0\)/)) has_set_drmd0=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SET_APEN_1="has_set_apen1
    print "HAS_SET_BPEN_6="has_set_bpen6
    print "HAS_SET_DRMD_1="has_set_drmd1
    print "HAS_TEXT_SYMBOL="has_text_symbol
    print "HAS_CURSOR_SYMBOL="has_cursor_symbol
    print "HAS_DISPLAY_CALL="has_display
    print "HAS_X_296="has_x296
    print "HAS_Y_390="has_y390
    print "HAS_SET_BPEN_2="has_set_bpen2
    print "HAS_SET_DRMD_0="has_set_drmd0
    print "HAS_RTS="has_rts
}
