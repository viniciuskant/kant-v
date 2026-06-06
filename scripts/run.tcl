#Note que para rodar esse comando vc deve estar dentro de uma pasta na mesma altura que scripts

source ../scripts/common/setup.tcl
source ../scripts/common/utils.tcl
source ../scripts/common/create_run_dirs.tcl

check_status "READ RTL" {source ../scripts/flow/read_rtl.tcl}

check_status "ELABORATE" {source ../scripts/flow/elaborate.tcl}

source ../scripts/constraints/cons.tcl
check_timing

check_status "SYNTHESIS" {source ../scripts/flow/synthesis.tcl}

# check_status "DFT" {source flow/dft.tcl\}

check_status "WRITE OUTPUTS"  {source ../scripts/flow/write_outputs.tcl}

check_status "REPORTS" {source ../scripts/flow/reports.tcl}

puts "FINISH"