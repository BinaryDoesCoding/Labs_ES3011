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

The lab introduced important operations working with vectors/matrices, plots, and polynomials in MATLAB in order to solve differential equations of mechanical or electrical systems.

## Methods

```m
%% Jefferson E Gonzalez

clear;
clc;
close all;

% A
random_matrix = rand(3,3);
ic_matrix = eye(3);
in_vector = [2; 5; 9];
result_vector = (random_matrix + ic_matrix) * in_vector;

% B
time = 0:0.01:10;
sine_output = sin(time);

figure;
plot(time, sine_output);
xlabel('Time (s)');
ylabel('y = sin(t)');
title('lab 1 part b');

% C
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

% D
s = tf('s');
polynomial = s^4 + 3*s^3 - 15*s^2 - 2*s + 9;
polynomial_roots = zero(polynomial);
```

### Figures

![First Order FK Teleplot](images/first_order_fk.png)

**Figure 1.** abcde..

## Conclusion

The lab utilized MATLAB to perform operations on vectors, matrices, and equations as well as plotting functions in both 2D and 3D. Specifically, part A demonstrated how to perform matrix addition and multiplication while part B used 2D plots ... to be continued

## Contribution Table

| Student | Contribution |
|---|---|
| Jefferson Gonzalez Campos | Wrote MATLAB script to solve the problems, provided lab report template|
| Maddox Burdon | Wrote/organized the lab report, assisted with MATLAB script|
