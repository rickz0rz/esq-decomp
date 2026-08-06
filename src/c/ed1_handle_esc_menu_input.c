/* RESTORES: ED1_HandleEscMenuInput
 * MODULE:   modules/groups/a/k/ed1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-only
 *   ref:     48e703004eba1b662e007c00100748800c400009640000d4d040303b00064efb000400100018003a005c0084008a00ae00c600bc6100033e600000d810390000061b724cb00166104eba254013fc000200001cd8600000bc7c01600000b610390000061b724cb00166104eba251e13fc000300001cd86000009a7c016000009413fc000600001cd84eba20c223f90000816a00008180487800094eba202c4eba2152584f7c00606a610003ee606413fc000a00001cd84eba209442b900008180487800044eba20024eba2256584f7c00604013fc000800001cd84eba1ba6603233fc00010000292c60287009be006604700560027001d1b90000818020390000818072064eba7ea223c1000081804eba1bc04a06674822790000870270042c79000028584eaefeaa100648805340661c487900001e924878010e487800912f39000087024ebaca664fef001022790000870270012c79000028584eaefeaa4cdf00c04e75
 *   got:     48e70302610000002e007c002007488048c00c8000000009640000d4d040303b00064efb000400100018003a005c0084008a00ae00c600bc61000000600000da103900000000724cb00166106100000013fc000200000000600000be7c01600000b8103900000000724cb00166106100000013fc0003000000006000009c7c016000009613fc0006000000006100000023f90000000000000000487800096100000061000000584f7c00606c61000000606613fc000a000000006100000042b900000000487800046100000061000000584f7c00604213fc00080000000061000000603433fc000100000000602a20077209b0016604720560027201d3b90000000020390000000072066100000023c100000000610000004a0667462279000000002c790000000070044eaefeaa20065300661c4879000000004878010e487800912f3900000000610000004fef00102279000000002c790000000070014eaefeaa4cdf40c04e75
 *   summary: 360 got vs 356 ref, first divergence at byte 3 -- the action code and the error flag land in different data registers. The nine-entry jump table has the same shape, including case 7 sharing the default arm that advances the menu cursor modulo 6, which is why case 0 and the other action arms skip that block entirely. The two 76-character availability guards, both help-text screens with their cursor resets, the shutdown flag and the two-pen error overlay match in kind and order. SHORTINT changes nothing here.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

extern struct RastPort *Global_REF_RASTPORT_1;
extern unsigned char ED_DiagTextModeChar;
extern char  ED_MenuStateId;
extern long  ED_EditCursorOffset;
extern long  ED_SavedScrollSpeedIndex;
extern short ESQ_ShutdownRequestedFlag;
extern char  ED2_STR_LOCAL_EDIT_NOT_AVAILABLE[];

extern long ED_GetEscMenuActionCode(void);
extern void ED1_ExitEscMenu(void);
extern void ED_DrawAdNumberPrompt(void);
extern void ED_DrawDiagnosticModeHelpText(void);
extern void ED_DrawMenuSelectionHighlight(long index);
extern void ED_DrawScrollSpeedMenuText(void);
extern void ED1_DrawDiagnosticsScreen(void);
extern void ED_DrawSpecialFunctionsMenu(void);
extern void ED_DrawBottomHelpBarBackground(void);
extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern void ED_DrawEscMainMenuText(void);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);

void ED1_HandleEscMenuInput(void)
{
    long code;
    char err;

    code = ED_GetEscMenuActionCode();
    err = 0;

    switch ((char)code) {
    case 0:
        ED1_ExitEscMenu();
        break;

    case 1:
        if (ED_DiagTextModeChar == 'L') {
            ED_DrawAdNumberPrompt();
            ED_MenuStateId = 2;
        } else {
            err = 1;
        }
        break;

    case 2:
        if (ED_DiagTextModeChar == 'L') {
            ED_DrawAdNumberPrompt();
            ED_MenuStateId = 3;
        } else {
            err = 1;
        }
        break;

    case 3:
        ED_MenuStateId = 6;
        ED_DrawDiagnosticModeHelpText();
        ED_EditCursorOffset = ED_SavedScrollSpeedIndex;
        ED_DrawMenuSelectionHighlight(9);
        ED_DrawScrollSpeedMenuText();
        err = 0;
        break;

    case 4:
        ED1_DrawDiagnosticsScreen();
        break;

    case 5:
        ED_MenuStateId = 10;
        ED_DrawDiagnosticModeHelpText();
        ED_EditCursorOffset = 0;
        ED_DrawMenuSelectionHighlight(4);
        ED_DrawSpecialFunctionsMenu();
        err = 0;
        break;

    case 6:
        ED_MenuStateId = 8;
        ED_DrawBottomHelpBarBackground();
        break;

    case 8:
        ESQ_ShutdownRequestedFlag = 1;
        break;

    case 7:
    default:
        ED_EditCursorOffset += ((char)code == 9) ? 5 : 1;
        ED_EditCursorOffset = (ED_EditCursorOffset - (ED_EditCursorOffset / 6) * 6);
        ED_DrawEscMainMenuText();
        break;
    }

    if (err != 0) {
        SetAPen(Global_REF_RASTPORT_1, 4);
        if (err == 1)
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 145, 270,
                                          ED2_STR_LOCAL_EDIT_NOT_AVAILABLE);
        SetAPen(Global_REF_RASTPORT_1, 1);
    }
}
