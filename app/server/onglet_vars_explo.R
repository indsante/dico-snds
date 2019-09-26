## Variables datatable

observe({
  
  query <- parseQueryString(session$clientData$url_search)
  if (!is.null(query[['search']])) {
    global_search = query[['search']]
    #updateTextInput(session, "search", value = query[['search']])
  }
  else{
    global_search = ''
  }
  if (!is.null(query[['variable']])) {
    variable_search = query[['variable']]
  }
  else{
    variable_search = ''
  }
  if (!is.null(query[['table']])) {
    table_search = paste0('["', query[['table']], '"]')
  }
  else{
    table_search = ''
  }
  if (!is.null(query[['lib']])) {
    lib_search = query[['lib']]
  }
  else{
    lib_search = ''
  }
  
  #snds_vars_filtered = snds_vars_raw %>% filter_all(any_vars(grepl(default_filter, .)))
  output$all_vars_snds = DT::renderDataTable(
    DT::datatable(get_snds_vars(snds_vars), 
                  colnames = c('Table'='table', 'Variable'='var', 'Libelle'='description', 'Nomenclature'='nomenclature'),
                  filter = "top",
                  selection = "single",
                  rownames = F,
                  options = list(
                    lengthMenu = c(10, 20, 50, 100), 
                    pageLength = 50,
                    search = list(regex = TRUE, search = global_search),
                    searchCols = list(
                      list(search = table_search),
                      list(search = variable_search),
                      list(search = lib_search),
                      NULL,
                      NULL),
                    language = list(
                      info = 'Résultats _START_ à _END_ sur une liste de _TOTAL_.',
                      paginate = list(previous = 'Précédent', `next` = 'Suivant'),
                      search="Rechercher",
                      lengthMenu='Afficher _MENU_ résultats'
                    )
                  )
    )
  )
})


## Display current variable of interest nomenclature
### Logics to select current variable of interest name
tmp_var_snds = reactive({
  input$all_vars_snds_row_last_clicked
})

#observe({print(tmp_var_snds())})
### Output current variable of interest name
output$tmp_var_snds = renderText({
  if (is.null(tmp_var_snds())){
    ""
  }
  else{
    var_table <- snds_vars[tmp_var_snds(), ] %>% 
      pull(table)
    var_produit <- snds_tables %>% 
      filter(Table == var_table) %>% 
      pull(Produit)
    if (grepl('PMSI', var_produit)){
      var_produit <- paste0('PMSI/', var_produit) 
    }
    path2var_schema <- paste0(PATH2GITLAB_SCHEMAS, var_produit, '/', var_table, '.json')
    var_modification_text <- paste0('Vous pouvez proposez une correction ou un complément <a href="', path2var_schema, '">à cette adresse</a>.')
    var_creation <- snds_vars[tmp_var_snds(), ] %>% 
      pull(creation) 
    var_suppression <- snds_vars[tmp_var_snds(), ] %>% 
      pull(suppression)
    
    HTML(
      paste0(strong("Variable "), snds_vars[tmp_var_snds(), ] %>% select(var), ', ', 
             snds_vars[tmp_var_snds(), ] %>% select(description), br(),
             br(), strong("Type : "), snds_vars[tmp_var_snds(), ] %>% select(format), br(),            
             strong('Historique :'), br(),
             '- Date de création : ', var_creation, br(),
             '- Date de suppression : ', var_suppression,
             br(), '<i><font size="3">', var_modification_text, '</font></i>',
             br(), br(), strong("Nomenclature : "), snds_vars[tmp_var_snds(), ] %>% select(nomenclature)
      )
    )
  }
})

### Logics to select current nomenclature of interest
tmp_nom_snds = reactive({
  nom = tolower(snds_vars[tmp_var_snds(), "nomenclature"])
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
      dom = 'Blfrtip',
      language = list(
        info = 'Résultats _START_ à _END_ sur une liste de _TOTAL_.',
        paginate = list(previous = 'Précédent', `next` = 'Suivant'),
        search="Rechercher",
        lengthMenu='Afficher _MENU_ résultats'
      )
    )
  )
)

observeEvent(input$var_details, {
  var_table <- snds_vars[tmp_var_snds(), ] %>% 
    pull(table)
  var_produit <- snds_tables %>% 
    filter(Table == var_table) %>% 
    pull(Produit)
  if (grepl('PMSI', var_produit)){
    var_produit <- paste0('PMSI/', var_produit) 
  }
  path2var_schema <- paste0(PATH2GITLAB_SCHEMAS, var_produit, '/', var_table, '.json')
  var_modification_text <- paste0('Vous pouvez proposez une correction ou un complément <a href="', path2var_schema, '">à cette adresse</a>.')
  var_creation <- snds_vars[tmp_var_snds(), ] %>% 
    pull(creation) 
  var_suppression <- snds_vars[tmp_var_snds(), ] %>% 
    pull(suppression)
  
  showModal(
    modalDialog(
      title <- paste0(
        "Détail sur la variable ",
        snds_vars[tmp_var_snds(), ] %>% 
          select(var)
      ),
      HTML(
        paste0(
          h4('Libellé : '), snds_vars[tmp_var_snds(), ] %>% select(description), '\n', 
          h4('Historique : \n \n'),
          strong('Date de création de la variable : '), var_creation, br(),
          strong('Date de suppression de la variable : '), var_suppression,
          br(), br(), var_modification_text)
      ),
      easyClose = TRUE
    ))
})

# Sharable view button (only in table 1)
observeEvent(input$sharable_link, {
  
  if (session$clientData$url_port != ''){
    pathname =  paste0(sub('/$', '', session$clientData$url_pathname), ':', session$clientData$url_port, '/')
  }
  else{
    pathname = session$clientData$url_pathname
  }
  link = paste0(
    session$clientData$url_protocol,
    '//',
    session$clientData$url_hostname,
    pathname,
    '?variable=',
    snds_vars[tmp_var_snds(), 'var'],
    '&search=',
    input$all_vars_snds_search,
    '&table=',
    snds_vars[tmp_var_snds(), 'table']#,
    #'&lib=',
    #snds_vars[tmp_var_snds(), 'description']
  )
  ## Needing a system package (xclip)
  #clipr::write_clip(link, allow_non_interactive = TRUE)                 
  showModal(modalDialog(
    title = "Copier le lien dans le presse-papier!",
    renderText(link),
    easyClose = TRUE
  ))
})

## Help button
observeEvent(input$help_button_1, {
  showModal(modalDialog(
    title = "Guide d'utilisation",
    includeMarkdown(paste0(PATH2MARKDOWNS, "help.Rmd")),
    easyClose = TRUE
  ))
})

## join keys button
observeEvent(input$show_joinkeys_1, {
  showModal(modalDialog(
    title = "Les 9 clés de jointure du DCIR",
    includeMarkdown(paste0(PATH2MARKDOWNS, "join_keys.Rmd")),
    easyClose = TRUE
  ))
})