typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern void *TEXTDISP_CommandBufferPtr;
extern WORD TEXTDISP_StatusGroupId;
extern WORD TEXTDISP_LastDispatchMatchIndex;
extern WORD TEXTDISP_LastDispatchGroupId;
extern WORD TEXTDISP_ActiveGroupId;
extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD TEXTDISP_PrimaryFirstMatchIndex;
extern WORD TEXTDISP_SecondaryFirstMatchIndex;
extern char TEXTDISP_PrimarySearchText[];
extern char TEXTDISP_DefaultSpacePad[];

extern const char Global_STR_TEXTDISP_C_1[];
extern const char Global_STR_TEXTDISP_C_2[];
extern const char TEXTDISP_CommandPrefixFormat[];

extern void *MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void WDISP_SPrintf(char *dst, const char *fmt, const char *arg);
extern LONG TEXTDISP_SelectGroupAndEntry(const char *cmd, char *primarySearch, LONG channelCode);
extern UBYTE SCRIPT_GetBannerCharOrFallback(void);
extern void TEXTDISP_BuildNowShowingStatusLine(LONG group, LONG match, LONG bannerChar);
extern void SCRIPT_ResetBannerCharDefaults(void);
extern void TEXTDISP_BuildEntryPairStatusLine(LONG group, LONG match, LONG bannerChar);
extern void TEXTDISP_SetEntryTextFields(void *entry, const UBYTE *shortText, const UBYTE *longText);
extern LONG TEXTDISP_FilterAndSelectEntry(void *entry, LONG mode);
extern void TEXTDISP_DrawHighlightFrame(void *entry);

LONG TEXTDISP_HandleScriptCommand(UBYTE scriptType, UBYTE command, const char *arg)
{
    LONG doFinalize = 1;
    LONG doCleanup = 1;
    char scratch[200];

    if (command == 'C') {
        WDISP_SPrintf(scratch, TEXTDISP_CommandPrefixFormat, arg);

        if (TEXTDISP_SelectGroupAndEntry(arg, TEXTDISP_PrimarySearchText, 0) == 0) {
            TEXTDISP_StatusGroupId = TEXTDISP_ActiveGroupId;
            TEXTDISP_LastDispatchMatchIndex = TEXTDISP_CurrentMatchIndex;
            TEXTDISP_LastDispatchGroupId = (WORD)SCRIPT_GetBannerCharOrFallback();
        } else if ((WORD)(TEXTDISP_PrimaryFirstMatchIndex + 1) != 0) {
            TEXTDISP_StatusGroupId = 1;
            TEXTDISP_LastDispatchMatchIndex = TEXTDISP_PrimaryFirstMatchIndex;
            TEXTDISP_LastDispatchGroupId = -1;
        } else if ((WORD)(TEXTDISP_SecondaryFirstMatchIndex + 1) != 0) {
            TEXTDISP_StatusGroupId = 0;
            TEXTDISP_LastDispatchMatchIndex = TEXTDISP_SecondaryFirstMatchIndex;
            TEXTDISP_LastDispatchGroupId = -1;
        } else {
            TEXTDISP_StatusGroupId = -1;
            TEXTDISP_LastDispatchMatchIndex = -1;
            TEXTDISP_LastDispatchGroupId = -1;
        }

        TEXTDISP_BuildNowShowingStatusLine(
            (LONG)TEXTDISP_StatusGroupId,
            (LONG)TEXTDISP_LastDispatchMatchIndex,
            (LONG)TEXTDISP_LastDispatchGroupId
        );
        SCRIPT_ResetBannerCharDefaults();
        doFinalize = 0;
    } else if (command == 'J') {
        TEXTDISP_BuildEntryPairStatusLine(
            (LONG)TEXTDISP_StatusGroupId,
            (LONG)TEXTDISP_LastDispatchMatchIndex,
            (LONG)TEXTDISP_LastDispatchGroupId
        );
        doFinalize = 0;
    } else {
        if (scriptType == 'F') {
            if (TEXTDISP_CommandBufferPtr == (void *)0) {
                TEXTDISP_CommandBufferPtr = MEMORY_AllocateMemory(
                    Global_STR_TEXTDISP_C_1,
                    1084,
                    732,
                    (MEMF_PUBLIC + MEMF_CLEAR)
                );
            }

            if (TEXTDISP_CommandBufferPtr != (void *)0) {
                TEXTDISP_SetEntryTextFields(TEXTDISP_CommandBufferPtr, (const UBYTE *)arg, (const UBYTE *)TEXTDISP_PrimarySearchText);

                if (TEXTDISP_FilterAndSelectEntry(TEXTDISP_CommandBufferPtr, 70) == 0) {
                    char *dst = (char *)TEXTDISP_CommandBufferPtr + 0xDC;
                    char *src = TEXTDISP_DefaultSpacePad;
                    while ((*dst++ = *src++) != 0) {
                    }
                }
            }
        }

        if (TEXTDISP_CommandBufferPtr != (void *)0) {
            TEXTDISP_DrawHighlightFrame(TEXTDISP_CommandBufferPtr);
            TEXTDISP_FilterAndSelectEntry(TEXTDISP_CommandBufferPtr, 88);
        }

        doCleanup = 0;
    }

    if (doFinalize != 0) {
        TEXTDISP_LastDispatchMatchIndex = -1;
        TEXTDISP_LastDispatchGroupId = 0x31;
    }

    if (doCleanup != 0) {
        TEXTDISP_FilterAndSelectEntry((void *)0, 0);
        if (TEXTDISP_CommandBufferPtr != (void *)0) {
            MEMORY_DeallocateMemory(Global_STR_TEXTDISP_C_2, 1106, TEXTDISP_CommandBufferPtr, 732);
            TEXTDISP_CommandBufferPtr = (void *)0;
        }
    }

    return 0;
}
