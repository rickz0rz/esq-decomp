BEGIN {
    has_entry=0
    has_replace=0
    has_enable=0
    has_workflow=0
    has_template_ptr=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^FLIB2_LOADDIGITALNICHEDEFAULTS:/ || u ~ /^FLIB2_LOADDIGITALNICHEDEFA[A-Z0-9_]*:/) has_entry=1
    if (n ~ /ESQPARSREPLACEOWNEDSTRING/) has_replace=1
    if (n ~ /GCOMMANDDIGITALNICHEENABLEDFLAG/) has_enable=1
    if (n ~ /GCOMMANDNICHEWORKFLOWMODE/) has_workflow=1
    if (n ~ /GCOMMANDDIGITALNICHELISTINGSTEM/) has_template_ptr=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_REPLACE_CALL="has_replace
    print "HAS_ENABLE_FLAG_GLOBAL="has_enable
    print "HAS_WORKFLOW_GLOBAL="has_workflow
    print "HAS_TEMPLATE_PTR_GLOBAL="has_template_ptr
    print "HAS_RTS="has_rts
}
