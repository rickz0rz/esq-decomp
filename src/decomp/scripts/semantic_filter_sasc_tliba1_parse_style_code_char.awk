BEGIN { has_entry=0; has_x=0; has_range=0; has_sub=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA1_PARSESTYLECODECHAR:/ || u ~ /^TLIBA1_PARSESTYLECODECHA[A-Z0-9_]*:/) has_entry=1
 if (u ~ /#88/ || u ~ /#\$58/ || n ~ /CMPBD0D7/) has_x=1
 if (u ~ /#49/ || u ~ /#55/ || u ~ /#\$31/ || u ~ /#\$37/) has_range=1
 if (u ~ /SUBI.B #\$30/ || u ~ /SUBQ.L #48/ || n ~ /SUBIB30D7/ || n ~ /SUBLD1D0/ || n ~ /MOVEQL30D1/) has_sub=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_X="has_x; print "HAS_RANGE="has_range; print "HAS_SUB="has_sub; print "HAS_RETURN="has_return }
