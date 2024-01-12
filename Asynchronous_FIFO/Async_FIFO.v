module Async_FIFO #(parameter DSIZE =8, parameter ASIZE =4)
  (
  input winc, wclk, wrst_n,
  input rinc, rclk, rrst_n,
  input [DSIZE-1:0] wdata, 
  output [DSIZE-1:0] rdata,
  output wfull, rempty);
  
  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w s_r2w (wclk, wrst_n, rptr, wq2_rptr);
  sync_w2r s_w2r (rclk, rrst_n, wptr, rq2_wptr);
  fifomem #(DSIZE, ASIZE) fifomem (winc, wfull, wclk, waddr, raddr, wdata, rdata);
  rptr_empty #(ASIZE) rptr_empty (rinc,rclk,rrst_n,rq2_wptr,rempty,raddr,rptr);
  wptr_full #(ASIZE) wptr_full (winc,wclk,wrst_n,wq2_rptr,wfull,waddr,wptr);

endmodule