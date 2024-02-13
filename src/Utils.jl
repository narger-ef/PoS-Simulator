
#Including the libraries used by the Simulator
using Plots
using LinearAlgebra
using ThreadSafeDicts
using ProgressMeter


"""
    gini(data::Vector{Float64})

Calculates the Gini coefficient of a given dataset.

The Gini coefficient is a measure of statistical dispersion representing the inequality of a distribution.
It is commonly used to measure income inequality in economics.

# Arguments
- `data::Vector{Float64}`: A vector containing numerical data points.

# Returns
The Gini coefficient of the input dataset. The coefficient ranges from 0 (perfect equality) to 1 (maximum inequality).

# Examples
```julia
data = [100.0, 200.0, 300.0, 400.0, 500.0]
gini(data)  # Output: 0.2
"""
function gini(data::Vector{Float64})
    # Calculate the number of data points
    n = length(data)

    # Calculate the total sum of the data points
    total = sum(data)

    # Sort the data points in ascending order
    sorted_data = sort(data)

    # Calculate the cumulative percentage of the sorted data
    cumulative_percentage = cumsum(sorted_data) / total

    # Calculate the Lorenz curve
    Lorenz_curve = cumulative_percentage .- 0.5 * (sorted_data ./ total)

    # Calculate the Gini coefficient
    G = 1 - 2 * sum(Lorenz_curve) / n

    return G
end

"""
    lerp(a::Vector{Float64}, b::Vector{Float64}, l::Float64)

Performs linear interpolation between two vectors `a` and `b` with a given interpolation factor `l`.

Linear interpolation (lerp) calculates a point between two given points (`a` and `b`) based on a scalar factor (`l`) between 0 and 1. 
When `l` is 0, the result is equal to `a`; when `l` is 1, the result is equal to `b`.

# Arguments
- `a::Vector{Float64}`: The starting vector.
- `b::Vector{Float64}`: The ending vector.
- `l::Float64`: The interpolation factor between 0 and 1.

# Returns
A new vector representing the result of linear interpolation between `a` and `b` with factor `l`.

# Examples
```julia
a = [1.0, 2.0, 3.0]
b = [4.0, 5.0, 6.0]
l = 0.5
lerp(a, b, l)  # Output: [2.5, 3.5, 4.5]
"""
function lerp(a::Vector{Float64}, b::Vector{Float64}, l::Float64)
    interpolated_vector = Vector{Float64}()
    for i in 1 : size(a)[1]
        push!(interpolated_vector, (1 - l) * a[i] + l * b[i])
    end
    return interpolated_vector
end

"""
    lerp(a::Float64, b::Float64, l::Float64)

Performs linear interpolation between two given values `a` and `b` with a given interpolation factor `l`.

Linear interpolation (lerp) calculates a point between two given points (`a` and `b`) based on a scalar factor (`l`) between 0 and 1. 
When `l` is 0, the result is equal to `a`; when `l` is 1, the result is equal to `b`.

# Arguments
- `a::Float64`: The starting value.
- `b::Float64`: The ending value.
- `l::Float64`: The interpolation factor between 0 and 1.

# Returns
The result of linear interpolation between `a` and `b` with factor `l`.

# Examples
```julia
a = 1.0
b = 4.0
l = 0.5
lerp(a, b, l)  # Output: 2.5
"""
function lerp(a::Float64, b::Float64, l::Float64)
    return (1 - l) * a + l * b
end

"""
    weighted_consensus(peers::Vector{Float64})

Determines the weighted consensus among a group of peers based on their probabilities.

The function calculates the weighted consensus among a group of peers, where each peer is represented by a probability value. 
Peers with higher probabilities have a greater influence on the consensus outcome.

# Arguments
- `peers::Vector{Float64}`: A vector containing the number of staked tokens by each peer.

# Returns
The index of the peer selected as the consensus, based on weighted probabilities.

# Examples
```julia
peers = [0.2, 0.3, 0.5]
weighted_consensus(peers)  # Output: index of the selected peer
"""
function weighted_consensus(peers::Vector{Float64})
    cumulative_probabilities = cumsum(peers/sum(peers))
    random_number = rand()
    
    index = argmax(cumulative_probabilities .>= random_number)

    return index
end

"""
    opposite_weighted_consensus(peers::Vector{Float64})

Determines the opposite weighted consensus among a group of peers based on their probabilities.

The function calculates the opposite weighted consensus among a group of peers, where each peer is represented by a probability value. 
Peers with lower probabilities (closer to the maximum probability) have a greater influence on the consensus outcome.

# Arguments
- `peers::Vector{Float64}`: A vector containing the number of staked tokens by each peer.

# Returns
The index of the peer selected as the opposite consensus, based on opposite weighted probabilities.

# Examples
```julia
peers = [0.2, 0.3, 0.5]
opposite_weighted_consensus(peers)  # Output: index of the selected peer
"""
function opposite_weighted_consensus(peers::Vector{Float64})
    opposite_peers = abs.(maximum(peers) .- peers)

    cumulative_probabilities = cumsum(opposite_peers/sum(opposite_peers))

    random_number = rand()
    
    index = argmax(cumulative_probabilities .>= random_number)

    return index
end

