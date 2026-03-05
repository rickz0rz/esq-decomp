BEGIN {
    has_entry = 0
    has_phase = 0
    has_bit_reader = 0
    has_delay_counter = 0
    has_sample_slot = 0
    has_sample_scratch = 0
    has_ctrl_buffer = 0
    has_ctrl_h = 0
    has_h_prev = 0
    has_buffered_count = 0
    has_h_delta_max = 0
    has_wrap_const = 0
    has_assemble_loop = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /CTRL_BIT4CAPTUREPHASE/) has_phase = 1
    if (l ~ /GET_BIT_4_OF_CIAB_PRA_INTO_D1/) has_bit_reader = 1
    if (l ~ /CTRL_BIT4CAPTUREDELAYCOUNTER/) has_delay_counter = 1
    if (l ~ /CTRL_BIT4SAMPLESLOTINDEX/) has_sample_slot = 1
    if (l ~ /CTRL_BIT4SAMPLESCRATCH/) has_sample_scratch = 1
    if (l ~ /CTRL_BUFFER/) has_ctrl_buffer = 1
    if (l ~ /CTRL_H([^A-Z0-9_]|$)/) has_ctrl_h = 1
    if (l ~ /CTRL_HPREVIOUSSAMPLE/) has_h_prev = 1
    if (l ~ /CTRL_BUFFEREDBYTECOUNT/) has_buffered_count = 1
    if (l ~ /CTRL_HDELTAMAX/) has_h_delta_max = 1
    if (l ~ /#\$?1F4/ || l ~ /#0X1F4/ || l ~ /#500/) has_wrap_const = 1

    if (l ~ /BSET / || l ~ /BCLR / || l ~ /LSL\./ || l ~ /ASL\./ || l ~ /OR\./ || l ~ /AND\./) has_assemble_loop = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PHASE=" has_phase
    print "HAS_BIT_READER=" has_bit_reader
    print "HAS_DELAY_COUNTER=" has_delay_counter
    print "HAS_SAMPLE_SLOT=" has_sample_slot
    print "HAS_SAMPLE_SCRATCH=" has_sample_scratch
    print "HAS_CTRL_BUFFER=" has_ctrl_buffer
    print "HAS_CTRL_H=" has_ctrl_h
    print "HAS_H_PREV=" has_h_prev
    print "HAS_BUFFERED_COUNT=" has_buffered_count
    print "HAS_H_DELTA_MAX=" has_h_delta_max
    print "HAS_WRAP_CONST=" has_wrap_const
    print "HAS_ASSEMBLE_LOOP=" has_assemble_loop
}
