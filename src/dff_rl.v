module dff_rl(
    input clk, rst,
    input d,
    output reg q
);

    always @(posedge clk or posedge rst)begin
        if(rst==1) 
            q  <= 1'b0;
        else
            q  <= d;
    end
endmodule