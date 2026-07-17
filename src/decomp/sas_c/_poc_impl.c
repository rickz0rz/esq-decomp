#include <exec/types.h>

/* POC copy of the restored string_to_upper_char.c, forced to __stdargs so the
   C-side callee reads its arg from the stack exactly like the original ASM.
   Body is byte-identical logic to the canonical restoration. */
ULONG __stdargs STRING_ToUpperChar(ULONG c)
{
    UBYTE ch = (UBYTE)c;

    if (ch >= 'a' && ch <= 'z') {
        ch = (UBYTE)(ch - 0x20);
    }

    return (ULONG)ch;
}
