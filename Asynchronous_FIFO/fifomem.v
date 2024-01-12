module fifomem #(
    parameter DATASIZE = 8, // Memory data word width
    parameter ADDRSIZE = 4) // Number of mem address bits
   (
    input winc, wfull, wclk,
    input [ADDRSIZE-1:0] waddr, raddr,
    input [DATASIZE-1:0] wdata,
    output [DATASIZE-1:0] rdata);

    localparam DEPTH = 1<<ADDRSIZE;
    
    // memory declaration  
    reg [DATASIZE-1:0] mem [0:DEPTH-1];
    
    // Reading data from memory
    assign rdata = mem[raddr];

    // Writing data into memory on rising edge of wclk
    always @(posedge wclk)
    begin
        if (winc && !wfull)
          mem[waddr] <= wdata;
    end    
endmodule