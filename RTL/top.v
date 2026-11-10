
`timescale 10ns / 1ns

module ITIBQS (
    rstn, clk, frontSensorInput, backSensorInput, tellers,
    emptyFlag, fullFlag, emptyAlarm, fullAlarm,
    pCountDisplay, waitTimeDisplay_1, waitTimeDisplay_2
);

parameter counterwidth = 3;

input rstn, clk;
input frontSensorInput, backSensorInput;
input [2:0] tellers;

output emptyFlag, fullFlag;
output emptyAlarm, fullAlarm;
output [6:0] pCountDisplay, waitTimeDisplay_1, waitTimeDisplay_2;

wire leaveSensorEvent, enterSensorEvent;
wire [counterwidth-1:0] pCount;
wire enable, upDown;
wire [4:0] addr;
wire [1:0] tellersCount;
wire [7:0] data;

edgeDetector frontSensorEdgeDetect(
    frontSensorInput, rstn, clk, leaveSensorEvent
);

edgeDetector backSensorEdgeDetect(
    backSensorInput, rstn, clk, enterSensorEvent
);

upDownCounter customersCounter (
    rstn, clk, enable, upDown, pCount
);

controllerFSM controllerBQS (
    rstn, clk, leaveSensorEvent, enterSensorEvent, pCount,
    enable, upDown, emptyFlag, fullFlag, emptyAlarm, fullAlarm
);

waitTime_rom waitTimeRom (addr, data);

sevenSegmentsDecoder customersDisplay (
    {1'b0, pCount}, pCountDisplay
);

sevenSegmentsDecoder waitDisplay_1 (
    data[3:0], waitTimeDisplay_1
);

sevenSegmentsDecoder waitDisplay_2 (
    data[7:4], waitTimeDisplay_2
);

assign tellersCount = tellers[2] + tellers[1] + tellers[0];
assign addr = {tellersCount, pCount};

endmodule
