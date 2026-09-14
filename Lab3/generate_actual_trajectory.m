function [current, angle, speed] = generate_actual_trajectory(time, parameters, voltage, init_current)
%GENERATE_ACTUAL_TRAJECTORY Use calculated voltage to get actual results.
%

% Add parameter values (shorten variable names)
Ra = parameters.armature_resistance;
La = parameters.armature_inductance;
KT = parameters.torque_constant;
KB = parameters.back_emf_constant;
Ieq = parameters.equivalent_inertia;

g = parameters.gravity;
m_arm = parameters.arm_mass;
L_arm = parameters.arm_length;

total_gear_ratio = parameters.gear_ratio_1 * parameters.gear_ratio_2;

Td = m_arm*g*L_arm / total_gear_ratio;

% x(1) = current, x(2) = angle, x(3) = speed

voltage_t = @(t) interp1(time, voltage, t, 'linear', 'extrap');

xdot = @(t,x)[(-Ra * x(1) - KB * total_gear_ratio * x(3) + voltage_t(t)) / La; % current derivative
        x(3); % angle derivative
        (KT * x(1) - Td*sin(x(2))) / (Ieq*total_gear_ratio)]; % speed derivative

x0 = [init_current; 0; 0]; % initial current taken from current_result

[~,outputs] = ode45(xdot,time,x0);

current = outputs(:,1);
angle = outputs(:,2);
speed = outputs(:,3);