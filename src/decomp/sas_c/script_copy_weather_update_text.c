extern const char Global_STR_WEATHER_UPDATE_FOR[];

void SCRIPT_CopyWeatherUpdateText(char *outBuffer)
{
    const char *src;
    char *dst;

    src = Global_STR_WEATHER_UPDATE_FOR;
    dst = outBuffer;
    while ((*dst++ = *src++) != '\0') {
    }
}
