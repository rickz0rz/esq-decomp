BEGIN {
    has_entry = 0
    has_dma_ptr_write = 0
    has_len_one = 0
    has_period = 0
    has_dmacon = 0
    has_zero_ctrl = 0
    has_return = 0
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

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /GLOBAL_PTR_AUD1_DMA/ || l ~ /#\$?DFF0B0/ || l ~ /#0X00DFF0B0/ || l ~ /#14676144/) has_dma_ptr_write = 1
    if ((l ~ /#1/ && l ~ /DFF0B4/) || (l ~ /#1/ && l ~ /AUD1LEN/) || (l ~ /^MOVE\.W #1,\(30,A0\)$/) || (l ~ /#\$?1/ && l ~ /\$?B4/)) has_len_one = 1
    if (l ~ /#\$?65B/ || l ~ /#1627/) has_period = 1
    if (l ~ /#\$?8202/ || l ~ /#33282/ || l ~ /#-32254/) has_dmacon = 1
    if (l ~ /CTRL_BIT4CAPTUREDELAYCOUNTER/ || l ~ /CTRL_BIT4CAPTUREPHASE/ || l ~ /CTRL_SAMPLEENTRYCOUNT/) has_zero_ctrl = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DMA_PTR_WRITE=" has_dma_ptr_write
    print "HAS_LEN_ONE=" has_len_one
    print "HAS_PERIOD_065B=" has_period
    print "HAS_DMACON_8202=" has_dmacon
    print "HAS_CTRL_ZERO_WRITES=" has_zero_ctrl
    print "HAS_RETURN=" has_return
}
