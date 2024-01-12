// Write pointer and full generation
module wptr_full #(parameter ADDRSIZE = 4)(
    input winc, wclk, wrst_n,
    input [ADDRSIZE :0] wq2_rptr,
    output reg wfull,
    output [ADDRSIZE-1:0] waddr,
    output reg [ADDRSIZE :0] wptr);

    reg [ADDRSIZE:0] wbin;
    wire [ADDRSIZE:0] wgraynext, wbinnext, wfull_val;

    // GRAYSTYLE2 pointer
    always@(posedge wclk or negedge wrst_n)
    begin
        if (!wrst_n)
            {wbin, wptr} <= {ADDRSIZE{1'b0}};
        else
            {wbin, wptr} <= {wbinnext, wgraynext};
    end
    
    // Memory write-address pointer
    assign waddr = wbin[ADDRSIZE-1:0];
    assign wbinnext = wbin + (winc & ~wfull);
    assign wgraynext = (wbinnext>>1) ^ wbinnext;

    /*------------------------------------------------------------------
    Simplified version of the three necessary full-tests:
    assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
    (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
    (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
    -------------------------------------------------------------------*/
    assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

    always@(posedge wclk or negedge wrst_n)
    begin
        if (!wrst_n)
            wfull <= {ADDRSIZE{1'b0}};
        else
            wfull <= wfull_val;
    end
endmodule