%% ES 3011 Control Engineering - Lab #6: Lead and Lag Compensators
%  2026 Fall A  |  Dr. Hunter Zhang            STUDENT STARTER SCRIPT
%
%  Team: ______________________  ______________________  ______________________
%  Section (AX01 / AX02): ______
%
%  Run ONE section at a time with Ctrl+Enter. Fill in every "% TODO".
%
%  SPECS   S1  overshoot <= 25%     S2  settling time (2%) <= 2 s
%          S3  steady-state ramp error <= 0.05 rad (1 rad/s ramp, measured at t = 60 s)

clear; clc; close all;
format short g

G = zpk([], [0 -2 -10], 20);     % robot-arm joint: 20 / (s (s+2) (s+10))
t = (0:0.01:60)';                % ramp test time vector: 60 s, long enough for the lag's slow tail


%% PART 1 - P control:  C(s) = K
Klist = [0.5 1 1.5 2 3 4 6 8];
res = zeros(numel(Klist), 4);
for i = 1:numel(Klist)
    T = feedback(Klist(i)*G, 1);             % closed loop
    S = stepinfo(T);                         % overshoot and settling time
    y = lsim(T, t, t);                       % response to the ramp r(t) = t
    res(i,:) = [Klist(i), S.Overshoot, S.SettlingTime, t(end) - y(end)];
end
disp(array2table(res, 'VariableNames', {'K','Overshoot_pct','Ts_s','RampErr_rad'}))

figure('Name','Part 1 - P control sweep');
subplot(1,2,1); plot(res(:,1), res(:,2), 'o-', 'LineWidth', 1.5); grid on;
xlabel('K'); ylabel('Overshoot (%)'); title('Overshoot vs K');
subplot(1,2,2); plot(res(:,1), res(:,3), 'o-', 'LineWidth', 1.5); grid on;
xlabel('K'); ylabel('Settling time (s)'); title('Settling time vs K');

% Find the smallest K that gives about 20% overshoot
KP = NaN;
for K = 0.5:0.01:8
    S = stepinfo(feedback(K*G, 1));
    if S.Overshoot >= 20
        KP = K; break
    end
end
T_P = feedback(KP*G, 1);
S_P = stepinfo(T_P);  y = lsim(T_P, t, t);
fprintf('\nP control: K = %.2f  overshoot = %.1f%%  settling = %.2f s  ramp error = %.3f rad\n', ...
        KP, S_P.Overshoot, S_P.SettlingTime, t(end) - y(end));

% Q1: Does any K in the table settle in 2 s or less? What happens to settling time for K = 3 to 8?

% No K has a settling time that is 2 s or less. From K=3 to K=8, the
% settling time begins to increase exponentially.

% Q2: Compare the ramp error with 1/K.

% The ramp error is approximately 1/K for every K value. For instance, at
% K=0.5, the error is 2 (1/0.5=2) and at K=8, the error is 0.125
% (1/8=0.125)


%% PART 2 - Lead compensator:  C(s) = Kc (s + 2)/(s + 20)
Clead = zpk(-2, -20, 1);                 % (s+2)/(s+20): zero at -2, pole at -20

% Root locus with and without the lead. The two dotted rays from sgrid mark 20% overshoot
% (zeta = 0.456): poles on them give about 20%. In the right plot the x and o at -2 sit on
% top of each other - that is the cancellation.
figure('Name','Part 2 - root locus');
subplot(1,2,1); rlocus(G);         sgrid(0.456, []); axis([-25 5 -15 15]); title('P control');
subplot(1,2,2); rlocus(Clead*G);   sgrid(0.456, []); axis([-25 5 -15 15]); title('With lead');

% Find the smallest Kc that gives about 20% overshoot (same search as Part 1)
Kc = NaN;
for k = 10:0.5:150
    S = stepinfo(feedback(minreal(k*Clead*G), 1));   % minreal cancels (s+2) against the pole at -2
    if S.Overshoot >= 20
        Kc = k; break
    end
end
L_lead = minreal(Kc*Clead*G);
T_lead = feedback(L_lead, 1);
S_lead = stepinfo(T_lead);  y = lsim(T_lead, t, t);
fprintf('\nLead: Kc = %.1f  overshoot = %.1f%%  settling = %.2f s  ramp error = %.3f rad\n', ...
        Kc, S_lead.Overshoot, S_lead.SettlingTime, t(end) - y(end));
