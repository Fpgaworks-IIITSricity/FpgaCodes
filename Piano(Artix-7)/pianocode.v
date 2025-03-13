`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2025 15:01:31
// Design Name: 
// Module Name: buzzer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module buzzer_multi_freq (
    input wire clk,         // System clock (100 MHz)
    input wire [4:0] button, // 5 Button inputs
    output wire buzzer      // Buzzer output
);

    reg [15:0] pwm_counter; // Counter for PWM frequency
    reg pwm_signal;        // PWM output signal
    reg [31:0] pwm_period; // PWM period for different frequencies

    // Define musical note frequencies (Clock / Desired Frequency)
    parameter C4  = 100000000 / 200; // Button 1 - C4 (200 Hz)
    parameter D4  = 100000000 / 500;  // Button 2 - D4 (500 Hz)
    parameter E4  = 100000000 / 1000;  // Button 3 - E4 (1 kHz)
    parameter F4  = 100000000 / 2500;  // Button 4 - F4 (2 kHz)
    parameter G4  = 100000000 / 5000;  // Button 5 - G4 (4 KHz)
    parameter SILENCE = 32'd0;        // No sound when no button is pressed

    always @(posedge clk) begin
        // Assign frequency based on which button is pressed
        case (button)
            5'b00001: pwm_period <= C4;  // Button 1 ? C4
            5'b00010: pwm_period <= D4;  // Button 2 ? D4
            5'b00100: pwm_period <= E4;  // Button 3 ? E4
            5'b01000: pwm_period <= F4;  // Button 4 ? F4
            5'b10000: pwm_period <= G4;  // Button 5 ? G4
            default:  pwm_period <= SILENCE; // No button pressed ? No sound
        endcase

        // Generate PWM signal when a button is pressed
        if (pwm_period != SILENCE) begin
            pwm_counter <= pwm_counter + 1;
            if (pwm_counter < (pwm_period / 2))
                pwm_signal <= 1;
            else
                pwm_signal <= 0;
        end else begin
            pwm_signal <= 0; // Mute buzzer if no button is pressed
        end
    end

    assign buzzer = pwm_signal; // Assign PWM signal to buzzer

endmodule
