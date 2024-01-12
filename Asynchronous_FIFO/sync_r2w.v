// Read pointer to write clock synchronizer
module sync_r2w #(
    parameter ADDRSIZE = 4)(
    
    input wclk, wrst_n,
    input [ADDRSIZE:0] rptr,
    output reg [ADDRSIZE:0] wq2_rptr);

    reg [ADDRSIZE:0] wq1_rptr;

    always @(posedge wclk or negedge wrst_n)
    begin
        if (!wrst_n) 
            {wq2_rptr,wq1_rptr} <= {ADDRSIZE{1'b0}};
        else 
            {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
    end  
endmodule