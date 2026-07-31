/* RESTORES: GCOMMAND_RefreshBannerTables
 * MODULE:   modules/groups/a/u/gcommand3b_p3.s
 * STATUS:   behavioural
 *
 * Rebuilds both banner copper rows from the 696x400 bitmap and repoints the
 * three plane snapshot pointers.
 *
 * The two row builds differ only in the copper list and in the byte offset:
 * the second is 88 bytes further on. The original computes that as
 * MOVEQ #88,D0 / ADD.L offset,D0 -- the constant first -- and reuses the
 * argument slot rather than re-pushing the other four.
 *
 * The three snapshot pointers all take the PREVIOUS row offset, not the current
 * one. That is the whole point of keeping two offsets, and reading the wrong
 * global here would snapshot the row that is being rebuilt.
 *
 * The three scratch raster tables are POINTERS (MOVEA.L loads their contents),
 * so the destination is table + offset rather than &table[offset].
 *
 * 122 ref vs 128 got. Both PEA 98 spans, both copper-list addresses, both
 * bitmap addresses, the MOVEQ #88 / ADD.L offset pair, the argument-slot reuse
 * (2e80) and the LEA 36(A7),A7 cleanup all match exactly, as do all three
 * ADDA.L / MOVE.L snapshot stores.
 *
 * SASC-MISMATCH: scratch-register-vs-saved-register
 *   ref:     20390000b2f2 ... d1c0 (x3)
 *            the previous offset loaded into D0, a scratch register
 *   got:     2f07 ... 2e3900000000 ... d1c7 (x3) ... 2e1f
 *            loaded into D7, which then has to be saved and restored
 *   summary: the original holds the shared offset in D0, which needs no
 *            save; 6.51 allocates the same local to D7 and pays 4 bytes for
 *            the MOVE.L D7,-(A7) / MOVE.L (A7)+,D7 pair, plus 2 of padding.
 *   tried:   using the global directly at all three sites instead of a local,
 *            measured at 132 bytes against the local form's 128. It is worse on
 *            size but interestingly CLOSER on register choice: 6.51 then uses
 *            D0 (d1c0) exactly as the original does, and needs no save. What it
 *            loses is the sharing -- it re-reads the global twice and reaches
 *            the third table with d1f9 instead of a plain ADDA.L. Neither form
 *            is the original's, which shares one D0 load across all three. The
 *            local form is kept because it is 4 bytes smaller and because
 *            sharing the load is the structure the original has.
 *   scope:   program-wide register allocation. docs/compiler-version.md,
 *            "A third divergence: register allocation order".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void GCOMMAND_BuildBannerRow(void *bitmap, char *list, long phase,
                                    long span, long offset);

extern char *ESQ_CopperListBannerA;
extern char *ESQ_CopperListBannerB;
extern char  Global_REF_696_400_BITMAP[];
extern long  GCOMMAND_BannerRowByteOffsetCurrent;
extern long  GCOMMAND_BannerRowByteOffsetPrevious;
extern long  GCOMMAND_BannerPhaseIndexCurrent;
extern char *WDISP_BannerRowScratchRasterTable0;
extern char *WDISP_BannerRowScratchRasterTable1;
extern char *WDISP_BannerRowScratchRasterTable2;
extern char *ESQPARS2_BannerSnapshotPlane0DstPtr;
extern char *ESQPARS2_BannerSnapshotPlane1DstPtr;
extern char *ESQPARS2_BannerSnapshotPlane2DstPtr;

void GCOMMAND_RefreshBannerTables(void)
{
    long prev;

    GCOMMAND_BuildBannerRow(Global_REF_696_400_BITMAP,
                            (char *)&ESQ_CopperListBannerA,
                            GCOMMAND_BannerPhaseIndexCurrent, 98L,
                            GCOMMAND_BannerRowByteOffsetCurrent);

    GCOMMAND_BuildBannerRow(Global_REF_696_400_BITMAP,
                            (char *)&ESQ_CopperListBannerB,
                            GCOMMAND_BannerPhaseIndexCurrent, 98L,
                            88 + GCOMMAND_BannerRowByteOffsetCurrent);

    prev = GCOMMAND_BannerRowByteOffsetPrevious;

    ESQPARS2_BannerSnapshotPlane0DstPtr = WDISP_BannerRowScratchRasterTable0 + prev;
    ESQPARS2_BannerSnapshotPlane1DstPtr = WDISP_BannerRowScratchRasterTable1 + prev;
    ESQPARS2_BannerSnapshotPlane2DstPtr = WDISP_BannerRowScratchRasterTable2 + prev;
}
