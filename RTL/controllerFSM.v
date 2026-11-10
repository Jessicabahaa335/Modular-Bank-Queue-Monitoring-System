
`timescale 10ns / 1ns

module controllerFSM (
    rstn, clk, leaveSensorEvent, enterSensorEvent, pCount,
    enable, upDown, emptyFlag, fullFlag, emptyAlarm, fullAlarm
);

parameter empty = 2'b00,
          count = 2'b01,
          full  = 2'b10;

parameter counterwidth = 3;

input rstn, clk;
input leaveSensorEvent, enterSensorEvent;
input [counterwidth-1:0] pCount;

output reg enable;
output reg upDown;
output emptyFlag, fullFlag;
output emptyAlarm, fullAlarm;

reg [1:0] state;

nor(emptyFlag, pCount[2], pCount[1], pCount[0]);
and(fullFlag, pCount[2], pCount[1], pCount[0]);

assign emptyAlarm = (emptyFlag & leaveSensorEvent) ? 1'b1 : 1'b0;
assign fullAlarm = (fullFlag & enterSensorEvent) ? 1'b1 : 1'b0;

always @(posedge clk, negedge rstn)
begin
    if (~rstn)
    begin
        state <= empty;
        enable <= 1'b0;
        upDown <= 1'b0;
    end
    else
    begin
        case (state)

            empty:
            begin
                case ({enterSensorEvent, leaveSensorEvent})
                    2'b00, 2'b11, 2'b01:
                    begin
                        enable <= 1'b0;
                        upDown <= 1'b0;
                    end

                    2'b10:
                    begin
                        state <= count;
                        enable <= 1'b1;
                        upDown <= 1'b1;
                    end
                endcase
            end

            count:
            begin
                case ({enterSensorEvent, leaveSensorEvent})
                    2'b00, 2'b11:
                    begin
                        enable <= 1'b0;
                        upDown <= 1'b0;
                    end

                    2'b10:
                    begin
                        if (pCount < 7)
                        begin
                            state <= count;
                            enable <= 1'b1;
                            upDown <= 1'b1;
                        end
                        else
                        begin
                            state <= full;
                            enable <= 1'b0;
                            upDown <= 1'b0;
                        end
                    end

                    2'b01:
                    begin
                        if (pCount > 0)
                        begin
                            state <= count;
                            enable <= 1'b1;
                            upDown <= 1'b0;
                        end
                        else
                        begin
                            state <= empty;
                            enable <= 1'b0;
                            upDown <= 1'b0;
                        end
                    end
                endcase
            end

            full:
            begin
                case ({enterSensorEvent, leaveSensorEvent})
                    2'b00, 2'b11, 2'b10:
                    begin
                        enable <= 1'b0;
                        upDown <= 1'b0;
                    end

                    2'b01:
                    begin
                        state <= count;
                        enable <= 1'b1;
                        upDown <= 1'b0;
                    end
                endcase
            end

        endcase
    end
end

endmodule
