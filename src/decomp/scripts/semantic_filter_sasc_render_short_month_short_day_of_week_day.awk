BEGIN {
    has_label = 0
    has_bitmap_swap = 0
    has_sprintf = 0
    has_setapen = 0
    has_setdrmd = 0
    has_rectfill = 0
    has_textlength = 0
    has_move = 0
    has_text = 0
    has_blt = 0
    has_center_const = 0
    has_return = 0
    pending_bitmap_reg = ""
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY[A-Z0-9_]*:/ || u ~ /^RENDER_SHORT_MONTH_SHORT_DAY_OF_[A-Z0-9_]*:/) has_label = 1
    if (u ~ /^LEA GLOBAL_REF_696_400_BITMAP\(A4\),A[0-7]$/) {
        pending_bitmap_reg = substr(u, length(u), 1)
    } else if (pending_bitmap_reg != "" && u ~ ("^MOVE\\.L A" pending_bitmap_reg ",(\\$4\\(A[0-7]\\)|4\\(A[0-7]\\)|STRUCT_RASTPORT__BITMAP\\(A[0-7]\\))$")) {
        has_bitmap_swap = 1
        pending_bitmap_reg = ""
    } else {
        pending_bitmap_reg = ""
    }
    if ((u ~ /GLOBAL_REF_696_400_BITMAP/ && (u ~ /4\(A0\)/ || u ~ /4\(A[0-7]\)/ || u ~ /4\(A1\)/ || u ~ /STRUCT_RASTPORT__BITMAP\(A0\)/)) || u ~ /MOVE.L A0,\(A1\)/) has_bitmap_swap = 1
    if (u ~ /WDISP_SPRINTF/ || u ~ /WDISP_SPRINT/) has_sprintf = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVOSETDRMD/) has_setdrmd = 1
    if (u ~ /_LVORECTFILL/) has_rectfill = 1
    if (u ~ /_LVOTEXTLENGTH/) has_textlength = 1
    if (u ~ /_LVOMOVE/) has_move = 1
    if (u ~ /_LVOTEXT/) has_text = 1
    if (u ~ /BLTBITMAPRASTPORT/ || u ~ /BLTBITM/) has_blt = 1
    if (u ~ /#108/ || u ~ /#\$6C/) has_center_const = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_BITMAP_SWAP=" has_bitmap_swap
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_SETAPEN=" has_setapen
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_BLT=" has_blt
    print "HAS_CENTER_CONST=" has_center_const
    print "HAS_RETURN=" has_return
}
