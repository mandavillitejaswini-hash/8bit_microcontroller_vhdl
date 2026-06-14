`timescale 1ns/1ps

module tb;

parameter WIDTH = 8;

reg clk, rst;
reg [WIDTH-1:0] A, B;
reg [2:0] opcode;

wire [WIDTH-1:0] result;
wire carry, zero;
wire overflow, negative;

// DUT Instantiation
pipelined_alu #(.WIDTH(WIDTH)) dut (
    .clk(clk),
    .rst(rst),
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(result),
    .carry(carry),
    .zero(zero),
    .negative(negative),
    .overflow(overflow)
);

// Clock Generation (10ns period)
always #5 clk = ~clk;

initial begin

    // Initialize Inputs
    clk = 0;
    rst = 1;
    A = 0;
    B = 0;
    opcode = 0;

    // Reset
    #12 rst = 0;

    // =====================================================
    // BASIC ALU OPERATIONS
    // =====================================================

    // ADD : 10 + 5 = 15
    A = 8'd10; B = 8'd5; opcode = 3'b000;
    #10;

    // SUB : 20 - 7 = 13
    A = 8'd20; B = 8'd7; opcode = 3'b001;
    #10;

    // AND
    A = 8'b11001100;
    B = 8'b10101010;
    opcode = 3'b010;
    #10;

    // OR
    A = 8'b11001100;
    B = 8'b10101010;
    opcode = 3'b011;
    #10;

    // XOR
    A = 8'b11001100;
    B = 8'b10101010;
    opcode = 3'b100;
    #10;

    // NOT
    A = 8'b00001111;
    B = 8'b00000000;
    opcode = 3'b101;
    #10;

    // SHIFT LEFT
    A = 8'b00000101;
    B = 8'b00000000;
    opcode = 3'b110;
    #10;

    // SHIFT RIGHT
    A = 8'b00010100;
    B = 8'b00000000;
    opcode = 3'b111;
    #10;

    // =====================================================
    // FLAG TEST CASES
    // =====================================================

    // Carry Flag = 1
    // 255 + 1 = 256
    A = 8'hFF;
    B = 8'h01;
    opcode = 3'b000;
    #10;

    // Overflow Flag = 1, Negative Flag = 1
    // +127 + 1 = -128 (signed overflow)
    A = 8'h7F;
    B = 8'h01;
    opcode = 3'b000;
    #10;

    // Negative Flag = 1
    // 5 - 10 = -5
    A = 8'd5;
    B = 8'd10;
    opcode = 3'b001;
    #10;

    // Carry = 1 and Overflow = 1
    // -128 + (-128)
    A = 8'h80;
    B = 8'h80;
    opcode = 3'b000;
    #10;

    // =====================================================
    // EXTRA TESTS
    // =====================================================

    // Random Add
    A = 8'd55;
    B = 8'd22;
    opcode = 3'b000;
    #10;

    // Random Sub
    A = 8'd100;
    B = 8'd50;
    opcode = 3'b001;
    #10;

    // Wait for pipeline to flush
    #50;

    $finish;

end

endmodule