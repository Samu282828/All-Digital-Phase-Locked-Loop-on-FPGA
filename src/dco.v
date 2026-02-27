module dco(
    input carry, borrow, ID_clk, rst,
    output dco_out
);
    wire ID_out;
    ID_counter id_cnt(
        .carry(carry),
        .borrow(borrow),
        .ID_clk(ID_clk),
        .rst(rst),
        .ID_out(ID_out)
    );

    N_div n_divider(
        .clk(ID_out),
        .rst(rst),
        .clk_d(dco_out)
    );

endmodule