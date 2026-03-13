{
    line = $0

    sub(/;.*/, "", line)
    sub(/^[ \t]+/, "", line)
    sub(/[ \t]+$/, "", line)
    gsub(/[ \t]+/, " ", line)

    if (line == "") {
        next
    }

    if (line ~ /^___[A-Za-z0-9_]+__[0-9]+:$/) {
        next
    }

    if (line == "const:" || line == "strings:" ||
        line == "__const:" || line == "__strings:") {
        next
    }

    if (line ~ /^(XREF|XDEF|END)( |$)/) {
        next
    }

    if (line == "CMP.L __base(A4),A7" || line == "CMP.L __base(A4),D0") {
        next
    }

    if (line == "BCS.W _XCOVF") {
        next
    }

    gsub(/\(A4\)/, "", line)
    gsub(/MOVEQ\.L #\$0,/, "MOVEQ #0,", line)
    gsub(/MOVEQ\.L #\$1,/, "MOVEQ #1,", line)
    gsub(/MOVEQ\.L #\$ff,/, "MOVEQ #-1,", line)
    gsub(/MOVEQ\.L #\$FF,/, "MOVEQ #-1,", line)

    print line
}
