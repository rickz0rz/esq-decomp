BEGIN {
    has_label = 0
    has_forbid = 0
    has_free_chain = 0
    has_free_brush = 0
    has_clear_vertb = 0
    has_clear_aud1 = 0
    has_clear_rbf = 0
    has_dealloc_recordbuf = 0
    has_shutdown_input = 0
    has_release_display = 0
    has_clear_lineheads = 0
    has_remove_groups = 0
    has_shutdown_grid = 0
    has_free_raster = 0
    has_replace_owned = 0
    has_setfunction = 0
    has_vbeam = 0
    has_stub0 = 0
    has_permit = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_SHUTDOWNSYSTEM[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOFORBID/) has_forbid = 1
    if (u ~ /LOCAVAIL_FREERESOURCECHAIN/ || u ~ /LOCAVAIL_FREERESOURCECH/ || u ~ /GROUP_AB_JMPTBL_LOCAVAIL_FREERES/) has_free_chain = 1
    if (u ~ /BRUSH_FREEBRUSHLIST/) has_free_brush = 1
    if (u ~ /CLEANUP_CLEARVERTBINTERRUPT/) has_clear_vertb = 1
    if (u ~ /CLEANUP_CLEARAUD1INTERRUPT/) has_clear_aud1 = 1
    if (u ~ /CLEANUP_CLEARRBFINTERRUPT/) has_clear_rbf = 1
    if ((u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /MEMORY_DEALLOC/) && (u ~ /#9000/ || u ~ /#\$2328/ || u ~ /PEA \(\$2328\)\.W/ || u ~ /PEA 9000\.W/)) has_dealloc_recordbuf = 1
    if (u ~ /CLEANUP_SHUTDOWNINPUTDEVICES/ || u ~ /SHUTDOWNINPUTDEVICES/) has_shutdown_input = 1
    if (u ~ /CLEANUP_RELEASEDISPLAYRESOURCES/ || u ~ /RELEASEDISPLAYRESOURCES/) has_release_display = 1
    if (u ~ /CLEARLINEHEADTAILBYMODE/ || u ~ /GROUP_AB_JMPTBL_ESQIFF2_CLEARLIN/) has_clear_lineheads = 1
    if (u ~ /REMOVEGROUPENTRYANDRELEASESTRINGS/ || u ~ /REMOVEGROUPENTRYANDRELEA/ || u ~ /GROUP_AB_JMPTBL_ESQPARS_REMOVEGR/) has_remove_groups = 1
    if (u ~ /SHUTDOWNGRIDRESOURCES/ || u ~ /GROUP_AB_JMPTBL_NEWGRID_SHUTDOWN/) has_shutdown_grid = 1
    if (u ~ /GRAPHICS_FREERASTER/ || u ~ /GRAPHICS_FREERASTE/ || u ~ /GROUP_AB_JMPTBL_GRAPHICS_FREERAS/) has_free_raster = 1
    if (u ~ /REPLACEOWNEDSTRING/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/) has_replace_owned = 1
    if (u ~ /_LVOSETFUNCTION/) has_setfunction = 1
    if (u ~ /_LVOVBEAMPOS/) has_vbeam = 1
    if (u ~ /UNKNOWN2A_STUB0/) has_stub0 = 1
    if (u ~ /_LVOPERMIT/) has_permit = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_FORBID=" has_forbid
    print "HAS_FREE_CHAIN=" has_free_chain
    print "HAS_FREE_BRUSH=" has_free_brush
    print "HAS_CLEAR_VERTB=" has_clear_vertb
    print "HAS_CLEAR_AUD1=" has_clear_aud1
    print "HAS_CLEAR_RBF=" has_clear_rbf
    print "HAS_DEALLOC_RECORDBUF=" has_dealloc_recordbuf
    print "HAS_SHUTDOWN_INPUT=" has_shutdown_input
    print "HAS_RELEASE_DISPLAY=" has_release_display
    print "HAS_CLEAR_LINEHEADS=" has_clear_lineheads
    print "HAS_REMOVE_GROUPS=" has_remove_groups
    print "HAS_SHUTDOWN_GRID=" has_shutdown_grid
    print "HAS_FREE_RASTER=" has_free_raster
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_SETFUNCTION=" has_setfunction
    print "HAS_VBEAM=" has_vbeam
    print "HAS_STUB0=" has_stub0
    print "HAS_PERMIT=" has_permit
    print "HAS_RETURN=" has_return
}
