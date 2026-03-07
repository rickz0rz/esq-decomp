BEGIN {
    has_entry=0
    has_chunk_loop=0
    has_read_id=0
    has_read_size=0
    has_tag_dispatch=0
    has_bmhd_path=0
    has_cmap_path=0
    has_body_path=0
    has_camg_path=0
    has_crng_path=0
    has_seek_unknown=0
    has_return=0
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

    if (u ~ /^BITMAP_PROCESSILBMIMAGE:/ || u ~ /^BITMAP_PROCESSILBMIMAG[A-Z0-9_]*:/) has_entry=1
    if (n ~ /READCHUNKID/ || n ~ /CONTINUEOREXIT/ || n ~ /READCHUNKSIZE/ || n ~ /TSTL38A7/ || n ~ /BNEW___BITMAPPROCESSILBMIMAGE/) has_chunk_loop=1
    if (n ~ /LVOREAD/) has_read_id=1
    if (n ~ /LVOREAD/) has_read_size=1
    if (n ~ /FORM/ || n ~ /BMHD/ || n ~ /CMAP/ || n ~ /BODY/ || n ~ /CAMG/ || n ~ /CRNG/ || n ~ /CHUNKTAG/) has_tag_dispatch=1
    if (n ~ /BMHD/ || n ~ /130A0/ || n ~ /148A0/ || n ~ /80A0/ || n ~ /82A0/) has_bmhd_path=1
    if (n ~ /LOADCOLORTEXTFONT/) has_cmap_path=1
    if (n ~ /STREAMFONTCHUNK/) has_body_path=1
    if (n ~ /CAMG/ || n ~ /READCAMGMODE/ || n ~ /94A0/ || n ~ /ORIW4D0/) has_camg_path=1
    if (n ~ /CRNG/ || n ~ /184A0/ || n ~ /9C/) has_crng_path=1
    if (n ~ /LVOSEEK/) has_seek_unknown=1
    if (u == "RTS") has_return=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CHUNK_LOOP=" has_chunk_loop
    print "HAS_READ_ID=" has_read_id
    print "HAS_READ_SIZE=" has_read_size
    print "HAS_TAG_DISPATCH=" has_tag_dispatch
    print "HAS_BMHD_PATH=" has_bmhd_path
    print "HAS_CMAP_PATH=" has_cmap_path
    print "HAS_BODY_PATH=" has_body_path
    print "HAS_CAMG_PATH=" has_camg_path
    print "HAS_CRNG_PATH=" has_crng_path
    print "HAS_SEEK_UNKNOWN=" has_seek_unknown
    print "HAS_RETURN=" has_return
}
