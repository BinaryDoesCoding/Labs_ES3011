---
title: "ES 3011 Lab 1"
author: "xxx xxx xxx"
date: "A-Term 2026"
geometry: margin=1.25in
fontsize: 11pt
header-includes:
  - \usepackage{etoolbox}
  - \AtBeginEnvironment{tabular}{\footnotesize}
---


## Summary

For this extra credit activity, we implemented and compared three forward kinematics odometry update methods for the Romi: first-order Euler, second-order midpoint, and ICC arc integration. The goal was to compare how each FK algorithm affected the robot's estimated path during a drive-to-point test.

## Methods

We modified the kinematics code so that `UpdatePoseFromOdometry()` could be switched between the three FK algorithms by commenting and uncommenting one define at the top of `kinematics.cpp`. This let us run the same drive-to-point style test with first-order Euler, second-order midpoint, and ICC without changing the rest of the robot state machine.

```cpp
// Uncomment exactly one odometry version.
#define ODOM_USE_FIRST_ORDER
//#define ODOM_USE_SECOND_ORDER
//#define ODOM_USE_ICC
```

The main odometry function then selects the active implementation based on that define.

```cpp
%% Jefferson E Gonzalez

clear;
clc;
close all;

random_matrix = rand(3,3);
ic_matrix = eye(3);
in_vector = [2; 5; 9];
result_vector = (random_matrix + ic_matrix) * in_vector;

time = 0:0.01:10;
sine_output = sin(time);

figure;
plot(time, sine_output);
xlabel('Time (s)');
ylabel('y = sin(t)');
title('lab 1 part b');

x_values = linspace(-3,3,100);
y_values = linspace(-1,5,100);
[x_grid,y_grid] = meshgrid(x_values,y_values);
surface_z = x_grid.^2 + y_grid.^2;

figure;
surf(x_grid, y_grid, surface_z);
xlabel('x');
ylabel('y');
zlabel('z');
title('z = x^2 + y^2');

s = tf('s');
polynomial = s^4 + 3*s^3 - 15*s^2 - 2*s + 9;
polynomial_roots = zero(polynomial);
```

For the experiment, we ran the same drive-to-point style test three times, once for each FK method. During each run, the Romi printed Teleplot and CSV data for the encoder-based odometry estimate and the simulated command-based estimate. The recorded data included real position, simulated position, real heading, simulated heading, position error, and heading error. The final comparison used the last CSV row before the robot transitioned into searching or AprilTag alignment so that the comparison stayed focused on the dead-reckoning portion of the run.

## Results


### Table 1. Final FK Comparison Data

| FK Algorithm | Time Before Transition (ms) | Real X (cm) | Real Y (cm) | Sim X (cm) | Sim Y (cm) | X Error (cm) | Y Error (cm) | Position Error (cm) | Theta Error (rad) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| First Order Euler | 5765 | 70.319 | 23.711 | 123.546 | 93.074 | -53.227 | -69.363 | 87.432 | -0.3938 |
| Second Order Midpoint | 7300 | 69.655 | 23.503 | 127.194 | 88.850 | -57.539 | -65.347 | **87.069** | -0.3437 |
| ICC Arc Method | 7878 | 69.968 | 23.666 | 128.692 | 91.734 | -58.724 | -68.069 | 89.899 | **-0.3365** |

### Figures

![First Order FK Teleplot](images/first_order_fk.png)

**Figure 1.** abcde..

## Conclusion

something something

## Contribution Table

| Student | Contribution | Nominal Points |
|---|---|---:|
| Jefferson Gonzalez Campos | Implemented and tested the FK method comparison, collected Teleplot and CSV data, created the comparison tables, wrote the code snippets and formulas section, and wrote the extra credit summary. | 15 |

\newpage
