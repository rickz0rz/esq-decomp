BEGIN {
    has_label = 0
    has_alias = 0
    has_link = 0
    has_save = 0
    has_find_char = 0
    has_build_clock_entry = 0
    has_build_status_line = 0
    has_parse_block = 0
    has_update_entry_flags = 0
    has_format_tokens = 0
    has_draw_inset = 0
    has_blit = 0
    has_copper_rise = 0
    has_restore = 0
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

    if (uline ~ /^CLEANUP_BUILDANDRENDERALIGNEDSTATUSBANNER:/) has_label = 1
    if (uline ~ /^CLEANUP_RENDERALIGNEDSTATUSSCREEN:/) has_alias = 1
    if (uline ~ /LINK.W A5,#-840/) has_link = 1
    if (uline ~ /MOVEM.L D2-D7\/A2,-\(A7\)/) has_save = 1
    if (uline ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/) has_find_char = 1
    if (uline ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/) has_build_clock_entry = 1
    if (uline ~ /CLEANUP_BUILDALIGNEDSTATUSLINE/) has_build_status_line = 1
    if (uline ~ /CLEANUP_PARSEALIGNEDLISTINGBLOCK/) has_parse_block = 1
    if (uline ~ /CLEANUP_UPDATEENTRYFLAGBYTES/) has_update_entry_flags = 1
    if (uline ~ /CLEANUP_FORMATENTRYSTRINGTOKENS/) has_format_tokens = 1
    if (uline ~ /CLEANUP_DRAWINSETRECTFRAME/) has_draw_inset = 1
    if (uline ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/) has_blit = 1
    if (uline ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANSITION/) has_copper_rise = 1
    if (uline ~ /MOVEM.L -868\(A5\),D2-D7\/A2/ || uline ~ /UNLK A5/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_ALIAS=" has_alias
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_BUILD_CLOCK_ENTRY=" has_build_clock_entry
    print "HAS_BUILD_STATUS_LINE=" has_build_status_line
    print "HAS_PARSE_BLOCK=" has_parse_block
    print "HAS_UPDATE_ENTRY_FLAGS=" has_update_entry_flags
    print "HAS_FORMAT_TOKENS=" has_format_tokens
    print "HAS_DRAW_INSET=" has_draw_inset
    print "HAS_BLIT=" has_blit
    print "HAS_COPPER_RISE=" has_copper_rise
    print "HAS_RESTORE=" has_restore
}
