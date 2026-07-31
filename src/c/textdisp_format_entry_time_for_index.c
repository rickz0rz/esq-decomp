/* RESTORES: _TEXTDISP_FormatEntryTimeForIndex
 * MODULE:   modules/groups/b/a/textdisp3_p1_p3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-only
 *   ref:     4e55fff448e70732266d00083e2d000e246d0010200748c0e5802b720838fffc200748c07200122a01f22f012f004eba1816504f2a004aadfffc67000106206dfffc4a10670000fc7028b0106608703ab0280003672870001039000028e3721e4eba5884220548c1d2802a01200548c02f0b2f004eba17ca504f600000c870001028000472309081720a4eba583a720012280005d081723090812c0070001039000028e3721e4eba583e220548c1d2802a01200648c0721e4eba582c70001039000028e32f410018721e4eba581a202f0018b0816c025245200648c081fc001e48402c007030ba406f0404450030200548c0e5802079000028f4d1c022502c4b1cd966fc7000102b000372309081720a4eba57b4220648c1d2802c01200648c0720a4eba57c27230d08117400003200648c0720a4eba57b07030d28017410004600242134cdf4ce04e5d4e75
 *   got:     594f48e737363e2f0032266f00342a6f002c48c72007e58024730838300748c07200122b01f02f012f00610000002c00504f200a6704101266064215600001047028b0126608703ab02a000367287000103900000000721e61000000320648c1d2802c01300648c02f0d2f0061000000504f600000ce102a000472001200703092802401e582d481d482122a000576001601d48394802a027000103900000000721e61000000320648c1d2802c01300548c0721e6100000070001039000000002f410024721e61000000202f0024b0816c025246300548c081fc001e48402a007030bc406f040446003048c62006e580207900000000d1c022502c4d1cd966fc102d000372001200703092802401e582d481d482320548c1d4812a02320548c12001720a610000007230d0811b400003300548c0720a610000007030d2801b4100044cdf6cec584f4e754e71
 *   summary: 332 got vs 332 ref, size-exact. Global_REF_STR_CLOCK_FORMAT is declared char ** because the symbol HOLDS the table base rather than being it -- data_shape_audit.py is the check, and getting this wrong is the invisible defect described in AGENTS.md. Every divide and modulo goes through the 32x32 helpers as the original does, including the two by 30 and the two by 10. The (-character and colon guard, the two-digit minute parse, the half-hour rounding compare, the 48-slot wrap, the clock-format string copy and the two rewritten digits all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

struct EntryTimeCtx {
    char          pad0[56];
    char         *rows[110];        /* +56, indexed by the row */
    unsigned char variant498;       /* +498 */
};

extern unsigned char CLOCK_FormatVariantCode;
extern char **Global_REF_STR_CLOCK_FORMAT;      /* a POINTER to the table */

extern short TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(long row,
                                                               long variant);
extern void  TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(long slot, char *out);

void TEXTDISP_FormatEntryTimeForIndex(char *out, short row,
                                      struct EntryTimeCtx *ctx)
{
    char *entry;
    short slot;
    short mins;

    entry = ctx->rows[row];
    slot = TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((long)row,
               (long)ctx->variant498);

    if (entry == 0 || *entry == 0) {
        *out = 0;
        return;
    }

    if (*entry != 40 || entry[3] != 58) {
        slot += CLOCK_FormatVariantCode / 30;
        TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry((long)slot, out);
        return;
    }

    mins = ((unsigned char)entry[4] - 48) * 10 + (unsigned char)entry[5] - 48;
    slot += CLOCK_FormatVariantCode / 30;
    if (mins % 30 < CLOCK_FormatVariantCode % 30)
        slot++;
    mins = mins % 30;
    if (slot > 48)
        slot -= 48;

    strcpy(out, Global_REF_STR_CLOCK_FORMAT[slot]);

    mins = ((unsigned char)out[3] - 48) * 10 + mins;
    out[3] = mins / 10 + 48;
    out[4] = mins % 10 + 48;
}
