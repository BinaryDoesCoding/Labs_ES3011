%% ES 3011 - Lab 4
% Design and Simulation of Feedback Control System

clear;
clc;
close all;


%% Output folders

figure_folder = fullfile('output', 'figures');
data_folder = fullfile('output', 'data');

mkdir(figure_folder);
mkdir(data_folder);


%% System parameters

inertia = 5;
damping = 2;

target_time_constant = 0.5;

damping_ratio_underdamped = 0.707;
damping_ratio_critical = 1.0;


%% Step 1 - Model the equation of motion

% Equation of motion:
%
% I * omega_dot + c * omega = torque
%
% For this system:
%
% 5 * omega_dot + 2 * omega = torque

test_omega = 0;
test_torque = 1;

test_omega_dot = cylinder_dynamics(test_omega, test_torque, inertia, damping);

fprintf('Step 1 - Equation of Motion\n');
fprintf('5 * omega_dot + 2 * omega = torque\n\n');

fprintf('Example check:\n');
fprintf('omega = %.2f rad/s\n', test_omega);
fprintf('torque = %.2f N*m\n', test_torque);
fprintf('omega_dot = %.4f rad/s^2\n\n', test_omega_dot);


%% Step 2 - Model the plant transfer function

% Plant:
%
% Omega(s) / T(s) = 1 / (I*s + c)
%
% Omega(s) / T(s) = 1 / (5*s + 2)

plant_tf = model_plant(inertia, damping);

disp('Step 2 - Plant Transfer Function');
disp(plant_tf);


%% Step 5 - Compute PI controller gains

[kp_underdamped, ki_underdamped] = design_pi_controller(inertia, damping, damping_ratio_underdamped, target_time_constant);

[kp_critical, ki_critical] = design_pi_controller(inertia, damping, damping_ratio_critical, target_time_constant);

fprintf('Step 5 - PI Controller Gains\n\n');

fprintf('Underdamped Controller\n');
fprintf('zeta = %.3f\n', damping_ratio_underdamped);
fprintf('tau = %.3f s\n', target_time_constant);
fprintf('Kp = %.4f\n', kp_underdamped);
fprintf('Ki = %.4f\n\n', ki_underdamped);

fprintf('Critically Damped Controller\n');
fprintf('zeta = %.3f\n', damping_ratio_critical);
fprintf('tau = %.3f s\n', target_time_constant);
fprintf('Kp = %.4f\n', kp_critical);
fprintf('Ki = %.4f\n\n', ki_critical);


%% Step 3 - Model the closed-loop transfer functions

[controller_underdamped, closed_loop_underdamped] = build_closed_loop(plant_tf, kp_underdamped, ki_underdamped);

[controller_critical, closed_loop_critical] = build_closed_loop(plant_tf, kp_critical, ki_critical);

disp('Step 3 - Underdamped PI Controller');
disp(controller_underdamped);

disp('Underdamped Closed-Loop Transfer Function');
disp(closed_loop_underdamped);

disp('Step 3 - Critically Damped PI Controller');
disp(controller_critical);

disp('Critically Damped Closed-Loop Transfer Function');
disp(closed_loop_critical);


%% Step 4 - Compute second-order system parameters

underdamped_parameters = second_order_parameters(inertia, damping, kp_underdamped, ki_underdamped);

critical_parameters = second_order_parameters(inertia, damping, kp_critical, ki_critical);

fprintf('Step 4 - Underdamped System Parameters\n');
fprintf('zeta = %.4f\n', underdamped_parameters.damping_ratio);
fprintf('omega_n = %.4f rad/s\n', underdamped_parameters.natural_frequency);
fprintf('tau = %.4f s\n\n', underdamped_parameters.time_constant);

fprintf('Step 4 - Critically Damped System Parameters\n');
fprintf('zeta = %.4f\n', critical_parameters.damping_ratio);
fprintf('omega_n = %.4f rad/s\n', critical_parameters.natural_frequency);
fprintf('tau = %.4f s\n\n', critical_parameters.time_constant);


%% Save controller design data

controller_name = [
    "Underdamped"
    "Critically Damped"
];

damping_ratio = [
    underdamped_parameters.damping_ratio
    critical_parameters.damping_ratio
];

natural_frequency = [
    underdamped_parameters.natural_frequency
    critical_parameters.natural_frequency
];

time_constant = [
    underdamped_parameters.time_constant
    critical_parameters.time_constant
];

kp = [
    kp_underdamped
    kp_critical
];

ki = [
    ki_underdamped
    ki_critical
];

controller_design_table = table(controller_name, damping_ratio, natural_frequency, time_constant, kp, ki);

controller_data_path = fullfile(data_folder, 'pi_controller_design.csv');

writetable(controller_design_table, controller_data_path);


%% Step 6 - Simulate and compare both PI controllers

simulation_time = 0:0.001:3.5;

response_results = compare_pi_responses(closed_loop_underdamped, closed_loop_critical, simulation_time);


%% Save comparison figure

png_path = fullfile(figure_folder, 'pi_controller_step_response.png');
fig_path = fullfile(figure_folder, 'pi_controller_step_response.fig');

exportgraphics(gcf, png_path, 'Resolution', 300);
savefig(gcf, fig_path);


%% Display step-response information

disp('Step 6 - Underdamped Response');
disp(response_results.underdamped_info);

disp('Step 6 - Critically Damped Response');
disp(response_results.critical_info);


%% Save step-response metrics

controller_type = [
    "Underdamped"
    "Critically Damped"
];

rise_time = [
    response_results.underdamped_info.RiseTime
    response_results.critical_info.RiseTime
];

settling_time = [
    response_results.underdamped_info.SettlingTime
    response_results.critical_info.SettlingTime
];

overshoot = [
    response_results.underdamped_info.Overshoot
    response_results.critical_info.Overshoot
];

peak = [
    response_results.underdamped_info.Peak
    response_results.critical_info.Peak
];

peak_time = [
    response_results.underdamped_info.PeakTime
    response_results.critical_info.PeakTime
];

response_metrics_table = table(controller_type, rise_time, settling_time, overshoot, peak, peak_time);

response_metrics_path = fullfile(data_folder, 'pi_response_metrics.csv');

writetable(response_metrics_table, response_metrics_path);


%% Save MATLAB workspace

workspace_path = fullfile(data_folder, 'lab4_workspace.mat');

save(workspace_path);


%% Completion message

fprintf('\nLab 4 simulation complete.\n');
fprintf('Figures saved in: %s\n', figure_folder);
fprintf('Data saved in: %s\n', data_folder);