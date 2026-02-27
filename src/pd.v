module pd(
    input u1, u2,
    output ud
);

    assign ud= u1 ^ u2;

endmodule