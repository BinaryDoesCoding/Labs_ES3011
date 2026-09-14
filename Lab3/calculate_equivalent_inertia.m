function equivalent_inertia = calculate_equivalent_inertia(parameters)
%CALCULATE_EQUIVALENT_INERTIA Calculate inertia referred to motor shaft.
% DON'T TOUCH

    gear_ratio_1 = parameters.gear_ratio_1;
    gear_ratio_2 = parameters.gear_ratio_2;

    total_gear_ratio = gear_ratio_1 * gear_ratio_2;

    motor_side_inertia = parameters.motor_inertia;
    motor_side_inertia = motor_side_inertia + parameters.gear_1_inertia;

    middle_shaft_inertia = parameters.gear_2_inertia;
    middle_shaft_inertia = middle_shaft_inertia + parameters.gear_3_inertia;
    middle_shaft_inertia = middle_shaft_inertia / gear_ratio_1^2;

    arm_inertia = parameters.arm_mass * parameters.arm_length^2;

    load_side_inertia = parameters.gear_4_inertia + arm_inertia;
    load_side_inertia = load_side_inertia / total_gear_ratio^2;

    equivalent_inertia = motor_side_inertia;
    equivalent_inertia = equivalent_inertia + middle_shaft_inertia;
    equivalent_inertia = equivalent_inertia + load_side_inertia;
end