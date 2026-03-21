function toupper_line(s, out) {
    out = toupper(s)
    sub(/;.*/, "", out)
    gsub(/^[ \t]+|[ \t]+$/, "", out)
    gsub(/[ \t]+/, " ", out)
    return out
}

{
    line = toupper_line($0)
    if (line == "") {
        next
    }

    if (line ~ /^LOCAVAIL_GETFILTERWINDOWHALFSPAN:/ || line ~ /^LOCAVAIL_GETFILTERWINDOWHALFSPA[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /LOCAVAIL_FILTERMODEFLAG/) has_mode_flag = 1
    if (line ~ /LOCAVAIL_FILTERWINDOWHALFSPAN/) has_window_half_span = 1
    if (line ~ /^MOVEQ(\.L)? #(\$1E|30),D[07]$/) has_default_span = 1
    if (line ~ /^ASR\.W #(\$1|1),D7$/ || line ~ /^ASR\.W #(\$1|1),D0$/) has_shift = 1
    if (line ~ /^ADDQ\.W #(\$1|1),D7$/ || line ~ /^ADDQ\.W #(\$1|1),D0$/) has_bias = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_FLAG=" has_mode_flag
    print "HAS_WINDOW_HALF_SPAN=" has_window_half_span
    print "HAS_DEFAULT_SPAN=" has_default_span
    print "HAS_SHIFT=" has_shift
    print "HAS_BIAS=" has_bias
    print "HAS_RETURN=" has_return
}
