using EmpiricalMeasure
using ArraysOfArrays
using LinearAlgebra
using Random
using Test

@testset "EmpiricalMeasure.jl" begin

    Random.seed!(7)
    n = 4
    m = 2
    A = nestedview(rand(n, m)')
    p = normalize!(rand(n), 1)

    μ = @inferred(MvDiscreteNonParametric{Float64,Float64,typeof(A),typeof(p)}(A, p))

    @test support(μ) == A
    @test length(μ) == 2
    @test size(μ) == size(flatview(A)')
    @test probs(μ)   == p

    μ = @inferred(MvDiscreteNonParametric(A,p))
    @test support(μ) == A
    @test length(μ) == 2
    @test size(μ) == size(flatview(A)')

    μ = @inferred(MvDiscreteNonParametric(A))
    @test support(μ) == A
    @test length(μ) == 2
    @test size(μ) == size(flatview(A)')
    @test probs(μ)   == fill(1/n, n)

    # Matrix
    M = rand(10,2)
    μ = @inferred(MvDiscreteNonParametric(M))

end
