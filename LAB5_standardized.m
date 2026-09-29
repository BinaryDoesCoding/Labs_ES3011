%% Lab 5: Root Locus and System Response
% Question:
% Manually calculate the root locus for G(s) = 1 / (s(s + 2)(s + 5))
% over 0 <= K <= 1000, then compare it with MATLAB's rlocus function.
% Analyze how gain affects response time, stability, and oscillation.
%
% Assume unity negative feedback:
% T(s) = K / (s^3 + 7s^2 + 10s + K).
%
% Parts 2 and 3 require Control System Toolbox.

clear;
clc;
close all;

%% Part 1: Manually Calculate the Root Locus
% Sample the required gain range in increments of 0.04.

k_max = 1000;
samples_per_unit = 25;
num_samples = samples_per_unit * k_max + 1;

gain_values = linspace(0, k_max, num_samples);
closed_loop_poles = complex(zeros(3, num_samples));

% Solve the characteristic equation at each gain.

for gain_index = 1:num_samples
    current_gain = gain_values(gain_index);
    characteristic_coefficients = [1, 7, 10, current_gain];

    closed_loop_poles(:, gain_index) = roots(characteristic_coefficients);
end

% Calculate the open-loop poles.

plant_denominator = [1, 7, 10, 0];
open_loop_poles = roots(plant_denominator);

% Flatten the array to plot all roots as one set of unconnected points.
% The order returned by roots does not affect this scatter-style plot.

figure;
plot(real(closed_loop_poles(:)), imag(closed_loop_poles(:)), 'b.');
hold on;
plot(real(open_loop_poles), imag(open_loop_poles), 'rx', 'MarkerSize', 10);
hold off;

grid on;
title('Part 1: Manual Root Locus, 0 <= K <= 1000');
xlabel('Real Part (1/s)');
ylabel('Imaginary Part (rad/s)');
legend('Closed-loop poles', 'Open-loop poles', 'Location', 'best');

% Include every calculated pole in the required gain range.

xlim([-14, 4]);
ylim([-10, 10]);

%% Part 2: Root Locus Using MATLAB's Built-in Function
% Pass the open-loop plant and the same gain vector to rlocus.

plant_tf = tf(1, plant_denominator);

figure;
rlocus(plant_tf, gain_values);
grid on;

title('Part 2: MATLAB Root Locus, 0 <= K <= 1000');
xlabel('Real Part (1/s)');
ylabel('Imaginary Part (rad/s)');
xlim([-14, 4]);
ylim([-10, 10]);

%% Part 3: Compare Representative Closed-Loop Step Responses
% These additional plots support the required performance analysis.
% Separate panels keep the unstable response from hiding stable responses.

selected_gains = [1, 4, 10, 30, 70, 100];
time_values = linspace(0, 30, 6001);

figure;
tiledlayout(2, 3);

for gain_index = 1:numel(selected_gains)
    current_gain = selected_gains(gain_index);
    closed_loop_tf = feedback(current_gain * plant_tf, 1);

    [step_response, response_time] = step(closed_loop_tf, time_values);

    nexttile;
    plot(response_time, step_response, 'b', 'LineWidth', 1.2);
    yline(1, 'k--');
    grid on;

    title(sprintf('K = %g', current_gain));
    xlabel('Time (s)');
    ylabel('Output');

    % Display pole locations for use in the report.

    fprintf('\nClosed-loop poles for K = %g:\n', current_gain);
    disp(pole(closed_loop_tf));
end

sgtitle('Closed-Loop Unit-Step Responses');
