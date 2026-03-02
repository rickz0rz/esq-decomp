#include "esq_types.h"

extern s32 LOCAVAIL_PrimaryFilterState;
extern s32 SCRIPT_RuntimeModeDeferredFlag;
extern s16 SCRIPT_RuntimeMode;
extern u8 CONFIG_MSN_FlagChar;
extern s32 SCRIPT_PlaybackCursor;
extern s16 SCRIPT_RuntimeModeDispatchLatch;
extern s16 TEXTDISP_CurrentMatchIndex;
extern s16 TEXTDISP_CurrentMatchIndexSaved;

void SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine(u8 *ctx, s32 *filter_state) __attribute__((noinline));
void SCRIPT_LoadCtrlContextSnapshot(u8 *ctx) __attribute__((noinline));
s32 SCRIPT_UpdateRuntimeModeForPlaybackCursor(void) __attribute__((noinline));
void SCRIPT_ApplyPendingBannerTarget(void) __attribute__((noinline));
void SCRIPT_DispatchPlaybackCursorCommand(s32 *cursor_ptr) __attribute__((noinline));
void SCRIPT_SaveCtrlContextSnapshot(u8 *ctx) __attribute__((noinline));

void SCRIPT_ProcessCtrlContextPlaybackTick(u8 *ctx) __attribute__((noinline, used));

void SCRIPT_ProcessCtrlContextPlaybackTick(u8 *ctx)
{
    SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine(ctx, &LOCAVAIL_PrimaryFilterState);
    SCRIPT_LoadCtrlContextSnapshot(ctx);

    if (SCRIPT_RuntimeModeDeferredFlag != 0) {
        SCRIPT_RuntimeMode = 3;
        SCRIPT_RuntimeModeDeferredFlag = 0;
    }

    if (CONFIG_MSN_FlagChar == 'M') {
        if (SCRIPT_PlaybackCursor > 0 && SCRIPT_PlaybackCursor < 10) {
            SCRIPT_PlaybackCursor = 2;
        }
    }

    if (SCRIPT_RuntimeMode == 2) {
        if (SCRIPT_RuntimeModeDispatchLatch != 0) {
            if (SCRIPT_PlaybackCursor > 10) {
                SCRIPT_RuntimeModeDispatchLatch = 0;
            }
        }
    }

    if (SCRIPT_PlaybackCursor > 0 && SCRIPT_PlaybackCursor <= 15) {
        if (SCRIPT_UpdateRuntimeModeForPlaybackCursor() == 0) {
            if (SCRIPT_PlaybackCursor != 1) {
                SCRIPT_ApplyPendingBannerTarget();
            }
            SCRIPT_DispatchPlaybackCursorCommand(&SCRIPT_PlaybackCursor);
        }
    }

    TEXTDISP_CurrentMatchIndexSaved = TEXTDISP_CurrentMatchIndex;
    SCRIPT_SaveCtrlContextSnapshot(ctx);
}
