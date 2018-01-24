###########################################################################################
#### Part 4: Test various contingency funds' performances using simulated data. 
####           - For each model, we do 1000 simulations of 50 years, and adjust params until
####             failure rate (fund balance < 0) is <5%
###########################################################################################
rm(list=ls())
#### Load data
load('r.rda')    # r = yearly hydropower revenues. dataframe, 50 rows (1 for each year), 1000 cols (1 for each simulation)
load('s.rda')    # s = yearly SWE index. dataframe, 50 rows (1 for each year), 1000 cols (1 for each simulation)
nsim <- ncol(r)
nyr <- nrow(r)

#### Method 1: over/under median. post-fund revenue will always equal median revenue.
r_med <- median(r)
f_start <- 21.87e6     #### Adjust this parameter until failure meets desired confLev (see test line 47)
r_min <- r_med
confLev <- 0.95

# store fund level in each year in f, revenue after dealing with fund in rf
f <- NA * r
rf <- NA * r

# loop over simulations
fail <- rep(NA, nsim)
for (i in 1:nsim){
  # calc yearly fund and post-fund rev
  rf[,i] <- rep(r_med, nyr)
  f[,i] <- f_start + cumsum(r[,i] - rf[,i])
  
  # If fund ever below zero, set all later f to zero (else interest compounds negatively, ruins stats)
  dum <- NA
  if (sum(f[,i] < 0) > 0){
    dum <- which(f[,i] < 0)[1]
    f[dum:(nrow(f)),i] <- 0
  }
  # check whether min(f) < 0 or whether min(rf) < r_min
  fail[i] <- !is.na(dum)
}
# get stats for range rf ($ mil)
revVals <- round(c(median(apply(rf, 2,FUN=min)), median(apply(rf, 2,function(x) quantile(x, 0.25))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.5))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.75))), median(apply(rf, 2, FUN=max)))/1e6, 2)
# get stats for end fund rf ($ mil)
fundVals <- round(c(min(f[nyr,]), quantile(f[nyr,],0.25), median(f[nyr,]), quantile(f[nyr,], 0.75), max(f[nyr,]))/1e6, 2)
# check if acceptable failure rate
conf <- sum(!fail)/nsim
conf >= confLev
plotEx <- 100
# Save example simulation for plot
fplot <- matrix(rep(NA, 5*nyr), ncol=5)
rfplot <- fplot
fplot[,1] <- f[,plotEx]
rfplot[,1] <- rf[,plotEx]

# Calculate present value net benefits (PVNB) of model, using only simulations that don't fail
d <- 0.08
rfdum <- rf[,which(colSums(f>0) == nyr)]     # use only non-failing sims
rdum <- r[,which(colSums(f>0) == nyr)]
fdum <- f[,which(colSums(f>0) == nyr)]
EPVNB_pass <- rep(NA, ncol(fdum))
for (i in 1:ncol(fdum)){
  EPVNB_pass[i] <- fdum[nyr,i]/(1+d)^nyr - f_start + sum((rfdum[,i] - rdum[,i]) / (1 + d) ^ c(1:50))
}
# output mean PVNB of passing sims, in $M
round(mean(EPVNB_pass)/1e6, 2)



#### Method 2: contribute all rev > r_s2, receive payout for rev < r_s1
r_med <- median(r)
qLow <- 0.2
r_min <- quantile(r, qLow)
f_start <- 9.12e6
r_s1 <- r_min 
r_s2 <- 2 * r_med - r_s1 #quantile(r, 1 - qLow)
confLev <- 0.95

# store fund level in each year in f, revenue after dealing with fund in rf
f <- NA * r
rf <- NA * r

