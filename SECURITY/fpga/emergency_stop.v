// Emergency stop (placeholder)
// - estop_btn is latched until reset; integrate watchdog/hardware override in real design
module emergency_stop(
    input clk,
    input reset,
    input estop_btn,
    output reg estop_active
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estop_active <= 0;
        end else if (estop_btn) begin
            estop_active <= 1;
        end
    end
endmodule
