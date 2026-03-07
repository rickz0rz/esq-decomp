BEGIN {
    has_entry=0
    has_mode_save=0
    has_mode_set_100=0
    has_grid_reinit=0
    has_promote_titles=0
    has_rebuild_filter=0
    has_promote_group=0
    has_mirror_if_empty=0
    has_promote_headtail=0
    has_flush=0
    has_save_textads=0
    has_save_locavail=0
    has_save_datetime=0
    has_promote_ptype=0
    has_write_promoid=0
    has_update_warning=0
    has_mode_restore=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQFUNC_COMMITSECONDARYSTATEANDPERSIST:/ || u ~ /^ESQFUNC_COMMITSECONDARYSTATEANDPERSI[A-Z0-9_]*:/ || u ~ /^ESQFUNC_COMMITSECONDARYSTATEANDP[A-Z0-9_]*:/) has_entry=1
    if (n ~ /ESQPARS2READMODEFLAGS/ && n ~ /MOVEW/) has_mode_save=1
    if (u ~ /#\$100/ || u ~ /#256/) has_mode_set_100=1
    if (n ~ /ESQDISPPENDINGGRIDREINITFLAG/ && (n ~ /1/ || n ~ /MOVEW/)) has_grid_reinit=1
    if (n ~ /ESQDISPPROPAGATEPRIMARYTITLEMETADATATOSECONDARY/ || n ~ /ESQDISPPROPAGATEPRIMARYTITLEMET/) has_promote_titles=1
    if (n ~ /ESQFUNCJMPTBLLOCAVAILREBUILDFILTERSTATEFROMCURRENTGROUP/ || n ~ /ESQFUNCJMPTBLLOCAVAILREBUILDF/) has_rebuild_filter=1
    if (n ~ /ESQDISPPROMOTESECONDARYGROUPTOPRIMARY/ || n ~ /ESQDISPPROMOTESECONDARYGROUPTOP/) has_promote_group=1
    if (n ~ /ESQDISPMIRRORPRIMARYENTRIESTOSECONDARYIFEMPTY/ || n ~ /ESQDISPMIRRORPRIMARYENTRIESTOSE/) has_mirror_if_empty=1
    if (n ~ /ESQDISPPROMOTESECONDARYLINEHEADTAILIFMARKED/ || n ~ /ESQDISPPROMOTESECONDARYLINEHEAD/) has_promote_headtail=1
    if (n ~ /ESQPARSJMPTBLDISKIO2FLUSHDATAFILESIFNEEDED/ || n ~ /ESQPARSJMPTBLDISKIO2FLUSHDATA/) has_flush=1
    if (n ~ /ESQPARSJMPTBLLADFUNCSAVETEXTADSTOFILE/ || n ~ /ESQPARSJMPTBLLADFUNCSAVETEXTA/) has_save_textads=1
    if (n ~ /ESQPARSJMPTBLLOCAVAILSAVEAVAILABILITYDATAFILE/ || n ~ /ESQPARSJMPTBLLOCAVAILSAVEAVAI/) has_save_locavail=1
    if (n ~ /DATETIMESAVEPAIRTOFILE/) has_save_datetime=1
    if (n ~ /ESQFUNCJMPTBLPTYPEPROMOTESECONDARYLIST/ || n ~ /ESQFUNCJMPTBLPTYPEPROMOTESEC/) has_promote_ptype=1
    if (n ~ /ESQPARSJMPTBLPTYPEWRITEPROMOIDDATAFILE/ || n ~ /ESQPARSJMPTBLPTYPEWRITEPROMO/) has_write_promoid=1
    if (n ~ /ESQFUNCUPDATEDISKWARNINGANDREFRESHTICK/ || n ~ /ESQFUNCUPDATEDISKWARNINGANDREFR/) has_update_warning=1
    if (n ~ /ESQPARS2READMODEFLAGS/ && (n ~ /MOVEW/ || n ~ /CLRW/)) has_mode_restore=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MODE_SAVE="has_mode_save
    print "HAS_MODE_SET_100="has_mode_set_100
    print "HAS_GRID_REINIT="has_grid_reinit
    print "HAS_PROPAGATE_TITLES="has_promote_titles
    print "HAS_REBUILD_FILTER="has_rebuild_filter
    print "HAS_PROMOTE_GROUP="has_promote_group
    print "HAS_MIRROR_IF_EMPTY="has_mirror_if_empty
    print "HAS_PROMOTE_HEADTAIL="has_promote_headtail
    print "HAS_FLUSH_FILES="has_flush
    print "HAS_SAVE_TEXTADS="has_save_textads
    print "HAS_SAVE_LOCAVAIL="has_save_locavail
    print "HAS_SAVE_DATETIME="has_save_datetime
    print "HAS_PROMOTE_PTYPE="has_promote_ptype
    print "HAS_WRITE_PROMOID="has_write_promoid
    print "HAS_UPDATE_WARNING="has_update_warning
    print "HAS_MODE_RESTORE="has_mode_restore
    print "HAS_RTS="has_rts
}
