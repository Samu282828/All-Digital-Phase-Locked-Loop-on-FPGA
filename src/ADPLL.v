module ADPLL(
    input clk_ref, clk_int, rst,
    output clk_out
);
    wire k_ID;

    ID_K_generator clk_k_ID_generator(
        .clk(clk_int),
        .rst(rst),
        .clk_d(k_ID)
    );

    wire clk_div;
    wire ud;

    pd XOR_detector(
        .u1(clk_ref),
        .u2(clk_div),
        .ud(ud)
    );

    wire cnt_carry;
    wire cnt_borrow;

    k_counter up_down_counter(
        .k_clk(k_ID),
        .ud(ud),
        .rst(rst),
        .carry(cnt_carry),
        .borrow(cnt_borrow)
    );

    dco DCO(
        .carry(cnt_carry),
        .borrow(cnt_borrow),
        .ID_clk(k_ID),
        .rst(rst),
        .dco_out(clk_div)
    );

    assign clk_out=clk_div;

endmodule