BEGIN { has_entry=0; has_snapshot_copy=0; has_add_time=0; has_parse_window=0; has_outputs=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA2_COMPUTEBROADCASTTIMEWINDOW:/ || u ~ /^TLIBA2_COMPUTEBROADCASTTIMEWINDO[A-Z0-9_]*:/) has_entry=1
 if (n ~ /CLOCKCURRENTDAYOFWEEKINDEX/ || n ~ /TLIBA2BROADCASTWINDOWCLOCKSNAPSHOTA/ || n ~ /DBFD0/) has_snapshot_copy=1
 if (n ~ /TLIBA2JMPTBLDSTADDTIMEOFFSET/ || n ~ /TLIBA2JMPTBLDSTADDTIMEOFFSE/) has_add_time=1
 if (n ~ /TLIBA2PARSEENTRYTIMEWINDOW/ || n ~ /TLIBA2PARSEENTRYTIMEWINDO/) has_parse_window=1
 if (u ~ /MOVE.L D0,\(A2\)/ || u ~ /MOVE.L D0,4\(A2\)/ || u ~ /MOVE.L D0,8\(A2\)/ || n ~ /MOVELD0A2/ || n ~ /MOVELD04A2/ || n ~ /MOVELD08A2/) has_outputs=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_SNAPSHOT_COPY="has_snapshot_copy; print "HAS_ADD_TIME="has_add_time; print "HAS_PARSE_WINDOW="has_parse_window; print "HAS_OUTPUTS="has_outputs; print "HAS_RETURN="has_return }
