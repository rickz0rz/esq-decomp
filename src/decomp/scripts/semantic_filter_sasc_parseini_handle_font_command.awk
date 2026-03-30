BEGIN {
    has_entry=0
    has_prefix32=0
    has_prefix33=0
    has_prefix34=0
    has_execute=0
    wait_call_count=0
    has_logo_scan_gate=0
    has_logo_scan_flag=0
    has_logo_scan_cmp=0
    has_logo_scan=0
    has_rebuild_pw=0
    has_h26f_busy_gate=0
    has_prevuec_loop=0
    has_prevuec_all_modes=0
    has_parse_ini_from_disk=0
    has_brush_reload_hotkey=0
    has_banner_reload=0
    has_gradient_ini=0
    has_banner_ini_probe=0
    has_banner_wait_loop=0
    has_banner_free_list=0
    has_banner_free_resources=0
    has_banner_ini_parse=0
    has_banner_queue_load=0
    has_default_ini=0
    has_sourcecfg_ini=0
    has_sourcecfg_refresh=0
    esc_enter_count=0
    esc_exit_count=0
    has_esc_diagnostics=0
    has_esc_version=0
    fonttest_count=0
    setfont_count=0
    parse_dispatch_count=0
    has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_HANDLEFONTCOMMAND:/ || u ~ /^PARSEINI_HANDLEFONTCOMMAN[A-Z0-9_]*:/) has_entry=1
 if (u ~ /#\$32/ || u ~ /#32/ || u ~ /'2'/) has_prefix32=1
 if (u ~ /#\$33/ || u ~ /#33/ || u ~ /'3'/) has_prefix33=1
 if (u ~ /#\$34/ || u ~ /#34/ || u ~ /'4'/) has_prefix34=1
 if (n ~ /LVOEXECUTE/ || n ~ /PARSEINIJMPTBLWDISPSPRINTF/) has_execute=1
 if (n ~ /PARSEINIJMPTBLED1WAITFORFLAGANDCLEARBIT0/ || n ~ /PARSEINIJMPTBLED1WAITFORFLAGANDCLEARBIT1/ || n ~ /PARSEINIJMPTBLED1WAITFORFLAGA/) wait_call_count++
 if (n ~ /CONFIGPARSEINILOGOSCANENABLEDFL/) has_logo_scan_flag=1
 if (u ~ /#\$59/ || u ~ /#89/) has_logo_scan_cmp=1
 if (has_logo_scan_flag && has_logo_scan_cmp) has_logo_scan_gate=1
 if (n ~ /PARSEINITESTMEMORYANDOPENTOPAZFONT/ || n ~ /PARSEINITESTMEMORYANDOPENTOPAZF/) fonttest_count++
 if (n ~ /ESQFUNCREBUILDPWBRUSHLISTFROMTA/) has_rebuild_pw=1
 if (n ~ /GLOBALUIBUSYFLAG/ || n ~ /GLOBALREFRASTPORT1/ || n ~ /GLOBALHANDLEH26FFONT/) has_h26f_busy_gate=1
 if (n ~ /SCRIPT3JMPTBLMATHMULU32/ || n ~ /GCOMMANDHIGHLIGHTMESSAGESLOTTAB/ || n ~ /CTASKSIFFTASKDONEFLAG/) has_prevuec_loop=1
 if (n ~ /TLIBA3SETFONTFORALLVIEWMODES/) has_prevuec_all_modes=1
 if (n ~ /PARSEINIJMPTBLDISKIO2PARSEINI/) has_parse_ini_from_disk=1
 if ((u ~ /#\$61/ || u ~ /#97/) || n ~ /ESQIFFHANDLEBRUSHINIRELOADHOTKE/) has_brush_reload_hotkey=1
 if (n ~ /GLOBALSTRDF0GRADIENTINI3/) has_gradient_ini=1
 if (n ~ /GLOBALSTRDF0BANNERINI2/ || n ~ /SCRIPTCHECKPATHEXISTS/) has_banner_ini_probe=1
 if (n ~ /CTASKSIFFTASKDONEFLAG/) has_banner_wait_loop=1
 if (n ~ /BRUSHFREEBRUSHLIST/ || n ~ /PARSEINIJMPTBLBRUSHFREEBRUSHLIST/) has_banner_free_list=1
 if (n ~ /BRUSHFREEBRUSHRESOURCES/ || n ~ /PARSEINIJMPTBLBRUSHFREEBRUSHRESOURCES/) has_banner_free_resources=1
 if (n ~ /GLOBALSTRDF0BANNERINI3/) has_banner_ini_parse=1
 if (n ~ /ESQIFFQUEUEIFFBRUSHLOAD/ || n ~ /PARSEINIJMPTBLESQIFFQUEUEIFFBRUSHLOAD/) has_banner_queue_load=1
 if (has_banner_ini_probe && has_banner_wait_loop && has_banner_free_list && has_banner_free_resources && has_banner_ini_parse && has_banner_queue_load) has_banner_reload=1
 if (n ~ /GLOBALSTRDF0DEFAULTINI2/) has_default_ini=1
 if (n ~ /GLOBALSTRDF0SOURCECFGINI1/) has_sourcecfg_ini=1
 if (n ~ /TEXTDISPAPPLYSOURCECONFIGALLENT/) has_sourcecfg_refresh=1
 if (n ~ /PARSEINIJMPTBLED1ENTERESCMENU/) esc_enter_count++
 if (n ~ /PARSEINIJMPTBLED1EXITESCMENU/) esc_exit_count++
 if (n ~ /PARSEINIJMPTBLED1DRAWDIAGNOST/) has_esc_diagnostics=1
 if (n ~ /ESQFUNCDRAWESCMENUVERSION/) has_esc_version=1
 if (n ~ /PARSEINISCANLOGODIRECTORY/) has_logo_scan=1
 if (n ~ /LVOSETFONT/) setfont_count++
 if (n ~ /PARSEINIPARSEINIBUFFERANDDISPAT/) parse_dispatch_count++
 if (u=="RTS") has_return=1
}
END {
 print "HAS_ENTRY="has_entry
 print "HAS_PREFIX32="has_prefix32
 print "HAS_PREFIX33="has_prefix33
 print "HAS_PREFIX34="has_prefix34
 print "HAS_EXECUTE="has_execute
 print "WAIT_CALL_COUNT="wait_call_count
 print "HAS_LOGO_SCAN_GATE="has_logo_scan_gate
 print "HAS_LOGO_SCAN="has_logo_scan
 print "HAS_REBUILD_PW="has_rebuild_pw
 print "FONTTEST_COUNT="fonttest_count
 print "SETFONT_COUNT="setfont_count
 print "PARSE_DISPATCH_COUNT="parse_dispatch_count
 print "HAS_H26F_BUSY_GATE="has_h26f_busy_gate
 print "HAS_PREVUEC_LOOP="has_prevuec_loop
 print "HAS_PREVUEC_ALL_MODES="has_prevuec_all_modes
 print "HAS_PARSE_INI_FROM_DISK="has_parse_ini_from_disk
 print "HAS_BRUSH_RELOAD_HOTKEY="has_brush_reload_hotkey
 print "HAS_GRADIENT_INI="has_gradient_ini
 print "HAS_BANNER_INI_PROBE="has_banner_ini_probe
 print "HAS_BANNER_WAIT_LOOP="has_banner_wait_loop
 print "HAS_BANNER_FREE_LIST="has_banner_free_list
 print "HAS_BANNER_FREE_RESOURCES="has_banner_free_resources
 print "HAS_BANNER_INI_PARSE="has_banner_ini_parse
 print "HAS_BANNER_QUEUE_LOAD="has_banner_queue_load
 print "HAS_BANNER_RELOAD="has_banner_reload
 print "HAS_DEFAULT_INI="has_default_ini
 print "HAS_SOURCECFG_INI="has_sourcecfg_ini
 print "HAS_SOURCECFG_REFRESH="has_sourcecfg_refresh
 print "ESC_ENTER_COUNT="esc_enter_count
 print "ESC_EXIT_COUNT="esc_exit_count
 print "HAS_ESC_DIAGNOSTICS="has_esc_diagnostics
 print "HAS_ESC_VERSION="has_esc_version
 print "HAS_RETURN="has_return
}
