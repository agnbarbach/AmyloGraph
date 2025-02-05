#' @importFrom visNetwork renderVisNetwork visNetwork visEdges visOptions visInteraction
#' @importFrom visNetwork visEvents visIgraphLayout visExport visNodes visPhysics
render_network <- function(ag_data_nodes, edges) {
  renderVisNetwork({
    # we don't want to render graph each time we modify edges
    # instead we remove and update them in a separate observer
    visNetwork(ag_data_nodes, isolate(edges[["graph"]]),
               width = 1600, height = 900) %>%
      visEdges(arrows = "to", 
               width = 2,
               color = "#3674AB") %>% 
      visNodes(color = "#F3C677",
               font = list(color = "#0C0A3E")) %>%
      visIgraphLayout(smooth = TRUE, physics = FALSE, randomSeed = 1337) %>%
      visPhysics(maxVelocity = 50, minVelocity = 49, timestep = 0.3) %>%
      visOptions(
        highlightNearest = list(enabled = TRUE, degree = 1,
                                labelOnly = FALSE, hover = TRUE,
                                algorithm = "hierarchical")) %>%
      visInteraction(zoomView = TRUE, navigationButtons = TRUE) %>%
      visEvents(
        selectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('single_protein', 'select_node')>>', nodes.nodes[0]);
                  }", .open = "<<", .close = ">>"),
        deselectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('single_protein', 'select_node')>>', '<<AmyloGraph:::ag_option('str_null')>>');
                  }", .open = "<<", .close = ">>")) %>%
      visExport(type = "png", name = "AmyloGraph", label = "Export as png", float = "left", 
                style = "")
  })
}