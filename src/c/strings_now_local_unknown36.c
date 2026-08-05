/* RESTORES: (nothing -- see strings_now_local_main_a.c for the pattern)
 * MODULE:   modules/submodules/unknown36_p0_strings_local.s
 * STATUS:   behavioural
 *
 * DELIBERATELY EMPTY. The module holds `UNKNOWN36_STR_BreakPrefix` and
 * `UNKNOWN36_STR_IntuitionLibrary`, two CODE-section strings whose only reader
 * is UNKNOWN36_ShowAbortRequester. That function now builds both into stack
 * locals, so neither symbol has a reader and the module has nothing to
 * contribute to the maximum-C build.
 *
 * ITS THREE FORMER NEIGHBOURS CANNOT MOVE THIS WAY, and that is why the module
 * was split in two. `data_wdisp_p1.c` builds DEBUG_AbortRequesterTagChain
 * holding (char *)DEBUG_STR_UserAbortRequested, (char *)DEBUG_STR_Continue and
 * (char *)DEBUG_STR_Abort. A data table holding a string's ADDRESS is the case
 * this pattern does not cover: a stack local has no address the linker can
 * write into a table, and a C definition would be an initialised static in
 * `data`. Those three stay in unknown36_p0_strings.s and are the floor.
 */
