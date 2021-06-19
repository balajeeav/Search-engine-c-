in_file <- file('/home/max/dev/academic-search/src/code/input.txt') 
open(in_file)
save_list <- list()

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
#for (i in 1:author_num)
#{
  i=1
  res_vec=GScholar_Scraper (save_list[i], since=1945, write=T, citation=1)
  
  new_res_vec=array(res_vec)
  num=res_vec[1]
  final_vec=0
  years_in_science=0
  h_res=0
  if (num>0)
  {
    dim=(dim(new_res_vec)-1)/2
    years=res_vec[2:(dim+1)]
    years=years[years>1945]
    citations=res_vec[(dim+2):(2*dim+1)]
    #print(citations)
    
    h_index <-0
    while (h_index<dim)
    {
      if (citations[h_index+1]>h_index)
      {
        h_index <- h_index+1
      }
      else
      {
        break
      }
    }
    
    cit_num=min(num,40)
    
    if_little=0
    #print(h_index)
    h_res=h_index
    if ((h_index>=40)&&(num>40))
    {
      if_little=1
      y=log(citations)
      help_x=1:40
      x=cbind(sign(help_x),log(help_x))
      theta=solve(t(x)%*%x)%*%t(x)%*%y
      h_tilde=exp(theta[1]/(1-theta[2]))
      h_res=round((2*h_tilde+40)/3)
      approx=exp(x%*%theta)
    }
    
    years_in_science=2013-min(years)
    if(if_little==0)
    {
      final_list=list(num,cit_num,if_little,h_res, years_in_science, citations)
      final_vec=unlist(final_list)
    }
    if (if_little==1)
    {
      final_list=list(num,cit_num,if_little,h_res, years_in_science, citations,approx)
      final_vec=unlist(final_list)
    }
    
    ##print("res_vec")
    ##print(new_res_vec)
  }
  
  res_vec_micro=Micro_Scraper (save_list[i], since=1945, write=T, citation=1)
  new_res_vec_micro=array(res_vec_micro)
  num_micro=res_vec_micro[1]
  final_vec_micro=0
  years_in_science_micro=0
  h_res_micro=0
  if (num_micro>0)
  {
    years_in_science_micro=res_vec_micro[2]
    dim_micro=dim(new_res_vec_micro)-2
    citations_micro=res_vec_micro[3:(dim_micro+2)]
    #citations=res_vec[(dim+2):(2*dim+1)]
    
    h_index_micro <-0
    while (h_index_micro<dim_micro-2)
    {
      if (citations_micro[h_index_micro+3]>h_index_micro)
      {
        h_index_micro <- h_index_micro+1
      }
      else
      {
        break
      }
    }
    
    cit_num_micro=min(num_micro,100)
    
    
    #print(h_index)
    h_res_micro=h_index_micro
    
    final_list_micro=list(num_micro, cit_num_micro, 0, h_res_micro, years_in_science_micro, citations_micro)
    final_vec_micro=unlist(final_list_micro)
    
    
  }
  lapply(final_vec, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
  lapply("##", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
  lapply(final_vec_micro, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
  
#   lapply(save_list[i], write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply("Publications (Google): ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply(num, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply("Publications (Microsoft): ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply(num_micro, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   
#   lapply("Years in science (Google): ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply(years_in_science, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply("Years in science (Microsoft): ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply(years_in_science_micro, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   
#   lapply("Hirsch index (Google): ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply(h_res, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   
#   lapply("Hirsch index (Microsoft): ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   lapply(h_res_micro, write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   
#   lapply("Citations (Google): ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   if (num>0)
#   {
#     lapply(t(citations), write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   }
#   if (num==0)
#   {
#     lapply('-', write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   }
#   
#   lapply("Citations (Microsoft): ", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   if (num>0)
#   {
#     lapply(t(citations_micro), write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   }
#   if (num==0)
#   {
#     lapply('-', write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#   }
  
 
#  lapply("##", write, "/home/max/dev/academic-search/src/code/output.txt", append=TRUE)
#}
close(out_file)