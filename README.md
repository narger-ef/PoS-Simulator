# Proof of Stake Simulator

### Experiment 1
We use *Weighted PoS* in order to show the trend for $g$ to go to 1
### Experiment 2
### Experiment 3
### Experiment 4
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

Test it online here: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/narger-ef/Proof-of-Stake-Simulator/HEAD?urlpath=notebooks/examples/experiment5/notebook.ipynb)
