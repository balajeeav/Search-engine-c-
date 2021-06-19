print("Olooooo11")

Z = read.csv("./approx.csv", header=FALSE, sep=";")
real_data <- Z[1,]
approx_data <- Z[2,]
xs <- 1:length(Z[1,])
aps <- 1:length(Z[2,])

print(Z)

jpeg("./graph.jpg")
plot(xs, real_data, type="p", xlab="Number of article", ylab="Count of citations", main="Citations and approximation", col="red")
lines(aps, approx_data, type="b", col="blue")
dev.off()