#include <exec/types.h>
typedef struct HandleEntry {
    void *ptr;
    LONG flags;
} HandleEntry;

extern LONG Global_HandleTableCount;
extern HandleEntry Global_HandleTableBase[];

extern LONG DOS_CloseWithSignalCheck(void *handle);
extern LONG ESQ_ReturnWithStackCode(LONG code);

LONG HANDLE_CloseAllAndReturnWithCode(LONG code)
{
    LONG i;

    for (i = Global_HandleTableCount - 1; i >= 0; --i) {
        LONG flags = Global_HandleTableBase[i].flags;
        if ((flags & 0xFF) != 0 && (flags & (1L << 4)) == 0) {
            DOS_CloseWithSignalCheck(Global_HandleTableBase[i].ptr);
        }
    }

    return ESQ_ReturnWithStackCode(code);
}
