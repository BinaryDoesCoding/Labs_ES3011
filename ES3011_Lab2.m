%% Lab 2 - DC Motor Simulation

clear;
clc;

% Given Perameters

va = 10; % V
Kb = 0.05; % V*s/rad
KT = 0.05; % kg*m^2
La = 0.002; % H
c = 0.0004; % N*m*s/rad
TL = 0; % N*m
I = 0.00009; % kg*m^2
Ra = 0.5; % Ω

%% Solving ODEs for ia, w

% Equations and solving (y(1) = ia y(2) = w)

equations = @(t,y) [(va-Ra*y(1)-Kb*y(2))/La;
            (KT*y(1)-c*y(2)-TL)/I];
tspan = linspace(0,0.1,1000);
y0 = [0; 0];

[t,outputs] = ode45(equations,tspan,y0);
ia = outputs(:, 1);
w = outputs(:, 2);

% Current plot

subplot(2,1,1);
plot(t, ia, 'LineWidth', 1.5, 'Color', 'blue');
title('DC Motor Constant Voltage Outputs');
xlabel('Time (s)');
ylabel('Current (A)');
ylim([min(ia)-1 max(ia)+1]);
grid on;

% Angular velocity plot

subplot(2,1,2);
plot(t, w, 'LineWidth', 1.5, 'Color', 'red');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
ylim([min(w)-25 max(w)+25]);
grid on;

%% Transfer Function (Ω(s)/V(s))

% Defining transfer function

num = KT;
den = [(I*La),(I*Ra+c*La),(Kb*KT+c*Ra)];

sys = tf(num,den);

% Time and step input vectors

t = linspace(0, 0.1, 1000);
u = 1;
uvec = ones(size(t))*u;

% Simulation and plot

sim = lsim(sys, uvec, t);

figure;
plot(t, sim, 'LineWidth', 1.5);
title('Linear Simulation Results of G(s) = Ω(s)/V(s) with Step Input');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
