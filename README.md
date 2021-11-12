# EmpiricalMeasure

[![Build Status](https://github.com/davibarreira/EmpiricalMeasure.jl/workflows/CI/badge.svg)](https://github.com/davibarreira/EmpiricalMeasure.jl/actions)
[![Coverage](https://codecov.io/gh/davibarreira/EmpiricalMeasure.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/davibarreira/EmpiricalMeasure.jl)

This package implements *empirical probability measures* in Julia.

Given a set of points $x_1,...,x_n \in \mathbb R^d$, the *generalized empirical probability measure* is
a discrete finite measure defined as
$\sum^n_{i=1} p_i \delta_{x_i},$
where $p_i$ are the probability of each mass point and
$\delta_{x_i}$ are the Dirac measures, i.e
$$
\delta_{x_i}(A) :=
\left\{
\begin{array}{ll}
    1, &  x \in A \\
    0, &  x \notin A
\end{array}
\right.
$$
