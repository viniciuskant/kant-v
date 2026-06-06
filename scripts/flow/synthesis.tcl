compile_ultra \ 
    -retime \
    -gate_clock \
    -timing_high_effort_script

check_design

write_file \
    -format ddc \
    -hierarchy \
    -output $SNAPSHOT_DIR/post_compile.ddc