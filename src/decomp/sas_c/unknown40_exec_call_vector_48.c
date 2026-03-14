#include <exec/types.h>
extern void *INPUTDEVICE_LibraryBaseFromConsoleIo;
#pragma libcall INPUTDEVICE_LibraryBaseFromConsoleIo execPrivate3 30 A19804
extern LONG execPrivate3(void *a0, void *a1, LONG d1, void *a2);

LONG EXEC_CallVector_48(void *a0, void *a1, LONG d1, void *a2)
{
    return execPrivate3(a0, a1, d1, a2);
}
