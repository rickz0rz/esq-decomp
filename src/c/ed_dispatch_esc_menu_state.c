/* RESTORES: ED_DispatchEscMenuState
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: saved-a6-and-ring-index
 *   ref:     20390000b35422390000b350b280670001244ab900001cda6700011a42b900001cdae588d0b90000b35441f90000b358d1c013d0000081944a790000a2dc672a22790000870270012c79000028584eaefeaa22790000870270024eaefea422790000870270014eaefe9e103900001cd848800c4000196400009cd040303b00064efb00040030003c00420042004e0048005a006000660054006c00720078007e0084008a008e008e008e008e008e008e008e008e00364eba233e605861000bc860526100158e604c6100123a6046610014dc604061000060603a61000b7c60344eba2f5c602e4eba2b3a6028610016c8602261000e98601c61001122601661001154601061001182600a610011b0600461000cbe52b90000b3540cb9000000140000b3546d0642b90000b354700123c000001cda4e75
 *   got:     2f0e203900000000223900000000b2806700012c4ab9000000006700012242b9000000002039000000002200e581d28041f900000000d1c113d000000000303900000000672a2279000000002c790000000070014eaefeaa22790000000070024eaefea422790000000070014eaefe9e103900000000488048c00c80000000196400009cd040303b00064efb00040030003c00420042004e0048005a006000660054006c00720078007e0084008a008e008e008e008e008e008e008e008e003661000000605861000000605261000000604c61000000604661000000604061000000603a61000000603461000000602e61000000602861000000602261000000601c61000000601661000000601061000000600a6100000060046100000052b9000000000cb900000014000000006d0642b900000000700123c0000000002c5f4e754e71
 *   summary: 320 got vs 310 ref, and THE JUMP TABLE IS BYTE-IDENTICAL -- all 25 word entries, including the two shared arms and the eight default arms. That took writing the case labels in the ORIGINAL's body order, which is not case order: 0, 24, 1, 2/3, 5, 4, 9, 6, 7, 8, then 10 to 15. Written in ascending order the table comes out monotonic and every entry differs. SHORTINT is load-bearing: without it the range check is CMPI.L #25 rather than the original's CMPI.W. esq-graphics-leaf.h is correct here -- the three pen calls are contiguous with no ESQ call between them, so the base loads once as in the original; the volatile header reloads it three times, +12. The residue is 6.51 saving and restoring A6 around the body, and reading the ring index once where the original reads it twice to build the five-byte stride.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics-leaf.h"

struct EdStateSlot {
    char keycode;
    char pad[4];            /* the ring stride is five bytes */
};

extern long  ED_StateRingIndex;
extern long  ED_StateRingWriteIndex;
extern long  ED_MenuDispatchReentryGuard;
extern struct EdStateSlot ED_StateRingTable[];
extern char  ED_LastKeyCode;
extern char  ED_MenuStateId;
extern short Global_UIBusyFlag;
extern struct RastPort *Global_REF_RASTPORT_1;

extern void ED2_HandleMenuActions(void);
extern void ED_CaptureKeySequence(void);
extern void ED1_HandleEscMenuInput(void);
extern void ED_HandleEditAttributesMenu(void);
extern void ED_HandleEditAttributesInput(void);
extern void ED_HandleEditorInput(void);
extern void ED_EnterTextEditMode(void);
extern void ED2_HandleScrollSpeedSelection(void);
extern void ED2_HandleDiagnosticsMenuActions(void);
extern void ED1_UpdateEscMenuSelection(void);
extern void ED_HandleSpecialFunctionsMenu(void);
extern void ED_SaveEverythingToDisk(void);
extern void ED_SavePrevueDataToDisk(void);
extern void ED_LoadTextAdsFromDh2(void);
extern void ED_RebootComputer(void);
extern void ED_HandleDiagnosticNibbleEdit(void);

void ED_DispatchEscMenuState(void)
{
    if (ED_StateRingWriteIndex == ED_StateRingIndex)
        return;
    if (ED_MenuDispatchReentryGuard == 0)
        return;

    ED_MenuDispatchReentryGuard = 0;
    ED_LastKeyCode = ED_StateRingTable[ED_StateRingIndex].keycode;

    if (Global_UIBusyFlag != 0) {
        SetAPen(Global_REF_RASTPORT_1, 1);
        SetBPen(Global_REF_RASTPORT_1, 2);
        SetDrMd(Global_REF_RASTPORT_1, 1);
    }

    switch (ED_MenuStateId) {
    case 0:  ED2_HandleMenuActions();            break;
    case 24: ED_CaptureKeySequence();            break;
    case 1:  ED1_HandleEscMenuInput();           break;
    case 2:
    case 3:  ED_HandleEditAttributesMenu();      break;
    case 5:  ED_HandleEditAttributesInput();     break;
    case 4:  ED_HandleEditorInput();             break;
    case 9:  ED_EnterTextEditMode();             break;
    case 6:  ED2_HandleScrollSpeedSelection();   break;
    case 7:  ED2_HandleDiagnosticsMenuActions(); break;
    case 8:  ED1_UpdateEscMenuSelection();       break;
    case 10: ED_HandleSpecialFunctionsMenu();    break;
    case 11: ED_SaveEverythingToDisk();          break;
    case 12: ED_SavePrevueDataToDisk();          break;
    case 13: ED_LoadTextAdsFromDh2();            break;
    case 14: ED_RebootComputer();                break;
    case 15: ED_HandleDiagnosticNibbleEdit();    break;
    default: break;
    }

    ED_StateRingIndex++;
    if (ED_StateRingIndex >= 20)
        ED_StateRingIndex = 0;
    ED_MenuDispatchReentryGuard = 1;
}
