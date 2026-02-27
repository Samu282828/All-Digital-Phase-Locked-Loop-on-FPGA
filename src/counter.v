module counter#(
    parameter k=4
)
(
    input in, clk, rst,
    output reg out
);
    integer count=k-1;
    always @(posedge clk or posedge rst)
        if (rst==1)
            out<=0;
        else if(in==0) 
        begin         
            if (count==((k/2)-1))
                begin
                    count<=count+1;
                    out<=1;
                end 
            else if(count==(k-1))
                begin 
                    count<=0;
                    out<=0;
                end
            else
                count <=count+1;
        end
endmodule

