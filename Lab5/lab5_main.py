"""Root Locus and System Response Analysis."""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal


def compute_root_locus(k_max=100, resolution=25):
    """
    Compute root locus for the system G(s) = 1/(s(s+2)(s+5)).

    Args:
        k_max: Maximum gain value (default: 100).
        resolution: Resolution multiplier for gain spacing (default: 25).

    Returns:
        tuple: (gain_values, root_locus_array)
    """
    res = resolution
    num_points = res * k_max
    root_locus = np.zeros((3, num_points), dtype=complex)
    gain_values = np.linspace(0, k_max, num_points)

    for i, k in enumerate(gain_values):
        # Characteristic polynomial: s^3 + 7s^2 + 10s + K
        poly = np.array([1, 7, 10, k])
        root_locus[:, i] = np.roots(poly)

    return gain_values, root_locus


def get_open_loop_roots():
    """
    Get the open-loop poles of G(s) = 1/(s(s+2)(s+5)).

    Returns:
        ndarray: Open-loop poles.
    """
    open_loop_poly = np.array([1, 7, 10, 0])
    return np.roots(open_loop_poly)


def plot_manual_root_locus(gain_values, root_locus, open_loop_roots):
    """Plot manually computed root locus."""
    plt.figure(figsize=(10, 8))
    plt.plot(np.real(root_locus), np.imag(root_locus), 'b.', markersize=3)
    plt.plot(np.real(open_loop_roots), np.imag(open_loop_roots),
             'rx', markersize=10, label='Open-loop poles')
    plt.grid(True, alpha=0.3)
    plt.title('Root Locus of G(s) = 1/(s(s+2)(s+5))')
    plt.xlabel('Real Part')
    plt.ylabel('Imaginary Part')
    plt.xlim(-10, 2)
    plt.ylim(-10, 10)
    plt.legend()
    plt.tight_layout()
    plt.show()


def plot_scipy_root_locus():
    """Plot root locus using scipy control systems."""
    # Define the system transfer function
    numerator = [1]
    denominator = [1, 7, 10, 0]
    system = signal.TransferFunction(numerator, denominator)

    # Create root locus plot
    plt.figure(figsize=(10, 8))

    # Manually create root locus for scipy (since scipy doesn't have rlocus)
    k_values = np.linspace(0, 100, 2500)
    roots_array = np.zeros((3, len(k_values)), dtype=complex)

    for i, k in enumerate(k_values):
        poly = np.array([1, 7, 10, k])
        roots_array[:, i] = np.roots(poly)

    plt.plot(np.real(roots_array), np.imag(roots_array), 'b.', markersize=3)
    plt.grid(True, alpha=0.3)
    plt.xlim(-10, 2)
    plt.ylim(-10, 10)
    plt.title('Root Locus of G(s) = 1/(s(s+2)(s+5))')
    plt.xlabel('Real Part')
    plt.ylabel('Imaginary Part')
    plt.tight_layout()
    plt.show()


if __name__ == '__main__':
    # Note: K_max = 100 matches the plot better than 1000,
    # though step 2 may ask for 1000
    K_MAX = 100
    RESOLUTION = 25  # High resolution for accurate plot near
                      # real-to-complex transition

    # Compute root locus
    k_vals, root_locus_data = compute_root_locus(K_MAX, RESOLUTION)
    open_loop_poles = get_open_loop_roots()

    # Plot manual root locus
    plot_manual_root_locus(k_vals, root_locus_data, open_loop_poles)

    # Plot using scipy (alternative method)
    plot_scipy_root_locus()
