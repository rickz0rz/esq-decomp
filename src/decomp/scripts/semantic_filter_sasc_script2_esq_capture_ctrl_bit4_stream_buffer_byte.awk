BEGIN { has_entry=0; has_call=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^SCRIPT_ESQ_CAPTURECTRLBIT4STREAMBUFFERBYTE:/ || u ~ /^SCRIPT_ESQ_CAPTURECTRLBIT4STREAM[A-Z0-9_]*:/) has_entry=1
 if (n ~ /SCRIPT2JMPTBLESQCAPTURECTRLBIT4STREAMBUFFERBYTE/ || n ~ /SCRIPT2JMPTBLESQCAPTURECTRLBIT4STREAM/ || n ~ /SCRIPT2JMPTBLESQCAPTURECTRLBI/ || n ~ /ESQCAPTURECTRLBIT4STREAMBUFFERBYTE/ || n ~ /ESQCAPTURECTRLBIT4STREAMBUFF/) has_call=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_CALL="has_call; print "HAS_RETURN="has_return }
