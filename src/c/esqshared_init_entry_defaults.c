/* RESTORES: ESQSHARED_InitEntryDefaults
 * MODULE:   modules/groups/a/p/esqshared.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     2f0b266f0008177c0002002870ff174000291740002a41eb002b43f900005d1410d966fc377c0003002e265f4e75
 *   got:     48e700342a6f001047ed002b45f9000000001b7c0002002870ff1b4000291b40002a204b528b101a10804a0066f43b7c0003002e4cdf2c004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char ESQPARS_DefaultEntryCodeString[];
struct EsqSharedEntry {
    char pad[40];
    unsigned char kind;
    unsigned char a;
    unsigned char b;
    char code[3];
    short mode;
};
void ESQSHARED_InitEntryDefaults(struct EsqSharedEntry *e)
{
    char *d = e->code;
    char *s = ESQPARS_DefaultEntryCodeString;

    e->kind = 2;
    e->a = 0xFF;
    e->b = 0xFF;
    while ((*d++ = *s++) != 0)
        ;
    e->mode = 3;
}
