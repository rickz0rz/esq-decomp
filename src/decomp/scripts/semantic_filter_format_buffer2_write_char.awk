BEGIN {e=0;s=0;c=0;st=0;r=0}
function trim(s,t){t=s;sub(/;.*/,"",t);sub(/^[ \t]+/,"",t);sub(/[ \t]+$/,"",t);return t}
{l=trim($0); if(l=="") next; gsub(/[ \t]+/," ",l); u=toupper(l)
 if(u~/^FORMAT_BUFFER2WRITECHAR:/)e=1
 if(u~/^MOVE\.L D7,-\(A7\)$/)s=1
 if(u~/^ADDQ\.L #1,GLOBAL_FORMATBYTECOUNT2\(A4\)$/)c=1
 if(u~/^MOVE\.B D0,\(A0\)\+$/)st=1
 if(u~/^RTS$/)r=1
}
END{print "HAS_ENTRY="e;print "HAS_SAVE="s;print "HAS_COUNT="c;print "HAS_STORE="st;print "HAS_RTS="r}
