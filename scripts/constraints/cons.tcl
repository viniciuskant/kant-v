#return
set clk_val 2.36
create_clock -period $clk_val [get_ports clk] -name clk
set_clock_uncertainty 0.3 [get_clocks clk]
set_clock_transition -max [expr $clk_val*0.1] [get_clocks clk]
set_clock_transition -rise 0.1 [get_clocks clk]
set_clock_transition -fall 0.1 [get_clocks clk]

set_max_fanout 8 [current_design]

set_input_delay 2.0 -clock clk [get_ports [remove_from_collection [all_inputs] clk]]
set_output_delay 2.0 -clock clk [get_ports [all_outputs]]

set_load -max 0.04 [all_outputs]
set_input_transition -min [expr $clk_val*0.01] [remove_from_collection [all_inputs] clk]
set_input_transition -max [expr $clk_val*0.1] [remove_from_collection [all_inputs] clk]
