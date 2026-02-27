module pd(
    input clk_ref, clk_dco, rst,
    output up, down
);
    wire a;
    wire b;
    wire c;
    wire rst_i;

    dff_rl dFF_up(
        .clk(clk_ref),
        .rst(rst_i),
        .d(1'b1),
        .q(a)
    );

    dff_rl dFF_dwn(
        .clk(clk_dco),
        .rst(rst_i),
        .d(1'b1),
        .q(b)
    );

    assign c=a&b;
    assign up=a;
    assign down=b;
    assign rst_i=c|rst;

endmodule
