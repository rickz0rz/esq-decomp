typedef long LONG;

extern LONG COI_GetAnimFieldPointerByMode(const void *entry, unsigned short key, unsigned short mode);

LONG COI_SelectAnimFieldPointer(const void *entry, LONG key, LONG mode)
{
    return COI_GetAnimFieldPointerByMode(entry, (unsigned short)key, (unsigned short)mode);
}
