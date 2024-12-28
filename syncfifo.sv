module syncFIFO #(parameter DATA_WIDTH = 6, parameter ADDR_WIDTH = 4) 
(
  input wire clk,
  input wire rst_n,
  input wire [DATA_WIDTH-1:0] data_in,
  input wire write_enable,
  input wire read_enable,
  output reg [DATA_WIDTH-1:0] data_out,
  output wire fifo_full,
  output wire fifo_empty
);

  // Memory array declaration
  reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0];

  // Read and write pointers with an extra bit for full/empty distinction
  reg [ADDR_WIDTH:0] read_ptr, write_ptr;

  // Request signals for read and write operations
  wire read_request = read_enable && !fifo_empty;
  wire write_request = write_enable && !fifo_full;

  // Fill level calculation
  wire [ADDR_WIDTH:0] fill_level = write_ptr - read_ptr;
  assign fifo_empty = (fill_level == 0);
  assign fifo_full = (fill_level == {1'b1, {ADDR_WIDTH{1'b0}}});

  // Write operation
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      write_ptr <= 0;
    end else if (write_request) begin
      memory[write_ptr[ADDR_WIDTH-1:0]] <= data_in;
      write_ptr <= write_ptr + 1'b1;
    end
  end

  // Read operation
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      read_ptr <= 0;
    end else if (read_request) begin
      read_ptr <= read_ptr + 1'b1;
    end
  end

  // Combinational read
  assign data_out = memory[read_ptr[ADDR_WIDTH-1:0]];

  // Assertions to validate FIFO behavior

  // Assertion: FIFO pointers reset correctly on reset
  property reset_behavior;
    @(posedge clk) !rst_n |-> ##1 (write_ptr == 0 && read_ptr == 0 && fifo_empty);
  endproperty
  assert property (reset_behavior) else $display("Reset behavior assertion failed at time: %0t", $time);

  // Assertion: Written data is correctly read back
  sequence read_event(ptr);
    ##[0:$] (read_enable && !fifo_empty && (read_ptr == ptr));
  endsequence

  property data_integrity(write_pointer);
    integer ptr, stored_data;
    @(posedge clk) disable iff (!rst_n)
      (write_enable && !fifo_full, ptr = write_pointer, stored_data = data_in)
        |-> ##1 first_match(read_event(ptr)) ##0 (data_out == stored_data);
  endproperty
  assert property (data_integrity(write_ptr)) else $display("Data integrity assertion failed at time: %0t", $time);

  // Assertion: No write when FIFO is full
  property no_write_when_full;
    @(posedge clk) disable iff (!rst_n) write_enable && fifo_full |-> ##1 write_ptr == $past(write_ptr);
  endproperty
  assert property (no_write_when_full) else $display("Write when full assertion failed at time: %0t", $time);

  // Assertion: No read when FIFO is empty
  property no_read_when_empty;
    @(posedge clk) disable iff (!rst_n) read_enable && fifo_empty |-> ##1 read_ptr == $past(read_ptr);
  endproperty
  assert property (no_read_when_empty) else $display("Read when empty assertion failed at time: %0t", $time);

  // Assertion: Write pointer increments correctly
  property write_pointer_increment;
    @(posedge clk) disable iff (!rst_n) write_enable && !fifo_full |-> ##1 (write_ptr == $past(write_ptr) + 1);
  endproperty
  assert property (write_pointer_increment) else $display("Write pointer increment assertion failed at time: %0t", $time);

  // Assertion: Read pointer increments correctly
  property read_pointer_increment;
    @(posedge clk) disable iff (!rst_n) read_enable && !fifo_empty |-> ##1 (read_ptr == $past(read_ptr) + 1);
  endproperty
  assert property (read_pointer_increment) else $display("Read pointer increment assertion failed at time: %0t", $time);

endmodule
