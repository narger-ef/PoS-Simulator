@enum Distribution Uniform=1 Gini=2 Random=3
@enum PoS Weighted=1 OppositeWeighted=2 GiniStabilized=3
@enum NewEntry NewMax=0 NewMin=1 NewRandom=2 NewAverage=3
@enum SType Constant=0 Linear=1 Quadratic=2 Sqrt=3

mutable struct Parameters
    n_epochs::Int64
    proof_of_stake::PoS
    initial_stake_volume::Float64
    initial_distribution::Distribution
    initial_gini::Float64
    n_peers::Int64
    n_corrupted::Int64
    p_fail::Float64
    p_join::Float64
    p_leave::Float64
    join_amount::NewEntry
    penalty_percentage::Float64
    θ::Float64
    s_type::SType
    k::Float64
    reward::Float64
    
    function Parameters(
            n_epochs::Int64=50000,
            proof_of_stake::PoS=Weighted,
            initial_stake_volume::Float64=10000.0,
            initial_distribution::Distribution=Gini,
            initial_gini::Float64=0.3,
            n_peers::Int64=1000,
            n_corrupted::Int64=20,
            p_fail::Float64=0.50,
            p_join::Float64=0.001,
            p_leave::Float64=0.001,
            join_amount::NewEntry=NewRandom,
            penalty_percentage::Float64=0.50,
            θ::Float64=0.3,
            s_type::SType=Linear,
            k::Float64=0.001,
            reward::Float64=10.0)
        
        new(n_epochs, proof_of_stake, initial_stake_volume, initial_distribution,
            initial_gini, n_peers, n_corrupted, p_fail, p_join, p_leave,
            join_amount, penalty_percentage, θ, s_type, k, reward)
    end
end