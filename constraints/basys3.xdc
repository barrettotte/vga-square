# XDC constraints for Basys 3 Artix-7 board
# Modified from https://github.com/Digilent/digilent-xdc/blob/master/Basys-3-Master.xdc

# Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# SPI configuration mode options for QSPI boot, can be used for all designs
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

# Clock
set_property PACKAGE_PIN W5      [get_ports i_clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk_100MHz]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0.0 5.0} [get_ports {i_clk_100MHz}]

# Center button
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports {i_reset}]

# VGA
set_property -dict { PACKAGE_PIN N19   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[11]}]
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[10]}]
set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[9]}]
set_property -dict { PACKAGE_PIN G19   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[8]}]
set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[7]}]
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[6]}]
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[5]}]
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[4]}]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[3]}]
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[2]}]
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[1]}]
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports {o_rgb[0]}]
set_property -dict { PACKAGE_PIN P19   IOSTANDARD LVCMOS33 } [get_ports {o_hsync}]
set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports {o_vsync}]
