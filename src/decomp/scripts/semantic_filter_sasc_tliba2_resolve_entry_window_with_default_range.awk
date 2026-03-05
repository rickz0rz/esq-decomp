BEGIN { has_entry=0; has_zero_defaults=0; has_forward_call=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA2_RESOLVEENTRYWINDOWWITHDEFAULTRANGE:/ || u ~ /^TLIBA2_RESOLVEENTRYWINDOWWITHDEFAU[A-Z0-9_]*:/ || u ~ /^TLIBA2_RESOLVEENTRYWINDOWWITHDEF[A-Z0-9_]*:/) has_entry=1
 if (u ~ /CLR\.L -\(A7\)/ || n ~ /MOVEQ0D0/ || n ~ /MOVEQL0D0/) has_zero_defaults=1
 if (n ~ /TLIBA2RESOLVEENTRYWINDOWANDSLOTCOUNT/ || n ~ /TLIBA2RESOLVEENTRYWINDOWANDSLOTC/ || n ~ /TLIBA2RESOLVEENTRYWINDOWANDSLOT/) has_forward_call=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_ZERO_DEFAULTS="has_zero_defaults; print "HAS_FORWARD_CALL="has_forward_call; print "HAS_RETURN="has_return }
