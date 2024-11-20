`timescale 1ns / 1ps

module RAM(
    input clk,
    input [31:0] address,
    input [31:0] writeData, // [31:24], [23:16], [15:8], [7:0]
    input nRD,
    input nWR, 
    output reg [31:0] Dataout,
    output reg readStatus, 
    output reg writeStatus,
    output isLastState
    );
    integer R,W;
    assign isLastState = R == 9 || W == 9; //TODO
    initial begin
      R = 0;
      W = 0;
      readStatus = 0;
      writeStatus = 0;
    end
    reg [7:0] ram [0:60];
    
    always@( negedge clk) begin
        if (R == 0) begin
            if (nRD == 0) begin
                R <= 1;
            end
            else begin // nRD == 1
                R <= 0;
            end
        end
        else if (R == 10) begin
            R <= 0;            
        end
        else begin
            R <= R+1;
        end

        if (W == 0) begin
            if (nWR == 0) begin
                W <= 1;
            end
            else begin // nWR == 1
                W <= 0;
            end
        end
        else if (W == 10) begin
            W <= 0;            
        end
        else begin
            W <= W+1;
        end
    end
    always@(*) begin
        // if (readStatus == 1) begin
        if (R == 10) begin
            Dataout[7:0] = ram[address + 3]; 
            Dataout[15:8] = ram[address + 2];
            Dataout[23:16] = ram[address + 1];
            Dataout[31:24] = ram[address ];
            readStatus = 1;
        end
        else begin
            readStatus = 0;
        end
        if( W == 1 ) begin
            ram[address] = writeData[31:24];
            ram[address+1] = writeData[23:16];
            ram[address+2] = writeData[15:8];
            ram[address+3] = writeData[7:0];
        end
        if (W == 10) begin
            writeStatus = 1;
        end
        else begin
            writeStatus = 0;
        end
    end
endmodule
