BEGIN {
    has_entry = 0
    has_textlen = 0
    has_text = 0
    has_setapen = 0
    has_frame = 0
    has_off36 = 0
    has_off38 = 0
    has_off58 = 0
    has_off25 = 0
    has_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^SCRIPT_DRAWINSETTEXTWITHFRAME:/ || u ~ /^SCRIPT_DRAWINSETTEXTWITHFRAM[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /LVOTEXTLENGTH/) has_textlen = 1
    if (n ~ /LVOTEXT/) has_text = 1
    if (n ~ /LVOSETAPEN/) has_setapen = 1
    if (n ~ /TEXTDISPJMPTBLCLEANUPDRAWINSETRECTFRAME/ ||
        n ~ /TEXTDISPJMPTBLCLEANUPDRAWINSETRECTFR/ ||
        n ~ /TEXTDISPJMPTBLCLEANUPDRAWINSE/ ||
        n ~ /CLEANUPDRAWINSETRECTFRAME/ ||
        n ~ /CLEANUPDRAWINSETRECTFR/ ||
        n ~ /CLEANUPDRAWINSE/) has_frame = 1
    if (u ~ /[^0-9]36[^0-9]/ || u ~ /^36$/ || u ~ /\$24/) has_off36 = 1
    if (u ~ /[^0-9]38[^0-9]/ || u ~ /^38$/ || u ~ /\$26/) has_off38 = 1
    if (u ~ /[^0-9]58[^0-9]/ || u ~ /^58$/ || u ~ /\$3A/) has_off58 = 1
    if (u ~ /[^0-9]25[^0-9]/ || u ~ /^25$/ || u ~ /\$19/) has_off25 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TEXTLEN=" has_textlen
    print "HAS_TEXT=" has_text
    print "HAS_SETAPEN=" has_setapen
    print "HAS_FRAME=" has_frame
    print "HAS_OFF36=" has_off36
    print "HAS_OFF38=" has_off38
    print "HAS_OFF58=" has_off58
    print "HAS_OFF25=" has_off25
    print "HAS_RETURN=" has_return
}
