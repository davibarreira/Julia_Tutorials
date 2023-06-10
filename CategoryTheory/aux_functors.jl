struct Just{T}
    _1::T
end
struct Nothing end
Maybe{T} = Union{Just{T}, Nothing};

fmap(f::Function, x::Nothing) = Nothing()
fmap(f::Function, x::Just)    = Just(f(x._1))

struct Nil end
struct Cons{T}
  val::T
  next::Union{Cons{T},Nil} # n.b. abstract type!
end
List{T} = Union{Cons{T}, Nil}
fmap(f::Function, x::Nil) = Nil()
fmap(f::Function, x::Cons) = Cons(f(x.val),fmap(f, x.next))
