default: simulation-iverilog

# Sources
RTL = $(wildcard verilog/top-level/rtl/*.sv) \
	$(wildcard verilog/alu/rtl/*.sv) \
	$(wildcard verilog/shifter/rtl/*.sv) \
	$(wildcard verilog/main-memory/rtl/*.sv) \
	$(wildcard verilog/control-store/rtl/*.sv)
TB = verilog/top-level/tb/mic1_icebreaker_tb.sv

# Configuration
SHELL = /bin/sh
FPGA_PKG = sg48
FPGA_TYPE = up5k
PCF = icebreaker.pcf
TOP = mic1_icebreaker

all: mic1_icebreaker.rpt mic1_icebreaker.bin

Vtop.vvp: $(RTL) $(TB)
	iverilog -o $@ -g2012 $(RTL) $(TB) `yosys-config --datdir/ice40/cells_sim.v` -D CONSTANTPOOL_ADDRESS=\'h0001

simulation-iverilog: Vtop.vvp
	vvp $^

%.json: $(RTL) $(TB)
	yosys -ql $(subst .json,,$@)-yosys.log -p 'synth_ice40 -top $(TOP) -json $@' $(RTL) -D CONSTANTPOOL_ADDRESS=\'h0001 # -dsp -abc2 -noflatten # techmap -D ALU_RIPPLE;;

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
	rm -f *.vvp *.fst *.vcd *.json *.asc *.rpt *.bin *yosys.log
