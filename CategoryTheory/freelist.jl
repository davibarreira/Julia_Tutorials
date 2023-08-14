using Pkg
Pkg.activate(".")
using MLStyle

abstract type List{T} end
struct Nil{T} <: List{T} end
struct Cons{T} <: List{T}
    _1::T
    _2::List{T}
end
fmap(f::Function, x::Nil) = x
fmap(f::Function, x::Cons{T}) where T = Cons(f(x._1),fmap(f, x._2))

@data FreeList{a} begin
    Pure(::a)
    FreeNil()
    FreeCons(::Union{Pure{a},Pure{<:FreeList}},::Union{FreeNil{a},FreeCons{a}})
end
