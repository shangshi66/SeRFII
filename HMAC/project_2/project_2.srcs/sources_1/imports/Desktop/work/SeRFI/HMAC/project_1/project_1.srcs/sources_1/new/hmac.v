module hmac_core(
                 input wire            clk,
                 input wire            reset_n,

                 input wire            init,

                 input wire [255 : 0]  key,

                 input wire [255 : 0]  message,

                 output wire           ready,
                 output wire [255 : 0] result
                );

  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------

  
  reg            sha256_init;
  reg            sha256_rst;
  reg            v;
  reg  [511 : 0] sha256_block;
  reg  [3 : 0] mode;
  reg  [255 : 0] temp;
  wire [255 : 0] sha256_digest;
  wire           sha256_digest_valid;
  parameter opad = 256'h5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c;
  parameter ipad = 256'h3636363636363636363636363636363636363636363636363636363636363636;
  
  //----------------------------------------------------------------
  // core instantiation.
  //----------------------------------------------------------------
  SHA_IP SHA_IP(
                     .clk(clk),
                     .rst(sha256_rst),

                     .go(sha256_init),

                     .data_in(sha256_block),

                     .data_out(sha256_digest),
                     .done(sha256_digest_valid)
                    );

assign ready = v;
assign result = temp;
  always @ (posedge clk or posedge reset_n)
    begin : reg_update
      if (reset_n)
        begin
          sha256_init <= 0;
          sha256_rst <= 1;
          sha256_block <= 0;
          mode <= 0;
          v <= 0;
          temp <= 0;
        end
      else if (init)
        begin
          if (mode == 0)
            begin
                sha256_rst <= 0;
                sha256_block <= {key ^ ipad, message};
                sha256_init <= 1;
                mode <= 1;
            end
          else if (mode == 1)
            begin
              if (sha256_digest_valid == 1)
                begin
                  mode <= 2;
                  temp <= sha256_digest;
                  sha256_init <= 0;          
                  sha256_rst <= 1;    
                end
            end
          else if (mode == 2)
            begin      
              mode <= 3;
              sha256_block <= {key ^ opad, temp};
              sha256_rst <= 0;                  
              sha256_init <= 1;
            end
            else if (mode == 3)
            begin      
              mode <= 4;
            end
          else if (mode == 4)
            begin
              if (sha256_digest_valid == 1)
                begin
                  temp <= sha256_digest;
                  v <=  1;
                end
            end
        end
    end // reg_update

endmodule // hmac_core