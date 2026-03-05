BEGIN {
    has_entry = 0
    has_sprintf = 0
    has_select = 0
    has_build_now = 0
    has_build_pair = 0
    has_alloc = 0
    has_set_entry = 0
    has_filter = 0
    has_draw = 0
    has_free = 0
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
    u = toupper(line)

    if (u ~ /^TEXTDISP_HANDLESCRIPTCOMMAND:/ || u ~ /^TEXTDISP_HANDLESCRIPTCOMMA[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "WDISP_SPRINTF") > 0) has_sprintf = 1
    if (index(u, "TEXTDISP_SELECTGROUPANDENTRY") > 0 || index(u, "TEXTDISP_SELECTGROUPANDENTR") > 0) has_select = 1
    if (index(u, "TEXTDISP_BUILDNOWSHOWINGSTATUSLINE") > 0 || index(u, "TEXTDISP_BUILDNOWSHOWINGSTAT") > 0) has_build_now = 1
    if (index(u, "TEXTDISP_BUILDENTRYPAIRSTATUSLINE") > 0 || index(u, "TEXTDISP_BUILDENTRYPAIRSTAT") > 0) has_build_pair = 1
    if (index(u, "MEMORY_ALLOCATEMEMORY") > 0) has_alloc = 1
    if (index(u, "TEXTDISP_SETENTRYTEXTFIELDS") > 0 || index(u, "TEXTDISP_SETENTRYTEXTFIELD") > 0) has_set_entry = 1
    if (index(u, "TEXTDISP_FILTERANDSELECTENTRY") > 0 || index(u, "TEXTDISP_FILTERANDSELECTENT") > 0) has_filter = 1
    if (index(u, "TEXTDISP_DRAWHIGHLIGHTFRAME") > 0 || index(u, "TEXTDISP_DRAWHIGHLIGHTFRA") > 0) has_draw = 1
    if (index(u, "MEMORY_DEALLOCATEMEMORY") > 0) has_free = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_SELECT=" has_select
    print "HAS_BUILD_NOW=" has_build_now
    print "HAS_BUILD_PAIR=" has_build_pair
    print "HAS_ALLOC=" has_alloc
    print "HAS_SET_ENTRY=" has_set_entry
    print "HAS_FILTER=" has_filter
    print "HAS_DRAW=" has_draw
    print "HAS_FREE=" has_free
    print "HAS_RETURN=" has_return
}
