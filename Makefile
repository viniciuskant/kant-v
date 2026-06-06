# DIRS
RTL_DIR = rtl
TB_DIR  = tb
OUT_DIR = output
SYN_DIR = $(OUT_DIR)/synth

# TOOLS
VCS = vcs
DC  = dc_shell

# TOP
TOP = top

# TESTBENCH
TB = top_tb
TB_FILE = $(TB_DIR)/$(TB).sv

# OUTPUTS
SIM_DIR = $(OUT_DIR)/$(TB)
SIMV    = $(SIM_DIR)/simv

# RTL FILES
SRCS = \
	$(RTL_DIR)/register_bank.sv \
	$(RTL_DIR)/mux4.sv \
	$(RTL_DIR)/mux4_registered.sv \
	$(RTL_DIR)/control.sv \
	$(RTL_DIR)/memory.sv \
	$(RTL_DIR)/ALU.sv \
	$(RTL_DIR)/top.sv

# VCS FLAGS
VCS_FLAGS = -sverilog -timescale=1ns/1ps -debug_access+all -kdb -lca

# DEFAULT
all: run

# COMPILE
$(SIMV): $(TB_FILE) $(SRCS)
	@mkdir -p $(SIM_DIR)
	$(VCS) $(VCS_FLAGS) \
	$(TB_FILE) $(SRCS) \
	-top $(TB) \
	-o $(SIMV)

# RUN
run: $(SIMV)
	@echo "Running simulation..."
	@cd $(SIM_DIR) && ./simv | tee run.log

# SYNTHESIS
synth:
	@mkdir -p $(SYN_DIR)

	@echo "read_verilog $(SRCS)" >  $(SYN_DIR)/run.tcl
	@echo "current_design $(TOP)" >> $(SYN_DIR)/run.tcl
	@echo "link" >> $(SYN_DIR)/run.tcl
	@echo "create_clock -period 10 clk" >> $(SYN_DIR)/run.tcl
	@echo "compile" >> $(SYN_DIR)/run.tcl
	@echo "write -format verilog -hierarchy -output $(SYN_DIR)/$(TOP).v" >> $(SYN_DIR)/run.tcl
	@echo "write -format ddc -output $(SYN_DIR)/$(TOP).ddc" >> $(SYN_DIR)/run.tcl
	@echo "report_area > $(SYN_DIR)/area.rpt" >> $(SYN_DIR)/run.tcl
	@echo "report_timing > $(SYN_DIR)/timing.rpt" >> $(SYN_DIR)/run.tcl
	@echo "exit" >> $(SYN_DIR)/run.tcl

	$(DC) -f $(SYN_DIR)/run.tcl | tee $(SYN_DIR)/synth.log

# CLEAN
clean:
	rm -rf $(OUT_DIR)
	rm -rf csrc simv simv.daidir simv.vdb ucli.key
	rm -rf *.vpd *.vcd *.log *.fsdb *.key
	rm -rf DVEfiles verdiLog novas.* urgReport
	rm -rf AN.DB
	rm -rf simulator
	rm -rf work
	rm -rf alib-52
	rm .nfs* moduleparamid default.svf 

.PHONY: all run synth clean