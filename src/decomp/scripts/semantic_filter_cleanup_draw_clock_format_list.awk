BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_update_bounds = 0
    has_row_loop = 0
    has_final_row = 0
    has_mulu32 = 0
    has_bevel = 0
    has_format_entry = 0
    has_textlength = 0
    has_move = 0
    has_text = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^CLEANUP_DRAWCLOCKFORMATLIST:/) has_label = 1
    if (uline ~ /LINK.W A5,#-100/) has_link = 1
    if (uline ~ /MOVEM.L D2-D3\/D5-D7,-\(A7\)/) has_save = 1
    if (uline ~ /GROUP_AC_JMPTBL_GCOMMAND_UPDATEBANNERBOUNDS/) has_update_bounds = 1
    if (uline ~ /\.ROW_LOOP:/) has_row_loop = 1
    if (uline ~ /\.FINAL_ROW:/) has_final_row = 1
    if (uline ~ /GROUP_AG_JMPTBL_MATH_MULU32/) has_mulu32 = 1
    if (uline ~ /BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT/) has_bevel = 1
    if (uline ~ /CLEANUP_FORMATCLOCKFORMATENTRY/) has_format_entry = 1
    if (uline ~ /LVOTEXTLENGTH/) has_textlength = 1
    if (uline ~ /LVOMOVE/) has_move = 1
    if (uline ~ /LVOTEXT([^A-Z]|$)/) has_text = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_UPDATE_BOUNDS=" has_update_bounds
    print "HAS_ROW_LOOP=" has_row_loop
    print "HAS_FINAL_ROW=" has_final_row
    print "HAS_MULU32=" has_mulu32
    print "HAS_BEVEL=" has_bevel
    print "HAS_FORMAT_ENTRY=" has_format_entry
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
}
