`timescale 1ns / 1ps

module elevator_controller#(
    parameter N = 8,
    parameter Open_Door_cycle = 3,
    parameter Travel_Cycle = 4
    )(
    input clk,
    input reset,
    input [N-1:0] floor_request,
    
    output reg move_up,
    output reg move_down,
    output reg is_door_open,
    output reg [$clog2(N)-1:0] current_floor
    );
    
    reg [1:0] state;
    
    localparam idle = 2'b00;
    localparam moving_up = 2'b01;
    localparam moving_down = 2'b10;
    localparam door_open = 2'b11;
    
    reg [N-1:0] pending_requests;
    reg [N-1:0] floor_request_prev;
    
    localparam travel_timer_bits = $clog2(Travel_Cycle);
    localparam door_timer_bits = $clog2(Open_Door_cycle+1);
    
    reg [travel_timer_bits-1:0] travel_timer;
    reg [door_timer_bits-1:0] door_timer;
    
    reg direction;
    localparam down = 1'b0;
    localparam up = 1'b1;
    
    reg request_below;
    reg request_above;
    reg request_here;
    
    wire serving_here;
    wire [N-1:0] floor_mask;
    wire [N-1:0] new_requests;
    
    assign serving_here = request_here && ((state == idle) || (state == moving_up) || (state == moving_down));
    assign floor_mask = {{(N-1){1'b0}}, 1'b1} << current_floor;
    assign new_requests = floor_request & ~floor_request_prev;
    
    integer i;
    
    always @(*)
    begin
        request_below = 1'b0;
        request_above = 1'b0;
        request_here = pending_requests[current_floor];
        
        for(i=0;i<N;i=i+1)
        begin
            if(pending_requests[i] == 1'b1)
            begin
                if(i>current_floor)
                begin
                    request_above = 1'b1;
                end
                if(i<current_floor)
                begin
                    request_below = 1'b1;
                end
            end
        end
    end
    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            floor_request_prev <= 0;
            state <= idle;
            current_floor <= 0;
            pending_requests <= 0;
            travel_timer <= 0;
            door_timer <= 0;
            direction <= up;
            is_door_open <= 0;
            move_up <= 0;
            move_down <= 0;
        end
        else
        begin
            if(serving_here)
            begin
                pending_requests <= (pending_requests | new_requests) & ~floor_mask;
            end
            else
            begin
                pending_requests <= pending_requests | new_requests;
            end
            floor_request_prev <= floor_request;
            case(state)
            idle:
            begin
                move_up <= 0;
                move_down <= 0;
                is_door_open <= 0;
                travel_timer <= 0;
                door_timer <= 0;
                
                if (request_here)
                begin
                    state <= door_open;
                end
                else if (direction == up)
                begin
                    if (request_above)
                    begin
                        state <= moving_up;
                    end
                    else if (request_below)
                    begin
                        state <= moving_down;
                        direction <= down;
                    end
                end
                else
                begin
                    if (request_below)
                    begin
                        state <= moving_down;
                    end
                    else if (request_above)
                    begin
                        state <= moving_up;
                        direction <= up;
                    end
                end
            end
            moving_up:
            begin
                move_up <= 1;
                move_down <= 0;
                is_door_open <= 0;
                if(request_here)
                begin
                    move_up <= 0;
                    state <= door_open;
                    travel_timer <= 0;
                    door_timer <= 0;
                end
                else if(request_above)
                begin
                    if(travel_timer == Travel_Cycle-1)
                    begin
                        current_floor <= current_floor+1;
                        travel_timer <= 0;
                    end
                    else
                    begin
                        travel_timer <= travel_timer + 1'b1;
                    end
                end
                else if(request_below)
                begin
                    state <= moving_down;
                    move_up <= 0;
                    direction <= down;
                    travel_timer <= 0;
                end
                else
                begin
                    state <= idle;
                    travel_timer <= 0;
                    move_up <= 0;
                end
            end
            
            
            moving_down:
            begin
                move_down <= 1;
                move_up <= 0;
                is_door_open <= 0;
                if(request_here)
                begin
                    move_down <= 0;
                    state <= door_open;
                    travel_timer <= 0;
                    door_timer <= 0;
                end
                else if(request_below)
                begin
                    if(travel_timer == Travel_Cycle-1)
                    begin
                        current_floor <= current_floor-1;
                        travel_timer <= 0;
                    end
                    else
                    begin
                        travel_timer <= travel_timer + 1'b1;
                    end
                end
                else if(request_above)
                begin
                    state <= moving_up;
                    move_down<=0;
                    direction <= up;
                    travel_timer <= 0;
                end
                else
                begin
                    state <= idle;
                    travel_timer <= 0;
                    move_down <= 0;
                end
            end
            door_open:
            begin
                move_up <= 0;
                move_down <= 0;
                is_door_open <= 1;
                if(door_timer == Open_Door_cycle)
                begin
                    door_timer <= 0;
                    state <= idle;
                    is_door_open <= 0;
                end
                else
                begin
                    door_timer <= door_timer + 1;
                end
            end
            endcase
        end
    end
endmodule
