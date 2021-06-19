pretty_name <- function (name) {
  names <- unlist(strsplit(name, split="\\s+"));
  if (length(names) == 3) {
    names[2] <- substr(names[2], 1, 1);
  }
  res <- "";
  for (n in names) {
    res <- paste(res, n)
  }
  res
}

inputs <- commandArgs(trailingOnly=TRUE);
in_name <- pretty_name(inputs[1]);
out_file_name <- inputs[2];

save_list <- list();
save_list <- c(save_list, in_name);

#j <-0
#while ((length(line <- readLines(in_file, n = 1, warn = FALSE)) > 0)) {
  #save_list <- c(save_list,line)
  #j <- j+1
#} 
#close(in_file)
author_num=length(save_list)

file.create(out_file_name)
out_file <- file(out_file_name) 
open(out_file)

#for (i in 1:author_num)
#{
i=1
res_vec=Micro_Scraper (save_list[i], since=1945, write=T, citation=1)
new_res_vec=array(res_vec)
num=res_vec[1]
final_vec=0
if (num>0)
{
years_in_science=res_vec[2]
dim=dim(new_res_vec)-2
citations=res_vec[3:(dim+2)]
#citations=res_vec[(dim+2):(2*dim+1)]

h_index <-0
while (h_index<dim-2)
{
  if (citations[h_index+3]>h_index)
  {
    h_index <- h_index+1
  }
  else
  {
    break
  }
}

cit_num=min(num,100)


#print(h_index)
h_res=h_index

final_list=list(num, cit_num, 0, h_res, years_in_science, citations)
final_vec=unlist(final_list)


}
##print("res_vec")
##print(new_res_vec)
lapply(final_vec, write, out_file_name, append=TRUE)
#}
close(out_file)