# Synchronous FIFO with Assertions (Verilog)

This repository contains a Verilog implementation of a **Synchronous FIFO (First-In-First-Out)** buffer. The FIFO is designed to store and retrieve data in a first-in-first-out manner, typically used in digital systems where data needs to be temporarily stored and processed at different rates between producer and consumer units. The FIFO includes built-in **assertions** to validate correct functionality, such as ensuring data integrity, pointer increments, and proper handling of full/empty states.

## Features

- **Synchronous FIFO Design**: Implements a FIFO with support for read and write operations.
- **Parameterizable**: 
  - `DATA_WIDTH`: Width of the data bus (default: 6 bits).
  - `ADDR_WIDTH`: Address width for the memory (default: 4 bits).
- **FIFO Status Indicators**: Flags for full and empty conditions (`fifo_full`, `fifo_empty`).
- **FIFO Pointers**: Read and write pointers with handling for wraparound and boundary conditions.
- **Assertions**:
  - **Reset Behavior**: Ensures that both pointers reset to zero and FIFO is empty after reset.
  - **Data Integrity**: Validates that written data is read correctly.
  - **No Write When Full**: Ensures no writes occur when the FIFO is full.
  - **No Read When Empty**: Ensures no reads occur when the FIFO is empty.
  - **Pointer Increments**: Verifies correct increments for read and write pointers.
  
## How It Works

The FIFO module operates synchronously, where:
- The **write operation** is triggered when `write_enable` is high and the FIFO is not full.
- The **read operation** is triggered when `read_enable` is high and the FIFO is not empty.
- The FIFO uses two pointers: `read_ptr` and `write_ptr` to track the locations for reading and writing data.
- **FIFO full** and **FIFO empty** conditions are determined by comparing the `read_ptr` and `write_ptr`.

### FIFO Memory

The FIFO memory is implemented as a register array, and the size is determined by `ADDR_WIDTH` (number of address bits). The FIFO supports data widths defined by the `DATA_WIDTH` parameter.

### Assertions

- **Reset Behavior**: After a reset (`rst_n`), both `write_ptr` and `read_ptr` should be set to zero, and the FIFO should be empty.
- **Data Integrity**: Ensures that the data written into the FIFO can be successfully read back in the correct order.
- **No Write When Full**: Prevents writes to the FIFO when it is full.
- **No Read When Empty**: Prevents reads from the FIFO when it is empty.
- **Pointer Increments**: Ensures that the pointers (`read_ptr`, `write_ptr`) are incremented correctly on each valid operation.

### Example Usage

You can modify the testbench to perform different tests based on the FIFO's behavior:
1. **Basic Test**: Write data into the FIFO and read it back to check data integrity.
2. **Edge Cases**: Test FIFO behavior when full or empty.
3. **Pointer Tests**: Verify that pointers increment correctly during read and write operations.



## Testing & Validation

A testbench (`tb_syncFIFO.v`) is included to simulate the FIFO operation. It applies various test cases to verify the correctness of FIFO behavior, such as:
- Writing and reading data from the FIFO.
- Checking FIFO status signals (`fifo_full`, `fifo_empty`).
- Validating pointer increments and resets.

### Verilog Simulation Tools

To run simulations, you can use the following tools:
- **Vivado/XSIM**: Xilinx Vivado's simulation tool.



## Acknowledgments

- Verilog and FPGA design resources.
- Open-source simulation tools (EDA Playground, Vivado).
- Contributors who inspired FIFO design patterns and best practices.

