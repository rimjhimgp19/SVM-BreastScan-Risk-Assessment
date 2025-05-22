# Load necessary libraries
library(tidyverse)
library(caret)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(pROC)
library(e1071)  # For SVM

# Load the dataset
data <- read.csv("breast-cancer-wisconsin-data.csv")

# Remove the `id` column and convert `diagnosis` to a factor
data <- data %>% select(-id)

# Keep only relevant features for prediction
data <- data %>% select(diagnosis, radius_mean, texture_mean, perimeter_mean, area_mean, 
                        smoothness_mean, compactness_mean, concavity_mean, 
                        concave.points_mean, symmetry_mean, fractal_dimension_mean)

# Convert `diagnosis` to a factor
data$diagnosis <- factor(data$diagnosis, levels = c("B", "M"), labels = c("Benign", "Malignant"))

# Check for any missing values
if (sum(is.na(data)) > 0) {
  stop("Data contains missing values.")
}

# Split the data into training and testing sets (70% training, 30% testing)
set.seed(123)
index <- createDataPartition(data$diagnosis, p = 0.7, list = FALSE)
train_data <- data[index, ]
test_data <- data[-index, ]

# Train the SVM model with RBF kernel and enable probability estimates
svm_model <- svm(diagnosis ~ ., data = train_data, kernel = "radial", cost = 1, gamma = 0.1, probability = TRUE)

