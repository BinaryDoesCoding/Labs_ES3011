%% ES 3011 - Lab 3
% Open-Loop Control for Robot Arm
clear;
clc;
close all;

%%  parameters

parameters.motor_inertia = 0.05;

parameters.gear_1_inertia = 0.025;
parameters.gear_2_inertia = 0.10;
parameters.gear_3_inertia = 0.025;
parameters.gear_4_inertia = 0.08;

parameters.gear_ratio_1 = 2;
parameters.gear_ratio_2 = 1.5;

parameters.arm_mass = 10;
parameters.arm_length = 0.3;

parameters.armature_resistance = 4;
parameters.armature_inductance = 3e-3;
parameters.torque_constant = 0.3;
parameters.back_emf_constant = 0.3;

parameters.gravity = 9.81;

%% Calculate equivalent inertia

equivalent_inertia = calculate_equivalent_inertia(parameters);
parameters.equivalent_inertia = equivalent_inertia;

fprintf('Equivalent inertia: %.6f kg*m^2\n', equivalent_inertia);

%% Desired trajectory parameters

trajectory.final_angle = 3 * pi / 4;
trajectory.acceleration_end_time = 0.3;
trajectory.deceleration_start_time = 1.7;
trajectory.final_time = 2.0;

time_step = 0.001;
time = 0:time_step:trajectory.final_time;

%% Generate desired trapezoidal trajectory

[desired_angle, desired_speed, desired_acceleration] = generate_trapezoidal_trajectory(time, trajectory);

%% Display stuff

maximum_speed = max(desired_speed);
maximum_acceleration = max(desired_acceleration);

fprintf('Maximum arm speed: %.6f rad/s\n', maximum_speed);
fprintf('Angular acceleration: %.6f rad/s^2\n', maximum_acceleration);
fprintf('Final desired angle: %.6f rad\n', desired_angle(end));

%% Verify desired trajectory

plot(time, desired_acceleration, 'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Angular Acceleration (rad/(s^2)');
title('Desired Angular Acceleration');
grid on;

figure;

plot(time, desired_speed, 'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
title('Desired Angular Velocity');
grid on;

figure;

plot(time, desired_angle, 'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Angular Position (rad)');
title('Desired Angular Position');
grid on;

%% Solve for input voltage (and resulting current)

[input_voltage, current_result] = solve_input_voltage(parameters, desired_angle, desired_speed, desired_acceleration);

%% Plotting input voltage and resulting current

figure;

plot(time, input_voltage, 'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Input Voltage (V)');
title('Required Input Voltage');
grid on;

figure;

plot(time, current_result, 'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Current (A)');
title('Resultant Current');
grid on;

%% Find the actual angle and speed from input voltage

init_current = current_result(1);
[actual_current, actual_angle, actual_speed] = generate_actual_trajectory(time, parameters, input_voltage, init_current);

%% Plotting of actual current, angle, and speed

figure;

plot(time, actual_current, 'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Current (A)');
title('Actual Current');
grid on;

figure;

plot(time, actual_speed, 'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
title('Actual Angular Velocity');
grid on;

figure;

plot(time, actual_angle, 'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Angular Position (rad)');
title('Actual Angular Position');
grid on;

%% Display some comparisons

maximum_speed_actual = max(actual_speed);

fprintf('Maximum arm speed (actual): %.6f rad/s\n', maximum_speed_actual);
fprintf('Final desired angle (actual): %.6f rad\n', actual_angle(end));