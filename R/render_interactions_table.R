#' @importFrom glue glue
download_button_callback <- function(ns, session, button_id, button_label)
  glue(
    "var i = document.createElement('i');",
    "$(i).addClass('fa fa-download');",
    
    "var span = document.createElement('span');",
    # TODO: keep space or use CSS properly?
    "$(span).text(' {button_label}');",
    
    "var a = document.createElement('a');",
    "$(a).addClass('dt-button ag-download-button');",
    "a.id = '{ns(button_id)}' + '_real';",
    "a.href = 'session/{session$token}/download/{ns(button_id)}?w=';",
    "a.download = '';",
    "$(a).attr({{",
    "  target: '_blank',",
    "  tabindex: 0",
    "}});",
    
    "$(a).append(i, span);",
    "$('#{ns('table')} .ag-buttons').append(a);"
  )

#' @importFrom DT renderDataTable JS
render_interactions_table <- function(interactions_table, ns, session, rvals)
  renderDataTable(
    interactions_table(),
    options = list(
      dom = 'B<"ag-buttons">frtip',
      scrollY = "calc(100vh - 330px - var(--correction))",
      scrollX = TRUE,
      scrollCollapse = TRUE,
      # it's either index or header class, and we don't use header classes
      columnDefs = list(list(visible = FALSE, targets = -1))
    ),
    escape = FALSE,
    filter = "top",
    rownames = FALSE,
    colnames = ag_colnames(interactions_table()),
    server = FALSE,
    selection = if (ic(rvals[["table_visited"]])) list(mode = "multiple", selected = rvals[["initially_selected"]], target = "row") else "multiple",
    callback = JS(
      download_button_callback(ns, session, "download_csv", "Download selected as CSV"),
      download_button_callback(ns, session, "download_xlsx", "Download selected as Excel")
    )
  )