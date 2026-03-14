#include <exec/types.h>
extern LONG LOCAVAIL_PrimaryFilterState;
extern LONG SCRIPT_RuntimeModeDeferredFlag;
extern UWORD SCRIPT_RuntimeMode;
extern char CONFIG_MSN_FlagChar;
extern LONG SCRIPT_PlaybackCursor;
extern UWORD SCRIPT_RuntimeModeDispatchLatch;
extern UWORD TEXTDISP_CurrentMatchIndex;
extern UWORD TEXTDISP_CurrentMatchIndexSaved;

extern void LOCAVAIL_UpdateFilterStateMachine(char *ctx, void *state);
extern void SCRIPT_LoadCtrlContextSnapshot(char *ctx);
extern UWORD SCRIPT_UpdateRuntimeModeForPlaybackCursor(void);
extern void SCRIPT_ApplyPendingBannerTarget(void);
extern void SCRIPT_DispatchPlaybackCursorCommand(LONG *cursorPtr);
extern void SCRIPT_SaveCtrlContextSnapshot(char *ctx);

void SCRIPT_ProcessCtrlContextPlaybackTick(char *ctx)
{
    const LONG FLAG_FALSE = 0;
    const LONG MODE_DEFERRED = 3;
    const UBYTE MSN_MODE_CHAR = 'M';
    const LONG CURSOR_MIN_ACTIVE = 1;
    const LONG CURSOR_WINDOW_END = 10;
    const LONG CURSOR_REMAP_VALUE = 2;
    const LONG RUNTIME_MODE_LATCHED = 2;
    const LONG CURSOR_DISPATCH_MAX = 15;
    LOCAVAIL_UpdateFilterStateMachine(ctx, &LOCAVAIL_PrimaryFilterState);
    SCRIPT_LoadCtrlContextSnapshot(ctx);

    if (SCRIPT_RuntimeModeDeferredFlag != FLAG_FALSE) {
        SCRIPT_RuntimeMode = MODE_DEFERRED;
        SCRIPT_RuntimeModeDeferredFlag = FLAG_FALSE;
    }

    if (CONFIG_MSN_FlagChar == MSN_MODE_CHAR &&
        SCRIPT_PlaybackCursor > FLAG_FALSE &&
        SCRIPT_PlaybackCursor < CURSOR_WINDOW_END) {
        SCRIPT_PlaybackCursor = CURSOR_REMAP_VALUE;
    }

    if (!(SCRIPT_RuntimeMode == RUNTIME_MODE_LATCHED &&
          SCRIPT_RuntimeModeDispatchLatch != FLAG_FALSE &&
          SCRIPT_PlaybackCursor <= CURSOR_WINDOW_END)) {
        if (SCRIPT_PlaybackCursor > FLAG_FALSE && SCRIPT_PlaybackCursor <= CURSOR_DISPATCH_MAX) {
            if (SCRIPT_UpdateRuntimeModeForPlaybackCursor() == FLAG_FALSE) {
                if (SCRIPT_PlaybackCursor != CURSOR_MIN_ACTIVE) {
                    SCRIPT_ApplyPendingBannerTarget();
                }
                SCRIPT_DispatchPlaybackCursorCommand(&SCRIPT_PlaybackCursor);
            }
        }
    } else {
        SCRIPT_RuntimeModeDispatchLatch = FLAG_FALSE;
    }

    TEXTDISP_CurrentMatchIndexSaved = TEXTDISP_CurrentMatchIndex;
    SCRIPT_SaveCtrlContextSnapshot(ctx);
}
