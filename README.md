# Coupled Whale Population Model

A Julia-based numerical simulation of interacting blue whale and fin whale populations. This project models how both species change over time when each population experiences logistic growth and both populations are affected by a shared interaction term. The system is approximated with the forward Euler method and visualized with `Plots.jl`.

The repository is intended as a small numerical-methods and population-dynamics study. It demonstrates how to define a coupled system of ordinary differential equations, advance the system with a discrete time step, store the simulated states, and compare trajectories in both time-series and phase-space plots.

## Table of Contents

- [Overview](#overview)
- [Mathematical Model](#mathematical-model)
- [Parameter Values](#parameter-values)
- [Numerical Method](#numerical-method)
- [Repository Contents](#repository-contents)
- [Requirements](#requirements)
- [Installation](#installation)
- [Running the Project](#running-the-project)
- [Simulation Sections](#simulation-sections)
- [Expected Output](#expected-output)
- [Interpreting the Results](#interpreting-the-results)
- [Numerical Stability](#numerical-stability)

## Overview

The model tracks two state variables:

- `B`: blue whale population
- `F`: fin whale population

When considered separately, each species follows logistic growth. Logistic growth allows a population to increase rapidly when it is small, then slow as it approaches the carrying capacity of its environment. The model also subtracts an interaction term, `α * B * F`, from both growth equations. This term represents a negative effect that grows when both populations are large, such as competition for shared resources.

The code explores several questions:

1. How does the fin whale population change over time from the selected initial condition?
2. What trajectory does the coupled system follow in blue-whale/fin-whale phase space?
3. How does the Euler step size affect the apparent long-term behavior of the model?
4. How does starting at the individual carrying capacities change the simulated trajectory?

## Mathematical Model

The coupled differential equations are:

```text
dB/dt = 0.05B(1 - B/150000) - α*B*F
dF/dt = 0.08F(1 - F/400000) - α*B*F
```

The first term in each equation is logistic growth. For blue whales, the intrinsic growth rate is `0.05` and the carrying capacity is `150000`. For fin whales, the intrinsic growth rate is `0.08` and the carrying capacity is `400000`.

The final term, `-α*B*F`, couples the equations. Because it is negative in both equations, the implementation treats the interaction as harmful to both populations. The interaction coefficient is small, but its effect can become substantial when the product of the two population sizes is large.

## Parameter Values

| Parameter | Meaning | Value |
|---|---|---:|
| `B` | Blue whale population | State variable |
| `F` | Fin whale population | State variable |
| `0.05` | Blue whale intrinsic growth rate | 0.05 |
| `0.08` | Fin whale intrinsic growth rate | 0.08 |
| `150000` | Blue whale carrying capacity | 150,000 |
| `400000` | Fin whale carrying capacity | 400,000 |
| `α` | Interaction coefficient | `1e-8` |
| `h` | Euler step size | Varies by experiment |

The main initial condition is:

```julia
X0 = [5000.0, 70000.0]
```

This means the simulation begins with 5,000 blue whales and 70,000 fin whales. A later experiment uses:

```julia
X0 = [150000.0, 400000.0]
```

This second state places both species at their individual carrying capacities before the interaction term is applied.

## Numerical Method

The project uses the forward Euler method. If `Xn` is the current state and `G(Xn)` is the vector of population growth rates, the update is:

```text
X_(n+1) = X_n + h G(X_n)
```

In the Julia implementation, the update is written as:

```julia
Xn = Xn + h * G(Xn)
```

Each new state is copied into `Xs`, which stores the full simulation history. Copying is important because Julia arrays are mutable; without `copy`, multiple entries could refer to the same array instead of preserving each individual state.

Forward Euler is easy to understand and implement, but it is only a first-order numerical method. Its accuracy and stability depend strongly on the step size `h`.

## Repository Contents

A simple repository layout could be:

```text
.
├── README.md
└── whales.jl
└── Plots

```

- `README.md` contains the project explanation and usage instructions.
- `whales.jl` contains the model, Euler simulations, and plotting commands.
- 'Plots' contains the model's output for each simulation in numerical order. 

## Requirements

- Julia 1.x
- `Plots.jl`

## Installation

1. Install Julia from the official Julia website.
2. Clone or download this repository.
3. Open a terminal in the repository directory.
4. Start Julia and install the plotting dependency:

```julia
using Pkg
Pkg.add("Plots")
```

After the package is installed, it can be loaded with:

```julia
using Plots
```

## Running the Project

Run the script from the repository directory:

```bash
julia whales.jl
```

Depending on the Julia environment and plotting backend, plots may open in a separate window or appear in the active Julia display.

## Simulation Sections

### Part I: Fin whale population over time

This section starts from `X0 = [5000.0, 70000.0]`, uses `h = 32.0`, and performs 50 Euler updates. It constructs a time vector and plots the fin whale population against elapsed model time.

The purpose of this experiment is to show the time evolution of one component of the coupled system.

### Part II: Phase-space trajectory

This section runs 1,000 Euler updates and extracts both populations from the saved states. It plots blue whales on the horizontal axis and fin whales on the vertical axis.

The first 100 iterations are omitted with `101:end`. This removes the early transient and makes the later behavior of the numerical trajectory easier to inspect.

### Part III: Step-size comparison

This section repeats the phase-space simulation for step sizes from `33.0` through `37.0`. A separate plot is created for each value of `h`.

This experiment is useful for observing how a numerical solution changes when the discretization is altered. Large differences between nearby step sizes may indicate that the Euler method is approaching or exceeding its stable range for this model.

### Part IV: Carrying-capacity initial condition

This section changes the initial state to `[150000.0, 400000.0]`. Although these values are the carrying capacities of the two uncoupled logistic equations, they are not automatically an equilibrium of the coupled system because the interaction term remains negative.

The resulting plots show how the system moves away from that initial point under the full coupled model.

## Expected Output

The script produces the following visualizations:

- A scatter plot of fin whale population versus time.
- A phase-space plot of blue whale population versus fin whale population after the first 100 iterations.
- A sequence of phase-space plots for `h = 33.0`, `34.0`, `35.0`, `36.0`, and `37.0`.
- A second sequence of phase-space plots using the carrying-capacity initial condition.

The exact appearance of the trajectories depends on the step size and the number of iterations.

## Interpreting the Results

A time-series plot shows how one population changes as the simulation advances. A phase-space plot instead shows the relationship between the two populations: each point represents one simulated state `(B, F)`, and the sequence of points traces the system's trajectory.

If the phase-space points approach a fixed location, the numerical solution may be approaching an equilibrium. If they form a repeating pattern, the simulation may be showing oscillatory behavior. If they spread rapidly, become negative, or grow without bound, the numerical method may be unstable rather than revealing meaningful population dynamics.

## Numerical Stability

The forward Euler method is sensitive to large step sizes. In this project, values near `h = 33` to `37` are intentionally compared to study this sensitivity. A trajectory that changes dramatically when `h` changes slightly should be treated cautiously.

Nonphysical results can include:

- Negative population values
- Extremely large values
- `Inf` or `NaN` values
- Jagged or rapidly diverging phase-space trajectories

These results do not necessarily describe the biological model. They may instead indicate that the chosen step size is too large for forward Euler.

For a more reliable simulation, try a smaller `h` and increase the number of iterations so that the total simulated time remains comparable.
