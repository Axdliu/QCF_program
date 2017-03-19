################################################
#####  Code for Example 5.2  ###################
################################################  

midcapD.ts = read.csv("midcapD.ts.csv")
x = 100*as.matrix(midcapD.ts[,-c(1,22)])
train = x[1:250,]
valid = x[-(1:250),]
meansTrain = apply(train,2,mean)
commonmeanTrain = mean(meansTrain)
meansValid = apply(valid,2,mean)
SSseparate = sum((meansTrain-meansValid)^2)
SScommon = sum((commonmeanTrain - meansValid)^2)
SScommonTrain = sum((commonmeanTrain - meansTrain)^2)
SSseparate
SScommon
SScommonTrain