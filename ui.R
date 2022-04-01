
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

shinyUI(fluidPage(
    title = "Word2Vec",
    titlePanel("Word2Vec", title = div(img(src="logo.png",align='right'),"Word2Vec")),

    sidebarLayout(
        sidebarPanel(fileInput("file", "Upload data"),
                     uiOutput('id_var'),
                     uiOutput("doc_var"),
                     textInput('word_inp','Enter terms separated by commas'),
                     textInput('doc_inp','Enter documentIDs separated by commas'),
                     checkboxInput('model_dm','Check if PV-DM algorithm'),
                     sliderInput('n0','Slide for similarity dataset size',1,50,10),
                     sliderInput('k','Slide for cluster size',2,15,4),
                     sliderInput('d','Slide for Word2Vec dimensions',10,300,100)
                     ),

        mainPanel(
            tabsetPanel(type = "tabs",
            tabPanel("Overview",
                h3("Word2Vectors"),
                p('The word2vec algorithm uses a neural network model to learn word',br(), 
                'associations from a large corpus of text. Once trained, such a model can ', br(),
                  'detect synonymous words or suggest additional words for a partial sentence.'),
                p('As the name implies, word2vec represents each distinct word', br(),
                'with a particular list of numbers called a vector. The vectors', br(),
                ' are chosen carefully such that a simple mathematical function (the cosine similarity between the vectors)', br(),
                'indicates the level of semantic similarity between the words represented by those vectors.')
            ),
            tabPanel("Data Overview",
                     DT::dataTableOutput('summary')
                     ),
            tabPanel("Word2Word",
                     DT::dataTableOutput("word2word")
                     ),
            tabPanel("Word2Doc",
                     DT::dataTableOutput("word2doc")
                     ),
            tabPanel("Doc2Doc",
                     DT::dataTableOutput("doc2doc")
                     ),
            tabPanel("Clustering",
                    DT::dataTableOutput("distPlot"))
            )
    )
)
))
