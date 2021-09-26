# Let's cover some basics of Makie
#  
using GLMakie
using AlgebraOfGraphics
kwargs = AlgebraOfGraphics.aog_theme()
set_theme!(;resolution=(500,500),kwargs...)

fig, ax, pltobj = scatterlines(1:10);


