typedef signed long LONG;

extern LONG _LVOFreeTrap(void *libBase, void *a0, void *a1, void *a2, void *a3, LONG d0, LONG d1, LONG d2, LONG d3);

LONG EXEC_CallVector_348(void *libBase, void *a0, void *a1, void *a2, void *a3, LONG d0, LONG d1, LONG d2, LONG d3)
{
    return _LVOFreeTrap(libBase, a0, a1, a2, a3, d0, d1, d2, d3);
}
