BEGIN {
    has_entry = 0
    has_process_grid = 0
    has_reload = 0
    has_queue = 0
    has_asset_source_write = 0
    has_gads_enabled_write = 0
    has_return = 0
    has_rts = 0
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

    if (uline ~ /^ESQIFF_SERVICEEXTERNALASSETSOURCESTATE:/) has_entry = 1
    if (uline ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDLE/) has_process_grid = 1
    if (uline ~ /ESQIFF_RELOADEXTERNALASSETCATALOGBUFFERS/) has_reload = 1
    if (uline ~ /ESQIFF_QUEUENEXTEXTERNALASSETIFFJOB/) has_queue = 1
    if (uline ~ /ESQIFF_ASSETSOURCESELECT/) has_asset_source_write = 1
    if (uline ~ /ESQIFF_GADSSOURCEENABLED/) has_gads_enabled_write = 1
    if (uline ~ /^\.RETURN:$/) has_return = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PROCESS_GRID=" has_process_grid
    print "HAS_RELOAD=" has_reload
    print "HAS_QUEUE=" has_queue
    print "HAS_ASSET_SOURCE_WRITE=" has_asset_source_write
    print "HAS_GADS_ENABLED_WRITE=" has_gads_enabled_write
    print "HAS_RETURN_LABEL=" has_return
    print "HAS_RTS=" has_rts
}
