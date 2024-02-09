function simulate(pos::PoS, stakes::Vector{Float64}, θ::Float64, reward::Float64, p_join::Float64 = 0.0, p_quit::Float64 = 0.0)
    gini_history = Vector{Float64}()

    t = d(gini(stakes), θ)

    @showprogress for i in 1 : n_epochs
        try_to_join(stakes, p_join)
        try_to_quit(stakes, p_quit)

        g = gini(stakes)
        push!(gini_history, g)
            
        #speed = abs(g - θ) / s
        s = 0.00005
            
        validator = consensus(pos, stakes, t)
        #stakes[validator] += constant_reward(Float64(reward), n_epochs)
        stakes[validator] += reward

        t = lerp(t, d(g, θ), s)
    end

    return gini_history
end
;