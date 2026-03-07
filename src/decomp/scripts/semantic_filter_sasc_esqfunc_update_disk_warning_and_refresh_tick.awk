BEGIN {
    has_entry=0
    has_probe_call=0
    has_tst_wp=0
    has_tst_media=0
    has_set_minus1=0
    has_draw_call=0
    has_str_wp=0
    has_str_reinsert=0
    has_y90=0
    has_refresh_inc=0
    has_refresh_clear=0
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

    if (u ~ /^ESQFUNC_UPDATEDISKWARNINGANDREFRESHTICK:/ || u ~ /^ESQFUNC_UPDATEDISKWARNINGANDREFRESHTI[A-Z0-9_]*:/ || u ~ /^ESQFUNC_UPDATEDISKWARNINGANDREFR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /ESQFUNCJMPTBLDISKIOPROBEDRIVESANDASSIGNPATHS/ || n ~ /ESQFUNCJMPTBLDISKIOPROBEDRIVE/) has_probe_call=1
    if (n ~ /DISKIODRIVE0WRITEPROTECTEDCODE/ && (n ~ /TST/ || n ~ /CMP/)) has_tst_wp=1
    if (n ~ /DISKIODRIVEMEDIASTATUSCODETABLE/ && (n ~ /TST/ || n ~ /CMP/)) has_tst_media=1
    if (u ~ /#\(-1\)/ || u ~ /#-1/ || u ~ /#\$FFFF/) has_set_minus1=1
    if (n ~ /ESQFUNCJMPTBLTLIBA3DRAWCENTEREDWRAPPEDTEXTLINES/ || n ~ /ESQFUNCJMPTBLTLIBA3DRAWCENTER/) has_draw_call=1
    if (n ~ /GLOBALSTRDISK0ISWRITEPROTECTED/ || n ~ /GLOBALSTRDISK0ISWRITEPROTE/) has_str_wp=1
    if (n ~ /GLOBALSTRYOUMUSTREINSERTSYSTEMDISKINTODRIVE0/ || n ~ /GLOBALSTRYOUMUSTREINSERTSYS/) has_str_reinsert=1
    if (u ~ /90\.W/ || u ~ /\$5A/) has_y90=1
    if ((n ~ /GLOBALREFRESHTICKCOUNTER/ && n ~ /MOVEW/) || n ~ /ADDQW1D0/ || n ~ /ADDQW1D7/ || n ~ /ADDIW1D0/ || n ~ /ADDIW1D7/) has_refresh_inc=1
    if (n ~ /CLRWGLOBALREFRESHTICKCOUNTER/ || n ~ /CLRW\(A0\)/) has_refresh_clear=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PROBE_CALL="has_probe_call
    print "HAS_TEST_WRITE_PROTECT="has_tst_wp
    print "HAS_TEST_MEDIA_STATUS="has_tst_media
    print "HAS_SET_MINUS1="has_set_minus1
    print "HAS_DRAW_CALL="has_draw_call
    print "HAS_STRING_WRITE_PROTECTED="has_str_wp
    print "HAS_STRING_REINSERT="has_str_reinsert
    print "HAS_Y_90="has_y90
    print "HAS_REFRESH_INCREMENT="has_refresh_inc
    print "HAS_REFRESH_CLEAR="has_refresh_clear
    print "HAS_RTS="has_rts
}
