BEGIN {
    has_entry = 0
    has_dealloc_call = 0
    has_clear_ads_ptr = 0
    has_clear_ads_size = 0
    has_clear_logo_ptr = 0
    has_clear_logo_size = 0
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

    if (uline ~ /^ESQIFF_DEALLOCATEADSANDLOGOLSTDATA:/) has_entry = 1
    if (uline ~ /ESQIFF_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc_call = 1
    if (uline ~ /^CLR\.L GLOBAL_REF_LONG_GFX_G_ADS_DATA$/) has_clear_ads_ptr = 1
    if (uline ~ /^CLR\.L GLOBAL_REF_LONG_GFX_G_ADS_FILESIZE$/) has_clear_ads_size = 1
    if (uline ~ /^CLR\.L GLOBAL_REF_LONG_DF0_LOGO_LST_DATA$/) has_clear_logo_ptr = 1
    if (uline ~ /^CLR\.L GLOBAL_REF_LONG_DF0_LOGO_LST_FILESIZE$/) has_clear_logo_size = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_CLEAR_ADS_PTR=" has_clear_ads_ptr
    print "HAS_CLEAR_ADS_SIZE=" has_clear_ads_size
    print "HAS_CLEAR_LOGO_PTR=" has_clear_logo_ptr
    print "HAS_CLEAR_LOGO_SIZE=" has_clear_logo_size
    print "HAS_RTS=" has_rts
}
