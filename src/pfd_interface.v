module pfd_interface (
    input  clk,          
    input  rst,           
    input  up_async,     // Segnale UP dal PFD (asincrono)
    input  down_async,   // Segnale DOWN dal PFD (asincrono)
    output up_sync_pulse,    
    output down_sync_pulse  
);

    // sincronizzatore per il segnale UP
    pulse_synchronizer sync_up (
        .clk(clk),
        .rst(rst),
        .async_in(up_async),
        .pulse_out(up_sync_pulse)
    );

    // sincronizzatore per il segnale DOWN
    pulse_synchronizer sync_down (
        .clk(clk),
        .rst(rst),
        .async_in(down_async),
        .pulse_out(down_sync_pulse)
    );

endmodule


module pulse_synchronizer (
    input clk,
    input rst,
    input async_in,
    output pulse_out
);

    reg flag_async;
    reg sync_q1, sync_q2, sync_q3;
    wire flag_clear;

    // Il flag viene alzato dal fronte del segnale asincrono
    // Viene abbassato (resettato) quando il dominio sincronizzato ha ricevuto il dato (flag_clear)
    always @(posedge async_in or posedge flag_clear or posedge rst) begin
        if (rst) begin
            flag_async <= 1'b0;  
        end else if (flag_clear) begin
            flag_async <= 1'b0; 
        end else begin
            flag_async <= 1'b1;  // Set da evento asincrono
        end
    end

    // Catena di 2 FF + 1 FF per edge detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_q1 <= 1'b0;
            sync_q2 <= 1'b0;
            sync_q3 <= 1'b0;
        end else begin 
            sync_q1 <= flag_async; 
            sync_q2 <= sync_q1;    
            sync_q3 <= sync_q2;   
        end
    end

    // Il segnale di clear viene mandato indietro quando sync_q2 è alto e resetta il primo flip-flop

    assign flag_clear = sync_q2;

    // Genero un impulso che dura esattamente 1 ciclo di clock
    assign pulse_out = sync_q2 & ~sync_q3;

endmodule
