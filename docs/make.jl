# Inside make.jl
push!(LOAD_PATH,"../src/")
using EmpiricalMeasures
using Documenter
makedocs(
         sitename="EmpiricalMeasures.jl",
         modules=[EmpiricalMeasures],
         pages=[
                "Home" => "index.md"
               ])
deploydocs(;
    repo="github.com/davibarreira/EmpiricalMeasures.jl",
)

