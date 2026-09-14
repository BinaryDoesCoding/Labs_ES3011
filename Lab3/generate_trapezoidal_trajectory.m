function [angle, speed, acceleration] = generate_trapezoidal_trajectory(time, trajectory)
%GENERATE_TRAPEZOIDAL_TRAJECTORY Generate desired arm motion.
% DON'T TOUCH

    final_angle = trajectory.final_angle;
    acceleration_end_time = trajectory.acceleration_end_time;
    deceleration_start_time = trajectory.deceleration_start_time;
    final_time = trajectory.final_time;

    acceleration_time = acceleration_end_time;
    constant_speed_time = deceleration_start_time - acceleration_end_time;
    deceleration_time = final_time - deceleration_start_time;

    equivalent_motion_time = constant_speed_time;
    equivalent_motion_time = equivalent_motion_time + acceleration_time / 2;
    equivalent_motion_time = equivalent_motion_time + deceleration_time / 2;

    maximum_speed = final_angle / equivalent_motion_time;
    angular_acceleration = maximum_speed / acceleration_time;

    angle = zeros(size(time));
    speed = zeros(size(time));
    acceleration = zeros(size(time));

    angle_at_acceleration_end = 0.5 * angular_acceleration * acceleration_time^2;

    cruise_displacement = maximum_speed * constant_speed_time;
    angle_at_deceleration_start = angle_at_acceleration_end + cruise_displacement;

    for index = 1:length(time)
        current_time = time(index);

        if current_time < acceleration_end_time
            acceleration(index) = angular_acceleration;
            speed(index) = angular_acceleration * current_time;
            angle(index) = 0.5 * angular_acceleration * current_time^2;

        elseif current_time < deceleration_start_time
            cruise_time = current_time - acceleration_end_time;

            acceleration(index) = 0;
            speed(index) = maximum_speed;
            angle(index) = angle_at_acceleration_end + maximum_speed * cruise_time;

        else
            current_deceleration_time = current_time - deceleration_start_time;

            acceleration(index) = -angular_acceleration;
            speed(index) = maximum_speed - angular_acceleration * current_deceleration_time;

            deceleration_displacement = maximum_speed * current_deceleration_time;
            deceleration_correction = 0.5 * angular_acceleration * current_deceleration_time^2;

            angle(index) = angle_at_deceleration_start + deceleration_displacement - deceleration_correction;
        end
    end
end