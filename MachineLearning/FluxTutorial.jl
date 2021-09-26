using Flux
using GLMakie

model = Dense(2, 1, σ)

x = rand(2)

model(x)

