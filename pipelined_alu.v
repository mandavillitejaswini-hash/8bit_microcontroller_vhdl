`timescale 1ns / 1ps
`timescale 1ns/1ps

module pipelined_alu #(
    parameter WIDTH = 8
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire [WIDTH-1:0]     A,
    input  wire [WIDTH-1:0]     B,
    input  wire [2:0]           opcode,

    output reg  [WIDTH-1:0]     result,
    output reg                  carry,
    output reg                  zero,
    output reg                  overflow,
    output reg                  negative
);

    //=====================================================
    // STAGE 1 : INPUT REGISTERS
    //=====================================================

    reg [WIDTH-1:0] A_r1, B_r1;
    reg [2:0]       op_r1;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            A_r1  <= 0;
            B_r1  <= 0;
            op_r1 <= 0;
        end
        else
        begin
            A_r1  <= A;
            B_r1  <= B;
            op_r1 <= opcode;
        end
    end

    //=====================================================
    // STAGE 2 : EXECUTION LOGIC
    //=====================================================

    reg [WIDTH:0]   add_sub;      // 9-bit for carry
    reg [WIDTH-1:0] alu_out;
    reg             carry_int;
    reg             overflow_int;

    always @(*)
    begin
        add_sub      = 0;
        alu_out      = 0;
        carry_int    = 0;
        overflow_int = 0;

        case(op_r1)

            // ADD
            3'b000:
            begin
                add_sub      = A_r1 + B_r1;
                alu_out      = add_sub[WIDTH-1:0];
                carry_int    = add_sub[WIDTH];

                overflow_int =
                   (~A_r1[WIDTH-1] & ~B_r1[WIDTH-1] & alu_out[WIDTH-1]) |
                   ( A_r1[WIDTH-1] &  B_r1[WIDTH-1] & ~alu_out[WIDTH-1]);
            end

            // SUB
            3'b001:
            begin
                add_sub      = A_r1 - B_r1;
                alu_out      = add_sub[WIDTH-1:0];
                carry_int    = add_sub[WIDTH];

                overflow_int =
                   ( A_r1[WIDTH-1] & ~B_r1[WIDTH-1] & ~alu_out[WIDTH-1]) |
                   (~A_r1[WIDTH-1] &  B_r1[WIDTH-1] &  alu_out[WIDTH-1]);
            end

            // AND
            3'b010:
            begin
                alu_out = A_r1 & B_r1;
            end

            // OR
            3'b011:
            begin
                alu_out = A_r1 | B_r1;
            end

            // XOR
            3'b100:
            begin
                alu_out = A_r1 ^ B_r1;
            end

            // NOT
            3'b101:
            begin
                alu_out = ~A_r1;
            end

            // SHIFT LEFT
            3'b110:
            begin
                alu_out   = A_r1 << 1;
                carry_int = A_r1[WIDTH-1];
            end

            // SHIFT RIGHT
            3'b111:
            begin
                alu_out   = A_r1 >> 1;
                carry_int = A_r1[0];
            end

            default:
            begin
                alu_out      = 0;
                carry_int    = 0;
                overflow_int = 0;
            end

        endcase
    end

    //=====================================================
    // STAGE 3 : OUTPUT REGISTERS
    //=====================================================

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            result   <= 0;
            carry    <= 0;
            overflow <= 0;
        end
        else
        begin
            result   <= alu_out;
            carry    <= carry_int;
            overflow <= overflow_int;
        end
    end

    //=====================================================
    // FLAGS
    //=====================================================

    always @(*)
    begin
        zero     = (result == 0);
        negative = result[WIDTH-1];
    end

endmodule
