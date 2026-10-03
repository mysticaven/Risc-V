Yes. The goal is **not to memorise that ALU testbench**. You should understand the pattern well enough that, when we build a register file tomorrow, you can write its testbench yourself.

A **testbench is simply a piece of SystemVerilog that tests your hardware module**.

Your actual hardware:

```text
rtl/alu.sv
```

Your test:

```text
tb/alu_tb.sv
```

The testbench is **not synthesised into your CPU**. It exists only for simulation.

---

# 1. The basic mental model

Suppose your ALU is:

```text
        a ───────┐
                 │
        b ───────┤
                 ▼
            ┌─────────┐
 control ──►│   ALU   │
            └────┬────┘
                 │
              result
```

Your testbench sits outside it:

```text
              TESTBENCH
┌──────────────────────────────────────┐
│                                      │
│   a ───────────────┐                │
│                    │                │
│   b ───────────────┤                │
│                    ▼                │
│               ┌─────────┐           │
│ control ─────►│   ALU   │           │
│               └────┬────┘           │
│                    │                │
│                 result              │
│                    │                │
│              check result           │
│                                      │
└──────────────────────────────────────┘
```

The testbench:

1. Creates inputs.
2. Connects them to the DUT.
3. Changes inputs.
4. Waits for the hardware to respond.
5. Checks the output.
6. Reports whether the test passed.

---

# 2. What is `DUT`?

You'll see this constantly:

```systemverilog
alu dut (
```

`DUT` means:

> **Device Under Test**

It is simply the hardware you're testing.

You have:

```systemverilog
module alu (...);
```

So your testbench creates an instance of it:

```systemverilog
alu dut (...);
```

Think of it like creating an object of the hardware module.

You could technically call it:

```systemverilog
alu banana (...);
```

and SystemVerilog wouldn't care.

But:

```systemverilog
alu dut (...);
```

is conventional because everyone understands:

> this is the module we're testing.

---

# 3. Start every testbench with a module

Your testbench itself is a module:

```systemverilog
module alu_tb;

endmodule
```

Notice there are **no ports**.

Why?

Because the testbench is at the top of the simulation. Nothing outside needs to connect to it.

So:

```systemverilog
module alu (
    input ...
    output ...
);
```

is your hardware.

But:

```systemverilog
module alu_tb;
```

is your test environment.

---

# 4. Create signals for the DUT

Look at your ALU:

```systemverilog
module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [3:0]  alu_control,
    output logic [31:0] result
);
```

The testbench needs matching signals:

```systemverilog
logic [31:0] a;
logic [31:0] b;
logic [3:0]  alu_control;
logic [31:0] result;
```

Why `logic`?

Because these are signals that the testbench will drive or observe.

Think:

```text
ALU input:
    a  ← testbench controls it
    b  ← testbench controls it
    control ← testbench controls it

ALU output:
    result → testbench observes it
```

So:

```text
             TESTBENCH

        a ───────────────► ALU
        b ───────────────► ALU
        control ─────────► ALU

        result ◄────────── ALU
```

---

# 5. Instantiate the DUT

Now connect those signals to your ALU:

```systemverilog
alu dut (
    .a(a),
    .b(b),
    .alu_control(alu_control),
    .result(result)
);
```

This is **named port mapping**.

The left side:

```systemverilog
.a
```

means:

> ALU's port called `a`

The right side:

```systemverilog
a
```

means:

> testbench signal called `a`

So:

```systemverilog
.a(a)
```

means:

```text
ALU a ←→ testbench a
```

Likewise:

```systemverilog
.b(b)
```

and:

```systemverilog
.result(result)
```

---

# 6. Now we need to give it inputs

This is where:

```systemverilog
initial begin
```

comes in.

For example:

```systemverilog
initial begin

    a = 10;
    b = 20;
    alu_control = 4'b0000;

end
```

This says:

> When simulation starts, set these signals to these values.

You can think of `initial` as:

> "Run this sequence once from the beginning of simulation."

For a simple testbench, this is exactly what we want.

---

# 7. Why do we use `#1`?

You saw:

```systemverilog
a = 10;
b = 20;
alu_control = 4'b0000;

#1;

$display("ADD: %0d", result);
```

The:

```systemverilog
#1
```

means:

> Wait 1 simulation time unit.

Why?

Because we changed the inputs and then want to give the simulator a chance to propagate the changes through the ALU.

Conceptually:

```text
time 0

a = 10
b = 20
control = ADD

       ↓

      ALU

       ↓

time 1

result = 30
```

For a purely combinational ALU, this is mostly about simulation scheduling rather than modelling a real one-cycle delay.

---

# 8. `$display`

This:

```systemverilog
$display("ADD: %0d", result);
```

prints something into your terminal.

For example:

```text
ADD: 30
```

`%0d` means:

> Print this value as a decimal number.

Other useful formats:

```text
%d    decimal
%b    binary
%h    hexadecimal
```

So:

```systemverilog
$display("result = %0d", result);
```

could give:

```text
result = 30
```

While:

```systemverilog
$display("result = %h", result);
```

could give:

```text
result = 0000001e
```

And:

```systemverilog
$display("result = %b", result);
```

gives the binary representation.

---

# 9. But `$display` isn't really testing

This is important.

