BEGIN {
    l=0; op=0; opnew=0; del=0; cls=0; ioerr=0; app=0; tbl=0; rts=0
}

function t(s){
    sub(/;.*/,"",s)
    sub(/^[ \t]+/,"",s)
    sub(/[ \t]+$/,"",s)
    gsub(/[ \t]+/," ",s)
    return toupper(s)
}

{
    x=t($0)
    if(x=="") next
    if(x ~ /^HANDLE_OPENENTRYWITHFLAGS:$/) l=1
    if(x ~ /DOS_OPENWITHERRORSTATE/ || x ~ /DOS_OPENWITHERRORST/) op=1
    if(x ~ /DOS_OPENNEWFILEIFMISSING/ || x ~ /DOS_OPENNEWFILEIFMISS/) opnew=1
    if(x ~ /DOS_DELETEANDRECREATEFILE/ || x ~ /DOS_DELETEANDRECREATEF/) del=1
    if(x ~ /DOS_CLOSEWITHSIGNALCHECK/ || x ~ /DOS_CLOSEWITHSIGNALCH/) cls=1
    if(x ~ /GLOBAL_DOSIOERR/) ioerr=1
    if(x ~ /GLOBAL_APPERRORCODE/) app=1
    if(x ~ /GLOBAL_HANDLETABLECOUNT|GLOBAL_HANDLETABLEBASE|GLOBAL_HANDLETABLEFLAGS/) tbl=1
    if(x ~ /^RTS$/) rts=1
}

END {
    print "HAS_LABEL=" l
    print "HAS_OPEN_CALL=" op
    print "HAS_OPENNEW_CALL=" opnew
    print "HAS_DELETE_RECREATE_CALL=" del
    print "HAS_CLOSE_CALL=" cls
    print "HAS_DOSIOERR=" ioerr
    print "HAS_APPERR=" app
    print "HAS_TABLE_SCAN=" tbl
    print "HAS_RTS=" rts
}
