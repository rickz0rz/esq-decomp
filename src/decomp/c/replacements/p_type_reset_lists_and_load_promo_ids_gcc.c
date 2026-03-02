extern void *P_TYPE_PrimaryGroupListPtr;
extern void *P_TYPE_SecondaryGroupListPtr;

void P_TYPE_LoadPromoIdDataFile(void) __attribute__((noinline));

void P_TYPE_ResetListsAndLoadPromoIds(void) __attribute__((noinline, used));

void P_TYPE_ResetListsAndLoadPromoIds(void)
{
    P_TYPE_SecondaryGroupListPtr = (void *)0;
    P_TYPE_PrimaryGroupListPtr = (void *)0;
    P_TYPE_LoadPromoIdDataFile();
}
