# Set a min number of rows! Overfitting
# Level control
# Purity control
# random forest

data <- read.csv("data/classes.csv", header=TRUE)

cols <- dim(data)[2]
rows <- dim(data)[1]

train_data <- data[ 1:(0.15*rows), ]
test_data <- data[ (0.75*rows):rows, ]

# we are predicting the last attribute
# neg (0) to the left, pos (1) to the right
# node: list( left_node, right_node, index )

gen_node <- function(left_node, right_node, index){

  return( list(left_node, right_node, index) )

}

# purity: prob of 1
calc_purity <- function(cdata, index){

  pred_index <- dim(cdata)[2]

  ldata <- cdata[ cdata[,index]==0 ,]
  rdata <- cdata[ cdata[,index]==1 ,]

  lpos <- ldata[ ldata[,pred_index]==1 ,]
  ltotal <- dim(ldata)[1]
  lpos_total <- dim(lpos)[1]

  rpos <- rdata[ rdata[,pred_index]==1 ,]
  rtotal <- dim(rdata)[1]
  rpos_total <- dim(rpos)[1]

  return( (lpos_total/ltotal)^2 + (rpos_total/rtotal)^2 )

}

get_left_leaf <- function(cdata, index){
  ldata <- cdata[ cdata[,index]==0 ,]
  return(ldata)
}

get_right_leaf <- function(cdata, index){
  rdata <- cdata[ cdata[,index]==1 ,]
  return(rdata)
}

gen_tree <- function(cdata, level){

  print(level)

  crows <- dim(cdata)[1]
  ccols <- dim(cdata)[2]

  if(ccols==1 || crows==1){
    return(gen_node(-1,-1, -1))
  }

  purities <- unlist( lapply( c(1:ccols), function(x) calc_purity(cdata, x) ) )

  # we can use as root
  pure_node <- which.max( purities[ 1:(length(purities)-1) ] )

  left_cdata <- get_left_leaf(cdata, pure_node)[,-pure_node]
  level[1]<-level[1]+1
  left_node <- gen_tree(left_cdata, level)

  right_cdata <- get_right_leaf(cdata, pure_node)[,-pure_node]
  level[2]<-level[2]+1
  right_node <- gen_tree(right_cdata, level)

  return(gen_node(left_node, right_node, pure_node))

}

root <- gen_tree(train_data[,2:cols], c(1,1))

print(root)
