/* RESTORES: _TEXTDISP_HandleScriptCommand
 * MODULE:   modules/groups/b/a/textdisp_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame
 *   ref:     4e55ff3048e72f101e2d000b1c2d000f266d00107a017801700010065240670001b80440004367125f40670000ee0440000a67000112600001a02f0b487900007696486dff384eba60e630390000c0aa48c02e8048790000bf1a2f0b4eba12624fef00145340662433f9000076e80000c28e33f90000c7580000768e6100ec847200120033c100007690605e30390000c74c5240671c33fc00010000c28e33f90000c74c0000768e70ff33c000007690603830390000c74e5240671a42790000c28e33f90000c74e0000768e70ff33c000007690601470ff33c00000769033c00000768e33c00000c28e30390000c28e48c032390000768e48c134390000769048c22f022f012f006100eff66100ebda4fef000c7a00600000c030390000c28e48c032390000768e48c134390000769048c22f022f012f006100f2f24fef000c7a00600000947046be00666e4ab90000769266222f3c00010001487802dc4878043c4879000076a24eba55e04fef001023c00000769248790000bf1a2f0b2f39000076926100f49a487800462f39000076926100f8a44fef00144a80661c4ab900007692671420790000769241e800dc43f9000076ae10d966fc2f39000076926100fca2487800582f39000076926100f8684fef000c78004a85671033fcffff0000768e33fc0031000076904a84673442a742a76100f842504f4ab9000076926722487802dc2f3900007692487804524879000076b04eba55624fef001042b9000076924cdf08f44e5d4e75
 *   got:     9efc00c848e72f041c2f00eb1e2f00e72a6f00ec7a017801700010065280670001b47243908167125f80670000ee720a9081670001126000019c2f0d487900000000486f00206100000030390000000048c02e804879000000002f0d610000004fef00145380662433f9000000000000000033f90000000000000000610000007200120033c100000000605e3039000000005240671c33fc00010000000033f9000000000000000070ff33c00000000060383039000000005240671a42790000000033f9000000000000000070ff33c000000000601470ff33c00000000033c00000000033c00000000030390000000048c032390000000048c134390000000048c22f022f012f0061000000610000004fef000c7a00600000bc30390000000048c032390000000048c134390000000048c22f022f012f00610000004fef000c7a00600000907046be00666a4ab90000000066222f3c00010001487802dc4878043c4879000000006100000023c0000000004fef00104879000000002f0d2f390000000061000000487800462f3900000000610000004fef00144a80661820390000000067102040d0fc00dc43f90000000010d966fc2f390000000061000000487800582f3900000000610000004fef000c78004a85671033fcffff0000000033fc0031000000004a84673042a742a761000000504f203900000000671e487802dc2f00487804524879000000006100000042b9000000004fef00104cdf20f4defc00c84e754e71
 *   summary: 552 got vs 556 ref, four bytes short. The command dispatch keeps the original's chained-subtract shape -- ADDQ.W #1 for the -1 arm, then SUBI #67, SUBQ #7 and SUBI #10 for 66, 73 and 83 -- which only comes out if the selector is an unsigned char switched with a case -1. The residue is the frame register on the 200-byte scratch buffer. The four-way match fallback that tries the active group, then the primary first match, then the secondary, then -1 for all three, the now-showing status line, the entry-pair line, the 732-byte command buffer with its lazy allocation and matching release, the default space pad and both filter passes at 70 and 88 match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

extern short TEXTDISP_PrimaryChannelCode;
extern char  TEXTDISP_PrimarySearchText[];
extern short TEXTDISP_ActiveGroupId;
extern short TEXTDISP_CurrentMatchIndex;
extern short TEXTDISP_StatusGroupId;
extern short TEXTDISP_LastDispatchMatchIndex;
extern short TEXTDISP_LastDispatchGroupId;
extern short TEXTDISP_PrimaryFirstMatchIndex;
extern short TEXTDISP_SecondaryFirstMatchIndex;
extern char *TEXTDISP_CommandBufferPtr;
extern char  TEXTDISP_CommandPrefixFormat[];
extern char  TEXTDISP_DefaultSpacePad[];
extern char  Global_STR_TEXTDISP_C_1[];
extern char  Global_STR_TEXTDISP_C_2[];

extern void  WDISP_SPrintf(char *buf, char *fmt, char *text);
extern long  TEXTDISP_SelectGroupAndEntry(char *source, char *out, long mode);
extern long  SCRIPT_GetBannerCharOrFallback(void);
extern void  TEXTDISP_BuildNowShowingStatusLine(long group, long match,
                                                long dispatch);
extern void  SCRIPT_ResetBannerCharDefaults(void);
extern void  TEXTDISP_BuildEntryPairStatusLine(long group, long match,
                                               long dispatch);
extern char *MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line, char *ptr, long size);
extern void  TEXTDISP_SetEntryTextFields(char *buf, char *text, char *search);
extern long  TEXTDISP_FilterAndSelectEntry(char *buf, long mode);
extern void  TEXTDISP_DrawHighlightFrame(char *buf);

void TEXTDISP_HandleScriptCommand(char sub, unsigned char cmd, char *text)
{
    char scratch[200];
    long resetBanner;
    long cleanup;

    resetBanner = 1;
    cleanup = 1;

    switch (cmd) {
    case -1:
        break;

    case 66:
        WDISP_SPrintf(scratch, TEXTDISP_CommandPrefixFormat, text);
        if (TEXTDISP_SelectGroupAndEntry(text, TEXTDISP_PrimarySearchText,
                (long)TEXTDISP_PrimaryChannelCode) == 1) {
            TEXTDISP_StatusGroupId = TEXTDISP_ActiveGroupId;
            TEXTDISP_LastDispatchMatchIndex = TEXTDISP_CurrentMatchIndex;
            TEXTDISP_LastDispatchGroupId =
                (unsigned char)SCRIPT_GetBannerCharOrFallback();
        } else if (TEXTDISP_PrimaryFirstMatchIndex != -1) {
            TEXTDISP_StatusGroupId = 1;
            TEXTDISP_LastDispatchMatchIndex = TEXTDISP_PrimaryFirstMatchIndex;
            TEXTDISP_LastDispatchGroupId = -1;
        } else if (TEXTDISP_SecondaryFirstMatchIndex != -1) {
            TEXTDISP_StatusGroupId = 0;
            TEXTDISP_LastDispatchMatchIndex = TEXTDISP_SecondaryFirstMatchIndex;
            TEXTDISP_LastDispatchGroupId = -1;
        } else {
            TEXTDISP_LastDispatchGroupId = -1;
            TEXTDISP_LastDispatchMatchIndex = -1;
            TEXTDISP_StatusGroupId = -1;
        }
        TEXTDISP_BuildNowShowingStatusLine((long)TEXTDISP_StatusGroupId,
            (long)TEXTDISP_LastDispatchMatchIndex,
            (long)TEXTDISP_LastDispatchGroupId);
        SCRIPT_ResetBannerCharDefaults();
        resetBanner = 0;
        break;

    case 73:
        TEXTDISP_BuildEntryPairStatusLine((long)TEXTDISP_StatusGroupId,
            (long)TEXTDISP_LastDispatchMatchIndex,
            (long)TEXTDISP_LastDispatchGroupId);
        resetBanner = 0;
        break;

    case 83:
        if (sub == 70) {
            if (TEXTDISP_CommandBufferPtr == 0)
                TEXTDISP_CommandBufferPtr = MEMORY_AllocateMemory(
                    Global_STR_TEXTDISP_C_1, 1084, 732,
                    MEMF_PUBLIC + MEMF_CLEAR);

            TEXTDISP_SetEntryTextFields(TEXTDISP_CommandBufferPtr, text,
                                        TEXTDISP_PrimarySearchText);

            if (TEXTDISP_FilterAndSelectEntry(TEXTDISP_CommandBufferPtr, 70) == 0
                && TEXTDISP_CommandBufferPtr != 0)
                strcpy(TEXTDISP_CommandBufferPtr + 0xdc,
                       TEXTDISP_DefaultSpacePad);
        }
        TEXTDISP_DrawHighlightFrame(TEXTDISP_CommandBufferPtr);
        TEXTDISP_FilterAndSelectEntry(TEXTDISP_CommandBufferPtr, 88);
        cleanup = 0;
        break;

    default:
        break;
    }

    if (resetBanner != 0) {
        TEXTDISP_LastDispatchMatchIndex = -1;
        TEXTDISP_LastDispatchGroupId = 0x31;
    }

    if (cleanup == 0)
        return;

    TEXTDISP_FilterAndSelectEntry(0, 0);

    if (TEXTDISP_CommandBufferPtr == 0)
        return;

    MEMORY_DeallocateMemory(Global_STR_TEXTDISP_C_2, 1106,
                            TEXTDISP_CommandBufferPtr, 732);
    TEXTDISP_CommandBufferPtr = 0;
}
