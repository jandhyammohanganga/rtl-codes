/*Design a Multi-Bank Memory System:
Spec:
- Implement a memory system consisting of 4 banks, each 256x8 bit.
- Input: addr[9:0], din[7:0], we, clk. Output: dout[7:0].
- Bank select: addr[9:8] chooses which bank (0–3). Word select: addr[7:0] chooses location within bank.
- Write/read to correct the bank on the clock.
- Testbench: Verify that each bank stores data independently, and writes to one bank don't overwrite others.*/

module multibank_memory (
input wire clk,
input wire we, // Write Enable: 1 = Write, 0 = Read
input wire [9:0] addr, // addr[9:8] = Bank Select, addr[7:0] = Word Address
input wire [7:0] din,
output reg [7:0] dout
);
// 4 memory banks, each 256 x 8-bit
reg [7:0] bank0 [0:255];
reg [7:0] bank1 [0:255];
reg [7:0] bank2 [0:255];
reg [7:0] bank3 [0:255];
wire [1:0] bank_sel = addr[9:8];
wire [7:0] word_addr = addr[7:0];
// Synchronous Write Operation
always @(posedge clk) begin
if (we) begin
case (bank_sel)
2'b00: bank0[word_addr] <= din;
2'b01: bank1[word_addr] <= din;
2'b10: bank2[word_addr] <= din;
2'b11: bank3[word_addr] <= din;
endcase
end
end
// Synchronous Read Operation
always @(posedge clk) begin
if (!we) begin
case (bank_sel)
2'b00: dout <= bank0[word_addr];
2'b01: dout <= bank1[word_addr];
2'b10: dout <= bank2[word_addr];
2'b11: dout <= bank3[word_addr];
endcase
end
end
endmodule

