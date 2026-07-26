/* RESTORES: _P_TYPE_ResetListsAndLoadPromoIds
 * MODULE:   modules/groups/b/a/p_type.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern void *P_TYPE_SecondaryGroupListPtr;
extern void *P_TYPE_PrimaryGroupListPtr;
extern void  P_TYPE_LoadPromoIdDataFile(void);
void P_TYPE_ResetListsAndLoadPromoIds(void)
{
    P_TYPE_PrimaryGroupListPtr = P_TYPE_SecondaryGroupListPtr = 0;
    P_TYPE_LoadPromoIdDataFile();
}
