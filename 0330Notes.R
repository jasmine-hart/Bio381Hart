# For Loop Review for HW
# 30 March 2022
# JAH

# Nested for loop -------------------------------
# create sample matrix

mat <- matrix(sample(1:10, size=9),
              nrow=3,
              ncol=3)
print(mat)

# writing the for loop (i takes values in 1)
for (i in 1:nrow(mat)) {
  for (j in 1:ncol(mat)) {
    print(mat[i,j]) # prints each cell of mat i=row j=columns
  }
}

# first 3 digits first 3 rows in the matrix
# nested for loops suck in r, python is better for it

# Part 2: Putting custom functions in for loops --------------
# simulating temperature data
site1 <- runif(min=60,max=70,n=10)
site2 <- runif(min=60,max=70,n=10)
site3 <- runif(min=40,max=50,n=10)

# put them in a dframe:
temps.df <- cbind(site1,site2,site3)

# function to convert to c 
degf.to.degc <- function(x){
  degc <- (x-32)*(5/9)
  
  return(degc)
}

# repeat function using a for loop
for(i in 1:ncol(temps.df)) {
  print(degf.to.degc(x=temps.df[,i]))
}
