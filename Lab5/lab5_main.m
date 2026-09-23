%% Lab 5 Root Locus and System Response



K_max = 100; % Not sure if this should be 100 or 1000
             % 100 matches the plot better, but the step 2 asks for 1000
             
res = 25; % Very high but improves the plot near where the roots go from
          % purely real to complex

root_locus = zeros([3,res*K_max]);
K = linspace(0,K_max,res*K_max);


for i = 1:res*K_max
    
    poly = [1, 7, 10, K(i)];

    root_locus(:,i) = roots(poly);

end

% Open Loop Roots
open_loop_poly = [1, 7, 10, 0];
open_loop_roots = roots(open_loop_poly);

plot(real(root_locus), imag(root_locus), 'b.');
grid on;
hold on;
plot(real(open_loop_roots),imag(open_loop_roots),'rx', MarkerSize=10);
hold off;
title('Root Locus of G(s) = 1/(s(s+2)(s+5))');
xlabel('Real Part');
ylabel('Imaginary Part');
xlim([-10 2]);
ylim([-10 10]);

%% Using 'rlocus'

plant_den = [1, 7, 10, 0];
plant_tf = tf(1, plant_den);
% closed_loop_tf = feedback(plant_tf, 1);

figure;
rlocus(plant_tf);
grid on;
xlim([-10 2]);
ylim([-10 10])
title('Root Locus of G(s) = 1/(s(s+2)(s+5))')

