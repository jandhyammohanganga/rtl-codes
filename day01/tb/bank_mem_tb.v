//test bench for multibank memory
module tb_multibank_memory;
reg clk;
reg we;
reg [9:0] addr;
reg [7:0] din;
wire [7:0] dout;
 multibank_memory uut (
 .clk(clk), .we(we), .addr(addr), .din(din), .dout(dout)
 );
always #5 clk = ~clk;
initial begin
 clk = 0; we = 0; addr = 0; din = 0;
 #10;
 $display("=== Phase 1: Writing distinct data to same word address (0x10) across all 4 banks ===");
 write_mem(2'd0, 8'h10, 8'hAA); // Bank 0: 0xAA
 write_mem(2'd1, 8'h10, 8'hBB); // Bank 1: 0xBB
 write_mem(2'd2, 8'h10, 8'hCC); // Bank 2: 0xCC
 write_mem(2'd3, 8'h10, 8'hDD); // Bank 3: 0xDD
 $display("=== Phase 2: Reading back each bank to confirm data isolation ===");
 read_and_check(2'd0, 8'h10, 8'hAA);
 read_and_check(2'd1, 8'h10, 8'hBB);
 read_and_check(2'd2, 8'h10, 8'hCC);
 read_and_check(2'd3, 8'h10, 8'hDD);
 $display("=== Phase 3: Overwriting Bank 1 only, verifying Banks 0, 2, 3 remain intact ===");
 write_mem(2'd1, 8'h10, 8'h55);
 read_and_check(2'd0, 8'h10, 8'hAA); // Must remain intact
 read_and_check(2'd1, 8'h10, 8'h55); // Updated
 read_and_check(2'd2, 8'h10, 8'hCC); // Must remain intact
 read_and_check(2'd3, 8'h10, 8'hDD); // Must remain intact
 $display("ALL MULTI-BANK MEMORY CHECKS PASSED!");
 $finish;
end
task write_mem(input [1:0] b, input [7:0] w, input [7:0] data);
 @(negedge clk);
 we = 1; addr = {b, w}; din = data;
 @(posedge clk);
endtask
task read_and_check(input [1:0] b, input [7:0] w, input [7:0] exp_data);
 @(negedge clk);
 we = 0; addr = {b, w};
 @(posedge clk);
 #1;
if (dout === exp_data)
 $display("[PASS] Bank %0d, Addr 0x%02h => Got: 0x%02h", b, w, dout);
else
 $error("[FAIL] Bank %0d, Addr 0x%02h => Expected: 0x%02h, Got: 0x%02h", b, w, exp_data, dout);
endtask
endmodule
