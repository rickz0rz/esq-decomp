BEGIN {
    label = 0
    has_null_guard = 0
    has_half_bias = 0
    has_blit_call = 0
    has_minterm_192 = 0
    has_return = 0
}

/^BRUSH_SelectBrushSlot:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /TST\.L .*A3|BEQ|JEQ/) has_null_guard = 1
    if (line ~ /ASR\.L[[:space:]]*#1|ADDQ\.L[[:space:]]*#1/ ) has_half_bias = 1
    if (line ~ /BLTBITMAPRASTPORT/) has_blit_call = 1
    if (line ~ /192\.W|#192|#\$C0/) has_minterm_192 = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_null_guard) print "HAS_NULL_GUARD"
    if (has_half_bias) print "HAS_HALF_BIAS_MATH"
    if (has_blit_call) print "HAS_BLIT_CALL"
    if (has_minterm_192) print "HAS_MINTERM_192"
    if (has_return) print "HAS_RTS"
}
