extern long DATETIME_NormalizeStructToSeconds(void *in_struct);
extern void DATETIME_SecondsToStruct(long seconds, void *out_struct);
extern long GROUP_AG_JMPTBL_MATH_Mulu32(long lhs, long rhs);

long DATETIME_BuildFromBaseDay(void *in_struct, void *out_struct, long day_slot, long flag_word)
{
    long base_seconds;
    long scaled_offset;
    long normalized_slot;
    long result_seconds;

    base_seconds = DATETIME_NormalizeStructToSeconds(in_struct);
    normalized_slot = (short)day_slot - 0x36;
    if ((short)flag_word == 1) {
        normalized_slot -= 1;
    }

    scaled_offset = GROUP_AG_JMPTBL_MATH_Mulu32(normalized_slot, 0x0E10);
    result_seconds = base_seconds + scaled_offset;

    DATETIME_SecondsToStruct(result_seconds, out_struct);
    *(short *)((char *)out_struct + 14) = 0;

    return result_seconds;
}
