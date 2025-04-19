# Single-Cycle-Processor
Implementing a basic single cycle processor in verilog


Simulation Results Demonstarting the following instructions

```assembly
MOV ACC, R1 ; Load R1 in ACC
XRA R1 ; clears ACC
ADD R5 ; ACC+R5
ADD R6; ACC + R6 (which is R5+R6)
MOV R7, ACC;
```
![image](https://github.com/user-attachments/assets/01a9064c-d179-4569-99cc-a0e6bceb2187)


The following instructions are supported
### Instruction Set Architecture

| Instruction      | Opcode     | Operand Format         | Description                                                                 |
|------------------|------------|-------------------------|-----------------------------------------------------------------------------|
| NOP              | `0000 0000`| None                    | No operation                                                                |
| ADD Ri           | `0001 xxxx`| Register address        | Add ACC with Register Ri, store result in ACC, update C/B                   |
| SUB Ri           | `0010 xxxx`| Register address        | Subtract Register Ri from ACC, store result in ACC, update C/B             |
| MUL Ri           | `0011 xxxx`| Register address        | Multiply ACC with Register Ri, store result in ACC, update EXT             |
| LSL ACC          | `0000 0001`| None                    | Logical shift left ACC (no C/B update)                                     |
| LSR ACC          | `0000 0010`| None                    | Logical shift right ACC (no C/B update)                                    |
| CIR ACC          | `0000 0011`| None                    | Circular right shift ACC (no C/B update)                                   |
| CIL ACC          | `0000 0100`| None                    | Circular left shift ACC (no C/B update)                                    |
| ASR ACC          | `0000 0101`| None                    | Arithmetic shift right ACC                                                 |
| AND Ri           | `0101 xxxx`| Register address        | Bitwise AND ACC with Ri, store result in ACC (no C/B update)               |
| XRA Ri           | `0110 xxxx`| Register address        | Bitwise XOR ACC with Ri, store result in ACC (no C/B update)               |
| CMP Ri           | `0111 xxxx`| Register address        | Compare ACC with Ri (ACC - Ri), update C/B (C/B=1 if ACC < Ri, else 0)     |
| INC ACC          | `0000 0110`| None                    | Increment ACC, update C/B on overflow                                       |
| DEC ACC          | `0000 0111`| None                    | Decrement ACC, update C/B on underflow                                      |
| Br addr          | `1000 xxxx`| 4-bit address (label)   | Branch to address if C/B = 1                                                |
| MOV ACC, Ri      | `1001 xxxx`| Register address        | Move value from Ri to ACC                                                   |
| MOV Ri, ACC      | `1010 xxxx`| Register address        | Move value from ACC to Ri                                                   |
| Ret addr         | `1011 xxxx`| 4-bit address (label)   | Return to program address                                                   |
| HLT              | `1111 1111`| None                    | Halt program execution                                                      |





