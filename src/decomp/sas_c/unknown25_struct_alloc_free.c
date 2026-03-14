#include <exec/types.h>
typedef struct StructWithOwner {
    char pad0[8];
    signed char field8;
    signed char field9;
    char pad10[4];
    void *owner;
    unsigned short sizeWord;
    char pad20[6];
} StructWithOwner;

extern void *AbsExecBase;
extern void *_LVOAllocMem(void *execBase, ULONG size, ULONG flags);
extern void _LVOFreeMem(void *execBase, void *memory, ULONG size);

void STRUCT_FreeWithSizeField(StructWithOwner *s)
{
    s->field8 = (signed char)-1;
    s->owner = (void *)(unsigned long)0xFFFFFFFFUL;
    *(void **)((char *)s + 24) = (void *)(unsigned long)0xFFFFFFFFUL;
    _LVOFreeMem(AbsExecBase, s, (ULONG)s->sizeWord);
}

StructWithOwner *STRUCT_AllocWithOwner(void *owner, ULONG size)
{
    StructWithOwner *s;

    if (!owner) {
        return (StructWithOwner *)0;
    }

    s = (StructWithOwner *)_LVOAllocMem(AbsExecBase, size, 0x10001UL);
    if (s) {
        s->field8 = 5;
        s->field9 = 0;
        s->owner = owner;
        s->sizeWord = (unsigned short)size;
    }

    return s;
}