disp('Closed-loop poles with lead:'); disp(pole(T_lead));
disp('Closed-loop poles with P:');    disp(pole(T_P));

% Motor command u(t) for a unit step:  u = C/(1 + C G) * r
figure('Name','Part 2 - motor command');
step(feedback(KP, G), feedback(Kc*Clead, G), 3); grid on;
legend('P control', 'Lead'); title('Motor command u(t) for a unit step');
fprintf('Peak motor command (at t = 0): P = %.2f, lead = %.1f  (%.0fx larger)\n', KP, Kc, Kc/KP);

% Q3: How much faster than P? Explain with the closed-loop poles (Ts is about 4/|real part|).

% The lead control has a settling time of 1.22 s and the P control has a
% settling time of 4.75 s, making the lead control 3.53 s faster. This is
% due to the lead controller having poles much farther from the imaginary
% axis in the left half of the plane. The dominant pair in the lead control
% has a real part at -3.1515 where the P control's is much closer to 0 at
% -0.80816. Approximating the settling time with 4/|real part of dominant
% pair|, the lead control approximates 1.27 s and the P control
% approximates 4.95 s.

% Q4: How many times larger is the lead's peak motor command, and why could that matter?

% The lead's peak motor command is 36x larger than the proportional
% controller. This could matter if the controller outputs a voltage and
% this large gain exceeds the voltage limit of the motor, causing damaging
% the motor.


%% PART 3 - Add a lag:  C(s) = Kc (s + 2)/(s + 20) * (s + 0.1)/(s + 0.01)
Clag = zpk(-0.1, -0.01, 1);              % (s+0.1)/(s+0.01): steady-state gain 0.1/0.01 = 10

% TODO: build the lead+lag loop with the SAME Kc. One line:
L_ll = minreal(Kc*Clead*Clag*G);
% L_ll = [];                                % TODO
if isempty(L_ll), error('Part 3: build L_ll first (see the TODO above).'); end
T_ll = feedback(L_ll, 1);
S_ll = stepinfo(T_ll);  y = lsim(T_ll, t, t);
fprintf('\nLead + lag: overshoot = %.1f%%  settling = %.2f s  ramp error = %.4f rad\n', ...
        S_ll.Overshoot, S_ll.SettlingTime, t(end) - y(end));
disp('Closed-loop poles with lead + lag:'); disp(pole(T_ll));

% Q5: By what factor did the ramp error drop? Where does that factor come from?

% The ramp error dropped by about a factor of 10. This factor comes from
% the ratio of the zero to the pole in the lag compensator
% (z/p=-0.1/-0.01=10)

% Q6: Overshoot and settling time changed only a little. Why?

% Introducing the lag compensator with such a low pole value slightly pulls
% the dominant pair of poles back towards the imaginary axis as well as 
% introducing an additional pole very close to the axis. This causes
% the settling time to increase slightly from 1.22 s to 1.65 s, and this
% extra settling time allows the overshoot to increase slightly before
% being brought back down to the desired value.


%% PART 4 - Put it togethe
figure('Name','Part 4 - step responses');
step(T_P, T_lead, T_ll, 8); grid on;
legend('P', 'Lead', 'Lead + lag', 'Location', 'southeast');
title('Step responses');

figure('Name','Part 4 - ramp tracking error'); hold on;
for Tc = {T_P, T_lead, T_ll}
    y = lsim(Tc{1}, t, t);
    plot(t, t - y, 'LineWidth', 1.5);
end
yline(0.05, '--', 'S3 limit (steady state)');
hold off; grid on;
xlabel('Time (s)'); ylabel('Tracking error (rad)'); ylim([0 1]);
legend('P', 'Lead', 'Lead + lag'); title('Ramp tracking error');

% TODO: fill in the summary table in your report (overshoot, settling time,
%       ramp error, and which specs each controller meets).


%% BONUS - move the lead zero
% TODO (optional): try C(s) = Kc (s + z)/(s + 20) with z = 1 and z = 4.
%       Copy the Part 2 search (use zpk(-z, -20, 1)), re-tune Kc for about
%       20% overshoot each time, and compare settling times.

