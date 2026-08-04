/* RESTORES: GCOMMAND_LoadMplexTemplate
 * MODULE:   modules/groups/a/u/gcommand2.s
 * STATUS:   behavioural
 *
 * 252 bytes in the original, 228 emitted, 7 differing regions. Smaller because
 * the original spills three pointers to the frame that SAS/C keeps in registers.
 *
 * Reproduces: the load-and-test where the result is incremented before the zero
 * test (so -1 means failure), the 52-byte CopyMem into the flag block and the
 * matching advance of the work-buffer pointer, the split of the template on
 * character 18 with the separator overwritten by a NUL and the tail pointer
 * advanced past it, both ReplaceOwnedString calls in order, the deallocation
 * using the saved base and length+1, and the case-folded substring search whose
 * hit has its second byte rewritten to 's'.
 *
 * QUIRK: every exit returns 1, including the load-failure path -- the failure
 * branch targets the same MOVEQ #1,D0 as the success path. The caller evidently
 * ignores the value. Written faithfully rather than "fixed".
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff0                   LINK.W A5,#-16
 *   got:     48e70136                   MOVEM only, no frame at all
 *   summary: The A5-frame class. With only three pointer locals SAS/C needs no
 *            frame, which is the whole -24.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the six cross-unit calls.
 */
#include "esq-exec.h"

extern long  DISKIO_LoadFileToWorkBuffer(char *path);
extern char *STR_FindCharPtr(char *s, long ch);
extern char *ESQPARS_ReplaceOwnedString(char *newstr, char *old);
extern void  MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern char *ESQ_FindSubstringCaseFold(char *hay, char *needle);

extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern char  GCOMMAND_DigitalMplexEnabledFlag;
extern char *GCOMMAND_MplexListingsTemplatePtr;
extern char *GCOMMAND_MplexAtTemplatePtr;
extern char  GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad[];
extern char  GCOMMAND_FMT_PCT_T_MplexTemplateLoad[];
extern char  Global_STR_GCOMMAND_C_2[];

long GCOMMAND_LoadMplexTemplate(void)
{
    char *base;
    char *sep;
    char *found;
    register long savedLen;

    if (DISKIO_LoadFileToWorkBuffer(
            GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad) + 1 == 0)
        return 1;

    base = Global_PTR_WORK_BUFFER;
    savedLen = Global_REF_LONG_FILE_SCRATCH;
    CopyMem(Global_PTR_WORK_BUFFER, &GCOMMAND_DigitalMplexEnabledFlag, 52L);
    Global_PTR_WORK_BUFFER += 52;

    GCOMMAND_MplexListingsTemplatePtr = 0;
    GCOMMAND_MplexAtTemplatePtr = 0;

    sep = STR_FindCharPtr(Global_PTR_WORK_BUFFER, 18);
    if (sep && *sep) {
        *sep++ = 0;
    }

    GCOMMAND_MplexAtTemplatePtr =
        ESQPARS_ReplaceOwnedString(Global_PTR_WORK_BUFFER, GCOMMAND_MplexAtTemplatePtr);
    GCOMMAND_MplexListingsTemplatePtr =
        ESQPARS_ReplaceOwnedString(sep, GCOMMAND_MplexListingsTemplatePtr);

    MEMORY_DeallocateMemory(Global_STR_GCOMMAND_C_2, 575, base,
                                           savedLen + 1);

    found = 0;
    if (GCOMMAND_MplexAtTemplatePtr && *GCOMMAND_MplexAtTemplatePtr)
        found = ESQ_FindSubstringCaseFold(GCOMMAND_MplexAtTemplatePtr,
                                                          GCOMMAND_FMT_PCT_T_MplexTemplateLoad);
    if (found && *found)
        found[1] = 's';

    return 1;
}
