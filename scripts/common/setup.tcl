# Aux Variables

set PDK_BASE "/pdk/synopsys/saed32/SAED32_EDK/"
set LIB_IO_PATH "${PDK_BASE}/lib/io_std/"
set DB_IO_PATH "${PDK_BASE}/lib/io_std/db_nldm/"
set LIB_PATH "${PDK_BASE}/lib/stdcell_rvt/"
set DB_PATH "${PDK_BASE}/lib/stdcell_rvt/db_nldm"

set high_density " \
	saed32rvt_tt1p05v25c.db \
	saed32io_fc_tt1p05v25c_2p5v.db \
	"
set LIBRARY_FILES " \
	${high_density} \
    "

set MW_REFERENCE_LIB_DIRS  " \
	${LIB_PATH}/milkyway/saed32nm_rvt_1p9m \
	${LIB_IO_PATH}/milkyway/saed32_io_fc \
       " 

set NDM_REFERENCE_LIB_DIRS  " \
	${PDK_BASE}/lib/stdcell_rvt/ndm/saed32rvt_base_frame_timing.ndm \
	${PDK_BASE}/lib/stdcell_rvt/ndm/saed32rvt_pg_frame_timing.ndm \
       " 
set TECH_FILE        "${PDK_BASE}/tech/tf/saed32nm_1p9m.tf"
set MAP_FILE         "${PDK_BASE}/tech/starrc/saed32nm_tf_itf_tluplus.map"
set TLUPLUS_MAX_FILE "${PDK_BASE}/tech/starrc/nominal/saed32nm_1p9m_nominal.tluplus"
set TLUPLUS_MIN_FILE "${PDK_BASE}/tech/starrc/nominal/saed32nm_1p9m_nominal.tluplus"

set ROUTING_LAYER_DIRECTION_OFFSET_LIST "{M1 horizontal} {M2 vertical} {M3 horizontal} {M4 vertical} {M5 horizontal} {M6 vertical} {M7 horizontal} {M8 vertical} {M9 horizontal} {MRDL vertical} "
set MIN_ROUTING_LAYER             "M1"
set MAX_ROUTING_LAYER             "M9"

set TCL_MV_SETUP_FILE           ""      ;# A Tcl script placeholder for your MV setup commands,such as create_voltage_area,
                                        ;# placement bound, power switch creation and level shifter insertion, etc   
set TCL_PG_CREATION_FILE        ""      ;# A Tcl script placeholder for your power ground network creation commands, 
                                        ;# such as create_pg*, set_pg_strategy, compile_pg, etc

set TIE_LIB_CELL_PATTERN_LIST "*/TIE*"  ;# A list of TIE lib cell patterns to be included for optimization;

set CTS_LIB_CELL_PATTERN_LIST   "*/NBUFF*LVT */NBUFF*RVT */INVX*_LVT */INVX*_RVT */CG* */AOBUFX*_LVT */AOINV* */*DFF*"  ;# List of CTS lib cell patterns to be used by CTS;
                                        ;# Please include repeaters, always-on repeaters (for MV-CTS), 
                                        ;# and gates (for sizing pre-existing gates)/always-on buffers;
                                        ;# Please also include flops as CCD can size flops to improve timing.
                                        ;# example : set CTS_LIB_CELL_PATTERN_LIST "*/NBUF* */AOBUF* */AOINV* */SDFF*".
set MW_POWER_NET                "VCCD" ;#
set MW_POWER_PORT               "VCCD" ;#
set MW_GROUND_NET               "VSSD" ;#
set MW_GROUND_PORT              "VSSD" ;#


set LIBRARY_FILES "${NDM_REFERENCE_LIB_DIRS}"
lappend search_path "${DB_PATH}"



set_app_var synthetic_library dw_foundation.sldb
set_app_var search_path "/home/ciexpert/vinicius.miguel/development/lab_cpu_pipe/rtl ${DB_PATH}"
set_app_var target_library "saed32rvt_tt1p05v25c.db" 
set_app_var link_library "* $target_library $synthetic_library"

