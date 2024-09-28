module FlowLock

using SHA: sha256
using MacroTools: postwalk

include("flow.jl")

export @flow

end
