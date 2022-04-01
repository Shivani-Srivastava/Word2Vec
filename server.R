
###############################################################################
#                                                                             #
#               Word2Vec - Shiny Application for Machine Learning             #
#                               by Shivani Srivastava                         #
#                                                                             #
###############################################################################

library(shiny)
library(doc2vec)
library(udpipe)
library(stringr)
library(data.table)
library(DT)
library(tools)

shinyServer(function(input, output) {

    ui_data_file = readLines('https://raw.githubusercontent.com/sudhir-voleti/sample-data-sets/master/text%20analysis%20data/amazon%20nokia%20lumia%20reviews.txt')
    
    dataset <- reactive({
        if (is.null(input$file)) {return(NULL)}
        else {
            if(file_ext(input$file$datapath)=="txt"){
                text = readLines(input$file$datapath)
                text  =  str_replace_all(text, "<.*?>", "")
                doc_id=seq(1:length(text))
                calib=data.frame(doc_id,text)
                return(calib)
            }
            else{
                text = read.csv(input$file$datapath ,header=TRUE, sep = ",", stringsAsFactors = F,encoding="UTF-8")
                
                text$doc_id = seq(1:nrow(text))
                return(text)
            }
        }
    })
    
    cols <- reactive({colnames(dataset())})
    
    y_col <- reactive({
        x <- match(input$x,cols())
        y_col <- cols()[-x]
        return(y_col)
        
    })
    
    output$id_var <- renderUI({
        print(cols())
        selectInput("doc_id","Select ID Column",choices = cols())
    })
    
    output$doc_var <- renderUI({
        selectInput("ui_data_file","Select Text Column",choices = y_col())
    })
    
    Outputs = reactive({VectorFunction(dataset(), input$word_inp, input$doc_inp, input$n0, input$k, input$d, input$model_dm)})
    
    
    
    output$summary <- renderDataTable(as.data.frame(head(dataset())))
    
    
    output$word2word <- DT::renderDataTable({as.data.frame(Outputs()[1])})  # word2word_outp show as html table in 'word2word' tab
    
    
    output$word2doc <- DT::renderDataTable({as.data.frame(Outputs()[2])}) # show in 'word2doc' tab as html tbl
    
    output$doc2doc <- DT::renderDataTable({as.data.frame(Outputs()[3])}) # show in 'doc2doc' tab
    
    output$distPlot <- DT::renderDataTable({as.data.frame(Outputs()[4])}) # for display in the tab

})
