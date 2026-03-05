BEGIN { has_entry=0; has_prefix=0; has_execute=0; has_wait=0; has_scan=0; has_fonttest=0; has_esc=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_HANDLEFONTCOMMAND:/ || u ~ /^PARSEINI_HANDLEFONTCOMMAN[A-Z0-9_]*:/) has_entry=1
 if (u ~ /#\$33/ || u ~ /#\$32/ || u ~ /#\$34/ || u ~ /#\$30/) has_prefix=1
 if (n ~ /LVOEXECUTE/ || n ~ /PARSEINIJMPTBLWDISPSPRINTF/) has_execute=1
 if (n ~ /PARSEINIJMPTBLED1WAITFORFLAGANDCLEARBIT0/ || n ~ /PARSEINIJMPTBLED1WAITFORFLAGANDCLEARBIT1/ || n ~ /PARSEINIJMPTBLED1WAITFORFLAGA/) has_wait=1
 if (n ~ /PARSEINISCANLOGODIRECTORY/) has_scan=1
 if (n ~ /PARSEINITESTMEMORYANDOPENTOPAZFONT/ || n ~ /PARSEINITESTMEMORYANDOPENTOPAZF/) has_fonttest=1
 if (n ~ /PARSEINIJMPTBLED1ENTERESCMENU/ || n ~ /PARSEINIJMPTBLED1EXITESCMENU/ || n ~ /PARSEINIJMPTBLED1DRAWDIAGNOSTICSSCREEN/ || n ~ /PARSEINIJMPTBLESQFUNCDRAWESCMENUVERSION/) has_esc=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_PREFIX="has_prefix; print "HAS_EXECUTE="has_execute; print "HAS_WAIT="has_wait; print "HAS_SCAN="has_scan; print "HAS_FONTTEST="has_fonttest; print "HAS_ESC="has_esc; print "HAS_RETURN="has_return }
