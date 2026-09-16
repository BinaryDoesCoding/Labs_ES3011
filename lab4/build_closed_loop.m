function [controller_tf, closed_loop_tf] = build_closed_loop(plant_tf, kp, ki)
    %BUILD_CLOSED_LOOP Create PI controller and unity-feedback system.
    %
    % PI controller:
    %
    % C(s) = Kp + Ki/s
    %
    %      = (Kp*s + Ki) / s
    %
    % Closed-loop transfer function:
    %
    % G_cl(s) = C(s)G(s) / (1 + C(s)G(s))

    controller_numerator = [kp, ki];
    controller_denominator = [1, 0];

    controller_tf = tf(controller_numerator, controller_denominator);

    open_loop_tf = controller_tf * plant_tf;
    closed_loop_tf = feedback(open_loop_tf, 1);
end
