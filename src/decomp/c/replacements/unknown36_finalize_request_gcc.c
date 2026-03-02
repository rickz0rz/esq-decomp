#include "esq_types.h"

/*
 * Target 595 GCC trial function.
 * Finalize a request record, optionally flush/cleanup, then close handler.
 */

typedef struct Unknown36Request {
    u32 unk00;
    u32 unk04;
    u32 unk08;
    u32 unk0c;
    s32 arg16;
    void *arg20;
    u32 flags;
    s32 handler;
} Unknown36Request;

s32 STREAM_BufferedPutcOrFlush(s32 ch, void *node) __attribute__((noinline));
s32 ALLOC_InsertFreeBlock(void *block, s32 size) __attribute__((noinline));
s32 HANDLE_CloseByIndex(s32 handle_index) __attribute__((noinline));

s32 UNKNOWN36_FinalizeRequest(Unknown36Request *req) __attribute__((noinline, used));

s32 UNKNOWN36_FinalizeRequest(Unknown36Request *req)
{
    s32 abort_result;
    s32 close_result;

    if ((((u8)req->flags) & 2u) != 0u) {
        abort_result = STREAM_BufferedPutcOrFlush(-1, req);
    } else {
        abort_result = 0;
    }

    if ((req->flags & 12u) == 0u && req->arg20 != 0) {
        (void)ALLOC_InsertFreeBlock(req->arg20, req->arg16);
    }

    req->flags = 0;
    close_result = HANDLE_CloseByIndex(req->handler);

    if (abort_result == -1 || close_result != 0) {
        return -1;
    }

    return 0;
}
