# SNDS Network (Schema) (Tab 3)
output$force_snds = renderForceNetwork({
  ## Color scale 
  ### String needed for the javascript of the force network
  product_names = c("BENEFICIAIRE", "DCIR/DCIRS", "DCIRS", "DCIR", "Causes de décès", "CARTOGRAPHIE_PATHOLOGIES", "PMSI MCO", "PMSI HAD", "PMSI SSR", "PMSI RIM-P")
  product_names_ix  = paste(1:length(product_names), collapse = ',') 
  product_colors_str = '"#CC2920", "#F36C64", "#E88310", "#E85B10", "#3C3C42", "#BB5DD1", "#3E5D96", "#8CD6E8", "#2A9BA5", "#26A589"'
  ### javascript color scale
  ColourScale = paste0('d3.scaleOrdinal()
                       .domain([', product_names_ix, '])
                       .range([', product_colors_str, ']);')
  
  ## d3network
  snds_links$value = 10
  snds_links$group = 1
  net = forceNetwork(
    Links = snds_links, 
    Source = "source", 
    Target = "target",
    Value = "value", # nécessaire pour arrows  https://stackoverflow.com/questions/51024363/forcenetwork-networkd3-arrow-issue
    
    Nodes = snds_nodes,
    NodeID = "name",
    Group = "group",
    Nodesize = "nb_vars",
    
    zoom = TRUE,
    opacityNoHover = 0.7, 
    colourScale = JS(ColourScale), 
    opacity = 1, fontSize = 15,  charge = -70, 
    # linkWidth = 2, # Incompatible avec arrows
    linkDistance = 150,
    arrows = TRUE,
    clickAction = 'Shiny.onInputChange("description", d.description);
    Shiny.onInputChange("name", d.name);
    Shiny.onInputChange("joint", d.joint_var);'
  )
  
  
  ## Ggplot legend, code taken from here: https://stackoverflow.com/questions/12041042/how-to-plot-just-the-legends-in-ggplot2
  ### R array needed for the legend plot
  product_colors = setNames(
    eval(parse(text = paste0('c(', product_colors_str, ')'))),
    product_names
  )
  ### Fake hist from which extracting legend
  my_hist = ggplot() + aes(1:length(product_names), fill = product_names) + 
    geom_bar() + 
    scale_fill_manual(values=product_colors) + 
    theme(legend.background = element_rect(fill = alpha("white", 0.0)))
  ### Legend extracted from the hist
  g_legend = function(a.gplot){ 
    tmp = ggplot_gtable(ggplot_build(a.gplot)) 
    leg = which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
    legend = tmp$grobs[[leg]] 
    return(legend)} 
  output$legend = renderPlot({
    legend = g_legend(my_hist)
    legend$widths[1] = unit(0, units = "null")  
    legend$widths[5] = unit(0, units = "null")
    legend$heights[1] = unit(0, units = "null")
    legend$heights[5] = unit(0, units = "null")
    grid.newpage()
    legend_p = grid.draw(legend) 
  })
  
  
  ## Add additional information to nodes (and links)
  #f$x$links$group = snds_links$group
  net$x$links$joint_var = snds_links$joint_var
  net$x$nodes$description = snds_nodes$description
  
  ## Add nodehover behavior issues with links opacities (conlifict with node.mouseover function)
  net = htmlwidgets::onRender(net,
                              '
                              function(el, x) {
                              d3.selectAll(".link")
                              .style("opacity", 0.5)
                              .append("title")
                              .text(function(d) {return d.joint_var})
                              .on("mouseover", function(d) {
                              d3.select(this).select("text").transition()
                              .duration(100)
                              .attr("x", 13)
                              .style("stroke-width", ".5px")
                              .style("opacity", 1);
                              d3.select(this)
                              .style("opacity", 1);
                              })
                              .on("mouseout", function(d) {
                              d3.select(this)
                              .style("opacity", 0.5);
                              });
                              }
                              '
  )
  return(net)
  })

## Network logic for displaying the SNDS tables when clicking on them
current_table_snds = reactive({
  data.frame(snds_vars %>% 
               filter(table == input$name) %>% 
               select(one_of("var", "description", "format"))
  )
})

### Display name of the table
default_table_name = 'IR_BEN_R'
default_header = paste0(default_table_name, ': ', snds_tables %>% filter(Table == default_table_name) %>% pull(Libelle))
default_table = data.frame(snds_vars %>% 
                             filter(table == default_table_name) %>% 
                             select(one_of("var", "description", "format")))

output$table_name_snds = renderText({
  # logic for default behaviour
  if (is.null(input$name)){
    default_header
  }
  else{
    paste0(input$name , ": ", input$description)[1]  
  }
})

## Display only current table variables
output$my_table_snds = DT::renderDataTable({
  # logic for default behaviour
  if (is.null(input$name)){
    non_null_table = default_table
  }
  else{
    non_null_table = current_table_snds()
  }
  DT::datatable(
    non_null_table,
    rownames = F,
    fillContainer = T,
    options = list(
      lengthMenu = c(10, 20, 30),
      pageLength = 50,
      language = list(
        info = 'Résultats _START_ à _END_ sur une liste de _TOTAL_.',
        paginate = list(previous = 'Précédent', `next` = 'Suivant'),
        search="Rechercher",
        lengthMenu='Afficher _MENU_ résultats'
      )
    )
  )
})

## Help button
observeEvent(input$help_button_3, {
  showModal(modalDialog(
    title = "Guide d'utilisation",
    includeMarkdown(paste0(PATH2MARKDOWNS, "help.Rmd")),
    easyClose = TRUE
  ))
})