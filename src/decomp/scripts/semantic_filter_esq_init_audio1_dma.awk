BEGIN {
    has_dma_ptr_write = 0
    has_len_one = 0
    has_period = 0
    has_dmacon = 0
    has_zero_ctrl = 0
    has_rts = 0
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

    if (uline ~ /GLOBAL_PTR_AUD1_DMA/ || uline ~ /#\$?DFF0B0/ || uline ~ /#0X00DFF0B0/ || uline ~ /#14676144/) has_dma_ptr_write = 1
    if ((uline ~ /#1/ && uline ~ /DFF0B4/) || (uline ~ /#1/ && uline ~ /AUD1LEN/) || (uline ~ /^MOVE\.W #1,\(30,A0\)$/)) has_len_one = 1
    if (uline ~ /#\$?65B/ || uline ~ /#1627/) has_period = 1
    if (uline ~ /#\$?8202/ || uline ~ /#33282/ || uline ~ /#-32254/) has_dmacon = 1
    if (uline ~ /CTRL_BIT4CAPTUREDELAYCOUNTER/ || uline ~ /CTRL_BIT4CAPTUREPHASE/ || uline ~ /CTRL_SAMPLEENTRYCOUNT/) has_zero_ctrl = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_DMA_PTR_WRITE=" has_dma_ptr_write
    print "HAS_LEN_ONE=" has_len_one
    print "HAS_PERIOD_065B=" has_period
    print "HAS_DMACON_8202=" has_dmacon
    print "HAS_CTRL_ZERO_WRITES=" has_zero_ctrl
    print "HAS_RTS=" has_rts
}
