# Limit the max number of suggestions based on the maximum number classes in
# in the semester

# page 68 cosine

# setwd("\\\\washjeff.edu\\shares\\YR2018\\britosampaiog\\datastore\\My Documents\\CIS\\SummerResearch")

# install.packages(ROCR)
# library(ROCR)

data <- read.csv("data/classes.csv", header=TRUE)

cols <- dim(data)[2]
rows <- dim(data)[1]

knn <- function(data, new_student, k=10){

  sub <- t( apply( data[, 2 : cols ], 1, function(x) (x-new_student)^2 ) )

  # dists <- rowSums( ( data[, 2 : cols ] - new_student ) ^ 2 )
  # dists <- matrix( rowSums(sub), dim(data)[1],1 )
  dists <- matrix( apply( sub, 1, function(row) sqrt(sum(row)) ), rows, 1 )

  order_list <- order(dists, decreasing=FALSE)

  nn <- data[ order_list, 2 : cols ]

  # return(nn[1:k,])

  nn_count <- t( apply( nn[1:k,], 2, mean ) )

  nn_count_mask <- nn_count * new_student

  nn_count_filtered <- nn_count - nn_count_mask;

  # new_student
  # nn_count_filtered
  nn_mean <- t( apply( nn_count_filtered, 1, mean ) )

  nn_count[ nn_count >= nn_mean[1] ] <- 2
  nn_count[ nn_count < nn_mean[1] ] <- 0

  matches <- nn_count - new_student

  fp <- length( matches[ matches==2 ] )
  tp <- length( matches[ matches==1 ] )
  tn <- length( matches[ matches==0 ] )
  fn <- length( matches[ matches==-1 ] )

  return( cbind(fp, tp, tn, fn) )

}

new_student <- matrix(0,1,(cols-1))
new_student[1] <- 1
new_student[3] <- 1
new_student[14] <- 1

train_data <- data[ 1:(0.75*rows), ]
test_data <- data[ (0.75*rows):rows, ]

nn <- matrix(0, (0.25*rows), 4 )

nn <- t( apply( test_data, 1, function(x) ( knn(train_data, x) ) ) )

# nn <- knn(data, new_student)



# prediction does not do the calculations

# predAct <- data.frame(nn_count,new_student)
# prf(predAct)

# pred <- prediction(nn_count, new_student)
# perf <- performance(pred, "prec")
# plot(perf)

# pred <- prediction(nn_count, new_student)
# perf <- performance(pred, measure="acc")
# plot(perf)
# abline(a=0, b= 1)

# data(ROCR.simple)
# pred <- prediction(ROCR.simple$predictions,ROCR.simple$labels)
# perf <- performance(pred,measure="acc",x.measure="cutoff")
# plot(perf)

# Precision: tp / (tp + fp)
# Recall: tp / (tp + fn)
