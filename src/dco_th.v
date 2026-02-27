module dco_th #(
    parameter BASE_THRESHOLD = 2500,
    parameter THRESHOLD_MIN = 10,
    parameter THRESHOLD_MAX = 4990
)(
    input  clk,
    input  rst,
    input  signed [12:0] K_signed,
    output reg dco_out
);

    localparam WIDTH =  $clog2(THRESHOLD_MAX + 1);


    reg [WIDTH-1:0] count;   

    // Calcolo la soglia effettiva come base - K_signed.

    wire signed [14:0] raw_threshold;
    assign raw_threshold = $signed(BASE_THRESHOLD) - $signed(K_signed);
    reg [WIDTH-1:0] threshold_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count   <= 0;
            dco_out <= 0;
            threshold_reg <= BASE_THRESHOLD[WIDTH-1:0];
        end 
		  else begin
            if (raw_threshold < $signed(THRESHOLD_MIN))
            threshold_reg <= THRESHOLD_MIN[WIDTH-1:0];
        else if (raw_threshold > $signed(THRESHOLD_MAX))
            threshold_reg <= THRESHOLD_MAX[WIDTH-1:0];
        else
            threshold_reg <= raw_threshold[WIDTH-1:0];
            count <= count + 1'b1;
            // quando supera la soglia → toggle + reset counter
            if (count >= threshold_reg) begin
                count   <= 0;
                dco_out <= ~dco_out;
            end
        end
	end

endmodule
