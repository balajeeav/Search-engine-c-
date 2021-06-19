inputs <- commandArgs(trailingOnly=TRUE);
sleep_time <- abs(rnorm(1, mean=2.5, sd=2));
Sys.sleep(sleep_time);
out_path <- inputs[2]

file.create(out_path);

number_of_articles <- sample(50:100, 1);
process_articles <- 40;
is_approx <- 1;
h_index <- sample(10:100, 1);
years <- sample(1:100, 1);
articles <- sort(sample(50:100, process_articles));
approx <- sort(articles + rnorm(process_articles));
data <- unlist(list(number_of_articles, process_articles, is_approx, h_index, years, articles, approx))
result <- lapply(data, write, file=out_path, append=TRUE);