typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG LOCAVAIL_PrimaryFilterState;
extern LONG SCRIPT_RuntimeModeDeferredFlag;
extern UWORD SCRIPT_RuntimeMode;
extern UBYTE CONFIG_MSN_FlagChar;
extern LONG SCRIPT_PlaybackCursor;
extern UWORD SCRIPT_RuntimeModeDispatchLatch;
extern UWORD TEXTDISP_CurrentMatchIndex;
extern UWORD TEXTDISP_CurrentMatchIndexSaved;

extern void SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine(void *ctx, void *state);
extern void SCRIPT_LoadCtrlContextSnapshot(void *ctx);
extern UWORD SCRIPT_UpdateRuntimeModeForPlaybackCursor(void);
extern void SCRIPT_ApplyPendingBannerTarget(void);
extern void SCRIPT_DispatchPlaybackCursorCommand(LONG *cursorPtr);
extern void SCRIPT_SaveCtrlContextSnapshot(void *ctx);

void SCRIPT_ProcessCtrlContextPlaybackTick(void *ctx)
{
    SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine(ctx, &LOCAVAIL_PrimaryFilterState);
    SCRIPT_LoadCtrlContextSnapshot(ctx);

    if (SCRIPT_RuntimeModeDeferredFlag != 0) {
        SCRIPT_RuntimeMode = 3;
        SCRIPT_RuntimeModeDeferredFlag = 0;
    }

    if (CONFIG_MSN_FlagChar == 'M' && SCRIPT_PlaybackCursor > 0 && SCRIPT_PlaybackCursor < 10) {
        SCRIPT_PlaybackCursor = 2;
    }

    if (!(SCRIPT_RuntimeMode == 2 && SCRIPT_RuntimeModeDispatchLatch != 0 && SCRIPT_PlaybackCursor <= 10)) {
        if (SCRIPT_PlaybackCursor > 0 && SCRIPT_PlaybackCursor <= 15) {
            if (SCRIPT_UpdateRuntimeModeForPlaybackCursor() == 0) {
                if (SCRIPT_PlaybackCursor != 1) {
                    SCRIPT_ApplyPendingBannerTarget();
                }
                SCRIPT_DispatchPlaybackCursorCommand(&SCRIPT_PlaybackCursor);
            }
        }
    } else {
        SCRIPT_RuntimeModeDispatchLatch = 0;
    }

    TEXTDISP_CurrentMatchIndexSaved = TEXTDISP_CurrentMatchIndex;
    SCRIPT_SaveCtrlContextSnapshot(ctx);
}