# loop over simulations
fail <- rep(NA, nsim)
for (i in 1:nsim){
  # calc yearly fund and post-fund rev
  rf[,i] <- sapply(r[,i], function(x) ifelse(x < r_s1, r_s1, ifelse(x > r_s2, r_s2, x)))
  f[,i] <- f_start + cumsum(r[,i] - rf[,i])
  
  # If fund ever below zero, set all later f to zero (else interest compounds negatively, ruins stats)
  dum <- NA
  if (sum(f[,i] < 0) > 0){
    dum <- which(f[,i] < 0)[1]
    f[dum:(nrow(f)),i] <- 0
  }
  # check whether min(f) < 0 or whether min(rf) < r_min
  fail[i] <- !is.na(dum)
}
# get average range rf ($ mil)
revVals <- round(c(median(apply(rf, 2,FUN=min)), median(apply(rf, 2,function(x) quantile(x, 0.25))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.5))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.75))), median(apply(rf, 2, FUN=max)))/1e6, 2)
# get average end fund rf ($ mil)
fundVals <- round(c(min(f[nyr,]), quantile(f[nyr,],0.25), median(f[nyr,]), quantile(f[nyr,], 0.75), max(f[nyr,]))/1e6, 2)
# check if acceptable failure rate
conf <- sum(!fail)/nsim
conf >= confLev
# Save example simulation for plot
fplot[,2] <- f[,plotEx]
rfplot[,2] <- rf[,plotEx]
# Calculate PVNB of model, using only simulations that don't fail
d <- 0.06
rfdum <- rf[,which(colSums(f>0) == nyr)]     # use only non-failing sims
rdum <- r[,which(colSums(f>0) == nyr)]
fdum <- f[,which(colSums(f>0) == nyr)]
EPVNB_pass <- rep(NA, ncol(fdum))
for (i in 1:ncol(fdum)){
  EPVNB_pass[i] <- fdum[nyr,i]/(1+d)^nyr - f_start + sum((rfdum[,i] - rdum[,i]) / (1 + d) ^ c(1:50))
}
# output mean PVNB of passing sims, in $M
round(mean(EPVNB_pass)/1e6, 2)




#### Method 3: contribute prem all years, payout below r_s, so that min rev is r_s - prem
r_med <- median(r)
# prem_approx <- 250000   # Adjust this until r_s - prem ~ r_min, then set premium to whole number below
# r_min <- quantile(r, 0.2)
# r_s <- r_min + prem_approx
# prem <- sum(r_s - r[r<r_s])/nsim/nyr
# r_s - prem - r_min

f_start <- 7.95e6
prem <- 250000
r_min <- quantile(r, 0.2)
r_s <- prem + r_min
confLev <- 0.95

# store fund level in each year in f, revenue after dealing with fund in rf
f <- NA * r
rf <- NA * r

# loop over simulations
fail <- rep(NA, nsim)
for (i in 1:nsim){
  # calc post-fund rev
  rf[,i] <- sapply(r[,i], function(x) ifelse(x < r_s, r_s - prem, x - prem))
  f[,i] <- f_start + cumsum(r[,i] - rf[,i])
  
  # If fund ever below zero, set all later f to zero (else interest compounds negatively, ruins stats)
  dum <- NA
  if (sum(f[,i] < 0) > 0){
    dum <- which(f[,i] < 0)[1]
    f[dum:(nrow(f)),i] <- 0
  }
  # check whether min(f) < 0 or whether min(rf) < r_min
  fail[i] <- !is.na(dum)
}
# get average range rf ($ mil)
revVals <- round(c(median(apply(rf, 2,FUN=min)), median(apply(rf, 2,function(x) quantile(x, 0.25))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.5))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.75))), median(apply(rf, 2, FUN=max)))/1e6, 2)
# get average end fund rf ($ mil)
fundVals <- round(c(min(f[nyr,]), quantile(f[nyr,],0.25), median(f[nyr,]), quantile(f[nyr,], 0.75), max(f[nyr,]))/1e6, 2)
# check if acceptable failure rate
conf <- sum(!fail)/nsim
conf >= confLev
# Save example simulation for plot
fplot[,3] <- f[,plotEx]
rfplot[,3] <- rf[,plotEx]
# Calculate PVNB of model, using only simulations that don't fail
d <- 0.06
rfdum <- rf[,which(colSums(f>0) == nyr)]     # use only non-failing sims
rdum <- r[,which(colSums(f>0) == nyr)]
fdum <- f[,which(colSums(f>0) == nyr)]
EPVNB_pass <- rep(NA, ncol(fdum))
for (i in 1:ncol(fdum)){
  EPVNB_pass[i] <- fdum[nyr,i]/(1+d)^nyr - f_start + sum((rfdum[,i] - rdum[,i]) / (1 + d) ^ c(1:50))
}
# output mean PVNB of passing sims, in $M
round(mean(EPVNB_pass)/1e6, 2)




