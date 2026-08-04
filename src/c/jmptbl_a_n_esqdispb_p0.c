/* RESTORES: ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages,
 *           ESQDISP_JMPTBL_GRAPHICS_AllocRaster
 * MODULE:   modules/groups/a/n/esqdispb_p0.s   (2 of its 3 labels)
 * STATUS:   behavioural
 *
 * The two jump-table thunks that share a module with
 * ESQDISP_FillProgramInfoHeaderFields. Both had to be restored before that
 * function's own restoration could be linked, because a C file replaces a
 * whole module.
 *
 * GRAPHICS_AllocRaster IS NOT THE TWO-ARGUMENT FUNCTION ITS NAME SUGGESTS, and
 * AGENTS.md calls this out by name. It reads its width and height from 16(A5)
 * and 20(A5), not 8(A5) and 12(A5) -- the first two slots are the caller's file
 * and line, which every allocator in this program takes for its leak log. A
 * thunk written from the name would pass the wrong slots and no byte check
 * could see it. The declaration below is copied from
 * brush_load_brush_asset.c, which calls the real thing.
 *
 * SASC-MISMATCH: tail-jump
 *   ref:     JMP target
 *   got:     a call and a return, +2 bytes and one extra frame
 *   summary: the same divergence every converted jump table carries.
 *   scope:   all converted tables.
 *   retest:  needs a compiler that can emit a tail jump; SAS/C 6.51 cannot.
 */
extern void  NEWGRID_ProcessGridMessages(void);
extern void *GRAPHICS_AllocRaster(char *who, long line, long width, long height);

void ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages(void)
{
    NEWGRID_ProcessGridMessages();
}

void *ESQDISP_JMPTBL_GRAPHICS_AllocRaster(char *who, long line,
                                          long width, long height)
{
    return GRAPHICS_AllocRaster(who, line, width, height);
}
