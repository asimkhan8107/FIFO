`timescale 1ns / 1ps

module tb_Async_FIFO #(parameter DSIZE = 8, ASIZE = 4);
    
    logic winc, wclk, wrst_n;
    logic rinc, rclk, rrst_n;
    logic [DSIZE-1:0] wdata;
    
    logic [DSIZE-1:0] rdata;
    logic wfull;
    logic rempty;
    
    // Queue for checking data
    logic [DSIZE-1:0] verif_data_q[$];
    logic [DSIZE-1:0] verif_wdata;
    
    Async_FIFO #(DSIZE, ASIZE) A_FIFO(.winc(winc),.wclk(wclk),.wrst_n(wrst_n),.rinc(rinc),
    .rclk(rclk), .rrst_n(rrst_n), .wdata(wdata), .rdata(rdata), .wfull(wfull), .rempty(rempty));
    
    // Clock generation
    always #5 wclk = ~wclk;
    always #8 rclk = ~rclk;
    
    initial
    begin : clock_generation
        {wclk, rclk} = 1'b0;
    end
    
    initial 
    begin
        {winc, wdata, wrst_n} = 'b0;
        repeat(5)
            @(posedge wclk);
            wrst_n = 1'b1;
            
            for(int i=0; i<32; i++)
            begin
                @(posedge wclk iff (!wfull));
                winc = (i%2==0)? 1'b1 : 1'b0;
                if(winc)
                begin
                    wdata = $urandom;
                    verif_data_q.push_front(wdata);
                end
            end
            #100us;                
    end
    
    initial
    begin
        {rinc, rrst_n} = 'b0;
        repeat(8)
            @(posedge rclk);
            rrst_n = 'b1;

            for(int i=0; i<32; i++)
            begin
                @(posedge rclk iff (!rempty))
                rinc = (i%2==0)? 1'b1: 1'b0; 
                if(rinc)
                begin
                    verif_wdata = verif_data_q.pop_back();
                    $display("Checking rdata => expected wdata = %0h, rdata = %0h",verif_wdata, rdata);
                    assert(rdata === verif_wdata) else $error("Checking Failed => expected wdata = %0h, rdata = %0h", verif_wdata, rdata);                              
                end
            end
            #100us;
            $finish();            
    end
endmodule
