# MIC-1

Verilog description of a MIC-1 based CPU.

# Introduction

This repository contains the work for a study project at the FH Joanneum.

The CPU is designed to work with Vivado and yosys/nextpnr.
It is tested to work on both the Basys-3 and the iCEBreaker FPGA boards.

# The Project Team

| Position         | Name               |
|------------------|--------------------|
| Team leader      | Leo Moser          |
| Team coordinator | Florian Zwittnigg  |
| Team member      | Michael Lang       |
| Team member      | Michael Stangl     |
| Team member      | Paul Sinabell      |

# Simulation

These instructions refer to simulation using Icarus Verilog and bitstream generation using yosys/nextpnr.

To run a behavioral simulation:

```
make simulation-iverilog
```

To run a gatelevel simulation:

```
make simulation-iverilog-gatelevel
```

To flash the bitstream to the iCEBreaker board:

```
make prog
```

# Repository

## verilog/

This directory contains the various submodules and the top-level module.

## python/

This directory houses the scripts for converting the MIC-1 programs to memory files.

## documentation/

Here you can find a `User Manual` on how to get the MIC-1 up and running on the Basys-3 FPGA Board.

To build the documentation yourself run:

```
make documentation/User_Manual.pdf
```

## Licenses

Copyright the project team.

Unless otherwise specified, source code in this repository is licensed under the GNU General Public License, Version 3 (GPL-3.0). A copy is included in the LICENSE file.