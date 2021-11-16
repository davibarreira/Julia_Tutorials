using ArtifactUtils
using Artifacts

add_artifact!(
           "Artifacts.toml",
           "JuliaMono",
           "https://github.com/cormullion/juliamono/releases/download/v0.043/JuliaMono-ttf.tar.gz",
           force=true,
       )

import Pkg; Pkg.instantiate()
