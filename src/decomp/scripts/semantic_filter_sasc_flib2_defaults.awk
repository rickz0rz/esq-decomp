/^___FLIB2_[A-Za-z0-9_]+__[0-9]+:$/ { next }
/^__const:$/ { next }
/^__strings:$/ { next }
/^MOVE\.L A7,D0$/ { next }
/^SUBQ\.L #\$8,D0$/ { next }
/^CMP\.L __base\(A4\),D0$/ { next }
/^BCS\.W _XCOVF$/ { next }

{
    line = $0

    gsub(/[A-Za-z0-9_]+\(A4\)/, "SYM(A4)", line)
    gsub(/[A-Za-z0-9_]+\(PC\)/, "SYM(PC)", line)
    gsub(/#'N'/, "#78", line)
    gsub(/#'B'/, "#66", line)
    gsub(/#\$4e/, "#78", line)
    gsub(/#\$42/, "#66", line)
    gsub(/#\$3c/, "#60", line)
    gsub(/#\$1e/, "#30", line)
    gsub(/#\$18/, "#24", line)
    gsub(/#\$a/, "#10", line)
    gsub(/\$c\(A7\)/, "12(A7)", line)
    gsub(/MOVEM\.L D2-D3/, "MOVEM D2\\/D3", line)
    gsub(/MOVEM\.L D2\/D3/, "MOVEM D2\\/D3", line)
    gsub(/MOVEM\.L/, "MOVEM", line)
    gsub(/MOVEQ\.L/, "MOVEQ", line)
    gsub(/\.L/, "", line)
    gsub(/\.W/, "", line)
    gsub(/^BSR(\.[A-Z]+)? /, "CALL ", line)
    gsub(/^JSR /, "CALL ", line)
    gsub(/^BRA(\.[A-Z]+)? /, "BRANCH ", line)
    gsub(/^B[A-Z]{1,3}(\.[A-Z]+)? /, "BRANCH ", line)

    print line
}
