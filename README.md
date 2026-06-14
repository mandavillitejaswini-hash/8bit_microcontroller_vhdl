# 8-bit Pipelined ALU using Verilog

## Project Overview

This project implements an **8-bit Pipelined Arithmetic Logic Unit (ALU)** using **VHDL** and simulates the design using **Vivado 2024.1**.

The ALU performs arithmetic and logical operations using a pipelined architecture to improve throughput and overall processing efficiency.

## Objective

To design, implement, and verify an 8-bit pipelined ALU architecture using VHDL and analyze its functionality through simulation.

## Features

* 8-bit data processing
* Pipelined architecture
* Arithmetic operations

  * Addition
  * Subtraction
* Logical operations

  * AND
  * OR
  * XOR
  * NOT
* Clock-based execution
* Simulation and waveform verification

## Design Specification

* Input Width: 8-bit
* Language: VHDL
* Development Tool: Vivado 2024.1
* Verification Method: Testbench Simulation

## Project Structure

src/ → VHDL source files
tb/ → Testbench files
constraints/ → XDC files
results/ → Simulation outputs

## Workflow

1. Design ALU modules in VHDL
2. Implement pipelining stages
3. Create testbench
4. Run simulation in Vivado
5. Verify outputs using waveforms

## Simulation Results

The design was simulated successfully and validated for different arithmetic and logical operations.

(Add waveform screenshots here)

## Future Improvements

* Increase ALU width to 16-bit / 32-bit
* Add multiplication and division support
* Implement forwarding and hazard handling

## Author

Lakshmi Tejasvini
ECE – VLSI

