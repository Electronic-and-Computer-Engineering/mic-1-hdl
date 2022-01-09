create_clock -period 166.000 -name clk -waveform {0.000 5.000} [get_ports clk]
#Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## LEDs
# RUN
set_property PACKAGE_PIN U16 [get_ports led_run_status]
set_property IOSTANDARD LVCMOS33 [get_ports led_run_status]
# STOP
set_property PACKAGE_PIN E19 [get_ports led_idle]
set_property IOSTANDARD LVCMOS33 [get_ports led_idle]
# STEP_1
set_property PACKAGE_PIN U19 [get_ports {led_run_step[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_run_step[0]}]
# STEP_2
set_property PACKAGE_PIN V19 [get_ports {led_run_step[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_run_step[1]}]
# STEP_3
set_property PACKAGE_PIN W18 [get_ports {led_run_step[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_run_step[2]}]
# STEP_4
set_property PACKAGE_PIN U15 [get_ports {led_run_step[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_run_step[3]}]


## BUTTONS
# Button_Up
set_property PACKAGE_PIN T18 [get_ports {button[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button[0]}]
# Button_Left
set_property PACKAGE_PIN W19 [get_ports {button[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button[1]}]
# Button_Right
set_property PACKAGE_PIN T17 [get_ports {button[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button[2]}]
# Button_Down
set_property PACKAGE_PIN U17 [get_ports {button[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button[3]}]
# Button_Center
set_property PACKAGE_PIN U18 [get_ports resetn]
set_property IOSTANDARD LVCMOS33 [get_ports resetn]