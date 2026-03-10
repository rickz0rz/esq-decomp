extern long DATETIME_NormalizeStructToSeconds(const void *in_struct);
extern void DATETIME_SecondsToStruct(long seconds, void *out_struct);
extern long GROUP_AG_JMPTBL_MATH_Mulu32(long lhs, long rhs);

enum {
    DATETIME_SLOT_BASE_OFFSET = 0x36,
    DATETIME_DST_CLEAR_FLAG = 1,
    DATETIME_SLOT_SECONDS = 0x0E10,
    DATETIME_STRUCT_DST_FLAG_CLEAR = 0,
    DATETIME_STRUCT_DST_FLAG_OFFSET = 14
};

long DATETIME_BuildFromBaseDay(const void *in_struct, void *out_struct, long daySlot, long dstFlagWord)
{
    long base_seconds;
    long scaled_offset;
    long normalized_slot;
    long result_seconds;

    base_seconds = DATETIME_NormalizeStructToSeconds(in_struct);
    normalized_slot = (short)daySlot - DATETIME_SLOT_BASE_OFFSET;
    if ((short)dstFlagWord == DATETIME_DST_CLEAR_FLAG) {
        normalized_slot -= 1;
    }

    scaled_offset = GROUP_AG_JMPTBL_MATH_Mulu32(normalized_slot, DATETIME_SLOT_SECONDS);
    result_seconds = base_seconds + scaled_offset;

    DATETIME_SecondsToStruct(result_seconds, out_struct);
    *(short *)((char *)out_struct + DATETIME_STRUCT_DST_FLAG_OFFSET) = DATETIME_STRUCT_DST_FLAG_CLEAR;

    return result_seconds;
}
