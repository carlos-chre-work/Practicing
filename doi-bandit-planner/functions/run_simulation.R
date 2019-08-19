run_simulation <- function(rates, controlRate, numSessions, batchSize, numberOfBatches, lagNumber) {
    numArms <- length(rates)
    
    #Set priors/posteriors
    modelParams <- list()
    
    for (i in 1:numArms) {
        modelParams[[i]] <- c(1,1)
    }
    
    #Initialize Histories
    sessionIndex <- c()
    rewardHistory <- c()
    armHistory <- c()
    costHistory <- c()
    abCostHistory <- c()
    batchHistory <- c()
    
    #Initialize Constants
    
    #helper functions
    flip <- function(p) {rbinom(1,1,p)}
    sampleBeta <- function(params) {rbeta(1,params[1],params[2])}
    vSampleBeta <- function(lparams) {simplify2array(lapply(X = lparams, FUN = sampleBeta))}
    sampleArm <- function(lparams) {which.max(vSampleBeta(lparams))}
    
    updatePosterior <- function(reward, arm, modelParams) {
        if (reward == 1) { #update modelParams
            modelParams[[arm]][1] <- modelParams[[arm]][1] + 1
        } else if (reward == 0) {
            modelParams[[arm]][2] <- modelParams[[arm]][2] + 1
        }
        modelParams
    }
    
    
    #simulation
    for (batchID in 1:numberOfBatches) {
        for (j in 1:batchSize){
            sessionID <- (batchID - 1)*batchSize + j
            arm <- sampleArm(modelParams) #choose arm (an integer)
            reward <- flip(rates[arm])
            
            #record what happened
            sessionIndex[sessionID] <- sessionID
            rewardHistory[sessionID] <- reward
            armHistory[sessionID] <- arm
            costHistory[sessionID] <- rates[arm] - controlRate
            abCostHistory[sessionID] <- mean(rates) - controlRate
        }
        #Do Batched and lagged updates
        startingTrainingIndex <- sessionID - (lagNumber+1)*batchSize + 1
        endingTrainingIndex <- sessionID - lagNumber*batchSize
        if (startingTrainingIndex > 0){
            trainingArms <- armHistory[startingTrainingIndex:endingTrainingIndex]
            trainingRewards <- rewardHistory[startingTrainingIndex:endingTrainingIndex]
            for(k in 1:batchSize){
                modelParams <- updatePosterior(trainingRewards[k], trainingArms[k], modelParams)
            }
        }
    }
    
    #write simulation results to dataframe for analysis
    dataForAnalysis <- data.frame(sessionIndex, rewardHistory, armHistory, costHistory, abCostHistory)
}