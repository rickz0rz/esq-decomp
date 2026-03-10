typedef signed long LONG;
typedef signed short WORD;
typedef signed char BYTE;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern LONG ED_StateRingIndex;
extern LONG ED_StateRingWriteIndex;
extern LONG ED_MenuDispatchReentryGuard;
extern BYTE ED_MenuStateId;
extern UBYTE ED_StateRingTable[];
extern BYTE ED_LastKeyCode;
extern WORD Global_UIBusyFlag;

extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);

extern void ED2_HandleMenuActions(void);
extern void ED1_HandleEscMenuInput(void);
extern void ED_HandleEditAttributesMenu(void);
extern void ED_HandleEditorInput(void);
extern void ED_HandleEditAttributesInput(void);
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
extern void ED_CaptureKeySequence(void);

void ED_DispatchEscMenuState(void)
{
    LONG idx;

    if (ED_StateRingWriteIndex == ED_StateRingIndex) {
        return;
    }

    if (ED_MenuDispatchReentryGuard == 0) {
        return;
    }

    ED_MenuDispatchReentryGuard = 0;

    idx = ED_StateRingIndex;
    ED_LastKeyCode = (BYTE)ED_StateRingTable[(idx << 2) + idx];

    if (Global_UIBusyFlag != 0) {
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
        _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    }

    if ((UWORD)(UBYTE)ED_MenuStateId < (UWORD)0x19) {
        switch ((UWORD)(UBYTE)ED_MenuStateId) {
        case 0: ED2_HandleMenuActions(); break;
        case 1: ED1_HandleEscMenuInput(); break;
        case 2:
        case 3: ED_HandleEditAttributesMenu(); break;
        case 4: ED_HandleEditorInput(); break;
        case 5: ED_HandleEditAttributesInput(); break;
        case 6: ED2_HandleScrollSpeedSelection(); break;
        case 7: ED2_HandleDiagnosticsMenuActions(); break;
        case 8: ED1_UpdateEscMenuSelection(); break;
        case 9: ED_EnterTextEditMode(); break;
        case 10: ED_HandleSpecialFunctionsMenu(); break;
        case 11: ED_SaveEverythingToDisk(); break;
        case 12: ED_SavePrevueDataToDisk(); break;
        case 13: ED_LoadTextAdsFromDh2(); break;
        case 14: ED_RebootComputer(); break;
        case 15: ED_HandleDiagnosticNibbleEdit(); break;
        case 24: ED_CaptureKeySequence(); break;
        default: break;
        }
    }

    ED_StateRingIndex += 1;
    if (ED_StateRingIndex >= 0x14) {
        ED_StateRingIndex = 0;
    }

    ED_MenuDispatchReentryGuard = 1;
}
