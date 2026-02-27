module FSM(
    input carry, borrow, ID_clk, rst,
    output reg fsm_out
);

    localparam S0=3'd0, S1=3'd1, S3=3'd3, S4=3'd4, S5=3'd5, S6=3'd6;

    reg [2:0] act_state;
    reg [2:0] next_state_raw;

    reg carry_f1, carry_f2, past_carry;
    reg borrow_f1, borrow_f2, past_borrow;

    always @(posedge ID_clk or posedge rst) begin
        if (rst) begin
            {carry_f1, carry_f2, past_carry} <= 3'b0;
            {borrow_f1, borrow_f2, past_borrow} <= 3'b0;
        end 
        else
        begin
            carry_f1 <= carry;
            carry_f2 <= carry_f1;
            past_carry <= carry_f2;

            borrow_f1 <= borrow;
            borrow_f2 <= borrow_f1;
            past_borrow <= borrow_f2;
        end
    end

    wire carry_rise  = (carry_f2 == 1'b1) && (past_carry == 1'b0);
    wire borrow_rise = (borrow_f2 == 1'b1) && (past_borrow == 1'b0);

    always @(posedge ID_clk or posedge rst) begin
        if (rst) 
            act_state <= S0;
        else     
            act_state <= next_state_raw;
    end

    always @(*) begin
        case(act_state)
            S0: next_state_raw = carry_rise ? S3 : (borrow_rise ? S6 : S1);
            S1: next_state_raw = carry_rise ? S4 : (borrow_rise ? S5 : S0);
            S3: next_state_raw = S4;
            S4: next_state_raw = S0;
            S5: next_state_raw = S6;
            S6: next_state_raw = S1;
            default: next_state_raw = S0;
        endcase
    end

    always @(posedge ID_clk or posedge rst) begin
        if (rst) 
            fsm_out <= 1'b0;
        else begin
            case(next_state_raw)
                S0, S4, S5: fsm_out <= 1'b0;
                S1, S3, S6: fsm_out <= 1'b1;
                default:    fsm_out <= 1'b0;
            endcase
        end
    end

endmodule
