set.seed(5)

source("doi-bandit-planner/functions/run_simulation.R")

#simulation parameters
rates <- c(0.05, 0.06, 0.045, 0.03, 0.03) #array of reward rates for each arm
controlRate <- .05 #reward rate of control (should be present in rates)
numSessions <- 2000 #number of sessions to simulate
batchSize <- 10 #number of sessions in a batch
numberOfBatches <- floor(numSessions/batchSize)
lagNumber <- 4 #number of batches behind we are

dataForAnalysis <- run_simulation(
    rates = rates,
    controlRate = controlRate,
    numSessions = numSessions,
    batchSize = batchSize,
    numberOfBatches = numberOfBatches,
    lagNumber = lagNumber
)