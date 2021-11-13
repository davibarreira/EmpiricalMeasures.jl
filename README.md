# EmpiricalMeasures.jl

[![][bag-dev]][bld-dev]
[![Build Status](https://github.com/davibarreira/EmpiricalMeasures.jl/workflows/CI/badge.svg)](https://github.com/davibarreira/EmpiricalMeasures.jl/actions)
[![Coverage](https://codecov.io/gh/davibarreira/EmpiricalMeasures.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/davibarreira/EmpiricalMeasures.jl)

This package implements *empirical probability measures* in Julia.

Given a set of points x₁,...,xₙ ∈ ℝⁿ, the *generalized empirical probability measure* is
a discrete finite measure defined as:

<p align="center">
<img src="./assets/empiricalmeasure.svg" align="center" height="25." />
<p></p>

where each pᵢ is the probability of each point ("sample") xᵢ
multiplying a Dirac measures, i.e

<p align="center">
<img src="./assets/diracdef.svg" align="center" height="50." />.
<p></p>

This package is compatible with [Distributions.jl](https://github.com/JuliaStats/Distributions.jl/),
and creates a new distribution called `MvDiscreteNonParametric` which is a multivariate
version of `DiscreteNonParametric`.

## Basic Use

Let's do a quick overview of how to use this package.

### Declaring (Multivariate) Discrete Non-Parametric Measures

This package provides the function `empiricalmeasure(support, p)`, which
dispatches to either `DiscreteNonParametric` (1D case from Distributions.jl)
or `MvDiscreteNonParametric` based on the `support`.

```julia
using EmpiricalMeasures
using LinearAlgebra

# 1D DiscreteNonParametric example
ν = empiricalmeasure(rand(10), normalize!(rand(10),1))

# MvDiscreteNonParametric example
μ = empiricalmeasure(rand(10,2), normalize!(rand(10),1))
```
Note that in the example above, the multivariate discrete measure μ was constructed
using a matrix. The default behavior is to interpret the rows as samples,
thus, μ is a probability measure in ℝ² with 10 "mass-points".
If all points have the same probability, you can omit the `p` and just do
```julia
μ = empiricalmeasure(rand(10,2))
```
Instead of passing matrices, one can also pass
an array of arrays, e.g. `empiricalmeasure([[0,0],[1,1]])`.
One can also use `MvDiscreteNonParametric` to declare in 
multivariate discrete distributions without the possibility
of dispatching for the 1D case.

```julia
using EmpiricalMeasures
using LinearAlgebra
using ArraysOfArrays

n = 4 # number of "samples"
m = 2 # dimension of each "sample"
A = nestedview(rand(n,m)')
p = normalize!(rand(n),1);

μ = MvDiscreteNonParametric(A,p)
```

### Basic Functionalities
This package implements all the basic functionalities
suggested by Distributions.jl for new multivariate distributions.

```julia
using EmpiricalMeasures

p = ([3/5, 1/5, 1/5])
A = [[1,0],[1,1],[0,1]]
μ = MvDiscreteNonParametric(A,p)

length(μ) # returns 2
size(μ) # returns (10,2)
```

Note that `μ` is of type `::MvDiscreteNonParametric` which
is a struct containing the support and the probability of each point.
```julia
μ.support, μ.p 
```
```
([[1, 0], [1, 1], [0, 1]], [0.6, 0.2, 0.2])
```
The support and probabilities
can also be obtained using `support(μ)` and `probs(μ)`.


As in any distribution from Distributions.jl, we can
easily calculate things like the mean, variance, covariance,
and even sample from it:
```julia
mean(μ)
var(μ)
cov(μ)

rand(μ,10)
```
```
2×10 Matrix{Int64}:
 1  0  1  1  1  1  1  1  0  1
 1  1  1  0  0  0  0  0  1  0
```

### Future Plans

At the moment, EmpiricalMeasures.jl only produces probability measures in ℝⁿ.
The goal is to extend this first, by making it compatible with
[MeasureTheory.jl](https://github.com/cscherrer/MeasureTheory.jl)
using [MeasureBase.jl](https://github.com/cscherrer/MeasureBase.jl), and thus,
allow for measures which do not sum to 1.
Also, the goal is to generalize for any non-parametric finite discrete measures (this might be too ambitious).

[bag-dev]: https://img.shields.io/badge/docs-dev-blue.svg
[bld-dev]: https://davibarreira.github.io/EmpiricalMeasures.jl/dev