# Define UI for the application with pastel theme
ui <- dashboardPage(
  dashboardHeader(title = "Breast Cancer Detection", titleWidth = 250),
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("chart-line")),
      menuItem("About", tabName = "about", icon = icon("info-circle")),
      menuItem("Help", tabName = "help", icon = icon("question-circle"))
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
      body {background-color: #FAFAFA;}
      .skin-blue .main-header .logo {background-color: #A8DADC;}
      .skin-blue .main-header .navbar {background-color: #457B9D;}
      .box {background-color: #F1FAEE; border-top: 3px solid #A8DADC; border-radius: 10px;}
      .box-header {background-color: #457B9D; color: white; border-top-left-radius: 10px; border-top-right-radius: 10px;}
      .box-title {font-size: 18px; font-weight: bold;}
    '))),
    
    tabItems(
      # Dashboard tab
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "Input Features", width = 6, solidHeader = TRUE, 
                    numericInput("radius_mean", label = tagList(icon("circle"), "Radius Mean"), value = 15, min = 5, max = 30, step = 0.1),
                    numericInput("texture_mean", label = tagList(icon("texture"), "Texture Mean"), value = 20, min = 5, max = 40, step = 0.1),
                    numericInput("perimeter_mean", label = tagList(icon("ruler"), "Perimeter Mean"), value = 100, min = 30, max = 200, step = 1),
                    numericInput("area_mean", label = tagList(icon("square"), "Area Mean"), value = 700, min = 100, max = 2500, step = 1),
                    numericInput("smoothness_mean", label = tagList(icon("smooth"), "Smoothness Mean"), value = 0.1, min = 0.05, max = 0.2, step = 0.01),
                    numericInput("compactness_mean", label = tagList(icon("compass"), "Compactness Mean"), value = 0.2, min = 0.1, max = 0.4, step = 0.01),
                    numericInput("concavity_mean", label = tagList(icon("concave-up"), "Concavity Mean"), value = 0.2, min = 0.1, max = 0.4, step = 0.01),
                    numericInput("concave.points_mean", label = tagList(icon("dot-circle"), "Concave Points Mean"), value = 0.1, min = 0.05, max = 0.2, step = 0.01),
                    numericInput("symmetry_mean", label = tagList(icon("align-left"), "Symmetry Mean"), value = 0.2, min = 0.1, max = 0.3, step = 0.01),
                    numericInput("fractal_dimension_mean", label = tagList(icon("chart-pie"), "Fractal Dimension Mean"), value = 0.07, min = 0.05, max = 0.1, step = 0.01),
                    actionButton("predict_btn", "Predict", style = "color: #FFF; background-color: #457B9D; border: none;"),
                    h4("Prediction Result:", style = "color: #457B9D;"),
                    textOutput("prediction_result", inline = TRUE),
                    textOutput("prediction_status")  # New output for prediction status
                ),
                box(plotOutput("rocPlot"), width = 6),
                box(DTOutput("confMatrix"), width = 6)
              )),
      
      # About tab
      tabItem(tabName = "about",
              h2("About Breast Cancer Detection App", style = "color: #457B9D;"),
              p("Breast cancer is one of the most common cancers in women worldwide. It can be categorized into two main types: Benign and Malignant."),
              
              h3("Understanding Breast Cancers", style = "color: #457B9D;"),
              
              h4("1. Benign Breast Tumors", style = "color: #A8DADC;"),
              p("Benign breast tumors are non-cancerous growths that do not invade nearby tissues or spread to other parts of the body. Common types include cysts and fibroadenomas. While they can cause discomfort and require monitoring, they generally do not pose a significant health risk."),
              img(src = "images/B.png", height = "300px", style = "display: block; margin-left: auto; margin-right: auto;"),
              
              h4("2. Malignant Breast Tumors", style = "color: #A8DADC;"),
              p("Malignant breast tumors are cancerous and can invade nearby tissues and metastasize to other parts of the body through the lymphatic system or bloodstream. Common types of malignant breast cancer include invasive ductal carcinoma and invasive lobular carcinoma. Early detection is crucial as it significantly increases the chances of successful treatment and survival."),
              img(src = "images/M.png", height = "300px", style = "display: block; margin-left: auto; margin-right: auto;"),
              
              h3("Why Early Detection Matters", style = "color: #457B9D;"),
              p("Detecting breast cancer early enables prompt intervention and can prevent the progression of malignant tumors. Machine learning models like the one used in this app help researchers and healthcare providers better understand patterns associated with cancer diagnosis."),
              
              h3("Consulting Healthcare Professionals", style = "color: #457B9D;"),
              p("If you notice any unusual changes in your breast, such as lumps, changes in size or shape, or unusual discharge, consult a healthcare professional immediately. Regular mammograms and clinical breast exams are essential for early detection, especially for those at higher risk."),
              
              h3("Available Solutions", style = "color: #457B9D;"),
              p("There are several treatment options available depending on the type and stage of breast cancer:"),
              tags$ul(
                tags$li("Surgery: Removal of the tumor or affected breast tissue. Surgery may be lumpectomy (removal of the tumor) or mastectomy (removal of one or both breasts)."),
                tags$li("Radiation Therapy: This uses high-energy waves to target and kill cancer cells, often used after surgery to eliminate any remaining cancer cells."),
                tags$li("Chemotherapy: This involves the use of drugs to kill rapidly dividing cancer cells, often used before surgery (neoadjuvant therapy) or after surgery (adjuvant therapy)."),
                tags$li("Hormone Therapy: Used for cancers that are hormone receptor-positive, this therapy blocks hormones like estrogen that fuel cancer growth."),
                tags$li("Targeted Therapy: This uses drugs to target specific characteristics of cancer cells, such as mutations or proteins, minimizing damage to healthy cells.")
              )
      ),
      
      # Help tab
      tabItem(tabName = "help",
              h2("Help & Instructions", style = "color: #457B9D;"),
              p("Welcome to the Breast Cancer Detection App! Follow these steps to navigate and use the features available:"),
              
              h3("Getting Started", style = "color: #A8DADC;"),
              tags$ul(
                tags$li("Enter the necessary features for prediction in the input fields on the Dashboard."),
                tags$li("Click the 'Predict' button to receive a diagnosis prediction."),
                tags$li("Check the 'Prediction Result' and 'Confusion Matrix' for more insights.")
              ),
              h4("Understanding Results:", style = "color: #A8DADC;"),
              p("The prediction result will indicate whether the tumor is benign or malignant based on the input features. The confusion matrix provides a summary of the prediction accuracy."),
              img(src = "images/ribbon.png", height = "400px", style = "display: block; margin-left: auto; margin-right: auto;")
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Render prediction
  output$prediction_result <- renderText({
    req(input$predict_btn)  # Wait for the Predict button to be clicked
    
    # Gather input values into a data frame
    new_data <- data.frame(
      radius_mean = input$radius_mean,
      texture_mean = input$texture_mean,
      perimeter_mean = input$perimeter_mean,
      area_mean = input$area_mean,
      smoothness_mean = input$smoothness_mean,
      compactness_mean = input$compactness_mean,
      concavity_mean = input$concavity_mean,
      concave.points_mean = input$concave.points_mean,
      symmetry_mean = input$symmetry_mean,
      fractal_dimension_mean = input$fractal_dimension_mean
    )
    
    # Make prediction
    pred <- predict(svm_model, new_data)
    paste("The predicted diagnosis is:", pred)
  })
  
  # Render ROC plot
  output$rocPlot <- renderPlot({
    # Get probability predictions for the test data
    prob <- attr(predict(svm_model, test_data, probability = TRUE), "probabilities")[, "Malignant"]
    
    # Calculate the ROC curve
    roc_curve <- roc(test_data$diagnosis, prob, levels = c("Benign", "Malignant"))
    
    # Plot ROC curve
    plot(roc_curve, main = "ROC Curve", col = "blue", lwd = 2)
  })
  
  # Render confusion matrix
  output$confMatrix <- renderDT({
    # Make predictions on the test set
    predictions <- predict(svm_model, test_data)
    
    # Confusion matrix
    confusionMatrix(predictions, test_data$diagnosis)$table
  })
}

# Run the application
shinyApp(ui = ui, server = server)
