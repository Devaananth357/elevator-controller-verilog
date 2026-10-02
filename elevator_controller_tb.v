`timescale 1ns / 1ps

module elevator_controller_tb;
    reg clk = 0;
    reg reset = 1;
    reg [7:0] floor_request = 0;

    wire move_up, move_down, is_door_open;
    wire [2:0] current_floor;

    elevator_controller dut (
        .clk(clk),
        .reset(reset),
        .floor_request(floor_request),
        .move_up(move_up),
        .move_down(move_down),
        .is_door_open(is_door_open),
        .current_floor(current_floor)
    );

    always #5 clk = ~clk;  
    
    initial
    begin
        #12
        reset = 0;
        
        @(negedge clk);
        floor_request[3] = 1;
        
        #1000
        $finish;
    end
    initial begin
        $monitor("time=%0t floor=%0d up=%b down=%b door=%b state=%b pending=%b",
                 $time, current_floor, move_up, move_down,
                 is_door_open, dut.state, dut.pending_requests);
    end
endmodule
