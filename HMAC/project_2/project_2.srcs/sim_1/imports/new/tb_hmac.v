module tb_hmac();

  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  parameter CLK_HALF_PERIOD = 1;
  parameter CLK_PERIOD = 2 * CLK_HALF_PERIOD;


  //----------------------------------------------------------------
  // Register and Wire declarations.
  //----------------------------------------------------------------
  reg            tb_clk;
  reg            tb_reset_n;
  reg [255 : 0]  tb_key;
  reg            tb_init;
  reg [255 : 0]  tb_block;
  wire           tb_ready;
  wire [255 : 0] tb_tag;

  //----------------------------------------------------------------
  // Device Under Test.
  //----------------------------------------------------------------
  hmac_core dut(
                  .clk(tb_clk),
                  .reset_n(tb_reset_n),

                  .init(tb_init),

                  .message(tb_block),
                  .key(tb_key),


                  .result(tb_tag),
                  .ready(tb_ready)
                 );

  always
    begin : clk_gen
      #CLK_HALF_PERIOD;
      tb_clk = !tb_clk;
    end // clk_gen
    
  task wait_ready;
    begin
      while (!tb_ready)
        begin
          #(CLK_PERIOD);
        end
    end
  endtask // wait_ready
  
 initial
    begin : main
      $display("   -- Testbench started: fada31cc1422560e42c8d95f8c262edcf66afab9f58f3753d73ca8ecc13ea20e --");
        tb_reset_n = 1;
        tb_key =   256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD;
        tb_block = 256'h93285BA783E78F920458AB82C346D9F0293877CBCAE32950683957BACEDF9EA7;
        tb_clk = 1;
        tb_init = 0;
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        tb_reset_n = 0;
        #(CLK_PERIOD);
        tb_init = 1;
        #(CLK_PERIOD);
        wait_ready();
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        #(CLK_PERIOD);
      $display("*** Simulation done.");
      $finish;
    end // main

endmodule // tb_sha256_core
