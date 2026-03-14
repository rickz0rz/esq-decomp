/^___FLIB2_[A-Za-z0-9_]+__[0-9]+:$/ { next }
/^__const:$/ { next }
/^__strings:$/ { next }
/^XREF / { next }
/^XDEF / { next }
/^END$/ { next }
/^MOVE\.L A7,D0$/ { next }
/^SUBQ\.L #\$8,D0$/ { next }
/^CMP\.L __base\(A4\),D0$/ { next }
/^BCS\.W _XCOVF$/ { next }
/^CMP\.L __base\(A4\),A7$/ { next }
/^BCS(\.[A-Z]+)? _XCOVF$/ { next }
/^MOVEM(\.[A-Z]+)? / { next }

function flush_zero_reg() {
}

function flush_pending_call() {
    if (pending_call) {
        print "CALL TARGET"
        pending_call = 0
    }
}

{
    line = $0

    gsub(/[A-Za-z0-9_]+\(A4\)/, "SYM(A4)", line)
    gsub(/[A-Za-z0-9_]+\(PC\)/, "SYM(PC)", line)
    gsub(/GCOMMAND_[A-Za-z0-9_]+/, "SYM", line)
    gsub(/FLIB_(STR|FMT)_[A-Za-z0-9_]+/, "SYM", line)
    gsub(/Global_STR_[A-Za-z0-9_]+/, "SYM", line)
    gsub(/ESQPARS_ReplaceOwnedString/, "TARGET", line)
    gsub(/#'N'/, "#78", line)
    gsub(/#'B'/, "#66", line)
    gsub(/#\$4e/, "#78", line)
    gsub(/#\$42/, "#66", line)
    gsub(/#\$3c/, "#60", line)
    gsub(/#\$1e/, "#30", line)
    gsub(/#\$18/, "#24", line)
    gsub(/#\$a/, "#10", line)
    gsub(/#\$8/, "#8", line)
    gsub(/#\$1/, "#1", line)
    gsub(/#\$3/, "#3", line)
    gsub(/#\$4/, "#4", line)
    gsub(/#\$5/, "#5", line)
    gsub(/#\$6/, "#6", line)
    gsub(/#\$7/, "#7", line)
    gsub(/\$c\(A7\)/, "12(A7)", line)
    gsub(/MOVEM\.L D2-D3/, "MOVEM D2\\/D3", line)
    gsub(/MOVEM\.L D2\/D3/, "MOVEM D2\\/D3", line)
    gsub(/MOVEM\.L/, "MOVEM", line)
    gsub(/MOVEQ\.L/, "MOVEQ", line)
    gsub(/D2\\\/D3/, "D23", line)
    gsub(/D2-D3/, "D2\\/D3", line)
    gsub(/D2\/D3/, "D23", line)
    gsub(/\.L/, "", line)
    gsub(/\.W/, "", line)
    gsub(/SYM\(A4\)/, "SYM", line)
    gsub(/SYM\(PC\)/, "SYM", line)
    gsub(/^FLIB2_ResetAndLoadListingTemplat:$/, "FLIB2_ResetAndLoadListingTemplates:", line)
    gsub(/^BSR(\.[A-Z]+)? /, "CALL ", line)
    gsub(/^JSR /, "CALL ", line)
    gsub(/^BRA(\.[A-Z]+)? /, "BRANCH ", line)
    gsub(/^B[A-Z]{1,3}(\.[A-Z]+)? /, "BRANCH ", line)

    if (line == "ADDQ #8,A7" || line == "ADDQ #$8,A7" || line == "LEA 12(A7),A7") {
        next
    }

    if (line ~ /^CALL /) {
        flush_zero_reg()
        flush_pending_call()
        delete const_val["D0"]
        pending_call = 1
        next
    }

    if (pending_call && line == "MOVE D0,SYM") {
        print "CALL TARGET"
        print line
        pending_call = 0
        next
    }

    flush_pending_call()

    if (line ~ /^MOVEQ #0,D[0-7]$/) {
        reg = "D" substr(line, length(line), 1)
        const_val[reg] = "0"
        next
    }

    if (line == "SUBA A0,A0") {
        const_val["A0"] = "0"
        next
    }

    if (line ~ /^MOVEQ #[0-9]+,D[0-7]$/) {
        split(substr(line, 8), imm_parts, ",")
        const_val[imm_parts[2]] = imm_parts[1]
        next
    }

    if (line ~ /^MOVE D[0-7],SYM$/ || line ~ /^MOVE\.B D[0-7],SYM$/) {
        reg = substr(line, index(line, "D"), 2)
        if (reg in const_val) {
            if (const_val[reg] == "0") {
                print "CLR SYM"
            } else if (line ~ /^MOVE\.B /) {
                print "MOVE.B #" const_val[reg] ",SYM"
            } else {
                print "MOVEQ #" const_val[reg] ",SYM"
            }
            next
        }
    }

    if (line == "MOVE A0,SYM" && ("A0" in const_val) && const_val["A0"] == "0") {
        print "CLR SYM"
        next
    }

    flush_zero_reg()
    print line
}

END {
    flush_pending_call()
    flush_zero_reg()
}
