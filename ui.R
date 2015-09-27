library(shiny)
# Define UI 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Model Selection - Backward Elimination", windowTitle = "Model Selection - Backward Elimination"),
  
  # Sidebar with controls to select the variable to plot against
  sidebarLayout(position = "left",
    sidebarPanel(
      helpText("Note: Choose significant level",
               "and eliminate one variable each step",
               "until all remaining variables are significant."),
      selectInput(inputId = "var", 
                  label = "Choose significance level",
                  choices = c("1%", "5%", "10%"),
                  selected = "5%"),
      
      helpText("Note: Un-check the variables with highest p-value",
               "until all the remaining variables(except intercept) have p-value smaller than significant level"),
      checkboxGroupInput(inputId = "variable", label = "Variable:",
                         choices = c("cyl : Cylinders" = "cyl", "disp : Displacement(cu.in.)" = "disp", "hp : Gross horsepower" = "hp",
                                     "drat : Rear axle ratio" = "drat", "wt : Weight(lb/1000)"  = "wt", "qsec : 1/4 mile time" = "qsec",
                                     "vs : V/S" = "vs", "am : Transmission" = "am", "gear : Gears" = "gear", "carb : Number of carburetors" = "carb"), 
                         selected = c("cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb")),
      strong("MADE BY ADROIT KIM", style = "color:black")
      

    ),
    

    mainPanel(
      
      h4("Backwards elimination: p-value with ",span(textOutput("sig", inline = T), style = "color:purple"), "significant level cutoff"),
      
      h5("Start with full model, and eliminate a variable with highest p-value at each steps until 
         all remaining variables have p-value lower than chosen significant level"),
      
      strong("Current Model: ", textOutput("caption")),
      
      p(tableOutput("summary")),
    
      strong(textOutput("prepvalueVar")),
      strong(textOutput("pvalueVar"), style = "color:red"),
      strong(textOutput("prepvalueValue")),
      strong(textOutput("pvalueValue"), style = "color:red"),
      br(),
      strong(textOutput("adj.r.squared"), style = "color:blue")

    )
  )
))