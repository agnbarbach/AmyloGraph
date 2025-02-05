#' @importFrom shiny NS
#' @importFrom shinyjs hidden
ui_interactions_table <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(ns("select_all"), "Select all"),
    actionButton(ns("deselect_all"), "Deselect all"),
    hidden(downloadButton(ns("download_csv"))),
    hidden(downloadButton(ns("download_xlsx"))),
    elem_interactions_table(ns("table"))
  )
}

#' @importFrom shiny moduleServer NS
#' @importFrom dplyr `%>%` select slice
#' @importFrom readr write_csv
#' @importFrom writexl write_xlsx
#' @importFrom shinyjs toggleState
#' @importFrom DT dataTableProxy
server_interactions_table <- function(id, edges, rvals) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    interactions_table <- reactive_interactions_table(edges, ns)
    
    output[["table"]] <- render_interactions_table(interactions_table, ns, session, rvals)
    
    table_proxy <- dataTableProxy("table")
    
    any_row_selected <- reactive({!is.null(input[["table_rows_selected"]])})
    
    observe_download_button(ns, any_row_selected)
    observe_deselect_button(ns, "deselect_all", any_row_selected)
    observe_deselecting_all(input, "deselect_all", table_proxy)
    observe_selecting_all(input, "select_all", table_proxy, interactions_table)
    
    output[["download_csv"]] <- download_handler(input, edges, write_csv, "csv")
    output[["download_xlsx"]] <- download_handler(input, edges, write_xslx, "xlsx")

    # must be executed after assignment to the corresponding output
    outputOptions(output, "download_csv", suspendWhenHidden = FALSE)
    outputOptions(output, "download_xlsx", suspendWhenHidden = FALSE)
    
    table_proxy
  })
}