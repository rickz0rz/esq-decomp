typedef signed long LONG;
typedef unsigned char UBYTE;

extern void P_TYPE_FreeEntry(UBYTE *entry);
extern UBYTE *P_TYPE_AllocateEntry(UBYTE typeByte, LONG length, UBYTE *dataPtr);

UBYTE *P_TYPE_CloneEntry(UBYTE *dstEntry, UBYTE *srcEntry)
{
    UBYTE scratch[104];
    UBYTE *result;
    LONG i;
    LONG len;

    P_TYPE_FreeEntry(dstEntry);
    result = (UBYTE *)0;

    if (srcEntry != (UBYTE *)0) {
        i = 0;
        len = *(LONG *)(srcEntry + 2);
        while (i < len) {
            scratch[i] = (*(UBYTE **)(srcEntry + 6))[i];
            i += 1;
        }
        scratch[i] = 0;
        result = P_TYPE_AllocateEntry(srcEntry[0], len, scratch);
    }

    return result;
}
