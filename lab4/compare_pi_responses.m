function response_results = compare_pi_responses(system_underdamped, system_critical, simulation_time)
    %COMPARE_PI_RESPONSES Plot and compare both PI-controlled systems.

    [omega_underdamped, time_underdamped] = step(system_underdamped, simulation_time);
    [omega_critical, time_critical] = step(system_critical, simulation_time);

    figure;

    plot(time_critical, omega_critical, 'LineWidth', 1.8);
    hold on;
    plot(time_underdamped, omega_underdamped, '--', 'LineWidth', 1.8);

    xlabel('Time (s)');
    ylabel('\omega (rad/s)');
    title('Step Response of the System');

    legend('\zeta = 1 (Critically Damped)', '\zeta = 0.707 (Underdamped)', 'Location', 'best');

    grid on;
    hold off;

    underdamped_info = stepinfo(system_underdamped);
    critical_info = stepinfo(system_critical);

    response_results.underdamped_info = underdamped_info;
    response_results.critical_info = critical_info;
end
