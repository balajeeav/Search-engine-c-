in_file <- file('/home/max/dev/academic-search/src/code/input.txt') 
open(in_file)
save_list <- list()
#close(in_file)

j <-0
while ((length(line <- readLines(in_file, n = 1, warn = FALSE)) > 0)) {
  save_list <- c(save_list,line)
  j <- j+1
} 
close(in_file)
author_num=length(save_list)

file.create("/home/max/dev/academic-search/src/code/output.txt")
out_file <- file('/home/max/dev/academic-search/src/code/output.txt') 
open(out_file)

for (i in 1:author_num)
{
res_vec=Micro_Scraper (save_list[i], since=1945, write=T, citation=1)
new_res_vec=array(res_vec)
num=res_vec[1]
final_vec=0
years_in_science=0
h_res=0
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
lapply(save_list[i], write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
lapply("Publications: ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
lapply(num, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)

lapply("Years in science: ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
lapply(years_in_science, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)

lapply("Hirsch index: ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
lapply(h_res, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)

lapply("Citations: ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
if (num>0)
{
  lapply(citations, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
}
if (num==0)
{
  lapply('-', write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
}

#lapply(final_vec, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
##It is necessary if we want to show the user all the information
lapply("##", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
}
close(out_file)