module adpll(
    input clk_ref,g_rst,ID_clk,
    output clk_dco
);

wire reset;

reset_synchronizer rst_sync1(
    .clk(ID_clk),
    .rst_async(g_rst),
    .rst_sync(reset)
);

wire upo;
wire downo;
wire dco_clk;

pd pd1(
     .clk_ref(clk_ref),
     .clk_dco(dco_clk),
     .rst(reset),
     .up(upo),
     .down(downo)                 
);

wire up_sync_pulse;
wire down_sync_pulse;

pfd_interface pfd_int1(
    .clk(ID_clk),
    .rst(reset),
    .up_async(upo),
    .down_async(downo),
    .up_sync_pulse(up_sync_pulse),
    .down_sync_pulse(down_sync_pulse)
);

wire signed [12:0] k_sig;

PI_filter #(
    .P_GAIN(1),
    .I_GAIN(1),
    .p_threshold(5),
    .i_threshold(5)
) pi_filter1(
    .rst(reset),
    .clk(ID_clk),
    .up(up_sync_pulse),
    .down(down_sync_pulse),
    .K_out(k_sig)
);

dco_th #(
    .BASE_THRESHOLD(2500),
    .THRESHOLD_MIN(10),
    .THRESHOLD_MAX(4990)
) dco1(
    .clk(ID_clk),
    .rst(reset),
    .K_signed(k_sig),
    .dco_out(dco_clk)
);

assign clk_dco=dco_clk;

endmodule