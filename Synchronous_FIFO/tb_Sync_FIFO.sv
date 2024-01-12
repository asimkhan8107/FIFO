`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2024 23:40:52
// Design Name: 
// Module Name: tb_Sync_FIFO
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


module tb_Sync_FIFO #(parameter DATA_WIDTH = 8);

    reg clk, rst_n;
    reg wr_en, rd_en;
    reg [DATA_WIDTH - 1:0] data_in;
    wire [DATA_WIDTH - 1:0] data_out;
    wire full, empty;
    
    //integer wr_ptr, rd_ptr;
    
    Sync_FIFO FIFO(.clk(clk), .rst_n(rst_n), .wr_en(wr_en), .rd_en(rd_en),
                  .data_in(data_in), .data_out(data_out), .full(full), .empty(empty));
    
    always #2 clk = ~clk; // 5*2 = 10 => 1000/10 => 100 MHz clock frequency
    
    initial
    begin
        {clk, rst_n} = 1'b0;
        {wr_en, rd_en} = 1'b0;
        
        #3      
        rst_n = 1'b1;
        drive(20);
        drive(40);
        $finish();
    end
    
    // To write the data into FIFO memory
    task push();
    begin : push_block
        if(!full)
        begin
            {wr_en,rd_en} = {1'b1,1'b0};
            //rd_en = 1'b0;
            data_in = $random;
            #1
            $display("Time=%0t: Pushed In => wr_en = %0b, rd_en = %0b, data_in = 0x%0h",$time, wr_en, rd_en, data_in);     
        end  
        else
            $info("FIFO FULL!!!!!!!!! Can not push data_in = 0x%0h", data_in); 
    end
    endtask
    
    // To read out data from the FIFO memory
    task pop();
    begin : pop_block
        if(!empty)
        begin
            {rd_en,wr_en} = {1'b1,1'b0};
            //wr_en = 1'b0;
            #1
            $display("Time=%0t: Poped Out => wr_en = %0b, rd_en = %0b, data_out = 0x%0h",$time, wr_en, rd_en, data_out);     
        end  
        else
            $info("FIFO Empty!!!!!!!!! Can not pop data_out = 0x%0h", data_out); 
    end
    endtask
    
    // Drive
    task drive(int delay);   // argumented task
         {wr_en, rd_en} = 1'b0;
         fork
            begin
                repeat(10)
                begin
                    @(posedge clk)
                    push();
                end
                wr_en = 0;
            end
            begin
                #delay;
                repeat(10)
                begin
                    @(posedge clk)
                    pop();
                end
                rd_en = 0;
            end
         join  
    endtask
    
endmodule

