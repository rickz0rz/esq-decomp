BEGIN { has_entry=0; has_copy=0; has_year1900=0; has_month12=0; has_isleap=0; has_calcday=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_NORMALIZECLOCKDATA:/ || u ~ /^PARSEINI_NORMALIZECLOCKDAT[A-Z0-9_]*:/) has_entry=1
 if (u ~ /^\(?MOVE\.L \(A0\)\+,\(A1\)\+$/ || u ~ /DBF/ || u ~ /MOVE\.L .*A[01].*A[01]/ || u ~ /^MOVE\.W \$0\(A3,D0\.L\),\$0\(A5,D0\.L\)$/) has_copy=1
 if (u ~ /1900/ || u ~ /\$76C/) has_year1900=1
 if (u ~ /#12/ || u ~ /\$C/) has_month12=1
 if (n ~ /PARSEINI2JMPTBLDATETIMEISLEAPYEAR/ || n ~ /PARSEINI2JMPTBLDATETIMEISLEAPYEA/ || n ~ /PARSEINI2JMPTBLDATETIMEISLEAP/) has_isleap=1
 if (n ~ /PARSEINI2JMPTBLESQCALCDAYOFYEARFROMMONTHDAY/ || n ~ /PARSEINI2JMPTBLESQCALCDAYOFYEARFROMMONTHDA/ || n ~ /PARSEINI2JMPTBLESQCALCDAYOFYE/) has_calcday=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_COPY="has_copy; print "HAS_YEAR1900="has_year1900; print "HAS_MONTH12="has_month12; print "HAS_ISLEAP="has_isleap; print "HAS_CALCDAY="has_calcday; print "HAS_RETURN="has_return }
