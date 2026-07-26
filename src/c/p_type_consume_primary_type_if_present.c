/* RESTORES: P_TYPE_ConsumePrimaryTypeIfPresent
 * MODULE:   modules/groups/b/a/p_type.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e70310266f00107e004ab90000b4e0673820790000b4e0202800024a806f2a7c004a87662420790000b4e0bca800026c1822790000b4e020690006d1c61013b01066027e01528660d8421320074cdf08c04e75
 *   got:     48e703042a6f00107e004ab9000000006738207900000000202800024a806f2a7c004a876624207900000000bca800026c1822790000000020690006d1c61015b01066027e01528660d8421520074cdf20c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct PTypeGroupList { char pad[2]; long count; char *codes; };
extern struct PTypeGroupList *P_TYPE_PrimaryGroupListPtr;

long P_TYPE_ConsumePrimaryTypeIfPresent(char *slot)
{
    long found = 0;
    long i;

    if (P_TYPE_PrimaryGroupListPtr != 0 && P_TYPE_PrimaryGroupListPtr->count > 0) {
        i = 0;
        while (!found && i < P_TYPE_PrimaryGroupListPtr->count) {
            if (*slot == P_TYPE_PrimaryGroupListPtr->codes[i])
                found = 1;
            i++;
        }
    }
    *slot = 0;
    return found;
}
