
module top (
  inout [14:0]  DDR_addr         ,
  inout [2:0]   DDR_ba           ,
  inout         DDR_cas_n        ,
  inout         DDR_ck_n         ,
  inout         DDR_ck_p         ,
  inout         DDR_cke          ,
  inout         DDR_cs_n         ,
  inout [3:0]   DDR_dm           ,
  inout [31:0]  DDR_dq           ,
  inout [3:0]   DDR_dqs_n        ,
  inout [3:0]   DDR_dqs_p        ,
  inout         DDR_odt          ,
  inout         DDR_ras_n        ,
  inout         DDR_reset_n      ,
  inout         DDR_we_n         ,
  inout         FIXED_IO_ddr_vrn ,
  inout         FIXED_IO_ddr_vrp ,
  inout [53:0]  FIXED_IO_mio     ,
  inout         FIXED_IO_ps_clk  ,
  inout         FIXED_IO_ps_porb ,
  inout         FIXED_IO_ps_srstb,
  
  output [3:0]  vga_r            ,
  output [3:0]  vga_g            ,
  output [3:0]  vga_b            ,
  output        vga_hs           ,
  output        vga_vs             
);

  logic reg_clk;
  logic reg_clk_rstn;
  logic sys_clk;
  logic pxl_clk;

  logic [31:0]  vga_regs_araddr  ;
  logic [2:0]   vga_regs_arprot  ;
  logic         vga_regs_arready ;
  logic         vga_regs_arvalid ;
  logic [31:0]  vga_regs_awaddr  ;
  logic [2:0]   vga_regs_awprot  ;
  logic         vga_regs_awready ;
  logic         vga_regs_awvalid ;
  logic         vga_regs_bready  ;
  logic [1:0]   vga_regs_bresp   ;
  logic         vga_regs_bvalid  ;
  logic [31:0]  vga_regs_rdata   ;
  logic         vga_regs_rready  ;
  logic [1:0]   vga_regs_rresp   ;
  logic         vga_regs_rvalid  ;
  logic [31:0]  vga_regs_wdata   ;
  logic         vga_regs_wready  ;
  logic [3:0]   vga_regs_wstrb   ;
  logic         vga_regs_wvalid  ;

  logic [31:0] video_processor_m_axis_tdata  ;
  logic [3:0]  video_processor_m_axis_tkeep  ;
  logic        video_processor_m_axis_tlast  ;
  logic        video_processor_m_axis_tready ;
  logic        video_processor_m_axis_tvalid ;
  
  logic [31:0] video_processor_s_axis_tdata  ;
  logic [3:0]  video_processor_s_axis_tkeep  ;
  logic        video_processor_s_axis_tlast  ;
  logic        video_processor_s_axis_tready ;
  logic        video_processor_s_axis_tvalid ;

  assign video_processor_s_axis_tdata  = video_processor_m_axis_tdata  ;
  assign video_processor_s_axis_tkeep  = video_processor_m_axis_tkeep  ;
  assign video_processor_s_axis_tlast  = video_processor_m_axis_tlast  ;
  assign video_processor_s_axis_tvalid = video_processor_m_axis_tvalid ;
  assign video_processor_m_axis_tready = video_processor_s_axis_tready ;

  zynq_ps u_zynq_ps
  (
    .DDR_addr              (DDR_addr         ),
    .DDR_ba                (DDR_ba           ),
    .DDR_cas_n             (DDR_cas_n        ),
    .DDR_ck_n              (DDR_ck_n         ),
    .DDR_ck_p              (DDR_ck_p         ),
    .DDR_cke               (DDR_cke          ),
    .DDR_cs_n              (DDR_cs_n         ),
    .DDR_dm                (DDR_dm           ),
    .DDR_dq                (DDR_dq           ),
    .DDR_dqs_n             (DDR_dqs_n        ),
    .DDR_dqs_p             (DDR_dqs_p        ),
    .DDR_odt               (DDR_odt          ),
    .DDR_ras_n             (DDR_ras_n        ),
    .DDR_reset_n           (DDR_reset_n      ),
    .DDR_we_n              (DDR_we_n         ),
    
    .FIXED_IO_ddr_vrn      (FIXED_IO_ddr_vrn ),
    .FIXED_IO_ddr_vrp      (FIXED_IO_ddr_vrp ),
    .FIXED_IO_mio          (FIXED_IO_mio     ),
    .FIXED_IO_ps_clk       (FIXED_IO_ps_clk  ),
    .FIXED_IO_ps_porb      (FIXED_IO_ps_porb ),
    .FIXED_IO_ps_srstb     (FIXED_IO_ps_srstb),
    
    .vga_axis_tdata         (),
    .vga_axis_tkeep         (),
    .vga_axis_tlast         (),
    .vga_axis_tready        (),
    .vga_axis_tvalid        (),
    
    .vga_regs_araddr  (vga_regs_araddr ),
    .vga_regs_arprot  (vga_regs_arprot ),
    .vga_regs_arready (vga_regs_arready),
    .vga_regs_arvalid (vga_regs_arvalid),
    .vga_regs_awaddr  (vga_regs_awaddr ),
    .vga_regs_awprot  (vga_regs_awprot ),
    .vga_regs_awready (vga_regs_awready),
    .vga_regs_awvalid (vga_regs_awvalid),
    .vga_regs_bready  (vga_regs_bready ),
    .vga_regs_bresp   (vga_regs_bresp  ),
    .vga_regs_bvalid  (vga_regs_bvalid ),
    .vga_regs_rdata   (vga_regs_rdata  ),
    .vga_regs_rready  (vga_regs_rready ),
    .vga_regs_rresp   (vga_regs_rresp  ),
    .vga_regs_rvalid  (vga_regs_rvalid ),
    .vga_regs_wdata   (vga_regs_wdata  ),
    .vga_regs_wready  (vga_regs_wready ),
    .vga_regs_wstrb   (vga_regs_wstrb  ),
    .vga_regs_wvalid  (vga_regs_wvalid ),

    .video_processor_regs_araddr   (),
    .video_processor_regs_arprot   (),
    .video_processor_regs_arready  (1'b1),
    .video_processor_regs_arvalid  (),
    .video_processor_regs_awaddr   (),
    .video_processor_regs_awprot   (),
    .video_processor_regs_awready  (1'b1),
    .video_processor_regs_awvalid  (),
    .video_processor_regs_bready   (),
    .video_processor_regs_bresp    (),
    .video_processor_regs_bvalid   (1'b1),
    .video_processor_regs_rdata    (32'hdeaddead),
    .video_processor_regs_rready   (),
    .video_processor_regs_rresp    (),
    .video_processor_regs_rvalid   (1'b1),
    .video_processor_regs_wdata    (),
    .video_processor_regs_wready   (1'b1),
    .video_processor_regs_wstrb    (),
    .video_processor_regs_wvalid   (),

    .video_processor_m_axis_tdata  (video_processor_m_axis_tdata ),
    .video_processor_m_axis_tkeep  (video_processor_m_axis_tkeep ),
    .video_processor_m_axis_tlast  (video_processor_m_axis_tlast ),
    .video_processor_m_axis_tready (video_processor_m_axis_tready),
    .video_processor_m_axis_tvalid (video_processor_m_axis_tvalid),
    
    .video_processor_s_axis_tdata  (video_processor_s_axis_tdata  ),
    .video_processor_s_axis_tkeep  (video_processor_s_axis_tkeep  ),
    .video_processor_s_axis_tlast  (video_processor_s_axis_tlast  ),
    .video_processor_s_axis_tready (video_processor_s_axis_tready ),
    .video_processor_s_axis_tvalid (video_processor_s_axis_tvalid ),
    
    .pxl_clk               (pxl_clk     ),
    .reg_clk               (reg_clk     ),
    .sys_clk               (sys_clk     ),
    .FCLK_RESET0_N_0       (reg_clk_rstn)
  );

  vga_tester u_vga
  (
    .pxl_clk       (pxl_clk          ),
  
    .S_AXI_ACLK    (reg_clk          ),
    .S_AXI_ARESETN (reg_clk_rstn     ),
    
    .S_AXI_AWADDR  (vga_regs_awaddr  ),
    .S_AXI_AWPROT  (vga_regs_awprot  ),
    .S_AXI_AWVALID (vga_regs_awvalid ),
    .S_AXI_AWREADY (vga_regs_awready ),
    .S_AXI_WDATA   (vga_regs_wdata   ),
    .S_AXI_WSTRB   (vga_regs_wstrb   ),
    .S_AXI_WVALID  (vga_regs_wvalid  ),
    .S_AXI_WREADY  (vga_regs_wready  ),
    .S_AXI_BRESP   (vga_regs_bresp   ),
    .S_AXI_BVALID  (vga_regs_bvalid  ),
    .S_AXI_BREADY  (vga_regs_bready  ),
    .S_AXI_ARADDR  (vga_regs_araddr  ),
    .S_AXI_ARPROT  (vga_regs_arprot  ),
    .S_AXI_ARVALID (vga_regs_arvalid ),
    .S_AXI_ARREADY (vga_regs_arready ),
    .S_AXI_RDATA   (vga_regs_rdata   ),
    .S_AXI_RRESP   (vga_regs_rresp   ),
    .S_AXI_RVALID  (vga_regs_rvalid  ),
    .S_AXI_RREADY  (vga_regs_rready  ),
  
    .vga_r         (vga_r            ),
    .vga_g         (vga_g            ),
    .vga_b         (vga_b            ),
    .vga_hs        (vga_hs           ),
    .vga_vs        (vga_vs           )
  );


endmodule