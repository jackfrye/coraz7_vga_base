
`timescale 1ns/1ns

module vga_ctrl_640_480 #
(
  // https://www.digikey.com/eewiki/pages/viewpage.action?pageId=15925278
  // Interfaces with ADV7123
  parameter integer H_PULSE  = 96 ,
  parameter integer H_BP     = 48 ,
  parameter integer H_PIXELS = 640,
  parameter integer H_FP     = 16 ,
  parameter integer H_POL    = 0  , // polarity
  parameter integer V_PULSE  = 2  ,
  parameter integer V_BP     = 33 ,
  parameter integer V_PIXELS = 480,
  parameter integer V_FP     = 10 ,
  parameter integer V_POL    = 1  
)
(
  input  wire        clk      ,     // 25.175 for 640x480
  input  wire        reset_n  ,
  output reg         h_sync   ,
  output reg         v_sync   ,
  output reg         disp_ena ,
  output reg [31:0]  col      ,
  output reg [31:0]  row      ,
  output reg         n_blank  ,
  output reg         n_sync    
);

  parameter integer H_PERIOD = H_PULSE + H_BP + H_PIXELS + H_FP;
  parameter integer V_PERIOD = V_PULSE + V_BP + V_PIXELS + V_FP;

  reg [31:0] h_count;
  reg [31:0] v_count;

  initial
  begin
    n_blank <= 1'b1;
    n_sync  <= 1'b0;
  end

  always @(posedge clk)
  begin
    if(~reset_n)
    begin
      h_count  <= 32'b0;
      v_count  <= 32'b0;
      h_sync   <= ~H_POL;
      v_sync   <= ~V_POL;
      disp_ena <= 1'b0;
      col      <= 32'b0;
      row      <= 32'b0;
    end
    else
    begin
      if(h_count < (H_PERIOD-1) )
      begin
        h_count <= h_count+1;
      end
      else
      begin
        h_count <= 32'b0;
        if(v_count < (V_PERIOD-1) )
        begin
          v_count <= v_count+1;
        end
        else
        begin
          v_count <= 32'b0;
        end 
      end

      if( (h_count < H_PIXELS+H_FP) || (h_count >= H_PIXELS+H_FP+H_PULSE) )
      begin
        h_sync <= ~H_POL;
      end
      else
      begin
        h_sync <= H_POL;
      end

      if( (v_count < V_PIXELS+V_FP) || (v_count >= V_PIXELS+V_FP+V_PULSE) )
      begin
        v_sync <= ~V_POL;
      end
      else
      begin
        v_sync <= V_POL;
      end

      if(h_count < H_PIXELS)
      begin
        col <= h_count;
      end

      if(v_count < V_PIXELS)
      begin
        row <= v_count;
      end

      if( (h_count < H_PIXELS) && (v_count < V_PIXELS) )
      begin
        disp_ena <= 1'b1;
      end
      else
      begin
        disp_ena <= 1'b0;
      end

    end
  end


endmodule
