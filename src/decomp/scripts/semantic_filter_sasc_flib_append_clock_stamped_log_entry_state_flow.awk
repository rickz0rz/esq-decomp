BEGIN {
    has_entry = 0
    saw_spin_wait = 0
    saw_spin_set = 0
    saw_guard_count = 0
    saw_guard_limit = 0
    saw_guard_exit = 0
    saw_strlen_test = 0
    saw_strlen_cap = 0
    saw_strlen_truncate = 0
    div_count = 0
    saw_ampm_flag = 0
    saw_ampm_pm = 0
    saw_ampm_am = 0
    saw_sprintf = 0
    saw_add14 = 0
    append_count = 0
    saw_alloc_count = 0
    saw_alloc_flag = 0
    saw_alloc_call = 0
    saw_copy_ptrs = 0
    saw_copy_loop = 0
    saw_copy_clear = 0
    saw_copy_append = 0
    saw_replace_owned = 0
    saw_free_tmp = 0
    saw_spin_clear = 0
    saw_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function advance_stage(stage, target) {
    if (stage == target - 1) {
        return target
    }
    return stage
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^FLIB_APPENDCLOCKSTAMPEDLOGENTRY:/ || u ~ /^FLIB_APPENDCLOCKSTAMPEDLOGENT[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (u ~ /LOGAPPENDSPINLOCK/ && (u ~ /^TST\./ || u ~ /^MOVE\./ || u ~ /^CLR\./)) {
        if (u ~ /^TST\./) {
            saw_spin_wait = 1
        }
        if (u ~ /^MOVE\./ && (u ~ /#1,D[0-7]/ || u ~ /D[0-7],ESQPARS2_LOGAPPENDSPINLOCK/ || u ~ /#\$1,D[0-7]/)) {
            saw_spin_set = 1
        }
        if (u ~ /^CLR\./ || (u ~ /^MOVE\./ && u ~ /ESQPARS2_LOGAPPENDSPINLOCK/ && u ~ /D[0-7]/)) {
            saw_spin_clear = 1
        }
    }

    if (u ~ /FLIB_LOGENTRYBYTECOUNT/) {
        saw_guard_count = 1
    }
    if (u ~ /#\$2710|#10000/) {
        saw_guard_limit = 1
    }
    if (u ~ /FLIB_APPENDCLOCKSTAMPEDLOGENTRY_RETURN/ || (u ~ /MOVEQ\.L? #\$0,D0/ && saw_guard_limit)) {
        saw_guard_exit = 1
    }

    if (u ~ /^TST\.B /) {
        saw_strlen_test = 1
    }
    if (u ~ /#100,D0|#\$64,D0|\(\$64\)\.W/) {
        saw_strlen_cap = 1
    }
    if (u ~ /CLR\.B 99\(|CLR\.B \$63\(/) {
        saw_strlen_truncate = 1
    }

    if (u ~ /MATH_DIVS32|DIVS32/) {
        div_count++
    }

    if (u ~ /CLOCK_CACHEAMPMFLAG/) {
        saw_ampm_flag = 1
    }
    if (u ~ /ESQPARS2_LOGTAGPM/) {
        saw_ampm_pm = 1
    }
    if (u ~ /ESQPARS2_LOGTAGAM/) {
        saw_ampm_am = 1
    }

    if (u ~ /WDISP_SPRINTF|SPRINTF/) {
        saw_sprintf = 1
    }
    if (u ~ /#14,D7|#\$E,D7|ADDI\.W #14,D7|MOVEQ\.L? #\$E,D0|MOVEQ\.L? #14,D0/) {
        saw_add14 = 1
    }
    if (u ~ /APPENDATNULL/) {
        append_count++
    }

    if (u ~ /FLIB_LOGENTRYBYTECOUNT/ && (u ~ /D1|D0|D2/)) {
        saw_alloc_count = 1
    }
    if (u ~ /MEMF_PUBLIC|\(\$1\)\.W/) {
        saw_alloc_flag = 1
    }
    if (u ~ /ALLOCATEMEMORY|ALLOCATEMEM/) {
        saw_alloc_call = 1
    }

    if (u ~ /NEWGRID2_ERRORLOGENTRYPTR/ && (u ~ /A0|D1/)) {
        saw_copy_ptrs = 1
    }
    if (u ~ /^MOVE\.B \(A0\)\+,\(A1\)\+/ || u ~ /^MOVE\.B \(A0\),\(A1\)\+/) {
        saw_copy_loop = 1
    }
    if (u ~ /^CLR\.B \(A0\)/ || u ~ /^CLR\.B \(A2\)/) {
        saw_copy_clear = 1
    }
    if (u ~ /APPENDATNULL/ && (u ~ /-119\(A5\)|\$28\(A7\)|\$48\(A7\)|\$50\(A7\)/)) {
        saw_copy_append = 1
    }

    if (u ~ /ESQPARS_REPLACEOWNEDSTRING|REPLACEOWNEDSTRING/) {
        saw_replace_owned = 1
    }
    if (u ~ /DEALLOCATEMEMORY|DEALLOCATEMEM|DEALLOCATE/ ) {
        saw_free_tmp = 1
    }
    if (u == "RTS") {
        saw_return = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SPIN_WAIT=" saw_spin_wait
    print "HAS_SPIN_SET=" saw_spin_set
    print "HAS_GUARD_COUNT=" saw_guard_count
    print "HAS_GUARD_LIMIT=" saw_guard_limit
    print "HAS_GUARD_EXIT=" saw_guard_exit
    print "HAS_STRLEN_TEST=" saw_strlen_test
    print "HAS_STRLEN_CAP=" saw_strlen_cap
    print "HAS_STRLEN_TRUNCATE=" saw_strlen_truncate
    print "DIV_COUNT=" div_count
    print "HAS_AMPM_FLAG=" saw_ampm_flag
    print "HAS_AMPM_PM=" saw_ampm_pm
    print "HAS_AMPM_AM=" saw_ampm_am
    print "HAS_SPRINTF=" saw_sprintf
    print "HAS_ADD14=" saw_add14
    print "APPEND_COUNT=" append_count
    print "HAS_ALLOC_COUNT=" saw_alloc_count
    print "HAS_ALLOC_FLAG=" saw_alloc_flag
    print "HAS_ALLOC_CALL=" saw_alloc_call
    print "HAS_COPY_PTRS=" saw_copy_ptrs
    print "HAS_COPY_LOOP=" saw_copy_loop
    print "HAS_COPY_CLEAR=" saw_copy_clear
    print "HAS_COPY_APPEND=" saw_copy_append
    print "HAS_REPLACE_OWNED=" saw_replace_owned
    print "HAS_FREE_TMP=" saw_free_tmp
    print "HAS_SPIN_CLEAR=" saw_spin_clear
    print "HAS_RETURN=" saw_return
}
