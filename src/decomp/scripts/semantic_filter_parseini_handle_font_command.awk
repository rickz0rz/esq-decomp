BEGIN {
    has_wait0 = 0
    has_wait1 = 0
    has_scan_logo = 0
    has_setfont = 0
    has_test_font = 0
    has_execute = 0
    has_parse_disk = 0
    has_parse_gradient = 0
    has_parse_banner = 0
    has_parse_default = 0
    has_parse_sourcecfg = 0
    has_diag = 0
    has_version = 0
    has_queue_load = 0
    has_rebuild = 0
    has_mulu = 0
    has_terminal = 0
}

function trim(s,    t) {
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /PARSEINIJMPTBLED1WAITFORFLAGANDCLEARBIT0/) has_wait0 = 1
    if (n ~ /PARSEINIJMPTBLED1WAITFORFLAGANDCLEARBIT1/) has_wait1 = 1
    if (n ~ /PARSEINISCANLOGODIRECTORY/) has_scan_logo = 1
    if (n ~ /LVOSETFONT/) has_setfont = 1
    if (n ~ /PARSEINITESTMEMORYANDOPENTOPAZFONT/) has_test_font = 1
    if (n ~ /LVOEXECUTE/) has_execute = 1
    if (n ~ /PARSEINIJMPTBLDISKIO2PARSEINIFILEFROMDISK/) has_parse_disk = 1
    if (n ~ /GLOBALSTRDF0GRADIENTINI3/) has_parse_gradient = 1
    if (n ~ /GLOBALSTRDF0BANNERINI3/) has_parse_banner = 1
    if (n ~ /GLOBALSTRDF0DEFAULTINI2/) has_parse_default = 1
    if (n ~ /GLOBALSTRDF0SOURCECFGINI1/) has_parse_sourcecfg = 1
    if (n ~ /PARSEINIJMPTBLED1DRAWDIAGNOSTICSSCREEN/) has_diag = 1
    if (n ~ /PARSEINIJMPTBLESQFUNCDRAWESCMENUVERSION/) has_version = 1
    if (n ~ /PARSEINIJMPTBLESQIFFQUEUEIFFBRUSHLOAD/) has_queue_load = 1
    if (n ~ /PARSEINIJMPTBLESQFUNCREBUILDPWBRUSHLISTFROMTAGTABLEFROMTAGTABLE/) has_rebuild = 1
    if (n ~ /SCRIPT3JMPTBLMATHMULU32/) has_mulu = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_WAIT0=" has_wait0
    print "HAS_WAIT1=" has_wait1
    print "HAS_SCAN_LOGO=" has_scan_logo
    print "HAS_SETFONT=" has_setfont
    print "HAS_TEST_FONT=" has_test_font
    print "HAS_EXECUTE=" has_execute
    print "HAS_PARSE_DISK=" has_parse_disk
    print "HAS_PARSE_GRADIENT=" has_parse_gradient
    print "HAS_PARSE_BANNER=" has_parse_banner
    print "HAS_PARSE_DEFAULT=" has_parse_default
    print "HAS_PARSE_SOURCECFG=" has_parse_sourcecfg
    print "HAS_DIAG=" has_diag
    print "HAS_VERSION=" has_version
    print "HAS_QUEUE_LOAD=" has_queue_load
    print "HAS_REBUILD=" has_rebuild
    print "HAS_MULU=" has_mulu
    print "HAS_TERMINAL=" has_terminal
}
