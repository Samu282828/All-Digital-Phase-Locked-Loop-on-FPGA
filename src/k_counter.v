module k_counter(
    input k_clk, ud, rst,
    output carry, borrow
);

    wire up;
    wire down;
    assign up = ud;
    assign down = ~ud;

    counter #(.k(4)) up_counter(
        .in(up),
        .clk(k_clk),
        .rst(rst),
        .out(carry)
    );

    counter #(.k(4)) down_counter(
        .in(down),
        .clk(k_clk),
        .rst(rst),
        .out(borrow)
    );

endmodule