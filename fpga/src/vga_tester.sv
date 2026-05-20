
module vga_tester
(
  input  wire           pxl_clk       ,

  input  wire           S_AXI_ACLK    ,
  input  wire           S_AXI_ARESETN ,
  input  wire [31 : 0]  S_AXI_AWADDR  ,
  input  wire [2 : 0]   S_AXI_AWPROT  ,
  input  wire           S_AXI_AWVALID ,
  output wire           S_AXI_AWREADY ,
  input  wire [31 : 0]  S_AXI_WDATA   ,
  input  wire [3 : 0]   S_AXI_WSTRB   ,
  input  wire           S_AXI_WVALID  ,
  output wire           S_AXI_WREADY  ,
  output wire [1 : 0]   S_AXI_BRESP   ,
  output wire           S_AXI_BVALID  ,
  input  wire           S_AXI_BREADY  ,
  input  wire [31 : 0]  S_AXI_ARADDR  ,
  input  wire [2 : 0]   S_AXI_ARPROT  ,
  input  wire           S_AXI_ARVALID ,
  output wire           S_AXI_ARREADY ,
  output reg  [31 : 0]  S_AXI_RDATA   ,
  output wire [1 : 0]   S_AXI_RRESP   ,
  output wire           S_AXI_RVALID  ,
  input  wire           S_AXI_RREADY  ,

  output logic [3:0]    vga_r         ,
  output logic [3:0]    vga_g         ,
  output logic [3:0]    vga_b         ,
  output                vga_hs        ,
  output                vga_vs         
);

  wire         disp_en ;
  logic [3:0]  sw_red  ;
  logic [3:0]  sw_green;
  logic [3:0]  sw_blue ;

  always @(posedge pxl_clk)
  begin
    if(disp_en)
    begin
      vga_r <= sw_red;
      vga_g <= sw_green;
      vga_b <= sw_blue;
    end
    else
    begin
      vga_r <= 4'h0;
      vga_g <= 4'h0;
      vga_b <= 4'h0;
    end
  end

  vga_ctrl_640_480 #
  (
    .H_PULSE  (96 ),
    .H_BP     (48 ),
    .H_PIXELS (640),
    .H_FP     (16 ),
    .H_POL    (0  ),
    .V_PULSE  (2  ),
    .V_BP     (33 ),
    .V_PIXELS (480),
    .V_FP     (10 ),
    .V_POL    (1  )
  ) i_vga_ctrl_640_480
  (
    .clk      (pxl_clk     ),
    .reset_n  (1'b1        ),
    .h_sync   (vga_hs      ),
    .v_sync   (vga_vs      ),
    .disp_ena (disp_en     ),
    .col      (            ),
    .row      (            ),
    .n_blank  (vga_blank_n ),
    .n_sync   (vga_sync_n  ) 
  );

  vga_tester_regs 
  (
  
    .S_AXI_ACLK    (S_AXI_ACLK    ),
    .S_AXI_ARESETN (S_AXI_ARESETN ),
    .S_AXI_AWADDR  (S_AXI_AWADDR  ),
    .S_AXI_AWPROT  (S_AXI_AWPROT  ),
    .S_AXI_AWVALID (S_AXI_AWVALID ),
    .S_AXI_AWREADY (S_AXI_AWREADY ),
    .S_AXI_WDATA   (S_AXI_WDATA   ),
    .S_AXI_WSTRB   (S_AXI_WSTRB   ),
    .S_AXI_WVALID  (S_AXI_WVALID  ),
    .S_AXI_WREADY  (S_AXI_WREADY  ),
    .S_AXI_BRESP   (S_AXI_BRESP   ),
    .S_AXI_BVALID  (S_AXI_BVALID  ),
    .S_AXI_BREADY  (S_AXI_BREADY  ),
    .S_AXI_ARADDR  (S_AXI_ARADDR  ),
    .S_AXI_ARPROT  (S_AXI_ARPROT  ),
    .S_AXI_ARVALID (S_AXI_ARVALID ),
    .S_AXI_ARREADY (S_AXI_ARREADY ),
    .S_AXI_RDATA   (S_AXI_RDATA   ),
    .S_AXI_RRESP   (S_AXI_RRESP   ),
    .S_AXI_RVALID  (S_AXI_RVALID  ),
    .S_AXI_RREADY  (S_AXI_RREADY  ),
  		
     .vga_r        (sw_red        ),
     .vga_g        (sw_green      ),
     .vga_b        (sw_blue       )
  
  );




endmodule
