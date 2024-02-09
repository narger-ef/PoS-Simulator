function simulate(stakes::Vector{Float64}, θ::Float64, p_join::Float64 = 0.0, p_quit::Float64 = 0.0)
    gini_history = Vector{Float64}()

    t = d(gini_coefficient(stakes), θ)

    for i in 1 : n_epochs
        try_to_join(stakes, p_join)
        try_to_quit(stakes, p_quit)

        g = gini_coefficient(stakes)
        push!(gini_history, g)
            
        #speed = abs(g - θ) / s
        s = 0.001

        t = lerp(t, d(g, θ), s)
            
        validator = gini_stabilized_consensus(stakes, t)
        
        stakes[validator] += constant_reward(Float64(total_reward), n_epochs)
    end

    return gini_history
end
;