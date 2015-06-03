# setwd("\\\\washjeff.edu\\shares\\YR2018\\britosampaiog\\datastore\\My Documents\\CIS\\SummerResearch")

data <- read.csv("data/classes.csv", header=TRUE)

cols <- dim(data)[2]
rows <- dim(data)[1]

new_student <- matrix(0,1,(cols-1))

new_student[1] <- 1
new_student[2] <- 1
new_student

sub <- t( apply( data[, 2 : cols ], 1, function(x) (x-new_student)^2 ) )

# dists <- rowSums( ( data[, 2 : cols ] - new_student ) ^ 2 )
# dists <- matrix( rowSums(sub), dim(data)[1],1 )
dists <- matrix( apply( sub, 1, function(row) sqrt(sum(row)) ), rows, 1 )

order_list <- order(dists, decreasing=FALSE)

nn <- data[ order_list, 2 : cols ]

nn[1:10,]
