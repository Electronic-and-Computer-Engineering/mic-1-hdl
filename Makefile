default: simulation-iverilog

# Sources
RTL = $(wildcard verilog/top-level/rtl/*.sv) \
	$(wildcard verilog/alu/rtl/*.sv) \
	$(wildcard verilog/shifter/rtl/*.sv)
TB = verilog/top-level/tb/mic1_icebreaker_tb.sv

# Configuration
SHELL = /bin/sh
FPGA_PKG = sg48
FPGA_TYPE = up5k
PCF = icebreaker.pcf
TOP = mic1_icebreaker

all: top.rpt top.bin

Vtop.vvp: $(RTL) $(TB)
	iverilog -o $@ -g2012 $(RTL) $(TB)

simulation-iverilog: Vtop.vvp
	vvp $^

%.json: %.sv
	yosys -ql $(subst .json,,$@)-yosys.log -p 'synth_ice40 -top $(TOP) -json $@' $< $(RTL)

%.asc: $(PCF) %.json
	nextpnr-ice40 --${FPGA_TYPE} --package ${FPGA_PKG} --json $(word 2,$^) --pcf $< --asc $@

%.rpt: %.asc
	icetime -d ${FPGA_TYPE} -mtr $@ $<

%.bin: %.asc
	icepack $< $@

prog: top.bin
	iceprog $<

.PHONY: all clean

clean:
	rm -f *.vvp *.fst *.vcd top*.json top*.asc top*.rpt top*.bin top*yosys.log
