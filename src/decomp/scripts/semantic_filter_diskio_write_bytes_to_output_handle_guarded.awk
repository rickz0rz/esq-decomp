BEGIN {h1=0;h2=0;h3=0;h4=0;h5=0;h6=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{l=t($0); if(l=="") next; if(l~/^DISKIO_WRITEBYTESTOOUTPUTHANDLEGUARDED:/)h1=1; if(l~/^MOVE\.W ESQPARS2_READMODEFLAGS,DISKIO_SAVEDREADMODEFLAGS$/)h2=1; if(l~/^JSR _LVOWRITE\(A6\)$/)h3=1; if(l~/^MOVE\.W DISKIO_SAVEDREADMODEFLAGS,ESQPARS2_READMODEFLAGS$/)h4=1; if(l~/^MOVEQ #-1,D0$/ || l~/^MOVEQ #0,D0$/)h5=1; if(l~/^RTS$/)h6=1}
END{print "HAS_ENTRY="h1;print "HAS_SAVE="h2;print "HAS_WRITE="h3;print "HAS_RESTORE="h4;print "HAS_RETVAL="h5;print "HAS_RTS="h6}
