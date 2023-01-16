using CliffordAlgebras
import CliffordAlgebras: basegrade
using LinearAlgebra: norm, normalize, dot
using Plots

coord(a::MultiVector) = a.e1 * cl.e1  + a.e2 * cl.e2 + a.e3* cl.e3

function getgradesdict(cl::CliffordAlgebra)
    gradesdict = Dict(g =>[] for g in 0:sum(signature(cl)))
    ngrades = sum(signature(cl))
    for g in 0:ngrades
        for (i,p) in enumerate(propertynames(cl))
            if i <= sum(binomial.(dimcl,0:g))
                push!(gradesdict[g],p)
            end
        end
    end

    return gradesdict
end

function Base.:≈(a::MultiVector,b::MultiVector)
    vector(a) ≈ vector(b)
end

function multivector(cl::CliffordAlgebra,v::Vector)
    bases = propertynames(cl)
    mapreduce(x->x[1] * getproperty(cl,x[2]),+, zip(v,bases))
end

function Base.map(f, c::MultiVector)
    multivector(algebra(c),map(f, vector(c)))
end

function Base.reduce(op, c::MultiVector)
    reduce(op, vectorize(c))
end

"""
vectorize(c::MultiVector)

Turns a multivector into a vector of multivectors,
where each element in a multivector with a single blade.
"""
function vectorize(c::MultiVector)
    filter(x->!isapprox(norm_sqr(x),0),basevector.(Ref(algebra(c)), propertynames(c)) .* vector(c))
end

"""
unvectorize(c::MultiVector)

Turns a vector of multivectors into a multivector by
summing each component.
"""
function unvectorize(c::MultiVector)
    reduce(+,vectorize(B))
end

"""
basesfromgrade(cl::CliffordAlgebra, k::Int)

Returns a list of base multivector for a given
grade `k`. Note that grades go from ``0`` to ``n``, 
where ``n`` is the dimension, given by the sum of
the signature, e.g. ``R^{3,1,1}`` has
``n = 5``.
"""
function basesfromgrade(cl::CliffordAlgebra, k::Int)
    ngrades = sum(signature(cl))
    i = sum(binomial.(ngrades,0:k-1))+1
    j = sum(binomial.(ngrades,0:k))
    basesymbol.(Ref(cl),i:j)
end


function norm_corr(a::MultiVector)
    sqrt(abs(norm_sqr(a)))
end


bladenormalization(B::MultiVector) = B / norm_corr(B)
orthogonalproj(c::MultiVector, B::MultiVector) = (c ⨼ B) * inv(B)
orthogonalreject(a::MultiVector, B::MultiVector) = (a ∧ B) ⨽ inv(B)

"""
maxgrade(A::MultiVector)

Returns the maximum grade ``k`` of a multivector A
with non-null value, i.e. ``\\langle A \\rangle_{max}``
is equal to `grade(A,maxgrade(A))`.
"""
function maxgrade(A::MultiVector)
    D = sum(signature(algebra(A)))
    i = findlast(!isapprox(0), norm_sqr(grade(A,k)) for k in 0:D)
    if isnothing(i)
        return 0
    end
    return i - 1
end
"""
mingrade(A::MultiVector)

Returns the minimum grade ``k`` of a multivector A
with non-null value, or returns 0.
"""
function mingrade(A::MultiVector)
    D = sum(signature(algebra(A)))
    i = findfirst(!isapprox(0), norm_sqr(grade(A,k)) for k in 0:D)
    if isnothing(i)
        return 0
    end
    return i - 1
end


function norm_corr(a::MultiVector)
    sqrt(abs(norm_sqr(a)))
end

bladenormalization(B::MultiVector) = B / norm_corr(B)
orthogonalproj(c::MultiVector, B::MultiVector) = (c ⨼ B) * inv(B)
orthogonalreject(a::MultiVector, B::MultiVector) = (a ∧ B) ⨽ inv(B)

function findmaxmv(f, a::MultiVector)
    cl = algebra(a)
    scalar, base = findmax(f,vector(a))
    return scalar * basevector(cl, base)
end

function deltaproduct(A::MultiVector,B::MultiVector)
    C = A*B
    return grade(C, maxgrade(C))
end

function span(a::MultiVector)
    if length(coefficients(a)) != 1
        error("This function takes only multivectors with a single coeffient")
    end
    if mingrade(a) ≤ 1
        return [a/norm(a)]
    end
    cl = algebra(a)
    A  = a / norm(a)
    b = []
    for e in basevector.(Ref(cl),basesfromgrade(cl,1))
        if !(norm_sqr(A ⋅ e) ≈ 0)
            push!(b, e)
        end
    end
    return b
end

"""
getblades(x,blades = [:e1,:e2,:e3

Returns a multivector consisting of the sum of a subset
of blades of a multivier. E.g. for `x = cl.e1 + cl.e2 + 3cl.e1e2`
```
getblades(x,[:e1,:e1e2])
# returns cl.e1 + 3cl.e1e2
```
"""
function getblades(x,blades = [:e1,:e2,:e3])
    cl = algebra(x)
    mapreduce(b->reduce(*,getproperty.([x,cl],b)),+,blades)
end


function tovec(x::MultiVector, dims=3)
    blades = Symbol.(["e"*i for i in 1:dims])
    getblades(x, blades)
end