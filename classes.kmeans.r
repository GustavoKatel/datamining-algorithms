data <- read.csv("data/classes.csv", header=TRUE)

cols <- dim(data)[2]
rows <- dim(data)[1]

train_data <- data[ 1:(0.75*rows), ]
test_data <- data[ (0.75*rows):rows, ]

k <- 4

clusters <- matrix(0, k, (cols-1) )

clusters_census <- matrix(0, k, 1)
colnames(clusters_census) <- c("Count")

total_dists <- 0

get_dist_cluster <- function(row) {

  dists <- t( apply( clusters, 1, function(x) (x - row)^2 ) )
  dists <- cbind( apply( dists, 1, sum ) )
  dists <- cbind( apply( dists, 1, sqrt ) )

  # assigned <- order(dists, decreasing=TRUE)[1]
  assigned <- which.min(dists)

  clusters_census[assigned,1] <- clusters_census[assigned,1]+1

  total_dists <- total_dists+dists[assigned,1]

}

a <- t( apply( train_data[,2:cols], 1, function(x) get_dist_cluster(x) ) )

# Evolutionary increase of clusters centers
# Check the mininum total_dists