% With z = 1, the Kc becomes 91.0 for 20.0% overshoot, with a settling time
% of 1.78s. With z = 4, the Kc becomes 19.0 for 20.0% overshoot, with a settling time
% of 2.59s. Both alternative zeros have slower settling times because the
% zero at -2 cancels with the pole at -2 from the motor, making it the most
% optimal option as it eliminates the slowest pole.

%% Bonus - z = 1

Clead = zpk(-1, -20, 1);                 % (s+1)/(s+20): zero at -1, pole at -20

% Root locus with and without the lead. The two dotted rays from sgrid mark 20% overshoot
% (zeta = 0.456): poles on them give about 20%. In the right plot the x and o at -2 sit on
% top of each other - that is the cancellation.
figure('Name','Bonus (z=1) - root locus');
subplot(1,2,1); rlocus(G);         sgrid(0.456, []); axis([-25 5 -15 15]); title('P control');
subplot(1,2,2); rlocus(Clead*G);   sgrid(0.456, []); axis([-25 5 -15 15]); title('With lead');

% Find the smallest Kc that gives about 20% overshoot (same search as Part 1)
Kc = NaN;
for k = 10:0.5:150
    S = stepinfo(feedback(minreal(k*Clead*G), 1));   % minreal cancels (s+2) against the pole at -2
    if S.Overshoot >= 20
        Kc = k; break
    end
end
L_lead = minreal(Kc*Clead*G);
T_lead = feedback(L_lead, 1);
S_lead = stepinfo(T_lead);  y = lsim(T_lead, t, t);
fprintf('\nLead: Kc = %.1f  overshoot = %.1f%%  settling = %.2f s  ramp error = %.3f rad\n', ...
        Kc, S_lead.Overshoot, S_lead.SettlingTime, t(end) - y(end));
disp('Closed-loop poles with lead:'); disp(pole(T_lead));
disp('Closed-loop poles with P:');    disp(pole(T_P));

% Motor command u(t) for a unit step:  u = C/(1 + C G) * r
figure('Name','Bonus (z=1) - motor command');
step(feedback(KP, G), feedback(Kc*Clead, G), 3); grid on;
legend('P control', 'Lead'); title('Motor command u(t) for a unit step');
fprintf('Peak motor command (at t = 0): P = %.2f, lead = %.1f  (%.0fx larger)\n', KP, Kc, Kc/KP);


%% Bonus - z = 4

Clead = zpk(-4, -20, 1);                 % (s+4)/(s+20): zero at -4, pole at -20

% Root locus with and without the lead. The two dotted rays from sgrid mark 20% overshoot
% (zeta = 0.456): poles on them give about 20%. In the right plot the x and o at -2 sit on
% top of each other - that is the cancellation.
figure('Name','Bonus (z=4) - root locus');
subplot(1,2,1); rlocus(G);         sgrid(0.456, []); axis([-25 5 -15 15]); title('P control');
subplot(1,2,2); rlocus(Clead*G);   sgrid(0.456, []); axis([-25 5 -15 15]); title('With lead');

% Find the smallest Kc that gives about 20% overshoot (same search as Part 1)
Kc = NaN;
for k = 10:0.5:150
    S = stepinfo(feedback(minreal(k*Clead*G), 1));   % minreal cancels (s+2) against the pole at -2
    if S.Overshoot >= 20
        Kc = k; break
    end
end
L_lead = minreal(Kc*Clead*G);
T_lead = feedback(L_lead, 1);
S_lead = stepinfo(T_lead);  y = lsim(T_lead, t, t);
fprintf('\nLead: Kc = %.1f  overshoot = %.1f%%  settling = %.2f s  ramp error = %.3f rad\n', ...
        Kc, S_lead.Overshoot, S_lead.SettlingTime, t(end) - y(end));
disp('Closed-loop poles with lead:'); disp(pole(T_lead));
disp('Closed-loop poles with P:');    disp(pole(T_P));

% Motor command u(t) for a unit step:  u = C/(1 + C G) * r
figure('Name','Bonus (z=4) - motor command');
step(feedback(KP, G), feedback(Kc*Clead, G), 3); grid on;
legend('P control', 'Lead'); title('Motor command u(t) for a unit step');
fprintf('Peak motor command (at t = 0): P = %.2f, lead = %.1f  (%.0fx larger)\n', KP, Kc, Kc/KP);


%% ------------------------------------------------------------------------
disp(' '); disp('Save figures with:  saveas(figure(n), ''Lab6_FigureN.png'')');
