remove_design -all

define_design_lib WORK -path $work_path

foreach file {
    register_bank.sv
    mux4.sv
    ALU.sv
    control.sv
    memory.sv
    top.sv
} {
    puts "Analyzing $file"
    analyze -format sverilog $file
}