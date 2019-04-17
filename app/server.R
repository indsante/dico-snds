#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.

library(shiny)
library(markdown)
library(dplyr)

# required for network plotting
library(networkD3) 

# For network legend
library(ggplot2) 
library(grid)
library(gridExtra) 

PATH2DATA = "app_data/"
PATH2MARKDOWNS = paste0("www/markdowns/")
PATH2NOMENCLATURES =  paste0(PATH2DATA, "nomenclatures/")

# SNDS nodes table
snds_nodes = read.csv(paste0(PATH2DATA, "snds_nodes.csv"),
                      encoding = "UTF-8")
# SNDS links table
snds_links = read.csv(paste0(PATH2DATA, "snds_links.csv"),
                      encoding = "UTF-8")
# SNDS tables table
snds_tables = read.csv(paste0(PATH2DATA, "snds_tables.csv"),
                       encoding = "UTF-8")
snds_tables$Libelle = as.character(snds_tables$Libelle)
# SNDS variables table
snds_vars = read.csv(paste0(PATH2DATA,"snds_vars.csv"), 
                      encoding = "UTF-8", 
                      stringsAsFactors = FALSE)
snds_vars$table = as.factor(snds_vars$table)

# Server logics
shinyServer(function(input, output) {
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
    data.frame(snds_vars[snds_vars$table == input$name, c(2,4,3)])
  })
  ### Display name of the table
  output$table_name_snds = renderText({paste0(input$name , ": ", input$description)[1]})
  ### Display only current table variables
  output$my_table_snds = DT::renderDataTable(
    DT::datatable(
      current_table_snds(),
      rownames = F,
      fillContainer = T,
      options = list(
        lengthMenu = c(10, 20, 30),
        pageLength = 50
        )
      )
    )
  
  # Explorateur des tables (tab 2)
  output$snds_tables = DT::renderDataTable(
    DT::datatable(
      snds_tables %>% 
        select(one_of('Produit', 'Table', 'Libelle')),
      filter = "top",
      selection = "single",
      rownames = F,
      options = list(
        lengthMenu = c(10, 20, 50, 100),
        pageLength = 50
      ) 
    )
  )
  
  # Explorateur des variables (tab 1)
  ## Variables datatable
  output$all_vars_snds = DT::renderDataTable(
    DT::datatable(snds_vars[,c(1,2,4,3)], 
                  colnames = c('Table'='table', 'Variable'='var', 'Libelle'='description', 'Type'='format'),
                  filter = "top",
                  selection = "single",
                  rownames = F,
                  options = list(
                    lengthMenu = c(10, 20, 50, 100), 
                    pageLength = 50) 
                  )
    )
  
  ## Display current variable of interest nomenclature
  ### Logics to select current variable of interest name
  tmp_var_snds = reactive({
    snds_vars[input$all_vars_snds_row_last_clicked, "var"]
  })
  ### Output current variable of interest name
  output$tmp_var_snds = renderText({paste0("Variable ", tmp_var_snds())})
  
  ### Logics to select current nomenclature of interest
  tmp_nom_snds = reactive({
    nom = tolower(snds_vars[input$all_vars_snds_row_last_clicked, "nomenclature"])
    if (req(nom != "-")){
       return (read.csv2(paste0(PATH2NOMENCLATURES, toupper(nom), ".csv"), encoding = "UTF-8") %>% 
         select(-one_of("TEC_COL", "CPT_COP_NUM", "nom_table")))
      }
  })
  
  # Current nomenclature of interest 
  output$noms_table_snds = DT::renderDataTable(
    DT::datatable(
      tmp_nom_snds(),
      rownames = F,
      selection = "single",
      extensions = "Buttons",
      options = list(
        lengthMenu = list(c(10, 20, 50, -1),
                           c(10, 20, 50, "Tout")),
        pageLength = 50,
        buttons = c('copy', 'csv'),
        dom = 'Blfrtip'
        )
      )
  )

  # Observers pour les actions buttons de l'ui (un par pannel)
  observeEvent(input$help_button_1, {
    showModal(modalDialog(
      title = "Guide d'utilisation",
      includeMarkdown(paste0(PATH2MARKDOWNS, "help.Rmd")),
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$help_button_2, {
    showModal(modalDialog(
      title = "Guide d'utilisation",
      includeMarkdown(paste0(PATH2MARKDOWNS, "help.Rmd")),
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$help_button_3, {
    showModal(modalDialog(
      title = "Guide d'utilisation",
      includeMarkdown(paste0(PATH2MARKDOWNS, "help.Rmd")),
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$show_joinkeys_1, {
    showModal(modalDialog(
      title = "Les 9 clés de jointure du DCIR",
      includeMarkdown(paste0(PATH2MARKDOWNS, "join_keys.Rmd")),
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$show_joinkeys_2, {
    showModal(modalDialog(
      title = "Les 9 clés de jointure du DCIR",
      includeMarkdown(paste0(PATH2MARKDOWNS, "join_keys.Rmd")),
      easyClose = TRUE
    ))
  })
  
})
  
