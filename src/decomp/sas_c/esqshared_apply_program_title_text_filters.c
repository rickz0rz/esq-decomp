#include <exec/types.h>

extern void ESQSHARED_CompressClosedCaptionedTag(char *text);
extern void ESQSHARED_NormalizeInStereoTag(char *text, ULONG flags);
extern void ESQSHARED_ReplaceMovieRatingToken(char *text);
extern void ESQSHARED_ReplaceTvRatingToken(char *text);

char *ESQSHARED_ApplyProgramTitleTextFilters(char *text, ULONG flags)
{
    ESQSHARED_CompressClosedCaptionedTag(text);
    ESQSHARED_NormalizeInStereoTag(text, flags);
    ESQSHARED_ReplaceMovieRatingToken(text);
    ESQSHARED_ReplaceTvRatingToken(text);

    return text;
}
