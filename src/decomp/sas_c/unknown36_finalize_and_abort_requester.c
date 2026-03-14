#include <exec/types.h>
enum {
    PROCESS_TASK_CLI_PTR_OFFSET = 172,
    PROCESS_TASK_CONSOLE_FH_OFFSET = 160,
    CLI_STDOUT_FH_OFFSET = 56,
    ABORT_MSG_MAX_LEN = 79
};

typedef struct Unknown36Request {
    ULONG unk00;
    ULONG unk04;
    ULONG unk08;
    ULONG unk0c;
    LONG arg16;
    void *arg20;
    ULONG flags;
    LONG handler;
} Unknown36Request;

extern ULONG AbsExecBase;
extern ULONG Global_DosLibrary;
extern const char *Global_UNKNOWN36_MessagePtr;
extern UBYTE *Global_UNKNOWN36_RequesterOutPtr;
extern const char Global_UNKNOWN36_RequesterText0[];
extern const char Global_UNKNOWN36_RequesterText1[];
extern const char Global_UNKNOWN36_RequesterText2[];

extern LONG STREAM_BufferedPutcOrFlush(LONG ch, void *node);
extern LONG ALLOC_InsertFreeBlock(void *block, LONG size);
extern LONG HANDLE_CloseByIndex(LONG handleIndex);

extern void *_LVOFindTask(void *execBase, void *name);
extern LONG _LVOWrite(void *dosBase, LONG fh, const void *buf, LONG len);
extern void *_LVOOpenLibrary(void *execBase, const char *name, ULONG ver);
extern LONG EXEC_CallVector_348(void *libBase, void *a0, void *a1, void *a2, void *a3, LONG d0, LONG d1, LONG d2, LONG d3);

LONG UNKNOWN36_FinalizeRequest(Unknown36Request *req)
{
    LONG abortResult;
    LONG closeResult;

    if ((((UBYTE)req->flags) & 2U) != 0U) {
        abortResult = STREAM_BufferedPutcOrFlush(-1, req);
    } else {
        abortResult = 0;
    }

    if ((req->flags & 12U) == 0U && req->arg20 != 0) {
        (void)ALLOC_InsertFreeBlock(req->arg20, req->arg16);
    }

    req->flags = 0;
    closeResult = HANDLE_CloseByIndex(req->handler);

    if (abortResult == -1 || closeResult != 0) {
        return -1;
    }

    return 0;
}

LONG UNKNOWN36_ShowAbortRequester(void)
{
    static const char kBreakPrefix[] = "*** Break: ";
    static const char kIntuitionLib[] = "intuition.library";

    UBYTE local[82];
    const char *msg = Global_UNKNOWN36_MessagePtr;
    LONG len = (UBYTE)msg[-1];
    LONG i;
    UBYTE *task;
    LONG fh = 0;

    if (len > ABORT_MSG_MAX_LEN) {
        len = ABORT_MSG_MAX_LEN;
    }

    for (i = 0; i < len; ++i) {
        local[i] = msg[i];
    }
    local[len] = 0;

    task = (UBYTE *)_LVOFindTask((void *)AbsExecBase, (void *)0);
    if (*(ULONG *)(task + PROCESS_TASK_CLI_PTR_OFFSET) != 0) {
        UBYTE *cli = (UBYTE *)((*(ULONG *)(task + PROCESS_TASK_CLI_PTR_OFFSET)) << 2);
        fh = *(LONG *)(cli + CLI_STDOUT_FH_OFFSET);
    }
    if (fh == 0) {
        fh = *(LONG *)(task + PROCESS_TASK_CONSOLE_FH_OFFSET);
    }

    if (fh != 0) {
        (void)_LVOWrite((void *)Global_DosLibrary, fh, kBreakPrefix, 11);
        local[len] = (UBYTE)'\n';
        (void)_LVOWrite((void *)Global_DosLibrary, fh, local, len + 1);
        return -1;
    }

    {
        void *intuition = _LVOOpenLibrary((void *)AbsExecBase, kIntuitionLib, 0U);
        LONG rc;

        if (intuition == 0) {
            return -1;
        }

        Global_UNKNOWN36_RequesterOutPtr = local;
        rc = EXEC_CallVector_348(
            intuition,
            0,
            (void *)Global_UNKNOWN36_RequesterText0,
            (void *)Global_UNKNOWN36_RequesterText1,
            (void *)Global_UNKNOWN36_RequesterText2,
            0,
            0,
            250,
            60
        );

        if (rc == 1) {
            return 0;
        }

        return -1;
    }
}
