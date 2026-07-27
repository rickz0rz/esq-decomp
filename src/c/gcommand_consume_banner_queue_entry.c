/* RESTORES: GCOMMAND_ConsumeBannerQueueEntry
 * MODULE:   modules/groups/a/u/gcommand3b.s
 * STATUS:   behavioural
 *
 * Takes the byte at the current banner-queue slot and acts on it: 0xFF arms the
 * attention countdown from the configured delay, 0xFE sets both read-mode flag
 * bytes at once, and anything else non-zero becomes the read-mode value directly.
 * The slot is then cleared and the attention countdown ticked; when it runs past
 * zero the deferred status apply is cancelled and a refresh is requested instead.
 *
 * The slot is cleared unconditionally, including when it was already empty -- the
 * empty case branches straight to the clear rather than returning, so the tick
 * runs on every call. That is what makes the countdown advance at all.
 *
 * 156 bytes in the original, 148 emitted, itemised in full by tools/casm.py.
 * Notably the original reaches both 255 and 254 by the documented four-byte short
 * forms -- MOVEQ #0 + NOT.B and MOVEQ #127 + ADD.L -- and 6.51 agrees on both, so
 * this function corroborates the constant rule rather than diverging from it.
 *
 * Three of the four divergences below are second or third sightings of classes
 * named earlier, which is the point of recording them.
 *
 * SASC-MISMATCH: index-through-address-register
 *   ref:     2248 d2c0 1211      MOVEA.L A0,A1 / ADDA.W D0,A1 / MOVE.B (A1),D1
 *   got:     10357000            MOVE.B (A5,D7.W),D0
 *   summary: The original materialises base+index in an address register at each
 *            of the four accesses instead of using the indexed addressing mode.
 *            Note it is not that the original cannot: it uses (A0,D0.L) elsewhere
 *            (esqfunc_free_extra_title_text_pointers.c,
 *            parseini_parse_color_table.c). What differs here is the WORD index --
 *            the original appears not to form (An,Dn.W). Declaring the index
 *            `long` does not help: 6.51 just adds EXT.L and keeps the indexed
 *            mode.
 *   scope:   any short-indexed array access. Grep for 2248/d2c0 pairs.
 *
 * SASC-MISMATCH: char-widen-move-width
 *   ref:     2401                MOVE.L D1,D2
 *   got:     3c00                MOVE.W D0,D6
 *   summary: Second sighting, after ladfunc_parse_hex_digit.c. The countdown is a
 *            short and only the low word is used, but the original copies the full
 *            register. Same size; the class is about width, not cost.
 *
 * SASC-MISMATCH: zero-store-via-register
 *   ref:     7000 1080  and  13c000002958   MOVEQ #0,D0 then MOVE.B D0,...
 *   got:     42357000   and  4239xxxxxxxx   CLR.B ...
 *   summary: Second and third sightings, after textdisp_set_entry_text_fields.c.
 *            The second one is also register-zero-reuse: the zero D0 is still
 *            holding from the slot clear is reused for the flag store much later,
 *            across two branches -- the same shape ctasks_ifftaskcleanup.c records
 *            as unreachable from C.
 *
 * SASC-MISMATCH: register-pressure
 *   ref:     2f02 ... 241f       D2 saved and restored
 *   got:     48e70304 ... 4cdf20c0   D6-D7/A5
 *   summary: Holding the base pointer and index in registers costs two more saves,
 *            +2 in the prologue and +2 in the epilogue. Directly downstream of the
 *            addressing-mode difference above.
 */

extern unsigned char ESQPARS2_BannerQueueBuffer[];
extern short GCOMMAND_BannerQueueSlotCurrent;
extern short ESQPARS2_BannerQueueAttentionDelayTicks;
extern short ESQPARS2_BannerQueueAttentionCountdown;
extern short ESQPARS2_ReadModeFlags;
extern char  ESQDISP_StatusIndicatorDeferredApplyFlag;
extern char  ESQDISP_StatusRefreshPendingFlag;
extern char  GCOMMAND_HighlightHoldoffTickCount;

void GCOMMAND_ConsumeBannerQueueEntry(void)
{
    unsigned char *q;
    short i;
    short left;

    q = ESQPARS2_BannerQueueBuffer;
    i = GCOMMAND_BannerQueueSlotCurrent;

    if (q[i]) {
        if (q[i] == 255) {
            ESQPARS2_BannerQueueAttentionCountdown =
                ESQPARS2_BannerQueueAttentionDelayTicks - 1;
            ESQDISP_StatusIndicatorDeferredApplyFlag = 1;
        } else if (q[i] == 254) {
            ESQPARS2_ReadModeFlags = 0x101;
        } else {
            ESQPARS2_ReadModeFlags = q[i];
        }
    }

    q[i] = 0;

    if (ESQPARS2_BannerQueueAttentionCountdown >= 0) {
        left = ESQPARS2_BannerQueueAttentionCountdown - 1;
        ESQPARS2_BannerQueueAttentionCountdown = left;
        GCOMMAND_HighlightHoldoffTickCount = 2;
        if (left < 0) {
            ESQDISP_StatusIndicatorDeferredApplyFlag = 0;
            ESQDISP_StatusRefreshPendingFlag = 1;
        }
    }
}
