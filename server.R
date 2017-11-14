library('shiny')
library('mice')
library(RSkittleBrewer)
library(magrittr)
library(dplyr)
library(markdown)

load('model/pooled-model.Rdata')

shinyServer(function(input, output, session) {

  predicted_prob <- reactive({
    predict_pooled(betas = pooledModel$qbar,
                           covariance = pooledModel$t, preopventilat = input$preopventilat,
                           preopsepsis = input$preopsepsis, fsteroid = input$fsteroid,
                           prwbcf = input$prwbcf, prplatef = input$prplatef, prcreat = input$prcreat, numage = input$numage)


  })


  plot_data <- reactive({

    n_points <- 100
    age_ranges <- seq(19, 91, length.out = n_points)

    res <- do.call(rbind, lapply(age_ranges,
                                 function(i, b, c, v, s, f, w, p, cr) predict_pooled(numage = i, betas = b, covariance = c,
                                                                                     preopventilat = v, preopsepsis = s, fsteroid = f,
                                                                                     prwbcf = w, prplatef = p, prcreat = cr),
                                 b = pooledModel$qbar, c = pooledModel$t,
                                 v = input$preopventilat,
                                 s = input$preopsepsis, f = input$fsteroid,
                                 w = input$prwbcf, p = input$prplatef, cr = input$prcreat))

    res
  })


  # Generate an HTML table view of the data ----
  output$table <- renderTable({
    summary(pooledModel)
  })

  output$print_pred = renderPrint({
    sprintf("Probability of mortality: %.2f,\n 95%% Confidence Interval: [%.2f, %.2f]",
            predicted_prob()[,"prob"],predicted_prob()[,"lower"],predicted_prob()[,"upper"])

    # predicted_prob()
    # predicted_prob[,"prob"]

    # input$preopventilat

  })


  output$prob1 <- renderText({
    paste("Probability of mortality:",round(predicted_prob()[,"prob"],3))
  })

  output$CI <- renderText({
    paste("95% Confidence Interval: [",round(predicted_prob()[,"lower"],3), ", ",round(predicted_prob()[,"upper"],3) ,"]")
  })



  output$plot <- renderPlot({

    trop <- RSkittleBrewer::RSkittleBrewer("trop")

    par(mai=c(0.85,0.9,0.1,0.2))
    # par(oma = c(4, 1, 1, 1))
    plot(plot_data()[,"numage"], plot_data()[,"prob"], lwd = 4, type = "l", ylab = "Probability of Death", xlab = "Age", col = trop[2],
         bty="n", xaxt="n", cex.lab = 1.4, xlim = c(20,100), ylim = range(plot_data()[,c("prob","lower","upper")]))
    axis(1, labels = T, at = seq(20,90,10))
    lines(plot_data()[,"numage"], plot_data()[,"lower"], lty = 2, col = "grey")
    lines(plot_data()[,"numage"], plot_data()[,"upper"], lty = 2, col = "grey")
    points(x = input$numage,y = predicted_prob()[,"prob"],  pch = 19, col = "red", cex = 2)

  })


})
