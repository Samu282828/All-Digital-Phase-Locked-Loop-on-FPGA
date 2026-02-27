module ID_counter(
    input carry,borrow,ID_clk,rst,
    output ID_out
);
    wire fsm_out;
    FSM toggle_ff(
        .carry(carry),
        .borrow(borrow),
        .ID_clk(ID_clk),
        .rst(rst),
        .fsm_out(fsm_out)
    );

    assign ID_out=~(ID_clk|fsm_out);

endmodule