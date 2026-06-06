set RUN_NAME [clock format [clock seconds] -format "%Y%m%d_%H%M%S"]

set RUN_DIR "../runs/$RUN_NAME"

set REPORTS_DIR  "$RUN_DIR/reports"
set OUTPUTS_DIR  "$RUN_DIR/outputs"
set LOGS_DIR     "$RUN_DIR/logs"
set SNAPSHOT_DIR "$RUN_DIR/snapshots"

foreach dir [list $RUN_DIR $REPORTS_DIR $OUTPUTS_DIR $LOGS_DIR $SNAPSHOT_DIR] {
    file mkdir $dir
    puts "Criado: $dir"
}

set work_path "../work"

if {![file exists $work_path]} {
    file mkdir $work_path
}

set files_to_backup {
    ../scripts/run.tcl
    ../scripts/common/setup.tcl
    ../scripts/constraints/cons.tcl
}

foreach file $files_to_backup {

    if {[file exists $file]} {
        file copy -force $file $SNAPSHOT_DIR/
    } else {
        puts "WARNING: Arquivo nao encontrado: $file"
    }
}

puts ""
puts "RUN NAME: $RUN_NAME"
puts "RUN DIR: $RUN_DIR"
puts "REPORTS: $REPORTS_DIR"
puts "OUTPUTS: $OUTPUTS_DIR"
puts "SNAPSHOTS: $SNAPSHOT_DIR"
puts ""