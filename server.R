library(shiny)
library(datasets)



shinyServer(function(input, output) {
  
  # Compute the formula text in a reactive expression 
  formulaText <- reactive({
    if(length(input$variable) !=0 ) c("mpg ~ ", paste0(input$variable, collapse = " + "))
  })
  
  sigLevel <- reactive({
    switch(
      input$var,
      "1%" = 0.01,
      "5%" = 0.05,
      "10%"= 0.1
    )
  })

  output$sig <- reactive({
    sigLevel()
  })
  
  
  # Compute the boolean expression in a reactive expression since it is
  # shared by the output$prepvalueVar, output$pvalueVar, output$prepvalueValue, and output$pvalueValue functions
  largerThanSig <- reactive({
    if(length(input$variable) !=0 ) max(summary(lm(formulaText(), data = mtcars))$coeff[-1,4]) > sigLevel()
  })
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  output$summary <- renderTable({
    if(length(input$variable) !=0 ) summary(lm(formulaText(), data = mtcars))
    })
  

  output$prepvalueVar <- renderText({
    ifelse(largerThanSig() == T, 
           "Variable with highest p-value is : ", 
           "")
  })
  
  output$pvalueVar <- renderText({
    if(length(input$variable) !=0 ) 
      ifelse(largerThanSig() == T, 
           names(which.max(summary(lm(formulaText(), data = mtcars))$coeff[-1,4])), 
           paste("All remaining exploratory variables have p-value smaller than",sigLevel(), ", in other words, all variables left in the model are significant."))
  })
  
  output$prepvalueValue <- renderText({
    ifelse(largerThanSig() == T, 
           "with p-value : ", 
           "")    
  })
  
  output$pvalueValue <- renderText({
    if(length(input$variable) !=0 ) 
      ifelse(largerThanSig() == T, 
           max(summary(lm(formulaText(), data = mtcars))$coeff[-1,4]), 
           "")
  })
  
  output$adj.r.squared <- renderText({
    if(length(input$variable) !=0 ) paste("adjusted R^2 =", round(summary(lm(formulaText(), data = mtcars))$adj.r.squared, 3))
  })
})