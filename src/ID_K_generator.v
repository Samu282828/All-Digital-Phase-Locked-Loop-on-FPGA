module ID_K_generator(
    input clk, rst,
    output reg clk_d
);

integer cnt=0;

    always@(posedge clk or posedge rst)
    begin
        if(rst==1)
            clk_d <= 1'b0;
        else 
        begin
            if(cnt==1)begin
                clk_d <= ~clk_d;
                cnt = 0;
            end
            else
                cnt = cnt+1;
        end
    end
    
endmodule

    
