write \
    -format verilog \
    -hierarchy \
    -output $OUTPUTS_DIR/top_syn.v

write_file \
    -format ddc \
    -hierarchy \
    -output $OUTPUTS_DIR/top.ddc

write_sdc $OUTPUTS_DIR/top.sdc