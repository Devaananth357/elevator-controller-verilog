create_clock -period 10.000 -name sys_clk [get_ports clk]

set_load 5.000 [all_outputs]
set_property LOAD 5 [get_ports {current_floor[0]}]
set_property LOAD 5 [get_ports {current_floor[1]}]
set_property LOAD 5 [get_ports {current_floor[2]}]
set_property LOAD 5 [get_ports is_door_open]
set_property LOAD 5 [get_ports move_down]
set_property LOAD 5 [get_ports move_up]
