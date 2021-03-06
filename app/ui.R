#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

PATH2MARKDOWNS = paste0("www/markdowns/")
img_width = 150

navbarPage("Visualisation de la structure du SNDS", 
           id="nav", 
           collapsible = T, 
           selected = "snds_explo",
           # Dark theme for tabs
           inverse = T,
           
  tabPanel("Explorateur des variables", value = "snds_explo",
       HTML(" 
       <script type=\"text/javascript\" src=\"https://tarteaucitron.io/load.js?domain=health-data-hub.shinyapps.iodico-snds&uuid=bc6d5f21273f2b08c46b3888025037246e4596ce\"></script>              
            "),
       #includeHTML("www/cookie_handler.html"),
       tags$script(JS(readLines("www/get_ip_client.js"))),

       # Include our custom CSS
       includeCSS("www/styles.css"),
       tags$style('.nodetext{fill: #000000}'),
    
    # Side buttons
    # actionButton(
    #   inputId = "var_details",
    #   label = 'Détails variable ',
    #   icon = icon("book-open")
    # ),
    actionButton(
      inputId = "help_button_1",
      label = "Aide",
      icon = icon("question")
    ),
    actionButton(
      inputId = "show_joinkeys_1",
      label = "9 clés de jointure",
      icon = icon("keycdn")
    ),
    actionButton(
      inputId = "sharable_link",
      label = 'Partager la vue',
      icon = icon("share")
    ),
      column(8,
             
             DT::dataTableOutput("all_vars_snds")),
      
      column(4, h4(htmlOutput("tmp_var_snds")), 
             DT::dataTableOutput("noms_table_snds"))
    ),
  
  tabPanel("Recherche dans les nomenclatures", value = "ES_nomenclatures",
           
           includeCSS("www/styles.css"),
           tags$style('.nodetext{fill: #000000}'),
           textInput("term_query", label = NULL, value = '', width = 1000,
                     placeholder = "Chercher des termes ou codes dans les nomenclatures. Ex : Otite, Audioprothèse, ECQM001"),
           column(4,DT::dataTableOutput("query_result_agg_by_index")),
           column(8, h4(htmlOutput("liste_variable")),
                  DT::dataTableOutput("query_result"))
  ),
  
  tabPanel("Explorateur des tables", value = "tables_explo",
           includeCSS("www/styles.css"),
           tags$style('.nodetext{fill: #000000}'),
           actionButton(
             inputId = "help_button_2",
             label = "Aide",
             icon = icon("question")
           ),
           actionButton(
             inputId = "show_joinkeys_2",
             label = "9 clés de jointure",
             icon = icon("keycdn")
           ),
           DT::dataTableOutput("snds_tables")
           ),
  
  tabPanel("Graphe interactif", value = "snds_graph",           
           div(class="outer",
               tags$head(
                 # Include our custom CSS
                 includeCSS("www/styles.css")
               ),
               # d3 force network
               forceNetworkOutput("force_snds", width = "100%", height = "100%"),
               
               absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                             draggable = F, top ="15%", left="2%", right = "auto", bottom = "15%", 
                             width = "30%", height = "80%",   
                             # Side buttons
                             actionButton(
                               inputId = "help_button_3",
                               label = "Aide",
                               icon = icon("question")
                             ),
                             actionButton(
                               inputId = "show_legend",
                               label = "Légende",
                               icon = icon("palette")
                             ),
                             h3(textOutput("table_name_snds")),
                             DT::dataTableOutput("my_table_snds", height = "80%")
                             
               ),
               conditionalPanel("input.show_legend % 2 != 0",
                 absolutePanel(id = "legend_block", class = "panel panel-default", fixed = F,
                               draggable = T, top ="5%", left="auto", right = "2%", bottom = "auto", 
                              width = "20%", height = "10%",  
                               wellPanel(
                                 plotOutput("legend", height = "250")
                                 )
                               
                 )
               )
           )
  ),
  
  tabPanel("Informations", value = "info_page",
                 includeCSS("www/styles.css"),
           
            HTML("
              <div class='col-xs-3 col-sm-3'>
              <div class='pull-right'>"),
            tags$a(
              img(src="logo-cnam.png", width = img_width, height = round(0.69*img_width)), 
              href="https://assurance-maladie.ameli.fr/", 
              target="_blank"),
            HTML("
              </div> 
              </div> 
              <div class='col-xs-3 col-sm-3'>
              <div class='pull-right'>"),
            tags$a(img(src="logo-hdh.png", width = img_width + 50, height = round(0.69*(img_width +50))), 
                  href="http://health-data-hub.fr/", 
                  target="_blank"),
            HTML("
              </div> 
              </div>
              <div class='col-xs-3 col-sm-3'>
              <div class='pull-right'>"),
            tags$a(img(src="logo-drees.png", width = img_width, height = round(0.69*img_width)), 
                  href="https://drees.solidarites-sante.gouv.fr/etudes-et-statistiques/", 
                  target="_blank"),
           
           HTML("
              </div>
              </div>"),
           HTML(" <div class='container-fluid col-md-12'>
                <div>"),
            hr(),
            # Side buttons
            actionButton(
              inputId = "reset_button",
              label = "Gitlab HDH",
              icon = icon("gitlab"),
              onclick = "window.open('https://gitlab.com/healthdatahub/dico-snds', '_blank')"),
          
            # Text as markdown files
            includeMarkdown(paste0(PATH2MARKDOWNS, "sup_infos.Rmd")),
            includeMarkdown(paste0(PATH2MARKDOWNS, "help.Rmd")),
            HTML("<hr>"),
            includeMarkdown(paste0(PATH2MARKDOWNS, "user_infos.Rmd")),
             HTML(
               "</div>
               </div>")
  )
)
#![alt text](../logos/logo-cnam.png) ![alt text](../logos/logo-inds.jpg) ![alt text](../logos/logo-drees.png)
