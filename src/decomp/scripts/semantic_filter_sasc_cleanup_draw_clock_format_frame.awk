BEGIN {
    has_label = 0
    has_col_x = 0
    has_rastport = 0
    has_source_bitmap = 0
    has_const_660 = 0
    has_const_36 = 0
    has_const_34 = 0
    has_const_192 = 0
    has_blt = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_DRAWCLOCKFORMATFRAME[A-Z0-9_]*:/) has_label = 1
    if (u ~ /NEWGRID_COLUMNSTARTXPX/) has_col_x = 1
    if (u ~ /NEWGRID_MAINRASTPORTPTR/) has_rastport = 1
    if (u ~ /4\(A0\)/ || u ~ /\(A0\),-\(A7\)/ || u ~ /MOVE.L .*4\(A0\)/) has_source_bitmap = 1
    if (u ~ /#660/ || u ~ /#\$294/) has_const_660 = 1
    if (u ~ /#36/ || u ~ /#\$24/) has_const_36 = 1
    if (u ~ /#34/ || u ~ /#\$22/) has_const_34 = 1
    if (u ~ /#192/ || u ~ /#\$C0/ || u ~ /PEA 192\.W/ || u ~ /PEA \(\$C0\)\.W/) has_const_192 = 1
    if (u ~ /BLTBITMAPRASTPORT/ || u ~ /BLTBITM/) has_blt = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_COL_X=" has_col_x
    print "HAS_RASTPORT=" has_rastport
    print "HAS_SOURCE_BITMAP=" has_source_bitmap
    print "HAS_CONST_660=" has_const_660
    print "HAS_CONST_36=" has_const_36
    print "HAS_CONST_34=" has_const_34
    print "HAS_CONST_192=" has_const_192
    print "HAS_BLT=" has_blt
    print "HAS_RETURN=" has_return
}
