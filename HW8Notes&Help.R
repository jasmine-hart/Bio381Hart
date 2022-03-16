###############################
# Bio 381 tutorial: data sims #
# 16 March 2022               #
###############################

library(boot)


# Why we simulate data?
# saves time:write parts of code before you have data
# baseline for comparisons: check assumptions in your data
# Test new stats techniques

# Part 1: Normally distributed data ---------------
# Start with groups oof data 
# For t-tests or ANOVA

# simulate groups with 20 observations
group1 <- rnorm(n=20, mean=2, sd=1)
hist(group1)

# change some parameters
group2 <- rnorm(n=20, mean=5, sd=1)
group3 <- rnorm(n=20, mean=2, sd=3)

hist(group2)
hist(group3)

# Sim data for a linear regression
# Two continuous normal variables
# Start simple: assume an intercept of 0
# Call the slope beta1
# X is the predictor variable

# Start with constant slope
beta1 <- 1

# our predictor variable is normally distributed 
x <- rnorm(n=20)
# x is a normal distribution of 20 observations

# linear model:
y <- beta1*x
y==x

# you can play with different slopes
beta1 <- 1.5
y <- beta1*x

# you can also add an intercept:
beta0 <-2
y <- beta0+ beta1*x

# adding covariates
# you can draw covariate from a different distribution

# Part2: Abundance/Count data -------------------
# Option 1: data are normal-ish
# use round() to remove decimals

abund1 <- round(rnorm(n=20, mean=50, sd=10))
hist(abund1)



# Options 2: Poisson distribution
abund2 <- rpois(n=20, lambda=3)
# lambda is the peak or center of graph/numbers
barplot(table(abund2))
# table() is counts the number if each number printed or listed in the rpois() function

# Sometimes the environment affects counts
# To account for that, first create our lambdas
# Then use lambdas to get counts

# use a regression to get the initial values
pre.lambda <- beta0 + beta1*x
# inverse log exp() to make lambdas positive 
lambda <- exp(pre.lambda)

# use created lambdas to get counts
abund3<- rpois(n=20,lambda=lambda)
hist(abund3)

# Part 3: Occupancy, presences/absence data ------------
# Option 1: getting probability (probs) for a beta distribution
probs <- rbeta(n=20,shape=1,shape2=1) # probability of success
occ1<- rbinom(n=20,size=1,prob=probs)
print(occ1)

# Option 2: occupancy with a covariate
# similar to above, except we're generating probs, not lambdas

pre.probs <- beta0 + beta1*x
print(pre.probs)

# convert to 0-1 scale
psi <- inv.logit(pre.probs)
# puts it on a 0-1 scale inv.logit()

# create new occupancy data:
occ2 <- rbinom(n=20,size=1,prob=psi)
print(occ2)
