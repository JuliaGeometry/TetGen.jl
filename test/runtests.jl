using TetGen
using Base.Test

# write your own tests here
@test 1 == 1

tetgen = "./" * Pkg.dir("TetGen", "deps", "tetgen")
cd(Pkg.dir("TetGen", "deps"))
example = readstring("example.poly")

open(`./tetgen -p `, "w") do f
    print(f, example)
end
