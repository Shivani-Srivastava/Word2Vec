library(doc2vec)
library(udpipe)
library(stringr)


#ui_data_file = readLines('https://raw.githubusercontent.com/sudhir-voleti/sample-data-sets/master/text%20analysis%20data/amazon%20nokia%20lumia%20reviews.txt')

# remove html junk 
#ui_data_file  =  str_replace_all(ui_data_file, "<.*?>", "") 
# str(ui_data_file)

# UI entry
#word_inp = c("good", "product")  # defaults. user can input a long list here
#doc_inp = c("doc_1", "doc_10")  # defaults

# UI defaults
#n0 = 10  # num of similarity results to show, from slider
#k = 4    # num of doc clusters, slider
#d = 100  # dimensionality of word2vec obj, slider
#model_dm = FALSE  # checkbox not checked


VectorFunction <- function(ui_data_file, word_inp, doc_inp, n0, k, d, model_dm = FALSE){

  output_store_list = vector(mode="list", length=5)
  
  word_inp = unlist(strsplit(word_inp,","))
  doc_inp = unlist(strsplit(doc_inp,","))
  #ui_data_file  =  str_replace_all(ui_data_file, "<.*?>", "") 
  
  #x0 <- data.frame(doc_id = sprintf("doc_%s", 1:length(ui_data_file)), 
   #             text   = ui_data_file, 
    #            stringsAsFactors = FALSE)

# basic cleaning ops
  #x$text   <- tolower(x$text)
  #x$text   <- gsub("[^[:alpha:]]", " ", x$text)
  #x$text   <- gsub("[[:space:]]+", " ", x$text)
  #x$text   <- trimws(x$text) # Remove leading and/or trailing whitespace

  #x$nwords <- txt_count(x$text, pattern = " ") # wordcounter with //s separator
  #x        <- subset(x, nwords < 1000 & nchar(text) > 0)


# below comes from UI checkbox
  if (model_dm == TRUE){ type0 = "PV-DM"} else {type0 = "PV-DBOW"}

# model trained on inp data
  model <- paragraph2vec(x = ui_data_file, type = type0, 
                       dim = d, iter = 20, # dim d=100 from UI default
                       min_count = 5, lr = 0.05, 
                       threads = 1) # 2.8s  # set threads=1 in zerocode if reqd

  word2word_outp = predict(model, 
                         newdata = word_inp, # c("battery", "camera")
                         type = "nearest", 
                         which = "word2word", 
                         top_n = n0)

#output_store_list[[1]] = word2word_outp  # show as html table in 'word2word' tab


  word2doc_outp = predict(model, 
                        newdata = word_inp, 
                        type = "nearest", which = "word2doc",  
                        top_n = n0)

#output_store_list[[2]] = word2doc_outp # show in 'word2doc' tab as html tbl


  doc2doc_outp = predict(model, 
                       newdata = doc_inp, 
                       type = "nearest", which = "doc2doc",
                       top_n = n0)

#output_store_list[[3]] = doc2doc_outp # show in 'doc2doc' tab


## use embedding matrix to calc kmeans clusters
  embedding_docs <- as.matrix(model, which = "docs")

  a0 = kmeans(embedding_docs, k) # 0s. k=4 from UI

  a0$size  # size distribution of clusters

  clus_outp = data.frame(doc_id = 1:length(a0$cluster), 
                       cluster = a0$cluster) # downloadable tbl
#output_store_list[[4]] = clus_outp

  
  word2word_outp = as.data.frame(word2word_outp) %>% mutate_if(is.numeric, round, digits = 3)
  word2doc_outp = as.data.frame(word2doc_outp) %>% mutate_if(is.numeric, round, digits = 3)
  doc2doc_outp = as.data.frame(doc2doc_outp) %>% mutate_if(is.numeric, round, digits = 3)
  
  output_store_list = list(word2word_outp, word2doc_outp, doc2doc_outp, clus_outp)

#head(clus_outp, 10) # for display in the tab
  return(output_store_list) 

}
