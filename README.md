# Proof of Stake Simulator
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/narger-ef/Proof-of-Stake-Simulator/HEAD)

In this repository we present a Proof-of-Stake Simulator written in Julia. We used this simulator in order to study the trend of Gini coefficient under different consensus algorithms.

## Parameters

- n_epochs: The number of epochs to be simulated, that corresponds to the number of blocks (virtually) validated.
- proof_of_stake: The type of PoS to be used. It takes values in the set Weighted, OppositeWeighted, GiniStabilized.
- initial_stake_volume: The initial number of coins, distributed among the peers according to the next parameter.
- initial_distribution: The initial distribution of coins among the validators. It takes values in the set Uniform, Gini, Random.
- n_peers: The number of participants (the same as $N$ in the formulas above) in the blockchain that aim to be selected as validators.
- n_corrupted: The number of validators in the blockchain that could exhibit corrupted behavior according to a probability p_fail.
- p_fail: The probability that a corrupted validator tries not to validate correctly the block.
- penalty_percentage: The percentage of coins removed (slashed) from the amount of coins staked by the corrupted validators, in case they show corrupted behavior.
- p_join: The probability, at each epoch, of a new user to join the validators. The new user can be labeled as corrupted with a probability equal to the initial ratio of corrupted peers over the total number of peers.
- p_leave: The probability, at each epoch, of any validator to quit the pool.
- join_amount: The amount of coins owned by a peer that just joined the set of validators. It takes values in the set Average, Random, Max, Min.

## How to use

First import the required simulator:

```
include ("src/Simulator.jl")
```

be sure to point the correct `src` folder.

Next, create a `Parameter` object containing all the parameters. A basic set of parameters can be created as follows:

```
parameters = Parameters()
```

Then, each parameter can be changed individually.
In order to execute a simulator, we require two other elements: an initial stake and a set of corrupted peers. The first one can be created as follows:

```
stakes = generate_peers(parameters.n_peers, 
                            parameters.initial_stake_volume, 
                            parameters.initial_distribution, 
                            parameters.starting_gini);
```

Then the subset of corrupted peers, is simply created as follows

```
corrupted = rand(1:parameters.n_peers, parameters.n_corrupted)
```


We can finally run an experiment as follows:

```
history, peers = simulate(stakes, corrupted, parameters);
```

The variable `history` will contain the Gini coefficient computed at the end of each epoch, and `peers` will contain the number of peers at the end of each epoch.
Examples can be found in the `examples` folder, and are described below.

### Experiment 1 and 2
Online notebook available: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/narger-ef/Proof-of-Stake-Simulator/HEAD?urlpath=notebooks/examples/experiment-1-and-2/notebook.ipynb)

We use *Weighted PoS* in order to show the trend for $g$ to go to 1, and *OppositeWeighted PoS* in order to show the trend for $g$ to go to 0

### Experiment 3
Online notebook available: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/narger-ef/Proof-of-Stake-Simulator/HEAD?urlpath=notebooks/examples/experiment-3/notebook.ipynb)

We use *GiniStabilized PoS* to show that it is possible to control the Gini coefficient $g$. We set a target value $\theta = 0.3$ and plot the trend of $g$. 
In particular, we chose a Constant update for *GiniStabilized*

### Experiment 4
Online notebook available: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/narger-ef/Proof-of-Stake-Simulator/HEAD?urlpath=notebooks/examples/experiment-4/notebook.ipynb)

We use *GiniStabilized PoS* and *Linear* updates, showing that it is possible to obtain a smooth trend for the Gini coefficient around the target value $\theta$.

### Experiment 5
In this experiment we want to run different simulations on different types of ${\tt g\_funct}$
All the simulations share a lot of parameters (such as the number of epochs, the number of peers, the PoS type and so on), but they differ on the function applied to $s$ at each epoch. We remark that:
- Constant 
$$s = k$$
- Linear
$$s = |s - \theta| / k$$
- Quadratic
- $$s = |s - \theta|^2 / k$$
We run the following five simulations:
1) Constant, $k=1 / 1000$
2) Linear, $k = 10$
3) Linear, $k = 100$
4) Quadratic, $k = 10$
5) Quadratic, $k = 100$

Test it online here: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/narger-ef/Proof-of-Stake-Simulator/HEAD?urlpath=notebooks/examples/experiment-5/notebook.ipynb)

## Authors

- Alberto Leporati (`alberto.leporati@unimib.it`)
- Lorenzo Rovida (`lorenzo.rovida@unimib.it`)

Made with <3  at [Bicocca Security Lab](https://www.bislab.unimib.it), at University of Milan-Bicocca.

<img src="imgs/lab_logo.png" alt="BisLab logo" width=20%>
