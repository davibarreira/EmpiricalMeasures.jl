using EmpiricalMeasure
using ArraysOfArrays
using StatsBase
using LinearAlgebra
using Random
using Test

@testset "EmpiricalMeasure.jl" begin

    @testset "Declaring Empirical Measures" begin

        @testset "MvDiscreteNonParametric from ArraysOfArrays" begin

            Random.seed!(7)
            n = 4
            m = 2
            A = nestedview(rand(n, m)')
            p = normalize!(rand(n), 1)

            # Passing probabilities
            μ = @inferred(MvDiscreteNonParametric{Float64,Float64,typeof(A),typeof(p)}(A, p))
            @test support(μ) == A
            @test length(μ) == m
            @test size(μ) == size(flatview(A)')
            @test probs(μ)   == p

            μ = @inferred(MvDiscreteNonParametric(A, p))
            @test support(μ) == A
            @test length(μ) == m
            @test size(μ) == size(flatview(A)')

            # Without passing probabilities
            μ = @inferred(MvDiscreteNonParametric(A))
            @test support(μ) == A
            @test length(μ) == m
            @test size(μ) == size(flatview(A)')
            @test probs(μ)   == fill(1 / n, n)

            # Array of arrays without ArraysOfArrays.jl
            n, m = 3, 2
            p = ([3 / 5, 1 / 5, 1 / 5])
            A = [[1,0],[1,1],[0,1]]
            μ = @inferred(MvDiscreteNonParametric(A, p))

            @test support(μ) == A
            @test length(μ) == m
            @test size(μ) == (length(A), length(A[1]))
            @test probs(μ) == p


        end

        @testset "MvDiscreteNonParametric from Matrix" begin

            Random.seed!(7)
            n, m = 10, 5
            A = rand(n, m)
            p = normalize!(rand(n), 1)

            # Passing probabilities
            μ = @inferred(MvDiscreteNonParametric(A, p))

            @test flatview(support(μ))' == A
            @test length(μ) == m
            @test size(μ) == size(A)
            @test probs(μ)   == p

            # Without passing probabilities
            μ = @inferred(MvDiscreteNonParametric(A))

            @test flatview(support(μ))' == A
            @test length(μ) == m
            @test size(μ) == size(A)
            @test probs(μ) == fill(1 / n, n)

        end
    end


    @testset "Functionalities" begin
        
        function variance(d)
            v = zeros(length(d))
            for i in 1:length(d)
                s = flatview(μ.support)'[:,i]
                m = mean(d)[i]
                v[i] = sum(abs2.(s .- m), Weights(d.p))
            end
            return v
        end

        function covariance(d)
            n = length(d)
            v = zeros(n, n)
            for i in 1:n, j in 1:n
                s = flatview(d.support)'[:,i]
                mₛ = mean(d)[i]
                
                u = flatview(d.support)'[:,j]
                mᵤ = mean(d)[j]
                
                v[i,j] = sum((s .- mₛ) .* (u .- mᵤ), Weights(d.p))
            end
            return v
        end


        p = ([3 / 5, 1 / 5, 1 / 5])
        A = [[1,0],[1,1],[0,1]]
        μ = @inferred(MvDiscreteNonParametric(A, p))

        v = flatview(μ.support)'[:,1]
        m = mean(μ)[1]
        @test sum(abs2.(v .- m), Weights(μ.p)) ≈ var(μ)[1]

            v = flatview(μ.support)'[:,2]
        m = mean(μ)[2]
        @test sum(abs2.(v .- m), Weights(μ.p)) ≈ var(μ)[2]
    end

end
