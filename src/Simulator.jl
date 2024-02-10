include("Parameters.jl")
include("Utils.jl")

function simulate(stakes::Vector{Float64}, params::Parameters)
    gini_history = Vector{Float64}()

    t = d(gini(stakes), params.θ)

    for i in 1 : params.n_epochs
        try_to_join(stakes, params.p_join)
        try_to_quit(stakes, params.p_quit)

        g = gini(stakes)
        push!(gini_history, g)
            
        if params.proof_of_stake == GiniStabilized
            #In case of GiniStabilized, compute 's' and 't'
            if params.s_type == Constant
                s = params.s_val
            elseif params.s_type == Linear
                s = abs(g - θ) * params.s_val
            end

            validator = consensus(params.proof_of_stake, stakes, t)
            t = lerp(t, d(g, params.θ), s)
        else
            validator = consensus(params.proof_of_stake, stakes)
        end
            
        #stakes[validator] += constant_reward(Float64(reward), n_epochs)
        stakes[validator] += params.reward

    end

    return gini_history
end
;