BEGIN {e=0; lf=0; wait=0; bt=0; ddr=0; prb=0; r=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  x=t($0)
  if(x=="") next
  if(x~/^PARALLEL_WRITECHARHW:$/) e=1
  if(x~/CMPI\.B #\$A,D0/ || x~/CMPI\.B #10,D0/ || x~/MOVEQ(\.L)? #13,D0/ || x~/MOVEQ(\.L)? #\$A,D[0-7]/ || x~/CMP\.B D[0-7],D[0-7]/ || x~/MOVE\.B #\$D,CIAA_PRB/) lf=1
  if(x~/CIAB_PRA/) wait=1
  if(x~/^BTST #0,D[0-7]$/ || x~/^BTST #\$0,D[0-7]$/ || x~/^ANDI\.B #1,D[0-7]$/) bt=1
  if(x~/CIAA_DDRB/) ddr=1
  if(x~/CIAA_PRB/) prb=1
  if(x~/^RTS$/) r=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_LF_CR_PATH=" lf
  print "HAS_WAIT_READ=" wait
  print "HAS_BIT_TEST=" bt
  print "HAS_DDRB_WRITE=" ddr
  print "HAS_PRB_WRITE=" prb
  print "HAS_RTS=" r
}