#### Method 4: same as 3, but with a drought charge to customers
r_med <- median(r)
f_start <- 5.70e6
dx <- 0.05
confLev <- 0.95
r_min <- quantile(r, 0.2)

# prem_approx <- 210000   # Adjust this until r_s - prem ~ r_min, then set premium to whole number below
# r_s <- r_min + prem_approx
# # rescale revenue, with r < r_min scaled up
# rscl <- r
# rscl[rscl < r_s] <- rscl[rscl < r_s] * (1 + dx)
# prem <- sum(r_s - rscl[rscl<r_s])/nsim/nyr
# r_s - prem - r_min

prem <- 120000
r_s <- r_min + prem
rscl <- r
rscl[rscl < r_s] <- rscl[rscl < r_s] * (1 + dx)

# store fund level in each year in f, revenue after dealing with fund in rf
f <- NA * rscl
rf <- NA * rscl

# loop over simulations
fail <- rep(NA, nsim)
for (i in 1:nsim){
  # calc post-fund rev
  rf[,i] <- sapply(rscl[,i], function(x) ifelse(x < r_s, r_s - prem, x - prem))
  f[,i] <- f_start + cumsum(rscl[,i] - rf[,i])
  
  # If fund ever below zero, set all later f to zero (else interest compounds negatively, ruins stats)
  dum <- NA
  if (sum(f[,i] < 0) > 0){
    dum <- which(f[,i] < 0)[1]
    f[dum:(nrow(f)),i] <- 0
  }
  # check whether min(f) < 0 or whether min(rf) < r_min
  fail[i] <- !is.na(dum)
}
# get average range rf ($ mil)
revVals <- round(c(median(apply(rf, 2,FUN=min)), median(apply(rf, 2,function(x) quantile(x, 0.25))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.5))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.75))), median(apply(rf, 2, FUN=max)))/1e6, 2)
# get average end fund rf ($ mil)
fundVals <- round(c(min(f[nyr,]), quantile(f[nyr,],0.25), median(f[nyr,]), quantile(f[nyr,], 0.75), max(f[nyr,]))/1e6, 2)

# check if acceptable failure rate
conf <- sum(!fail)/nsim
conf >= confLev
# Save example simulation for plot
fplot[,4] <- f[,plotEx]
rfplot[,4] <- rf[,plotEx]
# Calculate PVNB of model, using only simulations that don't fail
d <- 0.06
rfdum <- rf[,which(colSums(f>0) == nyr)]     # use only non-failing sims
rdum <- r[,which(colSums(f>0) == nyr)]
fdum <- f[,which(colSums(f>0) == nyr)]
EPVNB_pass <- rep(NA, ncol(fdum))
for (i in 1:ncol(fdum)){
  EPVNB_pass[i] <- fdum[nyr,i]/(1+d)^nyr - f_start + sum((rfdum[,i] - rdum[,i]) / (1 + d) ^ c(1:50))
}
# output mean PVNB of passing sims, in $M
round(mean(EPVNB_pass)/1e6, 2)



#### Method 5: same as 4 (or 3, if dx=0), but with yearly interest rate for fund and no premium
r_med <- median(r)
r_min <- quantile(r, 0.2)
f_start <- 9.91e6
f_int <- 0.02
r_s <- r_min
dx <- 0 #.1
confLev <- 0.95
# rescale revenue, with r < r_min scaled up
rscl <- r
rscl[rscl < r_min] <- rscl[rscl < r_min] * (1 + dx)
prem <- 0 #sum(r_min - rscl[rscl<r_min])/nsim/nyr

# store fund level in each year in f, revenue after dealing with fund in rf
f <- NA * rscl
rf <- NA * rscl

