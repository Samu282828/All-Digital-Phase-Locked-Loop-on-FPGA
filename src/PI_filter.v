module PI_filter #(
    parameter P_GAIN     = 2,       // guadagno proporzionale
    parameter I_GAIN     = 2,       // guadagno integrativo
    parameter p_threshold = 5,
    parameter i_threshold = 5
)(
    input rst,
    input clk,                    
    input up,
    input down,
    output reg signed [12:0] K_out
);

    localparam P_BITS = $clog2(p_threshold + 1);
    localparam I_BITS = $clog2(i_threshold + 1);
    localparam signed [12:0] I_MAX = 4000; 

    reg [P_BITS-1:0] p_scale;
    reg [I_BITS-1:0] i_scale;
    reg signed [12:0] I_term;                        // integratore (mantiene valore)
    reg signed [12:0] P_pulse;                       // termine proporzionale come impulso
    reg no_down;
    reg no_up;



    always @(posedge clk or posedge rst) begin
        if (rst) begin
            p_scale <= 0;                              
            i_scale <= 0;
            I_term <= 0;
            P_pulse <= 0;
            K_out <= 0;
            no_up <= 0;
            no_down <= 0;
        end 
        else begin
            P_pulse <= 0;
            // caso up (solo up attivo)
            if ((up)&&(!down)) begin
                if (no_up==0) begin
                    no_down <= 1;
                if (p_scale >= p_threshold) begin
                    P_pulse <= $signed(P_GAIN[12:0]);
                    p_scale <= 0;
                end else begin
                    p_scale <= p_scale + 1'b1;
                end
                if (i_scale >= i_threshold) begin
                     i_scale <= 0;
                    if (I_term < ($signed(I_MAX) - $signed(I_GAIN[12:0]))) begin
                        I_term <= I_term + $signed(I_GAIN[12:0]);
                    end
                end else begin
                    i_scale <= i_scale + 1'b1;
                end
            end
            else begin
                no_up <= 0;
            end
            end

            // caso down (solo down attivo)
            else if (down && !up) begin
                if (no_down==0) begin
                    no_up <= 1;
                if (p_scale >= p_threshold) begin
                    P_pulse <= - ($signed(P_GAIN[12:0])); 
                    p_scale <= 0;
                end else begin
                    p_scale <= p_scale + 1'b1;
                end
                if (i_scale >= i_threshold) begin
                    i_scale <= 0;
                    if (I_term > (-($signed(I_MAX)) + $signed(I_GAIN[12:0]))) begin
                        I_term <= I_term - $signed(I_GAIN[12:0]);
                    end
                end
                else begin
                    i_scale <= i_scale + 1'b1;
                end
            end
            else begin
                no_down <= 0;
            end
            end
            // Aggiorna K_out: integratore + impulso proporzionale
            K_out <= I_term + P_pulse;
    end
    end
endmodule
