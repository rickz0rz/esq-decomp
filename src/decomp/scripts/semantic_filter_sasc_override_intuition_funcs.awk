BEGIN {
    has_entry = 0
    has_setfunction = 0
    setfunction_calls = 0
    has_autorequest_ref = 0
    has_displayalert_ref = 0
    has_auto_noop_ref = 0
    has_alert_reboot_ref = 0
    has_backup_auto_write = 0
    has_backup_display_write = 0
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

    if (u ~ /^OVERRIDE_INTUITION_FUNCS[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "_LVOSETFUNCTION") > 0) {
        has_setfunction = 1
        setfunction_calls += 1
    }

    if (index(u, "_LVOAUTOREQUEST") > 0 || index(u, "LVOAUTOREQUEST") > 0) has_autorequest_ref = 1
    if (index(u, "_LVODISPLAYALERT") > 0 || index(u, "LVODISPLAYALERT") > 0) has_displayalert_ref = 1

    if (index(u, "LOCAVAIL2_AUTOREQUESTNOOP") > 0 || index(u, "LOCAVAIL2_AUTOREQUESTNO") > 0) has_auto_noop_ref = 1
    if (index(u, "LOCAVAIL2_DISPLAYALERTDELAYANDREBOOT") > 0 || index(u, "LOCAVAIL2_DISPLAYALERTDELAYANDRE") > 0) has_alert_reboot_ref = 1

    if (index(u, "GLOBAL_REF_BACKED_UP_INTUITION_AUTOREQUEST") > 0 || index(u, "GLOBAL_REF_BACKED_UP_INTUITION_A") > 0) has_backup_auto_write = 1
    if (index(u, "GLOBAL_REF_BACKED_UP_INTUITION_DISPLAYALERT") > 0 || index(u, "GLOBAL_REF_BACKED_UP_INTUITION_D") > 0) has_backup_display_write = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SETFUNCTION=" has_setfunction
    print "HAS_SETFUNCTION_2=" (setfunction_calls >= 2 ? 1 : 0)
    print "HAS_AUTOREQUEST_REF=" has_autorequest_ref
    print "HAS_DISPLAYALERT_REF=" has_displayalert_ref
    print "HAS_AUTO_NOOP_REF=" has_auto_noop_ref
    print "HAS_ALERT_REBOOT_REF=" has_alert_reboot_ref
    print "HAS_BACKUP_AUTO_WRITE=" has_backup_auto_write
    print "HAS_BACKUP_DISPLAY_WRITE=" has_backup_display_write
    print "HAS_RETURN=" has_return
}
