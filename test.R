library(shiny)
library(ggplot2)
library(dplyr)

data <- readRDS("expr3.rds")

# Sanitize gene names to remove problematic characters
data <- data %>% mutate(gene_id = gsub("[^a-zA-Z0-9_]", "_", gene))

# UI definition
ui <- fluidPage(
  titlePanel("Expression Heatmap"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput(
        "genes",
        "Select Gene(s):",
        choices = NULL,  # Choices populated dynamically
        multiple = TRUE,
        options = list(placeholder = "Search genes", maxOptions = 1000)
      )
    ),
    mainPanel(
      plotOutput("heatmap", height = "auto")
    )
  )
) 
# Server logic
server <- function(input, output, session) {
  # Populate the selectize input for genes dynamically
  observe({
    updateSelectizeInput(
      session,
      "genes",
      choices = unique(data$gene_id),  # Load gene names dynamically
      server = TRUE
    )
  })

  filtered_data <- reactive({
    req(input$genes)
    data %>%

  # Generate heatmap plot
  output$heatmap <- renderPlot({
    req(input$genes)
    plot_data <- filtered_data()

    if (nrow(plot_data) == 0) {
      plot.new()


    } return()o data available for the selected genes")

    ggplot(plot_data, aes(x = subtype2, y = time, fill = log_expr2)) +
      geom_tile(color = "grey") +
      facet_wrap(~ gene_id, scales = "free", ncol = 1) +  # Stacks subplots vertically
      scale_fill_distiller(
        palette = "RdBu",
        direction = -1,
        na.value = "grey50"  # Fallback color for NA values
      ) +
      labs(
        x = "Cell Type",
        y = "Time",
        fill = "Log Expression",
        title = paste("Gene Expression Heatmap for:", paste(input$genes, collapse = ", "))
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, size = 16)hjust = 1),
      )
  }, height = function() {
    max(300, 300 * length(input$genes))

} })

shinyApp(ui = ui, server = server)
