`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 12:51:42 PM
// Design Name: 
// Module Name: des_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module des_wrapper(
    input sys_clk,      
    input sys_rst,      // Button
    input show_upper,
    input show_lower,
    input dec_en,
    input cnt_rst,
    input cipher_rst,
    input [4:0] ref_clk_mode,
    
    output [6:0] SEG,
    output DP,
    output [7:0] AN
);
    
    wire ref_clk;
    wire [31:0] upper_cipher;
    wire [31:0] lower_cipher;
    reg [31:0] seg_disp_in;

    Clock_Divider GEN_CLK_DIV(
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .ref_clk_mode(ref_clk_mode),
        .ref_clk_out(ref_clk)
    );
    
    display_driver_8dig GEN_DISPLAY_DRIVER(
        .in(seg_disp_in),     // Inputs
        .clk(ref_clk),
        .dec_en(dec_en),
        .cnt_rst(cnt_rst),
        .seg(SEG),           // Outputs
        .dp(DP),
        .an(AN)
    );
    
    Encrypt GEN_ENCRYPT(
        .message(64'b0000_0001_0010_0011_0100_0101_0110_0111_1000_1001_1010_1011_1100_1101_1110_1111),
        .key(64'b00010011_00110100_01010111_01111001_10011011_10111100_11011111_11110001),
        .ciphertext({upper_cipher,lower_cipher})
    );
    
    always @(ref_clk) begin
        if(cipher_rst)
            seg_disp_in <= 0;
        else            
            case({show_upper, show_lower})
                2'b00:seg_disp_in<=0;
                2'b01:seg_disp_in<=lower_cipher;
                2'b10:seg_disp_in<=upper_cipher;
                2'b11:seg_disp_in<=0;
                default:seg_disp_in<=0;
            endcase
    end

endmodule