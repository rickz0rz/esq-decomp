/* RESTORES: _NEWGRID_InitShowtimeBuckets
 * MODULE:   modules/groups/b/a/newgrid1b.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
struct ShowtimeBucket { long a; long b; };
extern struct ShowtimeBucket *NEWGRID_ShowtimeBucketPtrTable[];
extern struct ShowtimeBucket  NEWGRID_ShowtimeBucketEntryTable[];
void NEWGRID_InitShowtimeBuckets(void)
{
    long i;

    for (i = 0; i < 10; i++) {
        NEWGRID_ShowtimeBucketPtrTable[i] = &NEWGRID_ShowtimeBucketEntryTable[i];
        NEWGRID_ShowtimeBucketEntryTable[i].b = 0;
    }
}
