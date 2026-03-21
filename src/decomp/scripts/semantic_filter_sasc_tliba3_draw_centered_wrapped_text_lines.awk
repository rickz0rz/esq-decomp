BEGIN {
    has_entry=0
    has_setdrmd=0
    has_setapen=0
    has_setbpen=0
    has_textlength=0
    has_display=0
    has_bytes_per_row=0
    has_baseline=0
    has_mask_restore=0
    has_depth_restore=0
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

    if (u ~ /^TLIBA3_DRAWCENTEREDWRAPPEDTEXTLINES:/ || u ~ /^TLIBA3_DRAWCENTEREDWRAPPEDTEXT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVOSETDRMD/) has_setdrmd=1
    if (n ~ /LVOSETAPEN/) has_setapen=1
    if (n ~ /LVOSETBPEN/) has_setbpen=1
    if (n ~ /LVOTEXTLENGTH/) has_textlength=1
    if (n ~ /DISPLIBDISPLAYTEXTATPOSITION/) has_display=1
    if (n ~ /BYTESPERROW/ || u ~ /MOVE.W \(A0\),D5/ || u ~ /MOVE.W \(A[0-7]\),D[0-7]/) has_bytes_per_row=1
    if (n ~ /TFBASELINE/ || u ~ /20\(A0\)/ || u ~ /\$1A\(A0\)/) has_baseline=1
    if (n ~ /MASK/ || u ~ /24\(A3\)/ || u ~ /\$18\(A5\)/) has_mask_restore=1
    if (n ~ /DEPTH/ || u ~ /5\(A0\)/) has_depth_restore=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SETDRMD="has_setdrmd
    print "HAS_SETAPEN="has_setapen
    print "HAS_SETBPEN="has_setbpen
    print "HAS_TEXTLENGTH="has_textlength
    print "HAS_DISPLAYTEXT="has_display
    print "HAS_BYTES_PER_ROW="has_bytes_per_row
    print "HAS_BASELINE_STEP="has_baseline
    print "HAS_MASK_RESTORE="has_mask_restore
    print "HAS_DEPTH_RESTORE="has_depth_restore
    print "HAS_RTS="has_rts
}
