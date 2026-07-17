#include <stdio.h>
#include <exec/types.h>

/* Same driver links against EITHER the restored C or the original ASM,
   so identical inputs -> comparable outputs. Vectors deliberately include
   nonzero high bytes to probe whether the impl preserves them. */
/* __stdargs = stack-based parameter passing, matching the original ASM's
   4(A7) read (SAS/C otherwise passes this arg in a register). */
extern ULONG __stdargs STRING_ToUpperChar(ULONG c);

int main(void)
{
    ULONG tv[12];
    int i;

    tv[0]  = 0x00000061UL;  /* 'a' low byte only            */
    tv[1]  = 0x0000007aUL;  /* 'z'                          */
    tv[2]  = 0x00000041UL;  /* 'A' (already upper)          */
    tv[3]  = 0x00000040UL;  /* '@' below 'a'                */
    tv[4]  = 0x00000080UL;  /* high-bit byte                */
    tv[5]  = 0x000000e9UL;  /* latin-1 'e-acute'            */
    tv[6]  = 0xffffffffUL;  /* all ones                     */
    tv[7]  = 0x11223361UL;  /* 'a' in low byte + high bytes */
    tv[8]  = 0xdeadbe61UL;  /* 'a' + garbage high bytes     */
    tv[9]  = 0x0000ff7aUL;  /* 'z' + byte 2 set             */
    tv[10] = 0x41424361UL;  /* 'a' + "ABC" high bytes       */
    tv[11] = 0x00000000UL;  /* zero                         */

    for (i = 0; i < 12; i++)
        printf("in=%08lx out=%08lx\n", tv[i], STRING_ToUpperChar(tv[i]));

    return 0;
}
