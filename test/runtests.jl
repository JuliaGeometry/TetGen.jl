using ExplicitImports, Aqua
using TetGen: TetGen
using Test

include("tetgentests.jl")

run(`julia $(joinpath(@__DIR__, "runtests-tetgen-1.5.1.jl"))`)

@testset "ExplicitImports" begin
    @test ExplicitImports.check_no_implicit_imports(TetGen, skip = (Base, Core)) === nothing
    @test ExplicitImports.check_all_explicit_imports_via_owners(TetGen) === nothing
    @static if VERSION >= v"1.11.0"
        @test ExplicitImports.check_all_explicit_imports_are_public(TetGen) === nothing
        @test ExplicitImports.check_all_qualified_accesses_are_public(TetGen) === nothing
    end
    @test ExplicitImports.check_no_stale_explicit_imports(TetGen) === nothing
    @test ExplicitImports.check_all_qualified_accesses_via_owners(TetGen) === nothing
    @test ExplicitImports.check_no_self_qualified_accesses(TetGen) === nothing
end

@testset "Aqua" begin
    Aqua.test_all(TetGen)
end

if isdefined(Docs, :undocumented_names)
    @testset "UndocumentedNames" begin
        @test isempty(Docs.undocumented_names(TetGen))
    end
end
