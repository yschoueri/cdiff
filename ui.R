library('shiny')

shinyUI(navbarPage(
  title = 'Mortality Following Surgery for Fulminant Clostridium difficile colitis',
  windowTitle = 'Mortality Following Surgery for Fulminant Clostridium difficile colitis',
  theme = 'flatly.css',

  tabPanel(title = 'Home',

           # fluidRow(
           #
           #   column(width = 4, offset = 1,
           #          sidebarPanel(width = 12,
           #                       h4('Please answer the following questions:'),
           #                       uiOutput('prediction_controls')
           #          )
           #   ),
           #
           #   column(width = 3,
           #          sidebarPanel(width = 12,
           #                       numericInput('pred_at',
           #                                    label = 'Prediction time point:',
           #                                    min = 0, value = 365),
           #                       actionButton(inputId = 'calc_pred_button',
           #                                    label = 'Predict Survival Probability',
           #                                    icon = icon('wrench'), class = 'btn-primary')
           #          )
           #   ),
           #
           #   column(width = 3,
           #          mainPanel(width = 12,
           #                    tabsetPanel(
           #                      tabPanel('Predicted Overall Survival Probability',
           #                               h2(textOutput('print_pred')))
           #                    )))
           #
           # ),


           fluidPage(
             # titlePanel("Please answer the following questions:"),
             fluidRow(
               column(width = 4,
                      wellPanel(
                        h4("Please answer the following questions:"),
                        numericInput("numage", label = h4("Age [19-90]"), value = 19, min = 19, max = 90, step = 0.5),
                        numericInput("prcreat", label = h4("Creatinine [0.18-14]"), value = 0.18, min = 0.18, max = 14, step = 0.01),
                        radioButtons("preopventilat", label = h4("Preoperative Intubation"),
                                     choices = list("Not Ventilated" = "Not Ventilated", "Ventilated" = "Ventilated"),
                                     selected = "Not Ventilated"),
                        radioButtons("preopsepsis", label = h4("Preoperative Septic Shock"),
                                     choices = list("No Shock" = "No Shock", "Shock" = "Shock"),
                                     selected = "No Shock"),
                        radioButtons("fsteroid", label = h4("Preoperative Immunosuppression"),
                                     choices = list("Non-immunosuppressed" = "Non-immunosuppressed",
                                                    "Immunosuppressed" = "Immunosuppressed"),
                                     selected = "Non-immunosuppressed"),
                        radioButtons("prwbcf", label = h4("WBC Count"),
                                     choices = list("[0.1,4]" = "[0.1,4]", "(4,20]" = "(4,20]", "(20,50]" = "(20,50]", "(50,124.3]" = "(50,124.3]"),
                                     selected = "[0.1,4]"),
                        radioButtons("prplatef", label = h4("Platelet Count"),
                                     choices = list("[17,150]" = "[17,150]", "(150,996]" = "(150,996]"),
                                     selected = "[17,150]")
                      )
               ),

               column(width = 8,
                      mainPanel(width = 12,
                                tabsetPanel(
                                  tabPanel('Predicted Overall Mortality Probability',
                                  h2(textOutput('prob1')),
                                  h2(textOutput('CI')))

                                ),
                                plotOutput('plot'),
                                br(),
                                helpText("The solid blue line represents probabilities for different ages while holding all other variables at their inputted value. ",
                                         "The dashed grey lines represent the 95% confidence intervals. ",
                                         "The red dot represents the inputted age.")
                      )
               )
             )
           )




  ),

  tabPanel(title = 'About',

           fluidRow(
             column(width = 10, offset = 1,
                    includeMarkdown('about.md')
                    # tableOutput("table")
             )))

))
