# Inside make.jl
push!(LOAD_PATH,"../src/")
using EmpiricalMeasure
using Documenter
makedocs(
         sitename="EmpiricalMeasure.jl",
         modules=[EmpiricalMeasure],
         pages=[
                "Home" => "index.md"
               ])
deploydocs(;
    repo="github.com/davibarreira/EmpiricalMeasure.jl",
)

