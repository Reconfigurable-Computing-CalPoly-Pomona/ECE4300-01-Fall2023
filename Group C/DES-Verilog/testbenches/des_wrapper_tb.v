`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 01:27:42 PM
// Design Name: 
// Module Name: des_wrapper_tb
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


module des_wrapper_tb();
    reg sys_clk_tb;      
    reg sys_rst_tb;
    reg show_upper_tb;
    reg show_lower_tb;
    reg dec_en_tb;
    reg cnt_rst_tb;
    reg cipher_rst_tb;
    reg [4:0] ref_clk_mode_tb;
    
    wire [6:0] SEG_tb;
    wire DP_tb;
    wire [7:0] AN_tb;

    des_wrapper GEN_TB(
        .sys_clk(sys_clk_tb),      
        .sys_rst(sys_rst_tb),
        .show_upper(show_upper_tb),
        .show_lower(show_lower_tb),
        .dec_en(dec_en_tb),
        .cnt_rst(cnt_rst_tb),
        .cipher_rst(cipher_rst_tb),
        .ref_clk_mode(ref_clk_mode_tb),
        .SEG(SEG_tb),
        .DP(DP_tb),
        .AN(AN_tb)
    );

    initial begin
        sys_clk_tb=0;
        sys_rst_tb = 1;
        show_upper_tb = 0;
        show_lower_tb = 0;
        dec_en_tb = 0;    
        cnt_rst_tb = 1;   
        cipher_rst_tb = 1;
        ref_clk_mode_tb = 2;
    end
        
    always begin
        #1 sys_clk_tb=~sys_clk_tb;
    end
    
    initial begin
        #2 sys_rst_tb = 0;
        #10 cnt_rst_tb = 0; cipher_rst_tb = 0;
        #10 show_upper_tb = 1;
        #10 show_upper_tb = 0; show_lower_tb = 1;
        #10 show_upper_tb = 1;
        #10 show_upper_tb = 0; show_lower_tb = 0;
    end

endmodule