If you write:

```systemverilog
$display("ADD: %0d", result);
```

you're just **looking at the answer**.

A proper testbench should eventually automatically determine whether the answer is correct.

For example:

```systemverilog
if (result == 30)
    $display("ADD PASS");
else
    $display("ADD FAIL");
```

Now the computer is actually checking your work instead of asking you to stare at a number and make a judgement like a tired teacher marking homework.

---

# 10. Even better: expected value

A cleaner pattern is:

```systemverilog
logic [31:0] expected;
```

Then:

```systemverilog
a = 10;
b = 20;
alu_control = 4'b0000;
expected = 30;

#1;

if (result == expected)
    $display("ADD PASS");
else
    $display("ADD FAIL: expected %0d, got %0d",
             expected, result);
```

Now you have:

```text
inputs
   ↓
 DUT
   ↓
actual result
   ↓
compare
   ↑
expected result
```

That's the foundation of **verification**.

---

# 11. Your testbench pattern

You can now memorise this general structure:

```systemverilog
module testbench;

    // 1. Declare signals
    logic ...;

    // 2. Instantiate DUT
    module_name dut (
        ...
    );

    // 3. Run tests
    initial begin

        // Set inputs
        ...

        // Wait
        #1;

        // Check outputs
        ...

        // More tests
        ...

        $finish;
    end

endmodule
```

That's the basic skeleton.

---

# 12. Let's build an ALU testbench together from scratch

Don't copy the previous one. Use this reasoning.

### Step A: What are the ALU inputs?

From:

```systemverilog
module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [3:0] alu_control,
    output logic [31:0] result
);
```

Therefore your testbench needs:

```systemverilog
logic [31:0] a;
logic [31:0] b;
logic [3:0] alu_control;
logic [31:0] result;
```

### Step B: Instantiate it

```systemverilog
alu dut (
    .a(a),
    .b(b),
    .alu_control(alu_control),
    .result(result)
);
```

### Step C: Give it an ADD test

You know:

```text
a = 500
b = 123
control = 0000
expected = 30
```

So:

```systemverilog
initial begin

    a = 10;
    b = 20;
    alu_control = 4'b0000;

    #1;

    if (result == 30)
        $display("ADD PASS");
    else
        $display("ADD FAIL");

    $finish;

end
```

That's already a complete testbench.

---

# 13. Then add more tests

You can extend it:

```systemverilog
// ADD
a = 10;
b = 20;
alu_control = 4'b0000;
#1;

if (result == 30)
    $display("ADD PASS");
else
    $display("ADD FAIL");

// SUB
a = 20;
b = 5;
alu_control = 4'b0001;
#1;

if (result == 15)
    $display("SUB PASS");
else
    $display("SUB FAIL");
```

Then AND:

```systemverilog
a = 4'b1100;
b = 4'b1010;
alu_control = 4'b0010;
#1;

if (result == 4'b1000)
    $display("AND PASS");
else
    $display("AND FAIL");
```

And so on.

---

# 14. Testbench vs actual CPU

This distinction is **really important** for your project.

Your RTL:

```text
rtl/
├── alu.sv
├── regfile.sv
├── decoder.sv
├── control.sv
├── pc.sv
└── cpu.sv
```

Your testbenches:

```text
tb/
├── alu_tb.sv
├── regfile_tb.sv
├── decoder_tb.sv
└── cpu_tb.sv
```

You don't put test code inside the CPU.

For example:

```systemverilog
module alu (...);
```

shouldn't contain:

```systemverilog
$display("ALU PASS");
```

The ALU is the thing being tested.

The testbench is the **experiment**.

---

# 15. What changes when we build the register file?

This is where testbench thinking becomes really useful.

Suppose we eventually have:

```systemverilog
module regfile (
    input logic clk,
    input logic rst,

    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,

    input logic [31:0] write_data,
    input logic reg_write,

    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);
```

Before writing its testbench, ask:

### What can I control?

```text
clk
rst
rs1
rs2
rd
write_data
reg_write
```

### What can I observe?

```text
read_data1
read_data2
```

### What behaviours must I test?

```text
1. Reset
2. Write x5
3. Read x5
4. Write x6
5. Read x5 and x6 simultaneously
6. x0 must always return zero
7. Writing x0 must have no effect
```

That's how you should approach **every future testbench**.

---

# The universal testbench recipe

Whenever we give you a new hardware module, don't ask:

> "How do I write the testbench?"

Ask these five questions:

### ① What are the inputs?

Create testbench signals for them.

### ② What are the outputs?

Create signals to observe them.

### ③ How do I connect the DUT?

Instantiate the module.

### ④ What behaviours should I test?

Create test cases.

### ⑤ What should the output be?

Compare **actual vs expected**.

So your thought process becomes:

```text
             NEW HARDWARE
                  │
                  ▼
          ┌───────────────┐
          │ What goes in? │
          └───────┬───────┘
                  ▼
          ┌───────────────┐
          │ What comes out│
          └───────┬───────┘
                  ▼
          ┌───────────────┐
          │ What can go   │
          │ wrong?        │
          └───────┬───────┘
                  ▼
          ┌───────────────┐
          │ Create tests  │
          └───────┬───────┘
                  ▼
          actual == expected?
```
