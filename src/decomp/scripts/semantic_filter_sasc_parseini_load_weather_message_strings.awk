BEGIN { has_entry=0; has_compare=0; has_replace=0; has_current=0; has_forecast=0; has_bottom=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_LOADWEATHERMESSAGESTRINGS:/ || u ~ /^PARSEINI_LOADWEATHERMESSAGESTRIN[A-Z0-9_]*:/) has_entry=1
 if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENocase/ || n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/ || n ~ /PARSEINIJMPTBLSTRINGCOMPARENO/ || n ~ /STRINGCOMPARENOCASE/ || n ~ /STRINGCOMPARENO/) has_compare=1
 if (n ~ /PARSEINIJMPTBLESQPARSREPLACEOWNEDSTRING/ || n ~ /PARSEINIJMPTBLESQPARSREPLACEOWNEDSTRIN/ || n ~ /PARSEINIJMPTBLESQPARSREPLACEO/ || n ~ /ESQPARSREPLACEOWNEDSTRING/ || n ~ /ESQPARSREPLACEOWNEDSTRIN/ || n ~ /ESQPARSREPLACEO/) has_replace=1
 if (n ~ /PTYPEWEATHERCURRENTMSGPTR/ || n ~ /PARSEINISTRWEATHERCURRENT/) has_current=1
 if (n ~ /PTYPEWEATHERFORECASTMSGPTR/ || n ~ /PARSEINISTRWEATHERFORECAST/) has_forecast=1
 if (n ~ /PTYPEWEATHERBOTTOMLINEMSGPTR/ || n ~ /PARSEINISTRBOTTOMLINETAG/) has_bottom=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_COMPARE="has_compare; print "HAS_REPLACE="has_replace; print "HAS_CURRENT="has_current; print "HAS_FORECAST="has_forecast; print "HAS_BOTTOM="has_bottom; print "HAS_RETURN="has_return }
