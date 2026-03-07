BEGIN {
    has_entry=0
    has_ravesc_guard=0
    has_gridmsg_call=0
    has_coi_guard=0
    has_source_select=0
    has_gads_enable=0
    has_drive0_check=0
    has_flags_and2=0
    has_reload0=0
    has_drive1_check=0
    has_flags_and1=0
    has_reload1=0
    has_queue=0
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

    if (u ~ /^ESQIFF_SERVICEEXTERNALASSETSOURCESTATE:/ || u ~ /^ESQIFF_SERVICEEXTERNALASSETSOURCEST[A-Z0-9_]*:/ || u ~ /^ESQIFF_SERVICEEXTERNALASSETSOURC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /GLOBALWORDSELECTCODEISRAVESC/ || n ~ /GLOBALWORDSELECTCODEISRAVES/) has_ravesc_guard=1
    if (n ~ /ESQDISPPROCESSGRIDMESSAGESIFIDLE/ || n ~ /ESQDISPPROCESSGRIDMESSAGESIFIDL/) has_gridmsg_call=1
    if (n ~ /COIATTENTIONOVERLAYBUSYFLAG/) has_coi_guard=1
    if (n ~ /ESQIFFASSETSOURCESELECT/) has_source_select=1
    if (n ~ /ESQIFFGADSSOURCEENABLED/) has_gads_enable=1
    if (n ~ /DISKIODRIVE0WRITEPROTECTEDCODE/) has_drive0_check=1
    if (u ~ /ANDI\.W #2/ || u ~ /ANDI\.W #\$2/ || n ~ /ANDIW2D0/) has_flags_and2=1
    if ((n ~ /ESQIFFRELOADEXTERNALASSETCATALOGBUFFERS/ || n ~ /ESQIFFRELOADEXTERNALASSETCATALO/) && (u ~ /CLR\.L -\(A7\)/ || u ~ /PEA 0\.W/ || n ~ /MOVEQ0/)) has_reload0=1
    if (n ~ /DISKIODRIVEWRITEPROTECTSTATUSCODEDRIVE1/ || n ~ /DISKIODRIVEWRITEPROTECTSTATUSCO/) has_drive1_check=1
    if (u ~ /ANDI\.W #1/ || u ~ /ANDI\.W #\$1/ || n ~ /ANDIW1D0/) has_flags_and1=1
    if ((n ~ /ESQIFFRELOADEXTERNALASSETCATALOGBUFFERS/ || n ~ /ESQIFFRELOADEXTERNALASSETCATALO/) && (u ~ /PEA 1\.W/ || n ~ /MOVEQ1/)) has_reload1=1
    if (n ~ /ESQIFFQUEUENEXTEXTERNALASSETIFFJOB/ || n ~ /ESQIFFQUEUENEXTEXTERNALASSETIFF/) has_queue=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_RAVESC_GUARD="has_ravesc_guard
    print "HAS_GRIDMSG_CALL="has_gridmsg_call
    print "HAS_COI_GUARD="has_coi_guard
    print "HAS_SOURCE_SELECT_WRITE="has_source_select
    print "HAS_GADS_ENABLE_WRITE="has_gads_enable
    print "HAS_DRIVE0_CHECK="has_drive0_check
    print "HAS_FLAGS_AND2="has_flags_and2
    print "HAS_RELOAD_ZERO="has_reload0
    print "HAS_DRIVE1_CHECK="has_drive1_check
    print "HAS_FLAGS_AND1="has_flags_and1
    print "HAS_RELOAD_ONE="has_reload1
    print "HAS_QUEUE_CALL="has_queue
    print "HAS_RTS="has_rts
}
