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

get_dist_cluster <- function(nclusters, row) {

  dists <- t( apply( nclusters, 1, function(x) (x - row)^2 ) )
  dists <- cbind( apply( dists, 1, sum ) )
  dists <- cbind( apply( dists, 1, sqrt ) )

  # assigned <- order(dists, decreasing=TRUE)[1]
  assigned <- which.min(dists)

  clusters_census[assigned,1] <<- clusters_census[assigned,1]+1

  total_dists <<- total_dists+dists[assigned,1]

}

a <- t( apply( train_data[,2:cols], 1, function(x) get_dist_cluster(clusters, x) ) )

# max_changes <- (2^(cols-1))
max_changes <- 100000

total_dists_min <- total_dists
clusters_census_min <- clusters_census

for(i in 1:max_changes){

  new_clusters <- matrix(sample(0:1,k*(cols-1), replace=TRUE),k,cols-1)

  # print(new_clusters)

  total_dists <<- 0
  clusters_census <<- matrix(0, k, 1)
  colnames(clusters_census) <- c("Count")

  a <- t( apply( train_data[,2:cols], 1, function(x) get_dist_cluster(new_clusters, x) ) )

  if(total_dists<total_dists_min){
    clusters <<- new_clusters
    clusters_census_min <<- clusters_census
    total_dists_min <<- total_dists
    print("Min")
  }

  print(paste("Step ", i, "/", max_changes, "... Dist: ", total_dists, sep=""))

}

print(clusters)
