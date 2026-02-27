module reset_synchronizer (
    input  clk,           
    input  rst_async,    // Reset asincrono dall'esterno
    output rst_sync      // Reset con rilascio sincronizzato per il sistema 
);

    reg sync_stage1;
    reg sync_stage2;

    always @(posedge clk or posedge rst_async) begin
        if (rst_async) begin
            sync_stage1 <= 1'b0;
            sync_stage2 <= 1'b0;
        end else begin
            sync_stage1 <= 1'b1;         // Primo stadio: D fissato a 1
            sync_stage2 <= sync_stage1;  
        end
    end

    assign rst_sync = ~(sync_stage2);

endmodule