BEGIN { has_entry=0; has_find_last=0; has_parse=0; has_testbit=0; has_wildcard=0; has_divmul=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA2_RESOLVEENTRYWINDOWANDSLOTCOUNT:/ || u ~ /^TLIBA2_RESOLVEENTRYWINDOWANDSLOTC[A-Z0-9_]*:/ || u ~ /^TLIBA2_RESOLVEENTRYWINDOWANDSLOT[A-Z0-9_]*:/) has_entry=1
 if (n ~ /TLIBA2FINDLASTCHARINSTRING/ || n ~ /TLIBA2FINDLASTCHARINSTR/) has_find_last=1
 if (n ~ /PARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3AL/ || n ~ /PARSEREADSIGNEDLONG/) has_parse=1
 if (n ~ /TLIBA2JMPTBLESQTESTBIT1BASED/ || n ~ /TLIBA2JMPTBLESQTESTBIT1BASE/) has_testbit=1
 if (n ~ /TLIBAFINDFIRSTWILDCARDMATCHINDEX/ || n ~ /TLIBAFINDFIRSTWILDCARDMATCHIND/) has_wildcard=1
 if (n ~ /MATHDIVS32/ || n ~ /MATHMULU32/) has_divmul=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_FIND_LAST="has_find_last; print "HAS_PARSE="has_parse; print "HAS_TESTBIT="has_testbit; print "HAS_WILDCARD="has_wildcard; print "HAS_DIVMUL="has_divmul; print "HAS_RETURN="has_return }
