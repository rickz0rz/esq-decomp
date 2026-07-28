/* RESTORES: _ESQDISP_GetEntryAuxPointerByMode
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_esqdisp_getentryauxpointerbymode.s
 * STATUS:   behavioural
 *
 * The sibling of esqdisp_get_entry_pointer_by_mode.c: the same function against
 * the TITLE tables rather than the entry tables. Identical control flow,
 * identical bounds checks, identical 112-byte reference. Restoring the pair
 * together is what establishes that the shape is the original's idiom for
 * "index a per-mode table" rather than a one-off.
 *
 * SIZE NOTE: tools/coverage.py reported this function as 228 bytes. It is 112.
 * The extra 116 were two `; Unreferenced Code` blocks that follow it with no
 * label of their own, so the label-to-label extraction ran straight through
 * them. Splitting the module fixed the extraction, because refbytes.py also
 * stops at a source-file change. All four such blocks in the program were in
 * this one module, so nothing else was mismeasured this way.
 *
 * SASC-MISMATCH: a5-frame-pointer
 *   ref:     4e55fffc ... 42adfffc ... 2b50fffc ... 202dfffc 4e5d
 *   got:     48e70304 ... 9bcd     ... 2a50     ... 200d
 *   summary: the original builds a frame (LINK.W A5,#-4) and holds the result
 *            in the stack slot -4(A5); 6.51 needs no frame, so it frees A5 and
 *            allocates the result to it. Same 16-byte delta and same single
 *            cause as the sibling; the full accounting is in that file.
 *   tried:   see esqdisp_get_entry_pointer_by_mode.c.
 *   scope:   whole-program -- 364 LINK.W A5 sites in the original against 0
 *            MOVEM masks containing A5.
 *   retest:  a compiler that reserves A5 as the frame pointer.
 */

extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned short TEXTDISP_SecondaryGroupEntryCount;
extern void *TEXTDISP_PrimaryTitlePtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];

void *ESQDISP_GetEntryAuxPointerByMode(long index, long mode)
{
    void *title = 0;

    if (mode == 1) {
        if (index >= 0 && index < TEXTDISP_PrimaryGroupEntryCount)
            title = TEXTDISP_PrimaryTitlePtrTable[index];
    } else if (mode == 2) {
        if (index >= 0 && index < TEXTDISP_SecondaryGroupEntryCount)
            title = TEXTDISP_SecondaryTitlePtrTable[index];
    }

    return title;
}
