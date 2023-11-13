using Documenter, TetGen

function make_all()
    makedocs(;
             sitename = "TetGen.jl",
             modules = [TetGen],
             warnonly = true,
             clean = false,
             doctest = false,
             authors = "Simon Danisch, Juergen Fuhrmann",
             repo = "https://github.com/JuliaGeometry/TetGen.jl",
             pages = [
                 "Home" => "index.md",
             ])

    if !isinteractive()
        deploydocs(; repo = "github.com/JuliaGeometry/TetGen.jl.git")
    end
end

make_all()
