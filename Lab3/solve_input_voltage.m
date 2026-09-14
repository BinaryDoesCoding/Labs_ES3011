function [voltage, current] = solve_input_voltage(parameters, angle, speed, acceleration)
%SOLVE_INPUT_VOLTAGE Use parameters and trajectory to find required input
%voltage

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


% va - Ra*ia - La*dia/dt = KB*N1*N2*wL
% ia = (N1*N2*Ieq*aL + Td*sin(Ø))/KT
% dia/dt = (Td*wL*cos(Ø))/KT
% sub in ia and dia/dt to find va in terms of trajectory

current = (total_gear_ratio*Ieq*acceleration + Td*sin(angle))/KT;

R_voltage = Ra*current;
L_voltage = La*(Td*speed.*cos(angle))/KT;
motor_voltage = KB*total_gear_ratio*speed;

voltage = R_voltage + L_voltage + motor_voltage;

