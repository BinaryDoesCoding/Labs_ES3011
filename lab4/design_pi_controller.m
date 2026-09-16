function [kp, ki] = design_pi_controller(inertia, damping, damping_ratio, time_constant)
    %DESIGN_PI_CONTROLLER Compute PI gains from desired specifications.
    %
    % Closed-loop characteristic polynomial:
    %
    % I*s^2 + (c + Kp)*s + Ki
    %
    % Normalized form:
    %
    % s^2 + ((c + Kp) / I)*s + Ki / I
    %
    % Standard second-order form:
    %
    % s^2 + 2*zeta*omega_n*s + omega_n^2
    %
    % Using tau = 1 / (zeta * omega_n):
    %
    % Kp = 2*I/tau - c
    % Ki = I / (zeta^2 * tau^2)

    proportional_numerator = 2 * inertia;
    kp = proportional_numerator / time_constant - damping;

    damping_ratio_squared = damping_ratio^2;
    time_constant_squared = time_constant^2;

    integral_denominator = damping_ratio_squared * time_constant_squared;
    ki = inertia / integral_denominator;
end