"""
    gini_stabilized_consensus(peers::Vector{Float64}, t::Float64)

Determines the Gini-stabilized consensus among a group of peers based on their probabilities, using linear interpolation between two consensus methods.
It combines two consensus methods: weighted consensus and opposite weighted consensus, using linear interpolation based on a parameter `t`.

# Arguments
- `peers::Vector{Float64}`: A vector containing the number of staked tokens by each peer.
- `t::Float64`: The interpolation parameter between 0 and 1, determining the weight of weighted consensus (when t=0) and opposite weighted consensus (when t=1).

# Returns
The index of the peer selected as the dynamic consensus.

# Examples
```julia
peers = [0.2, 0.3, 0.5]
t = 0.5
dynamic_lerp_consensus(peers, t)  # Output: index of the selected agent
"""
function gini_stabilized_consensus(peers::Vector{Float64}, t::Float64)
    if t == -1
        error("Can not launch GiniStabilized with t = -1")
    end

    weighted = cumsum(peers/sum(peers))
        
    processed_peers = abs.(maximum(peers) .- peers)

    opposite_weighted = cumsum(processed_peers/sum(processed_peers))
        
    cumulative_probabilities = lerp(opposite_weighted, weighted, t)
        
    random_number = rand()
    
    index = argmax(cumulative_probabilities .>= random_number)
end

"""
    random_consensus(peers::Vector{Float64})

Determines a random consensus among a group of peers.

The function selects a random agent from the group based on a uniform distribution.

# Arguments
- `peers::Vector{Float64}`: A vector containing the number of staked tokens by each peer.

# Returns
The index of the randomly selected agent as the consensus.

# Examples
```julia
agents = [0.2, 0.3, 0.5]
random_consensus(agents)  # Output: index of the randomly selected agent
"""


"""Da commentare"""
function random_consensus(peers::Vector{Float64})
    return rand(1 : size(peers)[1])
end

function constant_reward(total_reward::Float64, n_epochs::Int64)
    return total_reward / n_epochs
end

function dynamic_reward(total_reward::Float64, n_epochs::Int64, current_epoch::Int64)
    return (total_reward / n_epochs) + ((current_epoch / n_epochs) * total_reward)
end

function generate_peers(n_peers::Int64, initial_volume::Float64, distribution_type::Distribution, initial_gini = -1.0)
    if distribution_type == Uniform
        return generate_vector_uniform(n_peers, initial_volume)
    elseif distribution_type == Gini
        if initial_gini == -1.0
            println("In order to generate peers with a Gini distribution, call 'generate_peers' with the 'initial_gini' " * 
                    "parameter positive and less or equal to 1. Automatically setting 'initial_gini' equal to 0.3")
            initial_gini = 0.3
        end
        return generate_vector_with_gini(n_peers, initial_volume, initial_gini)
    end
end

function consensus(pos::PoS, stakes::Vector{Float64}, t::Float64 = -1.0)
    if pos == Weighted
        return weighted_consensus(stakes)
    elseif pos == OppositeWeighted
        return opposite_weighted_consensus(stakes)
    elseif pos == GiniStabilized
        return gini_stabilized_consensus(stakes, t)
    end

end

function generate_vector_with_gini(n_peers::Int, initial_volume::Float64, gini::Float64)
    function lorenz_curve(x1, y1, x2, y2)
        m = (y2 - y1) / (x2 - x1)
        return x -> m * x
    end

    max_r = (n_peers - 1) / 2
    r = gini * max_r
    prop = ((n_peers - 1) / n_peers) * ((max_r - r) / max_r)
    lc = lorenz_curve(0, 0, (n_peers - 1) / n_peers, prop)
    q = [lc(i / n_peers) for i in 1:n_peers-1] |> x -> [x..., 1]
    cumulate_sum = [i * initial_volume for i in q]
    stakes = [cumulate_sum[1]] |> x -> [x..., [cumulate_sum[i] - cumulate_sum[i - 1] for i in 2:n_peers]...]
    return stakes
end

function generate_vector_uniform(n::Int, volume::Float64)
   return [volume / n for _ in 1:n]
end

function compute_smooth_parameter(current_gini::Float64, target_gini::Float64, r::Float64)
    diff = abs(current_gini - target_gini)
    diff = diff * (1 / r)
    
    res = real((diff+0im) ^ (1 / 7.0))
    res = res * sign(current_gini - target_gini)
    
    res = (res / 2) + 0.5
    
    if res > 1.0
        res = 1.0
    end
    if res < 0.0
        res = 0.0
    end
    
    return 1 - res
end

function compute_smooth_parameter2(current_gini::Float64, target_gini::Float64, r::Float64)
    res = 0.5 - ((current_gini/(target_gini + r)) - (target_gini / (target_gini + r))) * (1 / (1 - target_gini / (target_gini + r)))
    if res > 1.0
        res = 1.0
    end
    if res < 0.0
        res = 0.0
    end
    return res
end

function compute_smooth_parameter3(current_gini::Float64, target_gini::Float64)
    if current_gini > target_gini
        return 0.0
    end
    if current_gini < target_gini
        return 1.5
    end
end

function d(g::Float64, θ::Float64)
    if g > θ
        return 0.5
    else 
        return 1.5
    end
end

function try_to_join(stakes::Vector{Float64}, p::Float64, join_amount::NewEntry)
    if rand() > 1 - p
        if join_amount == NewAverage
            push!(stakes, sum(stakes)/size(stakes)[1])
        elseif join_amount == NewMax
            push!(stakes, maximum(stakes))
        elseif join_amount == NewMin
            push!(stakes, minimum(stakes))
        elseif join_amount == NewRandom
            push!(stakes, stakes[rand(1:length(stakes))])
        end
    end
end

function try_to_quit(stakes::Vector{Float64}, p::Float64) 
    if rand() > 1 - p
        deleteat!(stakes, rand(1:size(stakes)[1]))
    end
end

;