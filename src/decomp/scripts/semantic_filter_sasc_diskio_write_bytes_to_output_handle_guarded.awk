BEGIN {
    has_entry = 0
    has_save = 0
    has_write = 0
    has_restore = 0
    has_retval = 0
    has_rts = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^DISKIO_WRITEBYTESTOOUTPUTHANDLE/) has_entry = 1
    if (index(l, "ESQPARS2_READMODEFLAGS") > 0 && index(l, "DISKIO_SAVEDREADMODEFLAGS") > 0) has_save = 1
    if (index(l, "_LVOWRITE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_write = 1
    if (index(l, "DISKIO_SAVEDREADMODEFLAGS") > 0 && index(l, "ESQPARS2_READMODEFLAGS") > 0) has_restore = 1
    if (l ~ /^MOVEQ(\.L)? #(-1|0),D0$/ || l ~ /^MOVEQ(\.L)? #\$?(FF|0),D0$/ || l ~ /^SNE D0$/ || l ~ /^EXT\.W D0$/ || l ~ /^EXT\.L D0$/ || l ~ /^NEG\.L D0$/) has_retval = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_WRITE=" has_write
    print "HAS_RESTORE=" has_restore
    print "HAS_RETVAL=" has_retval
    print "HAS_RTS=" has_rts
}
