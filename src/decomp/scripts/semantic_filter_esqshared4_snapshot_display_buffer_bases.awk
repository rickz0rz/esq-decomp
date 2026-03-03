BEGIN {e=0;s=0;l0=0;l1=0;l2=0;r=0}
function trim(s,t){t=s;sub(/;.*/,"",t);sub(/^[ \t]+/,"",t);sub(/[ \t]+$/,"",t);return t}
{l=trim($0); if(l=="") next; gsub(/[ \t]+/," ",l); u=toupper(l)
 if(u~/^ESQSHARED4_SNAPSHOTDISPLAYBUFFERBASES:/)e=1
 if(u~/^MOVE\.L A1,-\(A7\)$/)s=1
 if(u~/^LEA ESQSHARED_LIVEPLANEBASE0,A1$/)l0=1
 if(u~/^LEA ESQSHARED_LIVEPLANEBASE1,A1$/)l1=1
 if(u~/^LEA ESQSHARED_LIVEPLANEBASE2,A1$/)l2=1
 if(u~/^RTS$/)r=1
}
END{print "HAS_ENTRY="e;print "HAS_SAVE="s;print "HAS_L0="l0;print "HAS_L1="l1;print "HAS_L2="l2;print "HAS_RTS="r}
