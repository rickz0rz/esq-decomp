BEGIN {
    has_label = 0
    has_alias = 0
    has_find_char = 0
    has_build_clock_entry = 0
    has_build_status_line = 0
    has_blit = 0
    has_copper_rise = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_BUILDANDRENDERALIGNEDSTA[A-Z0-9_]*:/) has_label = 1
    if (u ~ /^CLEANUP_RENDERALIGNEDSTATUSSCRE[A-Z0-9_]*:/) has_alias = 1
    if (u ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/ || u ~ /GROUP_AI_JMPTBL_STR_FINDCHARP/) has_find_char = 1
    if (u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIB/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOC/) has_build_clock_entry = 1
    if (u ~ /CLEANUP_BUILDALIGNEDSTATUSLINE/) has_build_status_line = 1
    if (u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTP/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITM/) has_blit = 1
    if (u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANSITION/ || u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANS/ || u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPER/) has_copper_rise = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_ALIAS=" has_alias
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_BUILD_CLOCK_ENTRY=" has_build_clock_entry
    print "HAS_BUILD_STATUS_LINE=" has_build_status_line
    print "HAS_BLIT=" has_blit
    print "HAS_COPPER_RISE=" has_copper_rise
    print "HAS_RETURN=" has_return
}
