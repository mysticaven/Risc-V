# RISC-V CPU Building Blocks

A small SystemVerilog learning project containing standalone building blocks for a RISC-V processor. It is **not yet a complete CPU**: the modules are not connected by a top-level datapath or control unit.

## What is implemented

| Module | Purpose |
| --- | --- |
| `alu` | 32-bit add, subtract, AND, OR, XOR, NOT, logical left shift, and logical right shift operations. |
| `decoder` | Splits a 32-bit instruction into opcode, register, and function fields. |
| `imm_gen` | Sign-extends the 12-bit I-type immediate. Other immediate formats are not implemented. |
| `instruction_memory` | 256-word instruction ROM; the first 10 words are initialized with sample instructions. Byte addresses use bits `[9:2]` to select a word. |
| `pc` | 32-bit program counter with a synchronous, active-high reset. |
| `regfile` | 32 32-bit registers, two combinational read ports, one clocked write port, and a hard-wired zero register. |

## Project layout

```text
.
|-- README.md
|-- run-tests.ps1
`-- riscv-cpu/
    |-- rtl/       SystemVerilog hardware modules
    |-- tb/        Simulation testbenches
    |-- docs/      Learning notes and examples
    `-- build/     Generated simulation output (created when tests run)
```

## Run the simulations

Install [Icarus Verilog](https://steveicarus.github.io/iverilog/) and make sure `iverilog` and `vvp` are available in `PATH`. From the repository root, run:

```powershell
.\run-tests.ps1
```

The script first compiles every RTL module, then runs the ALU, decoder, program-counter, and register-file testbenches. The current testbenches print values for inspection; they do not yet perform automated pass/fail comparisons. Generated files are written to `riscv-cpu/build/`.

## Learning notes

- [Writing a testbench](riscv-cpu/docs/writing-testbenches.md) explains the structure of a SystemVerilog testbench.
- [Assembly immediate example](riscv-cpu/docs/assembly-immediate-example.md) works through a short RV32I assembly example.

## Current limitations

- There is no integrated processor top-level, control unit, or complete datapath.
- The decoder extracts instruction fields but does not decode them into control signals.
- The immediate generator currently supports only I-type immediates.
- The instruction ROM initializes only its first 10 entries; remaining entries are unspecified.
- The existing testbenches are introductory simulations, not a complete automated verification suite.