module FiniteDiscreteMeasure

using Distributions
import Distributions: DiscreteMultivariateDistribution
using ArraysOfArrays

export MvDiscreteNonParametric
export discretemeasure

struct MvDiscreteNonParametric{T<:Real,
                               P<:Real,
                               Ts<:AbstractVector{<:AbstractVector{T}},
                               Ps<:AbstractVector{P}} <: DiscreteMultivariateDistribution

    support::Ts
    p::Ps

    function MvDiscreteNonParametric{T,P,Ts,Ps}(support::Ts, p::Ps) where {
            T<:Real,P<:Real,Ts<:AbstractVector{<:AbstractVector{T}},Ps<:AbstractVector{P}}
        length(support) == length(p) || error("length of `support` and `p` must be equal")
        isprobvec(p) || error("`p` must be a probability vector")
        allunique(support) || error("`support` must contain only unique value")
        new{T,P,Ts,Ps}(support, p)
    end
end

"""
    MvDiscreteNonParametric(
        support::AbstractVector,
        p::AbstractVector{<:Real}=fill(inv(length(support)), length(support)),
    )

Construct a multivariate discrete nonparametric probability distribution with `support` and corresponding
probabilities `p`. If the probability vector argument is not passed, then
equal probability is assigned to each entry in the support.

# Examples
```julia
using ArraysOfArrays
# rows correspond to samples
μ = MvDiscreteNonParametric(nestedview(rand(7,3)'))

# columns correspond to samples
ν = MvDiscreteNonParametric(nestedview(rand(7,3)))
```
"""
function MvDiscreteNonParametric(
    support::AbstractVector{<:AbstractVector{<:Real}},
    p::AbstractVector{<:Real}=fill(inv(length(support)), length(support)),
)
    return MvDiscreteNonParametric{eltype(eltype(support)),eltype(p), typeof(support),typeof(p)}(support, p)
end

"""
    MvDiscreteNonParametric(
        support::Matrix{<:Real},
        p::AbstractVector{<:Real}=fill(inv(length(support)), length(support));
        by=:row
    )

Construct a multivariate discrete nonparametric probability distribution
with a matrix `support` where samples `by` either `:row` or `:col`,
and corresponding
probabilities `p`. If the probability vector argument is not passed, then
equal probability is assigned to each entry in the support.

# Examples
```julia
# rows correspond to samples
using LinearAlgebra
μ = MvDiscreteNonParametric(rand(10,3), normalize!(rand(10),1))

# columns correspond to samples
ν = MvDiscreteNonParametric(rand(3,5), normalize!(rand(5),1), by=:col)
```
"""
function MvDiscreteNonParametric(
    support::Matrix{<:Real},
    by = :row,
    p::AbstractVector{<:Real}= by == :row ? fill(inv(size(support)[1]), size(support)[1]) : fill(inv(size(support)[2]), size(support)[2])
)
    if by == :row
        s = nestedview(support')
        return MvDiscreteNonParametric{eltype(eltype(s)),eltype(p), typeof(s),typeof(p)}(s, p)
    elseif by == :col
        s = nestedview(support)
        return MvDiscreteNonParametric{eltype(eltype(s)),eltype(p), typeof(s),typeof(p)}(s, p)
    else
        error("only options are :row and :col")
    end
end

Base.eltype(::Type{<:MvDiscreteNonParametric{T}}) where T = T



"""
    discretemeasure(
        support::AbstractVector,
        probs::AbstractVector{<:Real}=fill(inv(length(support)), length(support)),
    )

Construct a finite discrete probability measure with `support` and corresponding
`probabilities`. If the probability vector argument is not passed, then
equal probability is assigned to each entry in the support.

# Examples
```julia
using ArraysOfArrays
# rows correspond to samples
μ = discretemeasure(nestedview(rand(7,3)'), normalize!(rand(10),1))

# columns correspond to samples, each with equal probability
ν = discretemeasure(nestedview(rand(3,12)))
```

!!! note
    If `support` is a 1D vector, the constructed measure will be sorted,
    e.g. for `mu = discretemeasure([3, 1, 2],[0.5, 0.2, 0.3])`, then
    `mu.support` will be `[1, 2, 3]` and `mu.p` will be `[0.2, 0.3, 0.5]`.
    Also, avoid passing 1D distributions as `RowVecs(rand(3))` or `[[1],[3],[4]]`,
    since this will be dispatched to the multivariate case instead
    of the univariate case for which the algorithm is more efficient.

!!! warning
    This function and in particular its return values are not stable and might be changed in future releases.
"""
function discretemeasure(
    support::AbstractVector{<:Real},
    p::AbstractVector{<:Real}=fill(inv(length(support)), length(support)),
)
    return DiscreteNonParametric(support, p)
end
function discretemeasure(
    support::AbstractVector{<:AbstractVector{<:Real}},
    p::AbstractVector{<:Real}=fill(inv(length(support)), length(support)),
)
    return MvDiscreteNonParametric{eltype(eltype(support)),eltype(p), typeof(support),typeof(p)}(support, p)
end

# Distributions.support(d::FiniteDiscreteMeasure) = d.support
# Distributions.probs(d::FiniteDiscreteMeasure) = d.p

end
