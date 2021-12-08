create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]
#Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## LEDs
# RUN
set_property PACKAGE_PIN U16 [get_ports {led_start_stop}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_start_stop}]
# STOP
set_property PACKAGE_PIN E19 [get_ports {led_step}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_step}]
# STATE_1
set_property PACKAGE_PIN U19 [get_ports {led_run[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_run[0]}]
# STATE_2
set_property PACKAGE_PIN V19 [get_ports {led_run[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_run[1]}]
# STATE_3
set_property PACKAGE_PIN W18 [get_ports {led_run[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_run[2]}]
# STATE_4
set_property PACKAGE_PIN U15 [get_ports {led_run[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_run[3]}]


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
set_property PACKAGE_PIN U18 [get_ports {resetn}]
set_property IOSTANDARD LVCMOS33 [get_ports {resetn}]