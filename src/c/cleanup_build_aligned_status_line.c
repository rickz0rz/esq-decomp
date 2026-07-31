/* RESTORES: _CLEANUP_BuildAlignedStatusLine
 * MODULE:   modules/groups/a/e/cleanup4.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-locals
 *   ref:     4e55ffe048e70710266d00083e2d000e3c2d00123a2d001642adffe4200648c04a4767047201600272022f012f004eba2596220548c12ead00182f012f002b40fffc6100fea04fef00104a80671a200548c0487800062f002f2dfffc610020064fef000c2b40ffe44aadffe467000100487800142f2dffe44878001348790000038c486dfff44eba25504fef00144aad001c671048790000771f2f0b4eba7016504f600e4879000003942f0b4eba7006504f486dfff42f0b4eba6ffa200548c0487800072f002f2dfffc61001f984fef00142b40ffe04a80661641f90000039843edffe912d866fc41edffe92b48ffe0206dffe010280006488048c043f900007c11d3c008110007671610280006488048c02f004eba24b6584f7200120060047200460113c100007fe6206dffe010280007488048c043f900007c11d3c008110007671610280007488048c02f004eba247c584f7200120060047200460113c100007fe713fc00010000037860064239000003784cdf08e04e5d4e75
 *   got:     9efc001848e727343a2f00463c2f00423e2f003e2a6f003895ca300648c04a4757c1740194012f022f00610000002640300548c02eaf00502f002f0b610000004fef00104a806716300548c0487800062f002f0b6100000024404fef000c200a660a423900000000600000e8487800142f0a48780013487900000000486f003c610000004fef00144aaf004c67104879000000002f0d61000000504f600e4879000000002f0d61000000504f486f002c2f0d61000000300548c0487800072f002f0b610000004fef00142f400028661641f90000000043ef001d12d866fc41ef001d2f480028206f002810280006488043f900000000d2c0081100076714488048c02f0061000000584f13c000000000600650f900000000206f002810280007488043f900000000d2c0081100076714488048c02f0061000000584f13c000000000600650f90000000013fc0001000000004cdf2ce4defc00184e75
 *   summary: 348 got vs 380 ref, 32 bytes short. The original reloads the entry pointer and the flags pointer from the A5 frame before each use, including twice per nibble test; 6.51 holds them in address registers. The flag-driven mode selection, the entry-flag gate, the wrap-format SPrintf, the centred-versus-double-space prefix, the fallback flags string, both character-class probes with their ParseHexDigit conversion, both 0xFF else-arms and the render gate all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

extern char CLOCK_FMT_WRAP_CHAR_STRING_CHAR[];
extern char CLOCK_STR_DOUBLE_SPACE[];
extern char CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY[];
extern char TEXTDISP_CenterAlignToken[];
extern unsigned char WDISP_CharClassTable[];
extern char CLEANUP_AlignedInsetNibblePrimary;
extern char CLEANUP_AlignedInsetNibbleSecondary;
extern char CLOCK_AlignedInsetRenderGateFlag;

extern char *GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(long row, long kind);
extern long  CLEANUP_TestEntryFlagYAndBit1(char *entry, long slot, long kind);
extern char *COI_GetAnimFieldPointerByMode(char *entry, long slot, long mode);
extern void  GROUP_AE_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, long a,
                                           char *s, long b);
extern void  GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, char *src);
extern long  GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(long c);

void CLEANUP_BuildAlignedStatusLine(char *line, short flag, short row,
                                    short slot, long kind, long centered)
{
    char  wrap[8];
    char  fallback[11];
    char *entry;
    char *text;
    char *flags;

    text = 0;
    entry = GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode((long)row,
                flag != 0 ? 1 : 2);

    if (CLEANUP_TestEntryFlagYAndBit1(entry, (long)slot, kind) != 0)
        text = COI_GetAnimFieldPointerByMode(entry, (long)slot, 6);

    if (text == 0) {
        CLOCK_AlignedInsetRenderGateFlag = 0;
        return;
    }

    GROUP_AE_JMPTBL_WDISP_SPrintf(wrap, CLOCK_FMT_WRAP_CHAR_STRING_CHAR, 19,
                                  text, 20);

    if (centered != 0)
        GROUP_AI_JMPTBL_STRING_AppendAtNull(line, TEXTDISP_CenterAlignToken);
    else
        GROUP_AI_JMPTBL_STRING_AppendAtNull(line, CLOCK_STR_DOUBLE_SPACE);

    GROUP_AI_JMPTBL_STRING_AppendAtNull(line, wrap);

    flags = COI_GetAnimFieldPointerByMode(entry, (long)slot, 7);
    if (flags == 0) {
        strcpy(fallback, CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY);
        flags = fallback;
    }

    if (WDISP_CharClassTable[flags[6]] & 0x80)
        CLEANUP_AlignedInsetNibblePrimary =
            GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((long)flags[6]);
    else
        CLEANUP_AlignedInsetNibblePrimary = ~0;

    if (WDISP_CharClassTable[flags[7]] & 0x80)
        CLEANUP_AlignedInsetNibbleSecondary =
            GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((long)flags[7]);
    else
        CLEANUP_AlignedInsetNibbleSecondary = ~0;

    CLOCK_AlignedInsetRenderGateFlag = 1;
}
