function parameters = second_order_parameters(inertia, damping, kp, ki)
    %SECOND_ORDER_PARAMETERS Compute zeta, omega_n, and tau.
    %
    % For the closed-loop characteristic polynomial:
    %
    % I*s^2 + (c + Kp)*s + Ki
    %
    % the second-order parameters are:
    %
    % omega_n = sqrt(Ki / I)
    %
    % zeta = (c + Kp) / (2 * sqrt(I * Ki))
    %
    % tau = 1 / (zeta * omega_n)

    natural_frequency = sqrt(ki / inertia);

    damping_denominator = 2 * sqrt(inertia * ki);
    damping_ratio = (damping + kp) / damping_denominator;

    time_constant = 1 / (damping_ratio * natural_frequency);

    parameters.natural_frequency = natural_frequency;
    parameters.damping_ratio = damping_ratio;
    parameters.time_constant = time_constant;
end
