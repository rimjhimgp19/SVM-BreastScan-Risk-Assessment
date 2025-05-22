# SVM-BreastScan-Risk-Assessment
## Overview
The **SVM Breast Cancer Risk Assessment** application is an interactive web app built using R and Shiny, designed to predict the diagnosis of breast tumors based on key features from the Wisconsin Breast Cancer dataset. The application utilizes a Support Vector Machine (SVM) classification model to classify tumors as **Benign** or **Malignant**. Early detection is critical for effective treatment, and this app serves as a valuable tool for awareness and education.
## Features
- **User Input for Prediction**: Users can input several tumor characteristics:
  - Radius Mean
  - Texture Mean
  - Perimeter Mean
  - Area Mean
  - Smoothness Mean
  - Compactness Mean
  - Concavity Mean
  - Concave Points Mean
  - Symmetry Mean
  - Fractal Dimension Mean
- **Prediction Result**: The app provides real-time predictions based on user input, indicating whether the tumor is benign or malignant.
- **ROC Curve Visualization**: Displays the Receiver Operating Characteristic (ROC) curve to evaluate the model's discriminative ability.
- **Confusion Matrix**: Shows the performance of the model by comparing predicted results against actual values in the test dataset.
- **Educational Resources**: The app contains information about breast cancer, types of tumors, and the importance of early detection.
## Technologies Used
This project utilizes the following technologies and packages:
- **R**: A programming language for statistical computing and graphics.
- **Shiny**: A web application framework for R, enabling interactive web applications.
- **shinydashboard**: A package to create dashboards using Shiny.
- **caret**: A package that streamlines the process of creating predictive models.
- **ggplot2**: A data visualization package for R to create static plots.
- **DT**: A package for rendering interactive data tables.
- **pROC**: A package for ROC curve analysis.
- **e1071**: A package that includes functions for SVM classification.
## Installation Instructions
To run the app locally, follow these steps:
1. **Install R**: Ensure that R and RStudio are installed on your machine. Download from [CRAN](https://cran.r-project.org/) if needed.
2. **Install Required Packages**: Open R or RStudio and run the following command to install the necessary packages:
   install.packages(c("shiny", "shinydashboard", "ggplot2", "DT", "pROC", "e1071", "caret"))
Clone the Repository: Clone or download this repository to your local machine:
git clone https://github.com/rimjhimgp19/SVM-BreastScan-Risk-Assessment.git
Open the Project in RStudio: Navigate to the project directory and open the R script file.
Run the Application: Execute the following command to start the Shiny app:
shiny::runApp("path/to/your/app")
# Usage Instructions
1. Launch the application in RStudio.
2. Navigate to the Dashboard tab.
3. Enter the required tumor feature values in the input fields.
4. Click the Predict button to get the diagnosis prediction.
5. Review the Prediction Result, ROC Curve, and Confusion Matrix for insights into the prediction accuracy.
# About Breast Cancer
Breast cancer is one of the most prevalent cancers among women worldwide. The app provides educational resources on:
## Types of Tumors
- **Benign Tumors**: Non-cancerous growths that do not invade nearby tissues.
- **Malignant Tumors**: Cancerous growths that can invade surrounding tissues and metastasize.
## Importance of Early Detection
Early detection significantly increases the chances of successful treatment. Regular screenings and consultations with healthcare professionals are crucial for at-risk individuals.
## Contributions
Contributions to this project are welcome! If you'd like to suggest improvements or report issues, please fork the repository and create a pull request.
## License
This project is licensed under the MIT License. See the LICENSE file for more details.
## Contact
For inquiries or feedback, please reach out to:
Rimjhim Gupta: rimjhimgp19@gmail.com
