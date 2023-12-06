`timescale 1ns / 1ps

module Clock_Divider(
    input sys_clk,
    input sys_rst,
    //input [4:0] div1, div2, div3,
    //output clk1, clk2, clk3
    input ref_clk_mode,
    output ref_clk_out

    );
    
    wire [31:0] cnt_tmp;
  
          nbit_counter #(.DATA_SIZE(32)) CLK_CNT(
              .clk(sys_clk),
              .reset(sys_rst),
              .counter(cnt_tmp)
          );
          
          nbit_mux #(.DATA_SIZE(5)) CLK_MUX1(
              .muxNx1_d(cnt_tmp),
              .muxNx1_s(ref_clk_mode),
              .muxNx1_y(ref_clk_out)
          );
    
endmodule
