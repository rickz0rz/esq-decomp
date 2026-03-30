BEGIN {
    has_label = 0
    has_forbid = 0
    count_free_chain = 0
    count_free_brush = 0
    has_clear_vertb = 0
    has_clear_aud1 = 0
    has_clear_rbf = 0
    count_dealloc_memory = 0
    has_dealloc_recordbuf = 0
    has_shutdown_input = 0
    has_release_display = 0
    has_free_banner = 0
    has_clear_alias = 0
    count_clear_lineheads = 0
    has_dealloc_ads_logo = 0
    count_remove_groups = 0
    has_free_line_text = 0
    has_restore_copper = 0
    has_shutdown_grid = 0
    count_free_raster = 0
    count_replace_owned = 0
    count_setfunction = 0
    has_vbeam = 0
    has_restore_window = 0
    has_stub0 = 0
    has_permit = 0
    has_return = 0
    saw_recordbuf_size = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    is_call = (u ~ /^(JSR|BSR(\.[A-Z]+)?) /)

    if (u ~ /^CLEANUP_SHUTDOWNSYSTEM[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOFORBID/) has_forbid = 1
    if (is_call && (u ~ /LOCAVAIL_FREERESOURCECHAIN/ || u ~ /LOCAVAIL_FREERESOURCECH/ || u ~ /GROUP_AB_JMPTBL_LOCAVAIL_FREERES/)) count_free_chain++
    if (is_call && u ~ /BRUSH_FREEBRUSHLIST/) count_free_brush++
    if (u ~ /CLEANUP_CLEARVERTBINTERRUPT/) has_clear_vertb = 1
    if (u ~ /CLEANUP_CLEARAUD1INTERRUPT/) has_clear_aud1 = 1
    if (u ~ /CLEANUP_CLEARRBFINTERRUPT/) has_clear_rbf = 1
    if (u ~ /^PEA (\(\$2328\)\.W|9000\.W)$/ || u ~ /^PEA (#\$2328|#9000)\.W$/) saw_recordbuf_size = 1
    if (is_call && (u ~ /MEMORY_DEALLOCATEMEMORY/ || u ~ /MEMORY_DEALLOC/)) {
        count_dealloc_memory++
        if (saw_recordbuf_size) {
            has_dealloc_recordbuf = 1
            saw_recordbuf_size = 0
        }
    }
    if (u ~ /CLEANUP_SHUTDOWNINPUTDEVICES/ || u ~ /SHUTDOWNINPUTDEVICES/) has_shutdown_input = 1
    if (u ~ /CLEANUP_RELEASEDISPLAYRESOURCES/ || u ~ /RELEASEDISPLAYRESOURCES/) has_release_display = 1
    if (u ~ /LADFUNC_FREEBANNERRECTENTRIES/ || u ~ /GROUP_AB_JMPTBL_LADFUNC_FREEBANN/) has_free_banner = 1
    if (u ~ /ESQPARS_CLEARALIASSTRINGPOINTERS/) has_clear_alias = 1
    if (is_call && (u ~ /CLEARLINEHEADTAILBYMODE/ || u ~ /GROUP_AB_JMPTBL_ESQIFF2_CLEARLIN/)) count_clear_lineheads++
    if (u ~ /DEALLOCATEADSANDLOGOLSTDATA/ || u ~ /GROUP_AB_JMPTBL_ESQIFF_DEALLOCAT/) has_dealloc_ads_logo = 1
    if (is_call && (u ~ /REMOVEGROUPENTRYANDRELEASESTRINGS/ || u ~ /REMOVEGROUPENTRYANDRELEA/ || u ~ /GROUP_AB_JMPTBL_ESQPARS_REMOVEGR/)) count_remove_groups++
    if (u ~ /FREE LINETEXTBUFFERS/ || u ~ /ESQFUNC_FREELINETEXTBUFFERS/ || u ~ /GROUP_AB_JMPTBL_ESQFUNC_FREELINE/) has_free_line_text = 1
    if (u ~ /COP1LC/ || u ~ /CUSTOM\+\$80/) has_restore_copper = 1
    if (u ~ /SHUTDOWNGRIDRESOURCES/ || u ~ /GROUP_AB_JMPTBL_NEWGRID_SHUTDOWN/) has_shutdown_grid = 1
    if (is_call && (u ~ /GRAPHICS_FREERASTER/ || u ~ /GRAPHICS_FREERASTE/ || u ~ /GROUP_AB_JMPTBL_GRAPHICS_FREERAS/)) count_free_raster++
    if (is_call && (u ~ /REPLACEOWNEDSTRING/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/)) count_replace_owned++
    if (is_call && u ~ /_LVOSETFUNCTION/) count_setfunction++
    if (u ~ /_LVOVBEAMPOS/) has_vbeam = 1
    if (u ~ /ESQ_PROCESSWINDOWPTRBACKUP/ || u ~ /WDISP_EXECBASEHOOKPTR/ || u ~ /184\\(A0\\)/ || u ~ /MOVE\\.L D0,\\(A0\\)/) has_restore_window = 1
    if (u ~ /UNKNOWN2A_STUB0/) has_stub0 = 1
    if (u ~ /_LVOPERMIT/) has_permit = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_FORBID=" has_forbid
    print "COUNT_FREE_CHAIN=" count_free_chain
    print "COUNT_FREE_BRUSH=" count_free_brush
    print "HAS_CLEAR_VERTB=" has_clear_vertb
    print "HAS_CLEAR_AUD1=" has_clear_aud1
    print "HAS_CLEAR_RBF=" has_clear_rbf
    print "COUNT_DEALLOC_MEMORY=" count_dealloc_memory
    print "HAS_DEALLOC_RECORDBUF=" has_dealloc_recordbuf
    print "HAS_SHUTDOWN_INPUT=" has_shutdown_input
    print "HAS_RELEASE_DISPLAY=" has_release_display
    print "HAS_FREE_BANNER=" has_free_banner
    print "HAS_CLEAR_ALIAS=" has_clear_alias
    print "COUNT_CLEAR_LINEHEADS=" count_clear_lineheads
    print "HAS_DEALLOC_ADS_LOGO=" has_dealloc_ads_logo
    print "COUNT_REMOVE_GROUPS=" count_remove_groups
    print "HAS_FREE_LINE_TEXT=" has_free_line_text
    print "HAS_RESTORE_COPPER=" has_restore_copper
    print "HAS_SHUTDOWN_GRID=" has_shutdown_grid
    print "COUNT_FREE_RASTER=" count_free_raster
    print "COUNT_REPLACE_OWNED=" count_replace_owned
    print "COUNT_SETFUNCTION=" count_setfunction
    print "HAS_VBEAM=" has_vbeam
    print "HAS_RESTORE_WINDOW=" has_restore_window
    print "HAS_STUB0=" has_stub0
    print "HAS_PERMIT=" has_permit
    print "HAS_RETURN=" has_return
}
