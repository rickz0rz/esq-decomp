BEGIN { has_entry=0; has_findchar=0; has_parse=0; has_output=0; has_success=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA2_PARSEENTRYTIMEWINDOW:/ || u ~ /^TLIBA2_PARSEENTRYTIMEWINDO[A-Z0-9_]*:/) has_entry=1
 if (n ~ /STRFINDCHARPTR/ || n ~ /STRFINDCHARPTR/) has_findchar=1
 if (n ~ /PARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3AL/ || n ~ /PARSEREADSIGNEDLONG/) has_parse=1
 if (u ~ /MOVE\.L D0,\(A2\)/ || u ~ /MOVE\.L D0,4\(A2\)/ || u ~ /MOVE\.L D0,\(A3\)/ || u ~ /MOVE\.L D0,\$4\(A3\)/ || n ~ /MOVELD0A2/ || n ~ /MOVELD04A2/ || n ~ /MOVELD0A3/ || n ~ /MOVELD04A3/) has_output=1
 if (u ~ /MOVEQ #1,D6/ || u ~ /MOVEQ.L #$1,D6/ || n ~ /MOVEQL1D6/) has_success=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_FINDCHAR="has_findchar; print "HAS_PARSE="has_parse; print "HAS_OUTPUT="has_output; print "HAS_SUCCESS="has_success; print "HAS_RETURN="has_return }
