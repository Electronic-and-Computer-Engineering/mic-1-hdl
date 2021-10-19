default: simulation-iverilog

RTL = $(wildcard verilog/top-level/rtl/*.sv)
TB = verilog/top-level/tb/mic1_icebreaker_tb.sv


Vtop.vvp: $(RTL) $(TB)
	iverilog -o $@ -g2012 $(RTL) $(TB)

simulation-iverilog: Vtop.vvp
	vvp $^

.PHONY: clean
clean:
	rm -f *.vvp *.fst *.vcd

