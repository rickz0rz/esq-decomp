extern void *P_TYPE_PrimaryGroupListPtr;
extern void *P_TYPE_SecondaryGroupListPtr;

void P_TYPE_FreeEntry(void *entry) __attribute__((noinline));

void P_TYPE_PromoteSecondaryList(void) __attribute__((noinline, used));

void P_TYPE_PromoteSecondaryList(void)
{
    P_TYPE_FreeEntry(P_TYPE_PrimaryGroupListPtr);
    P_TYPE_PrimaryGroupListPtr = P_TYPE_SecondaryGroupListPtr;
    P_TYPE_SecondaryGroupListPtr = (void *)0;
}
