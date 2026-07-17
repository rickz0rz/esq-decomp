# Behavioral fingerprint for ESQSHARED_UpdateMatchingEntriesByTitle.
# Run over BOTH the original hand-ASM (absolute addr, decimal immediates, full
# symbols) and the SAS/C .dis (A4/near addr, hex immediates, truncated symbols).
# Markers match both forms, so a real behavioral match yields identical output.
function t(s, x){ x=s; sub(/;.*/,"",x); sub(/^[ \t]+/,"",x); sub(/[ \t]+$/,"",x);
                 gsub(/[ \t]+/," ",x); return toupper(x) }
BEGIN{ wild=0; testbit=0; setbit=0; sprintf_=0; replace=0; append=0; findchar=0;
       bannertime=0; adjust=0; applyfilter=0; dealloc=0;
       pclose=0; colon=0; popen=0; norm59=0; norm60=0; norm12=0;
       btst2=0; btst4=0; off498=0; entry40=0; rts=0 }
{
    l=t($0)
    if(l=="") next
    # helper calls (symbol names truncated in the .dis -> short stems)
    if(l ~ /WILDCARDMA/)  wild=1
    if(l ~ /TESTBIT1/)    testbit=1
    if(l ~ /SETBIT1/)     setbit=1
    if(l ~ /SPRINTF/)     sprintf_=1
    if(l ~ /REPLACEOWN/)  replace=1
    if(l ~ /APPENDATN/)   append=1
    if(l ~ /FINDCHARP/)   findchar=1
    if(l ~ /BANNERTIME/ || l ~ /BUILDBANNE/) bannertime=1
    if(l ~ /BRACKETED/ || l ~ /ADJUSTBRAC/)  adjust=1
    if(l ~ /PROGRAMTITLE/ || l ~ /APPLYPROGR/) applyfilter=1
    if(l ~ /DEALLOCATE/)  dealloc=1
    # trailing "(H:MM)" / "(:MM)" detection chars: ')'=41/$29 ':'=58/$3a '('=40/$28
    if(l ~ /#\$?29,/ || l ~ /#41,/ || l ~ /#\$?29$/ || l ~ /#41$/) pclose=1
    if(l ~ /#\$?3A,/ || l ~ /#58,/ || l ~ /#\$?3A$/ || l ~ /#58$/) colon=1
    if(l ~ /#\$?28,/ || l ~ /#40,/ || l ~ /#\$?28$/ || l ~ /#40$/) popen=1
    # time normalization: minute >59 (dec 59/$3b), -60 (dec 60/$3c), hour wrap 12 ($c)
    if(l ~ /#\$?3B,/ || l ~ /#59,/ || l ~ /#\$?3B$/ || l ~ /#59$/) norm59=1
    if(l ~ /#\$?3C,/ || l ~ /#60,/ || l ~ /#\$?3C$/ || l ~ /#60$/) norm60=1
    if(l ~ /#\$?C,/  || l ~ /#12,/ || l ~ /#\$?C$/  || l ~ /#12$/) norm12=1
    # digit-class bit test (#2) and title slot-flag bit test (#4)
    if(l ~ /^BTST #\$?2,/) btst2=1
    if(l ~ /^BTST #\$?4,/) btst4=1
    # title group-code at offset 498 (dec 498 / hex $1f2)
    if(l ~ /498\(A[0-7]\)/ || l ~ /\$1F2\(A[0-7]\)/) off498=1
    # entry status byte |= 0x80 (ORI.W #$80 / OR #128)
    if(l ~ /ORI?(\.[WBL])? #\$?80,/ || l ~ /OR(\.[WBL])? #128,/) entry40=1
    if(l=="RTS") rts=1
}
END{
    print "HAS_WILDCARD_MATCH=" wild
    print "HAS_TEST_BIT=" testbit
    print "HAS_SET_BIT=" setbit
    print "HAS_SPRINTF=" sprintf_
    print "HAS_REPLACE_OWNED=" replace
    print "HAS_APPEND_AT_NULL=" append
    print "HAS_FIND_CHAR=" findchar
    print "HAS_BANNER_TIME=" bannertime
    print "HAS_ADJUST_BRACKETED=" adjust
    print "HAS_APPLY_FILTER=" applyfilter
    print "HAS_DEALLOC=" dealloc
    print "HAS_PAREN_CLOSE=" pclose
    print "HAS_COLON=" colon
    print "HAS_PAREN_OPEN=" popen
    print "HAS_NORM_59=" norm59
    print "HAS_NORM_60=" norm60
    print "HAS_NORM_12=" norm12
    print "HAS_BTST_2=" btst2
    print "HAS_BTST_4=" btst4
    print "HAS_TITLE_498=" off498
    print "HAS_ENTRY_OR80=" entry40
    print "HAS_RTS=" rts
}
