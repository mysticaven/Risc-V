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

## What remains to complete

The following checklist describes a practical path from the current building blocks to a small, working **single-cycle RV32I CPU**. The supported instruction subset should be chosen and documented before integration; full RV32I support is a larger project.

### 1. Define and verify the supported subset

- [ ] Choose the first instructions to support, such as `ADDI`, `ADD`, `SUB`, `AND`, `OR`, `LW`, `SW`, and `BEQ`.
- [ ] Record each instruction's encoding, operands, and expected effect in a compact reference table.
- [ ] Add self-checking testbenches that compare outputs with expected values and report a nonzero simulator exit on failure.
- [ ] Add focused tests for the immediate generator and instruction memory; neither currently has a testbench.
- [ ] Cover boundary cases such as sign extension, register `x0`, reset, unsupported ALU controls, and word-address selection.

### 2. Complete the building blocks

- [ ] Extend the immediate generator for the formats needed by the chosen instructions: I, S, B, U, and J.
- [ ] Define how instruction memory is initialized for simulations, and test reads at the first, last, and out-of-range supported addresses.
- [ ] Add any missing datapath blocks required by the selected subset, such as a branch comparator or result-selection muxes.
- [ ] Document each module's ports, timing, reset behavior, and supported operations.

### 3. Add decode and control

- [ ] Decode opcode and function fields into control signals for the chosen instruction subset.
- [ ] Define the control signals for register writes, memory reads and writes, ALU operation, branches, and writeback selection.
- [ ] Add tests for every supported instruction and for unsupported encodings.

### 4. Integrate a single-cycle processor

- [ ] Add a CPU top-level that connects the program counter, instruction memory, decoder/control, immediate generator, register file, ALU, and writeback path.
- [ ] Implement next-PC selection for sequential execution and supported branches.
- [ ] Connect load/store address generation and data-memory access if `LW` and `SW` are in the chosen subset.
- [ ] Run a short program from instruction memory and verify its final register and memory values.

### 5. Make the project easy to extend

- [ ] Update the README with the final supported instruction list, datapath overview, and known limitations as the design grows.
- [ ] Keep generated simulator outputs under `riscv-cpu/build/` and out of version control.
- [ ] Add a simple waveform workflow for debugging simulations when needed.