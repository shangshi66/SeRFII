module hmac_core(
                 input wire            clk,
                 input wire            reset_n,

                 input wire            init,
//                 input wire            next,
//                 input wire            finalize,
//                 input wire [5 : 0]    final_len,

                 input wire [255 : 0]  key,

                 input wire [255 : 0]  message,

                 output wire           ready,
                 output wire [255 : 0] result
                );

  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  localparam MODE_SHA_256   = 1;

  
  reg            sha256_init;
  reg            sha256_next;
  reg            sha256_rst;
  reg            v;
  reg  [511 : 0] sha256_block;
  reg  [255 : 0] temp;
  wire           sha256_ready;
  wire [255 : 0] sha256_digest;
  wire           sha256_digest_valid;
  parameter opad = 256'h5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c;
  parameter ipad = 256'h3636363636363636363636363636363636363636363636363636363636363636;
  
  //----------------------------------------------------------------
  // core instantiation.
  //----------------------------------------------------------------
  sha256_core sha256(
                     .clk(clk),
                     .reset_n(sha256_rst),

                     .init(sha256_init),
                     .next(sha256_next),
                     .mode(MODE_SHA_256),

                     .block(sha256_block),

                     .ready(sha256_ready),
                     .digest(sha256_digest),
                     .digest_valid(sha256_digest_valid)
                    );

assign ready = v;
assign result = temp;
  always @ (posedge clk or negedge reset_n)
    begin : reg_update
      integer mode;
      if (!reset_n)
        begin
          sha256_init <= 0;
          sha256_next <= 0;
          sha256_rst <= 0;
          sha256_block <= 0;
          mode <= 0;
          v <= 0;
          temp <= 0;
        end
      else if (init)
        begin
          if (mode == 0)
            begin
                sha256_rst <= 1;
                sha256_block <= {key ^ ipad, message};
                sha256_init <= 1;
                mode <= 4;
            end
            else if (mode == 1)
            begin
              if (sha256_digest_valid == 0)
                  sha256_init <= 0;
              else if (sha256_digest_valid == 1)
                begin
                  temp <= sha256_digest;
                  sha256_next <= 1;          
                  sha256_block <= {key ^ opad, sha256_digest};
                  mode <= 3;
                end
            end
          else if (mode == 2)
            begin
              if (sha256_digest_valid == 0)
                begin
                  sha256_next <= 0;
                end
              else if (sha256_digest_valid == 1)
                begin
                  temp <= sha256_digest;
                  v <=  1;
                end
            end
            else if (mode == 3)
              mode <= 2;
            else if (mode == 4)
              mode <= 1;
        end
    end // reg_update

endmodule // hmac_core