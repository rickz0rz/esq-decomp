BEGIN {
    has_label = 0
    has_dealloc = 0
    has_dealloc_96 = 0
    has_dealloc_100 = 0
    has_freeraster = 0
    has_696 = 0
    has_352 = 0
    has_240 = 0
    has_closefont = 0
    has_closelib = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_RELEASEDISPLAYRESOURCES[A-Z0-9_]*:/) has_label = 1
    if (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /MEMORY_DEALLOC/) has_dealloc = 1
    if (u ~ /#96/ || u ~ /#\$60/ || u ~ /PEA 96\.W/ || u ~ /PEA \(\$60\)\.W/) has_dealloc_96 = 1
    if (u ~ /#100/ || u ~ /#\$64/ || u ~ /PEA 100\.W/ || u ~ /PEA \(\$64\)\.W/) has_dealloc_100 = 1
    if (u ~ /GRAPHICS_FREERASTER/ || u ~ /GRAPHICS_FREERAS/) has_freeraster = 1
    if (u ~ /#696/ || u ~ /#\$2B8/) has_696 = 1
    if (u ~ /#352/ || u ~ /#\$160/) has_352 = 1
    if (u ~ /#240/ || u ~ /#\$F0/) has_240 = 1
    if (u ~ /_LVOCLOSEFONT/) has_closefont = 1
    if (u ~ /_LVOCLOSELIBRARY/) has_closelib = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_DEALLOC_96=" has_dealloc_96
    print "HAS_DEALLOC_100=" has_dealloc_100
    print "HAS_FREERASTER=" has_freeraster
    print "HAS_696=" has_696
    print "HAS_352=" has_352
    print "HAS_240=" has_240
    print "HAS_CLOSEFONT=" has_closefont
    print "HAS_CLOSELIB=" has_closelib
    print "HAS_RETURN=" has_return
}
