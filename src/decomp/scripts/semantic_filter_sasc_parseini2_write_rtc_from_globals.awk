BEGIN { has_entry=0; has_guard=0; has_adjust=0; has_check=0; has_seconds=0; has_write=0; has_month_plus1=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_WRITERTCFROMGLOBALS:/ || u ~ /^PARSEINI_WRITERTCFROMGLOBAL[A-Z0-9_]*:/) has_entry=1
 if (n ~ /GLOBALREFUTILITYLIBRARY/ || n ~ /GLOBALREFBATTCLOCKRESOURCE/) has_guard=1
 if (n ~ /PARSEINIADJUSTHOURSTO24HRFORMAT/ || n ~ /PARSEINIADJUSTHOURSTO24HRFORMA/) has_adjust=1
 if (n ~ /PARSEINI2JMPTBLCLOCKCHECKDATEORSECONDSFROMEPOCH/ || n ~ /PARSEINI2JMPTBLCLOCKCHECKDATEORSECONDSFROMEPOC/ || n ~ /PARSEINI2JMPTBLCLOCKCHECKDATE/) has_check=1
 if (n ~ /PARSEINI2JMPTBLCLOCKSECONDSFROMEPOCH/ || n ~ /PARSEINI2JMPTBLCLOCKSECONDSFROMEPOC/ || n ~ /PARSEINI2JMPTBLCLOCKSECONDSFR/) has_seconds=1
 if (n ~ /PARSEINI2JMPTBLBATTCLOCKWRITESECONDSTOBATTERYBACKEDCLOCK/ || n ~ /PARSEINI2JMPTBLBATTCLOCKWRITESECONDSTOBATTERYBACKEDCLOC/ || n ~ /PARSEINI2JMPTBLBATTCLOCKWRITESECONDS/ || n ~ /PARSEINI2JMPTBLBATTCLOCKWRITE/) has_write=1
 if (u ~ /ADDQ\.W #1/ || u ~ /ADDQ\.W #\$1/ || u ~ /ADDQ\.L #1/ || u ~ /ADDI\.W #1/) has_month_plus1=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_GUARD="has_guard; print "HAS_ADJUST="has_adjust; print "HAS_CHECK="has_check; print "HAS_SECONDS="has_seconds; print "HAS_WRITE="has_write; print "HAS_MONTH_PLUS1="has_month_plus1; print "HAS_RETURN="has_return }
