// Testbench for the synchronous FIFO
module syncFIFO_tb;

  parameter DATA_WIDTH = 6;
  parameter ADDR_WIDTH = 4;

  reg clk, rst_n;
  reg [DATA_WIDTH-1:0] data_in;
  reg write_enable, read_enable;
  wire [DATA_WIDTH-1:0] data_out;
  wire fifo_full, fifo_empty;

  syncFIFO #(DATA_WIDTH, ADDR_WIDTH) fifo_instance (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .write_enable(write_enable),
    .read_enable(read_enable),
    .data_out(data_out),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty)
  );

  initial begin
    $dumpfile("fifo_test.vcd");
    $dumpvars;
  end

  initial begin
    clk = 0;
    rst_n = 0;
    write_enable = 0;
    read_enable = 0;
    data_in = 0;
    #100 rst_n = 1;

    write_task;
    #20;
    @(negedge clk);
    write_enable = 0;
    read_task;
    #10;
    write_task;
    #100 $finish;
  end

  always #5 clk = ~clk;

  task write_task;
    begin
      @(negedge clk);
      write_enable = 1;
      repeat(10) begin
        @(negedge clk);
        data_in = $urandom($random) % 16;
        @(posedge clk);
      end
    end
  endtask

  task read_task;
    begin
      @(negedge clk);
      read_enable = 1;
      repeat(10) begin
        @(posedge clk);
      end
    end
  endtask

endmodule
