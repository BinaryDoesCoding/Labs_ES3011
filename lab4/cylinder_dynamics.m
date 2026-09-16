function omega_dot = cylinder_dynamics(omega, torque, inertia, damping)
    %CYLINDER_DYNAMICS Compute angular acceleration of the cylinder.
    %
    % Equation of motion:
    %
    % I * omega_dot + c * omega = torque
    %
    % Therefore:
    %
    % omega_dot = (torque - c * omega) / I

    damping_torque = damping * omega;
    net_torque = torque - damping_torque;

    omega_dot = net_torque / inertia;
end
