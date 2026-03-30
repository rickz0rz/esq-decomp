BEGIN {
    has_entry = 0
    clear_loop = 0
    saw_clear_primary_table = 0
    saw_clear_secondary_table = 0
    has_exec = 0
    has_open_primary = 0
    has_open_secondary = 0
    has_readline = 0
    has_primary_newline = 0
    has_primary_carriage = 0
    has_primary_comma = 0
    has_find_separator = 0
    has_primary_alloc = 0
    has_primary_copy = 0
    has_secondary_newline = 0
    has_secondary_carriage = 0
    has_secondary_alloc = 0
    has_secondary_copy = 0
    has_compare = 0
    has_delete_prefix = 0
    has_append_at_null = 0
    has_delete_execute = 0
    has_free_secondary = 0
    has_free_primary = 0
    has_finalize_primary = 0
    has_finalize_secondary = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^PARSEINI_SCANLOGODIRECTORY:/ || u ~ /^PARSEINI_SCANLOGODIRECTOR[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (n ~ /CLEARENTRYTABLESLOOP/ || n ~ /CLRLA0/ || n ~ /CLRL[0-9A-F]*A7D0L/) {
        clear_loop = 1
    }
    if (n ~ /LVOEXECUTE/ || n ~ /GLOBALSTRLISTRAMLOGODIRTXTDH2LOGOSNOHEADQUICK/) {
        has_exec = 1
    }
    if (n ~ /PARSEINIPATHDF0COLONLOGODOT/ || n ~ /PARSEINISTRRBLOGOLISTPRIMARY/) {
        has_open_primary = 1
    }
    if (n ~ /PARSEINIPATHRAMCOLONLOGODIRDOTTXT/ || n ~ /PARSEINIPATHRAMCOLONLOGODIR/ || n ~ /PARSEINISTRRBLOGOLISTSECONDARY/ || n ~ /PARSEINISTRRBLOGOLISTSECONDAR/) {
        has_open_secondary = 1
    }
    if (n ~ /STREAMREADLINEWITHLIMIT/) {
        has_readline = 1
    }

    if (n ~ /MOVEQ10D0/ || n ~ /MOVEQLAD1/ || n ~ /PEA10W/) {
        if (!has_find_separator) {
            has_primary_newline = 1
        } else {
            has_secondary_newline = 1
        }
    }
    if (n ~ /MOVEQ13D0/ || n ~ /MOVEQLDD1/ || n ~ /PEA13W/) {
        if (!has_find_separator) {
            has_primary_carriage = 1
        } else {
            has_secondary_carriage = 1
        }
    }
    if (n ~ /MOVEQ44D0/ || n ~ /MOVEQL2CD1/) {
        has_primary_comma = 1
    }

    if (n ~ /GCOMMANDFINDPATHSEPARATOR/) {
        has_find_separator = 1
    }
    if (n ~ /GLOBALSTRPARSEINIC4/ || n ~ /PEA1263W/ || n ~ /PEA4EFW/) {
        has_primary_alloc = 1
    }
    if (has_find_separator && (n ~ /MOVEBA1PLUSA2PLUS/ || n ~ /MOVEBA2PLUSA3PLUS/ || n ~ /TSTBFFFFFFFFA2/ || n ~ /TSTBFFFFFFFFA3/)) {
        has_primary_copy = 1
    }

    if (n ~ /GLOBALSTRPARSEINIC5/ || n ~ /PEA1287W/ || n ~ /PEA507W/) {
        has_secondary_alloc = 1
    }
    if (has_secondary_alloc && (n ~ /MOVEBA1PLUSA2PLUS/ || n ~ /MOVEBA2PLUSA3PLUS/ || n ~ /TSTBFFFFFFFFA2/ || n ~ /TSTBFFFFFFFFA3/)) {
        has_secondary_copy = 1
    }

    if (n ~ /STRINGCOMPARENOCASE/) {
        has_compare = 1
    }
    if (n ~ /GLOBALSTRDELETENILDH2LOGOS/) {
        has_delete_prefix = 1
    }
    if (n ~ /STRINGAPPENDATNULL/) {
        has_append_at_null = 1
    }
    if (has_delete_prefix && n ~ /LVOEXECUTE/) {
        has_delete_execute = 1
    }

    if (n ~ /GLOBALSTRPARSEINIC6/ || n ~ /PEA1323W/ || n ~ /PEA52BW/) {
        has_free_secondary = 1
    }
    if (n ~ /GLOBALSTRPARSEINIC7/ || n ~ /PEA1329W/ || n ~ /PEA531W/) {
        has_free_primary = 1
    }

    if (n ~ /MOVE4A5A7/ || n ~ /MOVEPRIMARYHANDLEA7/ || n ~ /MOVED7A7/ || n ~ /MOVE4A7PRIMARYHANDLE/) {
        has_finalize_primary = 1
    }
    if (n ~ /MOVE8A5A7/ || n ~ /MOVESECONDARYHANDLEA7/ || n ~ /MOVED6A7/ || n ~ /MOVE8A7SECONDARYHANDLE/) {
        has_finalize_secondary = 1
    }
    if (n ~ /UNKNOWN36FINALIZEREQUEST/) {
        if (!has_finalize_primary) {
            has_finalize_primary = 1
        } else {
            has_finalize_secondary = 1
        }
    }

    if (u == "RTS") {
        has_return = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "CLEAR_LOOP=" clear_loop
    print "HAS_EXEC=" has_exec
    print "HAS_OPEN_PRIMARY=" has_open_primary
    print "HAS_OPEN_SECONDARY=" has_open_secondary
    print "HAS_READLINE=" has_readline
    print "HAS_PRIMARY_NEWLINE=" has_primary_newline
    print "HAS_PRIMARY_CARRIAGE=" has_primary_carriage
    print "HAS_PRIMARY_COMMA=" has_primary_comma
    print "HAS_FIND_SEPARATOR=" has_find_separator
    print "HAS_PRIMARY_ALLOC=" has_primary_alloc
    print "HAS_PRIMARY_COPY=" has_primary_copy
    print "HAS_SECONDARY_NEWLINE=" has_secondary_newline
    print "HAS_SECONDARY_CARRIAGE=" has_secondary_carriage
    print "HAS_SECONDARY_ALLOC=" has_secondary_alloc
    print "HAS_SECONDARY_COPY=" has_secondary_copy
    print "HAS_COMPARE=" has_compare
    print "HAS_DELETE_PREFIX=" has_delete_prefix
    print "HAS_APPEND_AT_NULL=" has_append_at_null
    print "HAS_DELETE_EXECUTE=" has_delete_execute
    print "HAS_FREE_SECONDARY=" has_free_secondary
    print "HAS_FREE_PRIMARY=" has_free_primary
    print "HAS_FINALIZE_PRIMARY=" has_finalize_primary
    print "HAS_FINALIZE_SECONDARY=" has_finalize_secondary
    print "HAS_RETURN=" has_return
}
