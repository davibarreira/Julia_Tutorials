using LinearAlgebra
using Random
# using CairoMakie
using Distances
# CairoMakie.activate!(type = "svg")
using StatsBase



# function Merge(y1,y2)
#     N1 = length(y1)
#     N2 = length(y2)
#     N  = N1 + N2
#     i,j,k,b = 1,1,1,0
#     y = zeros(N)
#     while i ≤ N1 && j ≤ N2
#         if y1[i] ≤ y2[j]
#             y[k]  = y1[i]
#             b = b+1
#             i = i+1
#         else
#             y[k] = y2[j]
#             z[y2[j]] = z[y2[j]] + b
#             j = j+1
#         end
#         k = k+1
#     end
#     if i ≤ N1
#         y[k:end] .= y2[k:end]
#     end
# end

function Sort(y)
    N = length(y)
    if N == 1
        return y
    else
        m = floor(Int,N/2)
        y1= Sort(y[1:m])
        y2= Sort(y[m+1:N])
#         y = Merge(y1,y2)
        return y
    end
end

y = [2,4,5,3,1]
Sort(y)
z = zeros(length(y))