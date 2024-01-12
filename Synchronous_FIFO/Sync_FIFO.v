`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2024 23:40:52
// Design Name: 
// Module Name: Sync_FIFO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sync_FIFO #(parameter DATA_WIDTH = 8, DEPTH = 8) (
    input clk, rst_n,
    input wr_en, rd_en,
    input [DATA_WIDTH-1:0] data_in, // 8 bit data 
    output reg [DATA_WIDTH-1:0] data_out,
    output full, empty  
    );
    
    reg [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr; // $clog2 is simply work as under-root
    
    // memory
    reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];
    
    always@(posedge clk)
    begin
        if(~rst_n)
        begin : no_operation
            {mem[wr_ptr], data_out} <= {DATA_WIDTH{1'b0}};
            {wr_ptr,rd_ptr} <= 1'b0;
        end : no_operation
        
        else if((wr_en==1) && (~full) && (rd_en==0))
        begin : write_operation
            mem[wr_ptr] <= data_in;
            wr_ptr = wr_ptr + 1;
        end : write_operation
        
        else if((wr_en==0) && (~empty) && (rd_en==1))
        begin : read_operation
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end : read_operation
        
        else      
        begin : default_no_operation
            {mem[wr_ptr], data_out} <= {DATA_WIDTH{1'b0}};
            {wr_ptr, rd_ptr} <= 1'b0;
        end              
    end 
    
    assign full = ((wr_ptr+1) == rd_ptr);
    assign empty = (wr_ptr == rd_ptr);
    
endmodule
