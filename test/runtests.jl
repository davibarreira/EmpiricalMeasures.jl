using EmpiricalMeasure
using ArraysOfArrays
using StatsBase
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

    μ = @inferred(MvDiscreteNonParametric(A, p))
    @test support(μ) == A
    @test length(μ) == 2
    @test size(μ) == size(flatview(A)')

    μ = @inferred(MvDiscreteNonParametric(A))
    @test support(μ) == A
    @test length(μ) == 2
    @test size(μ) == size(flatview(A)')
    @test probs(μ)   == fill(1 / n, n)

    # Matrix
    M = rand(10, 2)
    μ = @inferred(MvDiscreteNonParametric(M))


    @testset "Functionalities" begin
        
        p = ([3 / 5, 1 / 5, 1 / 5])
        A = [[1,0],[1,1],[0,1]]
        A = ArrayOfSimilarArrays{Int64}(A)
        μ = MvDiscreteNonParametric(A, p)

        v = flatview(μ.support)'[:,1]
        m = mean(μ)[1]
        @test sum(abs2.(v .- m), Weights(μ.p)) ≈ var(μ)[1]
        println(var(μ))

        v = flatview(μ.support)'[:,2]
        m = mean(μ)[2]
        @test sum(abs2.(v .- m), Weights(μ.p)) ≈ var(μ)[2]
    end
end
