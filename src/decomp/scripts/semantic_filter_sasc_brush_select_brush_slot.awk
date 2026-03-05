BEGIN {
    has_entry = 0
    has_null_guard = 0
    has_half_bias = 0
    has_blit_call = 0
    has_minterm_192 = 0
    has_rts = 0
}

function trim(s,    t) {
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
    u = toupper(line)

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /TST\.L .*A[0-7]/ || u ~ /BEQ|JEQ/) has_null_guard = 1
    if (u ~ /ASR\.L[[:space:]]*#1/ || u ~ /ASR\.L[[:space:]]*#\$1/ || u ~ /ADDQ\.L[[:space:]]*#1/ || u ~ /ADDQ\.L[[:space:]]*#\$1/) has_half_bias = 1
    if (u ~ /BLTBITMAPRASTPORT/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPR/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITM/) has_blit_call = 1
    if (u ~ /192\.W|#192|#\$C0|\(\$C0\)\.W/) has_minterm_192 = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_HALF_BIAS_MATH=" has_half_bias
    print "HAS_BLIT_CALL=" has_blit_call
    print "HAS_MINTERM_192=" has_minterm_192
    print "HAS_RTS=" has_rts
}
