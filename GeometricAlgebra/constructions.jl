# Functions to Construct Elements in the Conformal Model.

"""
line(p::MultiVector, q::MultiVector) = p ∧ q ∧ n∞
"""
line(p::MultiVector, q::MultiVector) = p ∧ q ∧ n∞

"""
line(v::Vector, p::MultiVector=point(0,0,0))

Creates a line in the Conformal Model from a vector
`v` passing through a point `p`.
"""
function line(v::Vector, p::MultiVector=point(0,0,0))
    return p ∧ multivector(v) ∧ n∞
end


"""
plane(a::MultiVector,b::MultiVector,c::MultiVector) = a ∧ b ∧ c ∧ n∞

Plane passing through points `a`, `b` and `c`.
"""
plane(a::MultiVector,b::MultiVector,c::MultiVector) = a ∧ b ∧ c ∧ n∞

"""
plane(n::MultiVector,δ::Union{Real,MultiVector}) = cdual(n + δ*n∞)

Plane normal to vector `n` at a distance `δ` from the origin.
"""
plane(n::MultiVector,δ::Union{Real,MultiVector}) = cdual(n + δ*n∞)
function plane(n::Vector,δ::Real)
    n = n/norm(n)
    n = multivector(n)
    return plane(n, δ)
end


"""
circle(c::MultiVector, n::MultiVector, ρ::Real = 1.0)

Circle centered at point `c`, with rotation plane
normal to vector `n` and with radius `ρ`.
"""
function circle(c::MultiVector, n::MultiVector, ρ::Real = 1.0)
    E = edual(n / norm(n))
    return (c + ρ^2 * n∞/2) ∧ (-c ⨼ (grin(E)*n∞))
end


"""
sphere(ρ::Real=1.0, c::MultiVector=point(0,0,0))

Sphere centered at point `c` with radius `ρ`.
"""
function sphere(ρ::Real=1.0, c::MultiVector=point(0,0,0))
    cdual(c - ρ^2 * n∞ /2)
end
function sphere(ρ::Real, c::Vector)
    cdual(point(c...) - ρ^2 * n∞ /2)
end
"""
sphere(a::MultiVector,b::MultiVector,c::MultiVector,d::MultiVector)

Sphere passing through points `a`, `b`, `c` and `d`.
"""
function sphere(a::MultiVector,b::MultiVector,c::MultiVector,d::MultiVector)
    a ∧ b ∧ c ∧ d
end
