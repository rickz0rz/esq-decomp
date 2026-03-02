BEGIN {
    label=0; qerr=0; qpct=0; spr_call=0; gt0=0; errfmt=0; fullfmt=0; scratch=0; ret=0
}

/^ESQ_FormatDiskErrorMessage:$/ { label=1 }
/DISKIO_QueryVolumeSoftErrorCount/ { qerr=1 }
/DISKIO_QueryDiskUsagePercentAndSetBufferSize/ { qpct=1 }
/GROUP_AE_JMPTBL_WDISP_SPrintf/ { spr_call=1 }
/TST\.L|CMP\.L|BLE|BGT/ { gt0=1 }
/Global_STR_DISK_ERRORS_FORMATTED/ { errfmt=1 }
/Global_STR_DISK_IS_FULL_FORMATTED/ { fullfmt=1 }
/DISKIO_ErrorMessageScratch/ { scratch=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (qerr) print "HAS_QUERY_SOFT_ERROR_CALL"
    if (qpct) print "HAS_QUERY_USAGE_PERCENT_CALL"
    if (spr_call) print "HAS_SPRINTF_CALL"
    if (gt0) print "HAS_POSITIVE_BRANCH"
    if (errfmt) print "HAS_DISK_ERRORS_FMT"
    if (fullfmt) print "HAS_DISK_FULL_FMT"
    if (scratch) print "HAS_ERROR_SCRATCH_REF"
    if (ret) print "HAS_RTS"
}
