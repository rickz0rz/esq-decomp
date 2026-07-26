/* RESTORES: _P_TYPE_PromoteSecondaryList
 * MODULE:   modules/groups/b/a/p_typeb.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 *
 * Was recorded as `behavioural` with a argument-push-order divergence. That was an
 * artifact of the reference, not the compiler: refbytes.py dropped bytes
 * emitted on macro-expansion and continuation lines, so this function was
 * being diffed against a truncated original. With the oracle fixed it
 * matches exactly and the recorded divergence is deleted as false.
 */
extern void *P_TYPE_PrimaryGroupListPtr;
extern void *P_TYPE_SecondaryGroupListPtr;
extern void  P_TYPE_FreeEntry(void *e);
void P_TYPE_PromoteSecondaryList(void)
{
    P_TYPE_FreeEntry(P_TYPE_PrimaryGroupListPtr);
    P_TYPE_PrimaryGroupListPtr = P_TYPE_SecondaryGroupListPtr;
    P_TYPE_SecondaryGroupListPtr = 0;
}
