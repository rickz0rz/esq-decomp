BEGIN {
    has_entry = 0
    has_rts = 0
    has_bad_control = 0
}

function up(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = up($0)
    if (l == "") next

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (l == "RTS") has_rts = 1

    # For a no-op semantic check, reject control-transfer except stack-check guard.
    if (l ~ /^(JMP|JSR|BSR|BRA|BHI|BLS|BCC|BCS|BNE|BEQ|BVC|BVS|BPL|BMI|BGE|BLT|BGT|BLE)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_bad_control = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_BAD_CONTROL=" has_bad_control
}
