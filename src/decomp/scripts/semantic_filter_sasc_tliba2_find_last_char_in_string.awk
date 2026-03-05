BEGIN { has_entry=0; has_scan_end=0; has_backward_cmp=0; has_result=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA2_FINDLASTCHARINSTRING:/ || u ~ /^TLIBA2_FINDLASTCHARINSTR[A-Z0-9_]*:/) has_entry=1
 if (u ~ /TST\.B \(A0\)\+/ || u ~ /TST\.B \(A0\)/ || u ~ /TST\.B \(A3\)/ || n ~ /TSTBA0/ || n ~ /TSTBA3/) has_scan_end=1
 if (u ~ /CMP\.B D7/ || n ~ /CMPBD7D0/ || n ~ /CMPBD0D7/) has_backward_cmp=1
 if (u ~ /^MOVE\.L A0,-8\(A5\)/ || u ~ /^MOVE\.L -8\(A5\),D0/ || u ~ /^MOVE\.L A0,D0/ || u ~ /^MOVE\.L A3,D0/) has_result=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_SCAN_END="has_scan_end; print "HAS_BACKWARD_CMP="has_backward_cmp; print "HAS_RESULT="has_result; print "HAS_RETURN="has_return }
