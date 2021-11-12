# EmpiricalMeasure

[![Build Status](https://github.com/davibarreira/EmpiricalMeasure.jl/workflows/CI/badge.svg)](https://github.com/davibarreira/EmpiricalMeasure.jl/actions)
[![Coverage](https://codecov.io/gh/davibarreira/EmpiricalMeasure.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/davibarreira/EmpiricalMeasure.jl)

This package implements *empirical probability measures* in Julia.

Given a set of points x₁,...,xₙ ∈ ℝⁿ, the *generalized empirical probability measure* is
a discrete finite measure defined as:

<p align="center">
<img src="./empiricalmeasure.svg" align="center" height="25." />
<p></p>

where each pᵢ is the probability of each mass point
multiplying a Dirac measures, i.e

<p align="center">
<img src="./diracdef.svg" align="center" height="50." />.
<p></p>
