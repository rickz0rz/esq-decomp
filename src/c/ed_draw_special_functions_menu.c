/* RESTORES: ED_DrawSpecialFunctionsMenu
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * 150 bytes in the original, 148 emitted, only FOUR differing regions.
 *
 * The four menu lines drawn by ED_HandleSpecialFunctionsMenu, which is already
 * restored in this directory -- so the menu and its handler are now both C.
 *
 * Reproduces: the pen and draw-mode setup, all four DisplayTextAtPosition calls
 * at y = 90/120/150/180 with the single deferred LEA 64(A7),A7 covering all of
 * them, and the draw-mode restored to 1 at the end.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     2279xxxxxxxx 7001          rastport loaded, pen set, then GfxBase
 *   got:     2f0e 2279xxxxxxxx 7001     A6 saved first, then the same sequence
 *   summary: SAS/C brackets the body with a MOVE.L A6,-(A7) / restore pair and
 *            hoists the base load; the original treats A6 as scratch. That plus
 *            the call encoding is the entire difference -- there is nothing else
 *            wrong with this function.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit text calls, all of which
 *            were cross-unit in the original.
 */
#include <proto/graphics.h>

extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern struct RastPort *Global_REF_RASTPORT_1;
extern char Global_STR_SAVE_ALL_TO_DISK[];
extern char Global_STR_SAVE_DATA_TO_DISK[];
extern char Global_STR_LOAD_TEXT_ADS_FROM_DISK[];
extern char Global_STR_REBOOT_COMPUTER[];

void ED_DrawSpecialFunctionsMenu(void)
{
    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetDrMd(Global_REF_RASTPORT_1, 0L);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90,
                                  Global_STR_SAVE_ALL_TO_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 120,
                                  Global_STR_SAVE_DATA_TO_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 150,
                                  Global_STR_LOAD_TEXT_ADS_FROM_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 180,
                                  Global_STR_REBOOT_COMPUTER);

    SetDrMd(Global_REF_RASTPORT_1, 1L);
}
