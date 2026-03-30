BEGIN {
    has_label = 0
    has_dealloc = 0
    has_dealloc_96 = 0
    has_dealloc_100 = 0
    has_freeraster = 0
    has_696 = 0
    has_352 = 0
    has_240 = 0
    has_241 = 0
    has_live_table = 0
    has_352_table = 0
    has_banner_table = 0
    has_context_table = 0
    has_work_raster = 0
    has_prevue_font = 0
    has_topaz_font = 0
    has_h26f_font = 0
    has_prevuec_font = 0
    has_utility_lib = 0
    has_diskfont_lib = 0
    has_dos_lib = 0
    has_intuition_lib = 0
    has_graphics_lib = 0
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
    if (u ~ /(^|[^0-9])696([^0-9]|$)/ || u ~ /\$2B8/) has_696 = 1
    if (u ~ /(^|[^0-9])352([^0-9]|$)/ || u ~ /\$160/) has_352 = 1
    if (u ~ /(^|[^0-9])240([^0-9]|$)/ || u ~ /\$F0/) has_240 = 1
    if (u ~ /(^|[^0-9])241([^0-9]|$)/ || u ~ /\$F1/) has_241 = 1
    if (u ~ /WDISP_LIVEPLANERASTERTABLE0/) has_live_table = 1
    if (u ~ /WDISP_352X240RASTERPTRTABLE/) has_352_table = 1
    if (u ~ /WDISP_BANNERROWSCRATCHRASTERTABLE0/ || u ~ /WDISP_BANNERROWSCRATCHRASTERTABL/) has_banner_table = 1
    if (u ~ /WDISP_DISPLAYCONTEXTPLANEPOINTER0/ || u ~ /WDISP_DISPLAYCONTEXTPLANEPOINTER/) has_context_table = 1
    if (u ~ /WDISP_BANNERWORKRASTERPTR/) has_work_raster = 1
    if (u ~ /GLOBAL_HANDLE_PREVUE_FONT/) has_prevue_font = 1
    if (u ~ /GLOBAL_HANDLE_TOPAZ_FONT/) has_topaz_font = 1
    if (u ~ /GLOBAL_HANDLE_H26F_FONT/) has_h26f_font = 1
    if (u ~ /GLOBAL_HANDLE_PREVUEC_FONT/) has_prevuec_font = 1
    if (u ~ /GLOBAL_REF_UTILITY_LIBRARY/) has_utility_lib = 1
    if (u ~ /GLOBAL_REF_DISKFONT_LIBRARY/) has_diskfont_lib = 1
    if (u ~ /GLOBAL_REF_DOS_LIBRARY/) has_dos_lib = 1
    if (u ~ /GLOBAL_REF_INTUITION_LIBRARY/) has_intuition_lib = 1
    if (u ~ /GLOBAL_REF_GRAPHICS_LIBRARY/) has_graphics_lib = 1
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
    print "HAS_241=" has_241
    print "HAS_LIVE_TABLE=" has_live_table
    print "HAS_352_TABLE=" has_352_table
    print "HAS_BANNER_TABLE=" has_banner_table
    print "HAS_CONTEXT_TABLE=" has_context_table
    print "HAS_WORK_RASTER=" has_work_raster
    print "HAS_PREVUE_FONT=" has_prevue_font
    print "HAS_TOPAZ_FONT=" has_topaz_font
    print "HAS_H26F_FONT=" has_h26f_font
    print "HAS_PREVUEC_FONT=" has_prevuec_font
    print "HAS_UTILITY_LIB=" has_utility_lib
    print "HAS_DISKFONT_LIB=" has_diskfont_lib
    print "HAS_DOS_LIB=" has_dos_lib
    print "HAS_INTUITION_LIB=" has_intuition_lib
    print "HAS_GRAPHICS_LIB=" has_graphics_lib
    print "HAS_CLOSEFONT=" has_closefont
    print "HAS_CLOSELIB=" has_closelib
    print "HAS_RETURN=" has_return
}
