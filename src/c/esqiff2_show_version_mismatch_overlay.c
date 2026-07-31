/* RESTORES: ESQIFF2_ShowVersionMismatchOverlay
 * MODULE:   modules/groups/a/o/esqiff2_p3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: truncated-reference-and-base-reload
 *   ref:     4e55ffd848e7300020790000a3bc422800142f3900005e30487900005ba0487900005b98486dffd84ebab9be20790000a3bc52882e88486dffd84eba2af44fef00144a00670001104a790000a2dc670a4a790000a07c670000fe2c7800044eaeff8833fc010000005e8e4eba66b42c7800044eaeff82207900008702217c00008732000442790000a07c22790000870270022c79000028584eaefeaa2279000087027000723c243c000002a7766446034eaefece22790000870270034eaefeaa487900005ba44878005a4878001e2f39000087024eba1dd02eb900005e30487900005be8487900005bcc486dffd84ebab8f8486dffd8487800784878001e2f39000087024eba1da041f900005bec43edffd8700422d851c8fffc421120790000a3bc52882e88486dffd84eba3a90487900005c02486dffd84eba3a82486dffd8487800964878001e2f39000087024eba1d564fef0048
 *   got:     9efc002848e73002207900000000422800142f3900000000487900000000487900000000486f00186100000020790000000052882e88486f001c610000004fef00144a0067000122303900000000670a303900000000670001102c79000000004eaeff8833fc010000000000610000002c79000000004eaeff82207900000000217c0000000000044279000000002279000000002c790000000070024eaefeaa2279000000002c79000000007000723c243c000002a7766446034eaefece2279000000002c790000000070034eaefeaa4879000000004878005a4878001e2f3900000000610000002eb900000000487900000000487900000000486f002461000000486f0028487800784878001e2f39000000006100000041f90000000043ef0038700422d851c8fffc422f004c20790000000052882e88486f003861000000487900000000486f004061000000486f0044487800964878001e2f3900000000610000004fef00484cdf400cdefc00284e754e71
 *   summary: 372 got vs 342 ref, but the reference STOPS EARLY at ESQIFF2_ShowVersionMismatchOverlay_Return, so the MOVEM/UNLK/RTS is not counted and the true comparison is 372 against roughly 350. The residue is the volatile graphics base reloading before each library call where the original loads it once, plus the exec base as a data symbol rather than AbsExecBase. The 20-byte version blob is copied through a five-long struct assignment, which is what produces the original's MOVE.L (A0)+,(A1)+ / DBF; memcpy on the same char array inlines a MOVE.B loop instead. Both SPrintf calls, the wildcard gate, the Disable/Enable pair, the three text placements and both AppendAtNull calls match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"
#include "esq-exec.h"

struct VersionBlob { long w[5]; };

extern char *ESQIFF_RecordBufferPtr;
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;
extern long  Global_LONG_PATCH_VERSION_NUMBER;
extern short Global_UIBusyFlag;
extern short ED_DiagnosticsScreenActive;
extern short ESQPARS2_ReadModeFlags;
extern char  Global_STR_MAJOR_MINOR_VERSION_1[];
extern char  Global_STR_MAJOR_MINOR_VERSION_2[];
extern char  Global_STR_APOSTROPHE[];
extern char  ESQIFF_FMT_PCT_S_DOT_PCT_LD[];
extern char  ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD[];
extern char  ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA[];
extern char  ESQIFF_STR_CORRECT_VERSION_IS[];

extern void GROUP_AM_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, char *s, long v);
extern char ESQSHARED_JMPTBL_ESQ_WildcardMatch(char *pattern, char *text);
extern void GCOMMAND_SeedBannerFromPrefs(void);
extern void ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(struct RastPort *rp,
                long x, long y, char *text);
extern void GROUP_AR_JMPTBL_STRING_AppendAtNull(char *dst, char *src);

void ESQIFF2_ShowVersionMismatchOverlay(void)
{
    char buf[40];

    ESQIFF_RecordBufferPtr[20] = 0;

    GROUP_AM_JMPTBL_WDISP_SPrintf(buf, ESQIFF_FMT_PCT_S_DOT_PCT_LD,
        Global_STR_MAJOR_MINOR_VERSION_1, Global_LONG_PATCH_VERSION_NUMBER);

    if (ESQSHARED_JMPTBL_ESQ_WildcardMatch(buf, ESQIFF_RecordBufferPtr + 1) == 0)
        return;
    if (Global_UIBusyFlag != 0 && ED_DiagnosticsScreenActive == 0)
        return;

    Disable();
    ESQPARS2_ReadModeFlags = 0x100;
    GCOMMAND_SeedBannerFromPrefs();
    Enable();

    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
    ED_DiagnosticsScreenActive = 0;

    SetAPen(Global_REF_RASTPORT_1, 2);
    RectFill(Global_REF_RASTPORT_1, 0, 60, 679, 155);
    SetAPen(Global_REF_RASTPORT_1, 3);

    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 30, 90,
        ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA);

    GROUP_AM_JMPTBL_WDISP_SPrintf(buf,
        ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD,
        Global_STR_MAJOR_MINOR_VERSION_2, Global_LONG_PATCH_VERSION_NUMBER);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 30, 120,
        buf);

    *(struct VersionBlob *)buf = *(struct VersionBlob *)ESQIFF_STR_CORRECT_VERSION_IS;
    buf[20] = 0;

    GROUP_AR_JMPTBL_STRING_AppendAtNull(buf, ESQIFF_RecordBufferPtr + 1);
    GROUP_AR_JMPTBL_STRING_AppendAtNull(buf, Global_STR_APOSTROPHE);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 30, 150,
        buf);
}
