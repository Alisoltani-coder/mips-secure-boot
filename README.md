# MIPS Dual-Mode Processor with Secure Boot

This repository contains the Verilog implementation of a custom MIPS processor featuring a dual-mode architecture (Secure and User modes) and a hardware-level Secure Boot mechanism. 

## Features
*   **Custom MIPS Core:** Supports standard ALU operations, memory access, branching, and jumping.
*   **Dual-Mode Operation:** Incorporates a hardware `Mode_Bit` and a custom `DROP_PRIV` instruction to securely transition the processor from Secure Mode to User Mode.
*   **Memory Router:** Hardware-level access control that enforces memory boundaries based on the active privilege mode.
*   **Crypto Accelerator:** An MMIO-based hardware accelerator utilizing an XOR Accumulator to verify the integrity of the user program before execution.
*   **Hardware Execution Watchdog:** A standalone module that continuously monitors the Program Counter and triggers a system reset if illegal memory fetches occur during Secure Mode.

## File Structure
*   `*.v`: Verilog source files for the processor, memory modules, router, watchdog, and testbenches.
*   `*.hex`: Hexadecimal machine code files pre-loaded into the ROM and RAM during simulation.
*   `*.asm`: Reference Assembly files containing the source code for the Boot ROM and User programs (for documentation purposes).

## Execution Guide (ModelSim)
To verify the functionality of the system on either a Windows or Ubuntu Linux environment, please follow these step-by-step instructions:

1.  **Environment Setup:** Open ModelSim and create a new project. Set the project location to the directory containing all repository files.
2.  **Add Source Files:** Add all `.v` files to the project. Ensure the `.hex` files are physically present in the same root directory as the Verilog files so the `$readmemh` system task can locate them.
3.  **Compile:** Right-click in the project workspace and select **Compile > Compile All**. Ensure there are no compilation errors.
4.  **Simulation Scenarios:** Start a simulation (`Simulate > Start Simulation`) and choose one of the following testbenches from the `work` library:
    *   **`tb_success_boot`:** Simulates a valid user program. The Boot ROM will successfully verify the hash, switch the `Mode_Bit` to `0`, and transfer execution to the User RAM.
    *   **`tb_tampered_program`:** Simulates a modified/corrupted user program. The hash verification will fail, and the system will safely halt in Secure Mode (`Mode_Bit = 1`).
5.  **Observation:** Add the top-level signals (such as `pc`, `Mode_Bit`, `Watchdog_rst`, and registers) to the Wave window. Type `run -all` in the transcript or run the simulation for at least `2000 ns`. Observe the output messages in the transcript console and analyze the signal transitions in the Wave window.

## Authors
*   Mohammad Hosseini
*   Ali Soltani