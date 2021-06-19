# File-Name: GScholarScraper_3.1.R
# Date: 2012-08-22
# Author: Kay Cichini
# Email: kay.cichini@gmail.com
# Purpose: Scrape Google Scholar search result
# Packages used: XML
# Licence: CC BY-SA-NC
#
# Arguments:
# (1) input:
# A search string as used in Google Scholar search dialog
#
# (2) write:
# Logical, should a table be writen to user default directory?
# if TRUE ("T") a CSV-file with hyperlinks to the publications will be created.
#
# Difference to version 3:
# (3) added "since" argument - define year since when publications should be returned..
# defaults to 1900..
#
# (4) added "citation" argument - logical, if "0" citations are included
# defaults to "1" and no citations will be included..
# added field "YEAR" to output
#
# Caveat: if a submitted search string gives more than 1000 hits there seem
# to be some problems (I guess I'm being stopped by Google for roboting the site..)
#
# And, there is an issue with this error message:
# > Error in htmlParse(URL):
# > error in creating parser for http://scholar.google.com/scholar?q
# I haven't figured out his one yet.. most likely also a Google blocking mechanism..
# Reconnecting / new IP-address helps..

Micro_Scraper <- function(input, since = 1900, write = F, citation = 1) {
  
  require(XML)
  
  # putting together the search-URL:
  #URL <- paste("http://scholar.google.com/scholar?q=", input, "&hl=en&as_sdt=1,5&as_vis=",
  #             citation, "&as_ylo=", since, sep = "")
  #cat("\nThe URL used is: ", "\n----\n", paste("* ", "http://scholar.google.com/scholar?q=", input, "&as_sdt=1,5&hl=en&as_vis=",
  #                                             citation, "&as_ylo=", since, " *", sep = ""))
  
  URL <- paste("http://academic.research.microsoft.com/Search?query=author:(", input, ")&start=1&end=100", sep = "")
  #cat("\nThe URL used is: ", "\n----\n", paste("* ", "http://academic.research.microsoft.com/Search?query=author:(", input, ")&start=1&end=100"
  #                                             , sep = ""))
  
  # get content and parse it:
  doc <- htmlParse(URL)
  #print(doc)
  
  # number of articles and books:
  #help <- xpathSApply(doc, "//div[@class = 'container']", xmlValue)
  h1 <- xpathSApply(doc, "//span[@class = 'item-count']", xmlValue)
  len=nchar(h1)
  
  h1=substring(h1,2,len-1)
  #print(h1)
  
  if (length(len)==0)
  {
    h1=0;
  }
  
  
#   h3 <-h1
#   
#   if (charmatch("About ",h1, nomatch=0)==0)
#   {
#     h3 <- paste("About",h1)
#   }
#   
#   ##print(h3)
#   h2 <- strsplit(h3, " ")[[1]][2]
  ##print(h2)
  num <- as.integer(h1)
  cat("\n\nNumber of articles and books: ", num, "\n----\n", "If this number is far from the returned results\nsomething might have gone wrong..\n\n", sep = "")
  
  # If there are no results, stop:
  if (num == 0 | is.na(num)) {
    num = 0
    return(0)
    #stop("\n\n...There is no result for the submitted search string!")
  }
  
  
  #two_el <- c(ceiling(num/20),2)
  pages.max <- min(ceiling(num/100),1)
  #print(num)
  
  # 'start' as used in URL:
  start <- 100 * 1:pages.max - 99
  
  # Collect URLs as list:
  #URLs <- paste("http://scholar.google.com/scholar?start=", start, "&q=author:", input,
  #              "&num=20&hl=en&as_sdt=1,5&as_vis=", citation, "&as_ylo=", since, sep = "")
  URLs <- paste("http://academic.research.microsoft.com/Search?query=author:(", input,
                ")&start=", start, "&end=", start+100, sep = "")
  ##print("URLS")
  ##print(URLs)
  
  micro_scraper_internal <- function(doc) {
    
    #doc <- htmlParse(x, encoding="UTF-8")
    
    # titles:
#     tit <- xpathSApply(doc, "//h3[@class='gs_rt']", xmlValue)
    
    # publication:
    pub <- xpathSApply(doc, "//span[@class=\"year\"]", xmlValue)
    num_str <- as.integer(length(pub))
    
    i <- 1
    while (i <=num_str)
    {
      ##print(cit[[i]])
      len=nchar(pub[i])
      pub[i]=substring(pub[i],len-3,len)
      #j <- j+1
      
      i <- i+1
    }
    pub=as.integer(pub)
    
    #     cit_new <- gsub('Citations ','',cit_new)
    #     cit_new <-strtoi(cit_new)
    #cit_new <- -sort(-cit_new)
    
    pub <- unlist(pub)
    #print(pub)   
    #pub <- xpathSApply(doc, "//div[@class='gs_a']", xmlValue)
    
    # links:
#     lin <- xpathSApply(doc, "//h3[@class='gs_rt']/a", xmlAttrs)
    
    #citations
#     cit <- xpathSApply(doc, "//div[@class='gs_fl']/a", xmlValue)
    ##print(cit)
    #cit_arr <- strsplit(cit,'Citations')
#     num_str <- length(cit)
#     j <- 0
#     i <- 1
#     while (i <=num_str-j)
#     {
#       ##print(cit[[i]])
#       if (charmatch("Citations",cit[i], nomatch=0)==0)
#       {
#         cit[i] <-'0'
#         #j <- j+1
#       }
#       i <- i+1
#     }
#     cit <- gsub('Citations ','',cit)
#     cit <-strtoi(cit)
#     cit <- -sort(-cit)
#     
#     cit <- unlist(cit)
    ##print(cit)   
    ##print(length(cit))
    ##print(cit_arr[3])
    
    # summaries are truncated, and thus wont be used..
    # abst <- xpathSApply(doc, '//div[@class='gs_rs']', xmlValue)
    # ..to be extended for individual needs
    options(warn=(-1))
    #dat <- data.frame(TITLES = tit, PUBLICATION = pub,
    #YEAR = as.integer(gsub(".*\\s(\\d{4})\\s.*", "\\1", pub)),
    #LINKS = lin)
    #dat <- data.frame(YEAR = as.integer(gsub(".*\\s(\\d{4})\\s.*", "\\1", pub)))
    #dat <- as.integer(gsub(".*\\s(\\d{4})\\s.*", "\\1", pub))
    
    options(warn=0)
    return(pub)
  }
  micro_scraper_internal_cit <- function(doc) {
    
    
    #doc <- htmlParse(x, encoding="UTF-8")
    
    #citations
    cit_new <- xpathSApply(doc, "//span[@class='citation']/a", xmlValue)
    #print(cit_new)
    
    
    #cit_arr <- strsplit(cit,'Citations')
    num_str <- as.integer(length(cit_new))
    
    i <- 1
    while (i <=num_str)
    {
      ##print(cit[[i]])
        len=nchar(cit_new[i])
        cit_new[i]=substring(cit_new[i],12,len)
        #j <- j+1
      
      i <- i+1
    }
    cit_new=as.integer(cit_new)
    
#     cit_new <- gsub('Citations ','',cit_new)
#     cit_new <-strtoi(cit_new)
    cit_new <- -sort(-cit_new)
    
    cit_new <- unlist(cit_new)
    #print(cit_new)   
    ##print(length(cit))
    ##print(cit_arr[3])
    
    # summaries are truncated, and thus wont be used..
    # abst <- xpathSApply(doc, '//div[@class='gs_rs']', xmlValue)
    # ..to be extended for individual needs
    options(warn=(-1))
    #dat <- data.frame(TITLES = tit, PUBLICATION = pub,
    #YEAR = as.integer(gsub(".*\\s(\\d{4})\\s.*", "\\1", pub)),
    #LINKS = lin)
    
    
    options(warn=0)
    return(cit_new)
  }
  
  
  #result <- do.call("rbind", lapply(URLs, scraper_internal))
  
  #result contatins years of publications whereas result_cit contains numbers of citations for all
  #articles
  
  #result <- unlist(lapply(doc, micro_scraper_internal))
  result <- micro_scraper_internal(doc)
  #print("result")
  #print(result)
  #result_cit <- cbind(lapply(URLs, scraper_internal_cit))
  
  #a=lapply(doc, micro_scraper_internal_cit)
  a=micro_scraper_internal_cit(doc)
  b=unlist(a)
  ##print(b)
  #result_cit <- b
  result_cit <- -sort(-b)
  #print("result_cit")
  #print(result_cit)
  
  #Defining hirsh index and years in science
  ##print(result_cit)
  current_year <- 2013
  
  result <- ifelse(is.na(result),current_year,result)
  result <- ifelse(result<1900,current_year,result)
  
  #result_cit <- ifelse(is.na(result_cit),0,result_cit)
  result_cit=result_cit[!is.na(result_cit)]
  result_cit <- ifelse(is.na(result_cit),0,result_cit)
  #print("result")
  #print(result)
  
  years_science=current_year-min(result)
  
#   h_index <-0
#   while (h_index<length(result_cit))
#   {
#     if (result_cit[h_index+1]>h_index)
#     {
#       h_index <- h_index+1
#     }
#     else
#     {
#       break
#     }
#   }
  
  #print(h_index)
  
  # if (write == T) {
  #    result$LINKS <- paste("=Hyperlink(","\"", result$LINKS, "\"", ")", sep = "")
  #    write.table(result, "GScholar_Output.CSV", sep = ";",
  #                row.names = F, quote = F)
  #source("GScholar_Output.CSV")
  #  } else {
  #    return(result)
  #  }(
  # #print("lfkdkflk")
  ret_value=c(num,2013-min(result),result_cit)
  #ret_value=t(ret_value)
  #ret_value=list(c(num),c(result),c(result_cit))
  return(ret_value)
}

# EXAMPLES:
# 1:
#input <- "intitle:metapopulation"
#df <- GScholar_Scraper(input, since = 2010, citation = 1)
#nrow(df)
#hist(df$YEAR, xlab = "Year",
#     main = "Frequency of Publications with\n\"METAPOPULATION\" in Title")
# 2:
#input <- "allintitle:live on mars"
#GScholar_Scraper(input, since = 2010, citation = 0)
# 3:
#input <- "allintitle:ziggy stardust"
#GScholar_Scraper(input, write = T)
# 4: ERROR with message:
#input <- "allintitle:crazyshit"
#GScholar_Scraper(input)
# 5: CAVEAT, Google blocks automated requests at about the 1000th hit:
#input <- "metapopulation"
#df <- GScholar_Scraper(input, since = 2010)
#nrow(df)

# 6: this also leads to this error for example no. 1,
# because when including citations (.., citation = 0) 1000 hits are exceeded,
# Google blocks and dataframe generation is not working..
#input <- "intitle:metapopulation"
#df <- GScholar_Scraper(input, since = 2010, citation = 0)