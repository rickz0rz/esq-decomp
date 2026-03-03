BEGIN {
    has_label = 0
    has_save = 0
    has_load_a3 = 0
    has_finalize = 0
    has_ptr_index = 0
    has_len_index = 0
    has_len_load = 0
    has_setup_a0a1 = 0
    has_textlength = 0
    has_restore = 0
    has_return = 0
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

    if (uline ~ /^DISPTEXT_MEASURECURRENTLINELENGTH:/) has_label = 1
    if (index(uline, "MOVE.L A3,-(A7)") > 0) has_save = 1
    if (index(uline, "MOVEA.L 8(A7),A3") > 0) has_load_a3 = 1
    if (index(uline, "BSR.W DISPTEXT_FINALIZELINETABLE") > 0) has_finalize = 1
    if (index(uline, "LEA DISPTEXT_LINEPTRTABLE,A0") > 0 || index(uline, "ADDA.L D0,A0") > 0) has_ptr_index = 1
    if (index(uline, "LEA DISPTEXT_LINELENGTHTABLE,A1") > 0 || index(uline, "ADDA.L D0,A1") > 0) has_len_index = 1
    if (index(uline, "MOVE.W (A1),D0") > 0) has_len_load = 1
    if (index(uline, "MOVEA.L A3,A1") > 0 || index(uline, "MOVEA.L (A0),A0") > 0) has_setup_a0a1 = 1
    if (index(uline, "LVOTEXTLENGTH(A6)") > 0) has_textlength = 1
    if (index(uline, "MOVEA.L (A7)+,A3") > 0) has_restore = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_LOAD_A3=" has_load_a3
    print "HAS_FINALIZE=" has_finalize
    print "HAS_PTR_INDEX=" has_ptr_index
    print "HAS_LEN_INDEX=" has_len_index
    print "HAS_LEN_LOAD=" has_len_load
    print "HAS_SETUP_A0A1=" has_setup_a0a1
    print "HAS_TEXTLENGTH=" has_textlength
    print "HAS_RESTORE=" has_restore
    print "HAS_RETURN=" has_return
}
