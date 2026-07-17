# Behavioral fingerprint for ESQSHARED_CreateGroupEntryAndTitle.
# Run over BOTH the original hand-ASM (absolute addressing, decimal immediates,
# full symbol names) and the SAS/C .dis (A4/near addressing, hex immediates,
# 31-char-truncated symbols). Markers are written to match BOTH forms, so a true
# behavioral match yields identical output on both sides.
function t(s, x){ x=s; sub(/;.*/,"",x); sub(/^[ \t]+/,"",x); sub(/[ \t]+$/,"",x);
                 gsub(/[ \t]+/," ",x); return toupper(x) }
BEGIN{ alloc=0; ensure=0; reverse=0; initdef=0; copyloop=0;
       b49=0; b6=0; off498=0; present=0; mutation=0; rts=0 }
{
    l=t($0)
    if(l=="") next
    # two entry-record + title-record allocations (JMPTBL_MEMORY_AllocateMemory)
    if(l ~ /ALLOCATEME/) alloc++
    # helper calls (names may be truncated in the .dis -> match a short stem)
    if(l ~ /ENSUREANIM/) ensure=1
    if(l ~ /REVERSEBI/)  reverse=1
    if(l ~ /INITENTRYDEF/) initdef=1
    # byte string-copy loops (name/title text). The hand-ASM uses
    # MOVE.B (An)+,(An)+; SAS/C codegen emits MOVE.B (An),(An)+ paired with a
    # separate MOVE.B (An)+,Dn null-test -> accept an optional source post-inc.
    if(l ~ /^MOVE\.B \(A[0-7]\)\+?,\(A[0-7]\)\+$/) copyloop=1
    # present-flag loop bound 49 (dec 49 / hex $31) and clear loop bound 6
    if(l ~ /#\$?31,/ || l ~ /#49,/ || l ~ /#\$?31$/ || l ~ /#49$/) b49=1
    if(l ~ /#\$?6,/ || l ~ /#6,/ || l ~ /#\$?6$/ || l ~ /#6$/) b6=1
    # title group-code store at offset 498 (dec 498 / hex $1f2)
    if(l ~ /498\(A[0-7]\)/ || l ~ /\$1F2\(A[0-7]\)/) off498=1
    # set a group present flag to 1
    if(l ~ /PRESENTFL/) present=1
    # group mutation-state writes
    if(l ~ /MUTATION/) mutation=1
    if(l=="RTS") rts=1
}
END{
    print "ALLOC_COUNT_GE2=" (alloc>=2 ? 1 : 0)
    print "HAS_ENSURE_ANIM=" ensure
    print "HAS_REVERSE_BITS=" reverse
    print "HAS_INIT_DEFAULTS=" initdef
    print "HAS_COPY_LOOP=" copyloop
    print "HAS_LOOP_49=" b49
    print "HAS_LOOP_6=" b6
    print "HAS_TITLE_498=" off498
    print "HAS_PRESENT_FLAG=" present
    print "HAS_MUTATION_STATE=" mutation
    print "HAS_RTS=" rts
}
