; Constants defined by the DATA section but consumed from code modules.
; Under one-big-assembly these resolved implicitly; with separate assembly the
; code units cannot see DATA labels, so the values live here. Each value that is
; derived from a data-label difference is re-verified by an `assert` at its
; original site in src/data, so editing the data without updating this file
; fails the build instead of silently desyncing.

ED_DiagGraphModeChar_Length                      = 1
ED_DiagScrollSpeedChar_Length                    = 1
ED_DiagTextModeChar_Length                       = 1
ED_DiagVinModeChar_Length                        = 1
ESQ_STR_6_Length                                 = 1
ESQ_STR_B_Length                                 = 1
ESQ_STR_E_Length                                 = 1
ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_Length  = 1
ESQ_STR_Y_Length                                 = 1
ESQ_SecondarySlotModeFlagChar_Length             = 1
ESQ_TAG_36_Length                                = 2
GCOMMAND_BannerRowByteOffsetResetValueDefault    = 5984
Global_STR_PLEASE_STANDBY_1_Length               = 18
