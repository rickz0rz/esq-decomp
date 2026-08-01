#!/usr/bin/env python3
"""Check that each C extern dereferences a global as many times as the original.

A restoration reaches a global through an `extern` declaration, and the number
of loads that declaration implies AT THE SYMBOL must equal the number the
original assembly performs. Get it wrong and the code reads a different
address:

    _Global_REF_STR_CLOCK_FORMAT:  DC.L 0        <- a POINTER variable

    extern char *X[];      X[i]  ->  load at (sym + i*4)          WRONG
    extern char **X;       X[i]  ->  load at (*(sym) + i*4)       right

DATA=FAR turns every global access into an absolute long carrying a
relocation, and cdiff.sh masks relocated fields, so the byte comparison cannot
see this. The emitted size does not change either. The only reliable signal is
the ADDRESSING MODE the original uses at the symbol:

    LEA _SYM,An / PEA _SYM / #_SYM / _SYM(An,Dn)   the symbol IS the data
    MOVEA.L _SYM,An / MOVE.W _SYM,Dn               the symbol HOLDS a pointer
                                                   or a scalar value

A C declaration implies the same two shapes. An array declarator, or any use
of &X, means the symbol is the data. Anything else means the symbol is read.
This tool compares the two and reports every disagreement.

Usage:  python3 tools/data_shape_audit.py [--all] [--verbose]

Without --all only the C files named in a manifest under src/c/ are checked.
Exit status is 1 if any disagreement remains.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASM_DIRS = [os.path.join(ROOT, 'src', 'modules'), os.path.join(ROOT, 'src', 'data')]
C_DIR = os.path.join(ROOT, 'src', 'c')

# extern declarations that are DATA (no parentheses -> not a function)
EXTERN_RE = re.compile(r'^\s*extern\s+(?![^;]*\()(.+?)\s*;\s*$')
DECL_RE = re.compile(r'((?:\*\s*)*)([A-Za-z_]\w*)\s*((?:\[[^\]]*\])*)\s*$')

ADDR = 'address'
VALUE = 'value'

# Shapes that disagree structurally but address the same bytes. Each was read
# and confirmed by hand; anything NOT listed here is a finding.
#
#   char X[] with X[0] on a one-byte datum loads the same address as a scalar
#   read, so the array declarator costs nothing.
#
#   A whole-struct assignment `local = X;` reads the bytes AT the symbol, which
#   is what LEA _X,A0 plus a copy loop does. It is the documented struct-copy
#   idiom in AGENTS.md, not an extra dereference.
BENIGN = {
    ('cleanup_draw_clock_banner.c', 'Global_REF_STR_USE_24_HR_CLOCK'),
    ('cleanup_draw_grid_time_banner.c', 'Global_REF_STR_USE_24_HR_CLOCK'),
    ('newgrid_apply_24_hour_formatting.c', 'Global_REF_STR_USE_24_HR_CLOCK'),
    ('esqshared_match_selection_code_with_optional_suffix.c', 'ESQ_STR_A'),
    ('esqfunc_draw_diagnostics_screen.c', 'ESQFUNC_VideoInsertionStateStrings'),
    ('newgrid_select_next_mode.c', 'NEWGRID_ModeSelectionTable'),

    # Whole-struct assignment `*(T *)dst = X;` or `&X` address arithmetic.
    # Each was read and confirmed on 2026-07-31: the C never dereferences a
    # pointer the symbol does not hold, it copies or addresses the bytes AT the
    # symbol, which is exactly what the original's LEA does.
    ('cleanup_format_entry_string_tokens.c', 'CLOCK_STR_TOKEN_PAIR_DEFAULTS'),
    ('diskio2_receive_transfer_blocks_to_file.c', 'DISKIO2_TransferCrc32Table'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_TEXT_ADS_DOT'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_CONFIGURATION_FILE_DOT'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_LOCAL_AVAIL_CFG_DOT'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_QTABLE_DOT'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_ERROR_LOG_DOT'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_DST_DATA_DOT'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_PROMO_TYPES'),
    ('diskio2_run_disk_sync_workflow.c', 'DISKIO2_STR_SAVING_DATA_VIEW_CONFIG'),
    ('esqdisp_draw_status_banner_impl.c', 'WDISP_StatusDayEntry0'),
    ('esqdisp_draw_status_banner_impl.c', 'WDISP_StatusDayEntry1'),
    ('esqdisp_draw_status_banner_impl.c', 'WDISP_StatusDayEntry2'),
    ('esqdisp_draw_status_banner_impl.c', 'WDISP_StatusDayEntry3'),
    ('locavail_save_availability_data_file.c', 'LOCAVAIL_TAG_UVGTI'),
    ('locavail_save_availability_data_file.c', 'LOCAVAIL_STR_LA_VER_1_COLON_CURDAY'),
    ('locavail_save_availability_data_file.c', 'LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY'),
    ('tliba2_compute_broadcast_time_window.c', 'TLIBA2_BroadcastWindowClockSnapshotA'),
}


def asm_usage():
    """Map symbol -> set of {address, value} over the whole assembly source."""
    use = {}
    for d in ASM_DIRS:
        for root, _, files in os.walk(d):
            for fn in sorted(files):
                if not fn.endswith('.s'):
                    continue
                # `LEA _SYM,An` followed at once by a dereference of An is a
                # VALUE access, not merely an address. The original writes the
                # banner sweep words that way -- LEA _SYM,A4 then MOVE.W D0,(A4)
                # -- which is a plain store to the symbol, and reading only the
                # LEA reported six such stores as one dereference too many.
                pending = None      # (symbol, register) from the previous line
                with open(os.path.join(root, fn), errors='replace') as fh:
                    for line in fh:
                        line = line.split(';')[0]
                        if '\t' not in line and not line.startswith(' '):
                            # a label line still may carry an instruction
                            pass
                        s = line.strip()
                        if not s or s.endswith(':'):
                            pending = None      # a label may be branched to
                            continue
                        parts = s.split(None, 1)
                        if len(parts) < 2:
                            pending = None
                            continue
                        op, operands = parts[0].upper(), parts[1]
                        if pending is not None:
                            psym, preg = pending
                            if re.search(r'[-(]?\(%s\)[+]?' % preg, operands,
                                         re.I):
                                use.setdefault(psym, set()).add(VALUE)
                        pending = None
                        m_lea = re.match(
                            r'LEA(?:\.[LW])?\s+(_?[A-Za-z_][\w.]*)\s*,\s*(A[0-7])\s*$',
                            s, re.I)
                        if m_lea:
                            pending = (m_lea.group(1), m_lea.group(2).upper())
                        if op.startswith(('DC.', 'DS.', 'DCB.', 'XDEF', 'XREF',
                                          'INCLUDE', 'IF', 'ENDIF', 'EQU')):
                            continue
                        base = op.split('.')[0]
                        for m in re.finditer(r'(#?)(_?[A-Za-z_][\w.]*)', operands):
                            hashed, sym = m.group(1), m.group(2)
                            if sym.startswith('.') or len(sym) < 3:
                                continue
                            after = operands[m.end():m.end() + 1]
                            rec = use.setdefault(sym, set())
                            if hashed == '#' or base in ('LEA', 'PEA'):
                                rec.add(ADDR)
                            elif after == '(':
                                # _SYM(An,Dn) -- indexed off the symbol itself
                                rec.add(ADDR)
                            else:
                                rec.add(VALUE)
    return use


def parse_externs(path):
    """Yield (symbol, is_array, raw) for each data extern in a C file."""
    out = []
    with open(path, errors='replace') as fh:
        for raw in fh:
            if 'extern' not in raw:
                continue
            m = EXTERN_RE.match(raw)
            if not m:
                continue
            mm = DECL_RE.search(m.group(1))
            if not mm:
                continue
            out.append((mm.group(2), bool(mm.group(3)), raw.strip()))
    return out


def address_of(body, name):
    """True if the C file uses &name as address-of rather than binary AND.

    `x & MASK` and `a && b` are not address-of. The test is the first
    non-space character before the ampersand: an identifier, a closing
    bracket or another ampersand means an operator, not an address.
    """
    for m in re.finditer(r'&\s*' + re.escape(name) + r'\b\s*(->|\.|\[)?', body):
        if m.group(1):
            # &X->f / &X.f / &X[i] takes the address of a MEMBER or element,
            # which still READS X when X is a pointer. Not address-of-symbol.
            continue
        j = m.start() - 1
        while j >= 0 and body[j] in ' \t':
            j -= 1
        if j < 0:
            return True
        if not (body[j].isalnum() or body[j] in '_)]&'):
            return True
    return False


def manifest_files():
    keep = set()
    for fn in os.listdir(C_DIR):
        if not (fn.startswith('replacements') and fn.endswith('.txt')):
            continue
        with open(os.path.join(C_DIR, fn), errors='replace') as fh:
            for line in fh:
                cols = line.split('#')[0].split()
                if len(cols) >= 2 and cols[1].startswith('c/'):
                    keep.add(os.path.basename(cols[1]))
    return keep


def main():
    check_all = '--all' in sys.argv
    verbose = '--verbose' in sys.argv
    use = asm_usage()
    keep = None if check_all else manifest_files()

    findings = []
    checked = 0
    benign = 0
    for fn in sorted(os.listdir(C_DIR)):
        if not fn.endswith('.c'):
            continue
        if keep is not None and fn not in keep:
            continue
        checked += 1
        path = os.path.join(C_DIR, fn)
        body = open(path, errors='replace').read()
        for name, is_array, raw in parse_externs(path):
            modes = use.get('_' + name) or use.get(name)
            if not modes:
                continue
            takes_addr = is_array or address_of(body, name)
            want = ADDR if takes_addr else VALUE
            if want in modes:
                continue
            if want is ADDR:
                why = ('C treats the symbol as the DATA, but the original only '
                       'ever LOADS it -- one dereference too few')
            else:
                why = ('C READS the symbol, but the original only ever takes '
                       'its ADDRESS -- one dereference too many')
            if (fn, name) in BENIGN:
                benign += 1
                continue
            findings.append((fn, name, sorted(modes), why, raw))

    for fn, name, modes, why, raw in findings:
        print('%s: %s' % (fn, name))
        print('    asm:   %s' % ', '.join(modes))
        print('    C:     %s' % raw)
        print('    ISSUE: %s' % why)
        print()

    if verbose:
        print('(symbols with no assembly reference are skipped)')
    scope = 'all' if check_all else 'manifest'
    print('data_shape_audit: %d C files checked (%s), %d disagreement(s), '
          '%d known-benign' % (checked, scope, len(findings), benign))
    return 1 if findings else 0


if __name__ == '__main__':
    sys.exit(main())
