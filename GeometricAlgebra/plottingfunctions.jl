using PlotlyJS

"""
plotpoint(pts::Vector;
        mode="markers",
        plottype="scatter3d",
        kwargs...)

Returns a scatter object from `PlotlyJS.jl` package.
Use `p1 = plotpoint([point(1,1,1), point(2,2,2)])` then
`plot(p1)` to visualize the plot. You can also
define another plot such as `p2 = plotploint([point(0,0,0)])`
and do `plot([p1,p2])`.
"""
function plotpoint(pts::Vector;
        mode="markers",
        plottype="scatter3d",
        kwargs...)
    
    x = [i.e1 for i in pts]
    y = [i.e2 for i in pts]
    z = [i.e3 for i in pts]
    
    scatter(x=x,y=y,z=z,mode=mode,type=plottype;kwargs...) 
end

"""
plotpoint(p::MultiVector; plottype="scatter3d", kwargs...)

Returns a scatter object from `PlotlyJS.jl` package.
"""
function plotpoint(p::MultiVector; plottype="scatter3d", kwargs...)
    plotpoint([p];plottype=plottype, kwargs...)
end

"""
plotpointpair(p_q::MultiVector;
        marker=attr(symbol="circle-open"),
        plottype="scatter3d", kwargs...)
    
It takes as input a point pair e.g. `point(1,1,1) ∧ point(0,0,0)`.
Returns a scatter object from `PlotlyJS.jl`.
"""
function plotpointpair(p_q::MultiVector;
        marker=attr(symbol="circle-open"),
        plottype="scatter3d", kwargs...)
    
    T = p_q
    G = T/√scalar(T^2)
    Prj = (1+G)/2
    p = Prj * ((T) ⋅ n∞) * reverse(Prj)
    q = -reverse(Prj) * ((T) ⋅ n∞) * Prj
    plotpoint([p,q]; plottype = plottype, marker = marker, kwargs...)
end


"""
plotline(l::MultiVector,
        linelengthfactor=1;
        mode="lines",
        plottype="scatter3d",
        kwargs...)

It takes a line `l` from the Conformal Model.
One can define a line by `p ∧ q ∧ n∞`, or using the
helper function `line(p,q)`.

Returns a scatter object from `PlotlyJS.jl`.
"""
function plotline(l::MultiVector,
        linelengthfactor=1;
        mode="lines",
        plottype="scatter3d",
        kwargs...)
    
    weight = norm(n∞ ⨼ (no ⨼ l))
    v = n∞ ⨼ (no ⨼ l)/weight
    d = getblades((no ⨼ l) / l)
    
    lstart = linelengthfactor*v + d
    lend   = -linelengthfactor*v + d
    
    x = [i.e1 for i in [lstart,lend]]
    y = [i.e2 for i in [lstart,lend]]
    z = [i.e3 for i in [lstart,lend]]
    
    scatter(x=x,y=y,z=z,mode=mode,type=plottype;kwargs...) 
end


"""
plotplane(Π::MultiVector,
        planelengthfactor=1;
        color="rgba(244,22,100,0.6)",
        kwargs...)

It takes a direct plane object from the Conformal Model,
e.g. `plane(a,b,c) = a ∧ b ∧ c ∧ n∞`.
Returns a mesh3d object from `PlotlyJS.jl`.
"""
function plotplane(Π::MultiVector,
        planelengthfactor=1;
        color="rgba(244,22,100,0.6)",
        kwargs...)
    
    weight = norm(n∞ ⨼ (no ⨼ Π))
    A = n∞ ⨼ (no ⨼ Π)/weight
    n = edual(A)

    d_vec = getblades((no ⨼ Π) / Π)
    d = F(d_vec)

    δ = norm(d_vec)
    pts = [
        translate(d, planelengthfactor* point(1,0,0)),
        translate(d, planelengthfactor* point(0,1,0)),
        translate(d, planelengthfactor* point(0,0,1)),
        translate(d, planelengthfactor* point(-1,0,0)),
        translate(d, planelengthfactor* point(0,-1,0)),
        translate(d, planelengthfactor* point(0,0,-1)),
    ]
    
    # Project points into plane Π
    pts = [(p ⨼ Π)/Π for p in pts]
    
    x = [i.e1 for i in pts]
    y = [i.e2 for i in pts]
    z = [i.e3 for i in pts]
    
    mesh3d(x=x,y=y,z=z;color=color, kwargs...)
end


"""
plotcircle(C::MultiVector)

Takes a direct circle in the Conformal Model.
Returns a scatter object from `PlotlyJS.jl`.
"""
function plotcircle(C::MultiVector; mode = "lines", kwargs...)
    E = C ∧ n∞ # Carrier
    c = -(1/2)*(C * n∞ * C)/((n∞ ⨼ C)^2) # center
    ρ = √scalar(C*grin(C)/(n∞ ⨼ C)^2) # radius
    
    weight = norm(n∞ ⨼ (no ⨼ E))
    A = n∞ ⨼ (no ⨼ E)/weight
    n = edual(A)
    A = translate(A, c)
    
    u = n + cl.e1
    t = c ∧ ( c ⨼ ( u ∧ n∞)) # Tangent vector translated to c 
    t = (t ⨼ E) / E
    u = getblades(-(n∞ ⨼ t))

    ϕs = 0:0.1:2π
    ϕs = vcat(ϕs,0)
    tp = F(ρ* u/norm(u) + getblades(c))
    ts = []
    push!(ts,tp)
    for ϕ in ϕs
        R  = exp(-A*ϕ/2)
        tr = R*tp*reverse(R)
        push!(ts,tr)
    end
    plotpoint(ts, mode=mode, kwargs...)
end



"""
generatespherepoints(Σ)

Helper function to generate points in the sphere.
"""
function generatespherepoints(Σ)
    ρ = √scalar((Σ * grin(Σ))/((n∞ ⨼ Σ)^2));
    c = -(1/2)*(Σ * n∞ * Σ)/((n∞ ⨼ Σ)^2)
    
    n = 100
    u = range(-π, π; length = n)
    v = range(0, π; length = n)
    x = ρ.*cos.(u) * sin.(v)' .+ c.e1
    y = ρ.*sin.(u) * sin.(v)' .+ c.e2
    z = ρ.*ones(n) * cos.(v)' .+ c.e3
    return x,y,z
end


"""
plotsphere(Σ::MultiVector;showscale=false,kwargs...)

Takes a direct sphere from the Conformal Model.

Returns a surface object from `PlotlyJS.jl` package.
"""
function plotsphere(Σ::MultiVector;showscale=false,kwargs...)
    x,y,z = generatespherepoints(Σ)
    surface(x=x, y=y, z=z;showscale=showscale, kwargs...)
end
