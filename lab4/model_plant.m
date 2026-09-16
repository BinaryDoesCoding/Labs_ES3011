function plant_tf = model_plant(inertia, damping)
    %MODEL_PLANT Create the cylinder plant transfer function.
    %
    % From:
    %
    % I * omega_dot + c * omega = torque
    %
    % Taking the Laplace transform with zero initial conditions gives:
    %
    % (I * s + c) * Omega(s) = T(s)
    %
    % Therefore:
    %
    % Omega(s) / T(s) = 1 / (I * s + c)

    plant_numerator = 1;
    plant_denominator = [inertia, damping];

    plant_tf = tf(plant_numerator, plant_denominator);
end
