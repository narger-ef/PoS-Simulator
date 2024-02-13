include("Parameters.jl")
include("Utils.jl")

function simulate(stakes::Vector{Float64}, corrupted::Vector{Int64}, params::Parameters)
    gini_history = Vector{Float64}()

    t = d(gini(stakes), params.θ)

    for i in 1 : params.n_epochs
        try_to_join(stakes, params.p_join, params.join_amount)
        try_to_quit(stakes, params.p_quit)

        g = gini(stakes)
        push!(gini_history, g)
            
        if params.proof_of_stake == GiniStabilized
            #In case of GiniStabilized, compute the new 't'
            if params.s_type == Constant
                s = params.s_val
            elseif params.s_type == Linear
                s = abs(g - params.θ) * params.s_val
            elseif params.s_type == Quadratic
                s = (abs(g - params.θ))^2 * params.s_val
            end

            validator = consensus(params.proof_of_stake, stakes, t)
            t = lerp(t, d(g, params.θ), s)
             
        else
            validator = consensus(params.proof_of_stake, stakes)
        end

        if validator ∈ corrupted && rand() > 1 - params.p_fail
            stakes[validator] *= 1 - params.penalty_percentage
        else
            stakes[validator] += params.reward
        end

    end

    return gini_history
end
;