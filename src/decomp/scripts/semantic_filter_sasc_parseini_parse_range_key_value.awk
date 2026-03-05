BEGIN { has_entry=0; has_findeq=0; has_compare=0; has_parse_signed=0; has_parse_hex=0; has_rangeidx=0; has_store=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_PARSERANGEKEYVALUE:/ || u ~ /^PARSEINI_PARSERANGEKEYVALU[A-Z0-9_]*:/) has_entry=1
 if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/ || n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/ || u ~ /PEA 61\.W/) has_findeq=1
 if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASEN/ || n ~ /PARSEINITAGTABLE/ || n ~ /PARSEINITAGCOLOR/ || n ~ /PARSEINITAGDONE/) has_compare=1
 if (n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDLONGSKIPCLASS3AL/ || n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDL/) has_parse_signed=1
 if (n ~ /PARSEINIPARSEHEXVALUEFROMSTRING/ || n ~ /PARSEINIPARSEHEXVALUEFROMSTRIN/) has_parse_hex=1
 if (n ~ /PARSEINICURRENTRANGETABLEINDEX/) has_rangeidx=1
 if (u ~ /MOVE\.W .*32\(A[0-7]\)/ || u ~ /^MOVE\.W D[0-7],\(A1\)$/ || u ~ /CMPI\.[WL] #\$1000/ || u ~ /ASL\.L #7/ || u ~ /ASL\.L #\$7/) has_store=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_FINDEQ="has_findeq; print "HAS_COMPARE="has_compare; print "HAS_PARSE_SIGNED="has_parse_signed; print "HAS_PARSE_HEX="has_parse_hex; print "HAS_RANGEIDX="has_rangeidx; print "HAS_STORE="has_store; print "HAS_RETURN="has_return }