# loop over simulations
fail <- rep(NA, nsim)
for (i in 1:nsim){
  # calc post-fund rev
  rf[,i] <- sapply(rscl[,i], function(x) ifelse(x < r_s, r_s - prem, x - prem))
  
  # add interest to fund
  f[1,i] <- f_start * (1 + f_int) + rscl[1,i] - rf[1,i]
  for (j in 2:nyr){
    f[j,i] <- f[j-1,i] * (1 + f_int) + rscl[j,i] - rf[j,i]
  }
  
  # If fund ever below zero, set all later f to zero (else interest compounds negatively, ruins stats)
  dum <- NA
  if (sum(f[,i] < 0) > 0){
    dum <- which(f[,i] < 0)[1]
    f[dum:(nrow(f)),i] <- 0
  }
  # check whether min(f) < 0 or whether min(rf) < r_min
  fail[i] <- !is.na(dum)
}
# get average range rf ($ mil)
revVals <- round(c(median(apply(rf, 2,FUN=min)), median(apply(rf, 2,function(x) quantile(x, 0.25))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.5))), 
                   median(apply(rf, 2,function(x) quantile(x, 0.75))), median(apply(rf, 2, FUN=max)))/1e6, 2)
# get average end fund rf ($ mil)
fundVals <- round(c(min(f[nyr,]), quantile(f[nyr,],0.25), median(f[nyr,]), quantile(f[nyr,], 0.75), max(f[nyr,]))/1e6, 2)
# check if acceptable failure rate
conf <- sum(!fail)/nsim
conf >= confLev
# Save example simulation for plot
fplot[,5] <- f[,plotEx]
rfplot[,5] <- rf[,plotEx]
# Calculate PVNB of model, using only simulations that don't fail
d <- 0.06
rfdum <- rf[,which(colSums(f>0) == nyr)]     # use only non-failing sims
rdum <- r[,which(colSums(f>0) == nyr)]
fdum <- f[,which(colSums(f>0) == nyr)]
EPVNB_pass <- rep(NA, ncol(fdum))
for (i in 1:ncol(fdum)){
  EPVNB_pass[i] <- fdum[nyr,i]/(1+d)^nyr - f_start + sum((rfdum[,i] - rdum[,i]) / (1 + d) ^ c(1:50))
}
# output mean PVNB of passing sims, in $M
round(mean(EPVNB_pass)/1e6, 2)




### Get stats for No Action (r)
# get average range rf ($ mil)
revVals <- round(c(median(apply(r, 2,FUN=min)), median(apply(r, 2,function(x) quantile(x, 0.25))), 
                   median(apply(r, 2,function(x) quantile(x, 0.5))), 
                   median(apply(r, 2,function(x) quantile(x, 0.75))), median(apply(r, 2, FUN=max)))/1e6, 2)

### Plot sim results - fund
#jpeg(filename='modelSims.jpg', quality=100, width=720)
#par(mfrow=c(1,2))
plot(1:nyr, fplot[,1]/1e6, type='l', ylim = c(0,40), col='red', xlab='Year', ylab='Fund Balance ($M)')
lines(1:nyr, fplot[,2]/1e6, col='orange')
lines(1:nyr, fplot[,3]/1e6, col='green')
lines(1:nyr, fplot[,4]/1e6, col='blue')
lines(1:nyr, fplot[,5]/1e6, col='violet')
legend('topleft', legend=c('M1','M2','M3','M4','M5'), lwd=1, col=c('red','orange','green','blue','violet'))
#dev.off()
####

### Plot sim results - rf
#jpeg(filename = 'modelSimsRF.jpg', quality=100, width=720, height=720)
#par(mfrow=c(2,2))
plot(1:nyr, r[,plotEx]/1e6, ylim=c(9,19), xlab='Year', ylab='Revenue ($M)', main='No Contingency Fund', cex.lab=1.2, type='l')
plot(1:nyr, rfplot[,1]/1e6, ylim=c(9,19), xlab='Year', ylab='Revenue ($M)', main='Model 1', cex.lab=1.2, type='l')
plot(1:nyr, rfplot[,2]/1e6, ylim=c(9,19), xlab='Year', ylab='Revenue ($M)', main='Model 2', cex.lab=1.2, type='l')
plot(1:nyr, rfplot[,3]/1e6, ylim=c(9,19), , xlab='Year', ylab='Revenue ($M)', main='Model 3', cex.lab=1.2, type='l')
# plot(1:nyr, rfplot[,4]/1e6, ylim=c(9,19))
# plot(1:nyr, rfplot[,5]/1e6, ylim=c(9,19))
#dev.off()


