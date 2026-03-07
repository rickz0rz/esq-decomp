typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef signed long LONG;

#define MEMF_PUBLIC 1
#define ESQPARS_FREE_LINE 1081
#define ESQPARS_ALLOC_LINE 1100
#define AVAILMEM_PUBLIC_REQUIREMENT 1
#define AVAILMEM_MIN_FREE_THRESHOLD 0x2710UL
#define STR_TERM_BYTES 1

extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG line, void *ptr, ULONG size);
extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const char *tag, LONG line, ULONG flags, ULONG size);
extern ULONG AvailMem(ULONG requirements);

extern const char Global_STR_ESQPARS_C_5[];
extern const char Global_STR_ESQPARS_C_6[];

void *ESQPARS_ReplaceOwnedString(char *new_src, char *old_owned)
{
    ULONG old_len = 0;
    ULONG new_len = 0;
    char *dst = old_owned;

    if (old_owned != (char *)0) {
        while (old_owned[old_len] != 0) {
            old_len++;
        }
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_ESQPARS_C_5,
            ESQPARS_FREE_LINE,
            old_owned,
            old_len + STR_TERM_BYTES);
    }

    if (new_src == (char *)0) {
        return (void *)0;
    }

    while (new_src[new_len] != 0) {
        new_len++;
    }
    new_len++;

    if (new_len == 1) {
        return (void *)0;
    }

    dst = (char *)0;
    if (AvailMem(AVAILMEM_PUBLIC_REQUIREMENT) > AVAILMEM_MIN_FREE_THRESHOLD) {
        dst = (char *)ESQIFF_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_ESQPARS_C_6,
            ESQPARS_ALLOC_LINE,
            MEMF_PUBLIC,
            new_len);
    }

    if (dst != (char *)0) {
        ULONG i = 0;
        do {
            dst[i] = new_src[i];
        } while (new_src[i++] != 0);
    }

    return (void *)dst;
}
