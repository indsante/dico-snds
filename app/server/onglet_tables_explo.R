# Explorateur des tables (tab 2)
output$snds_tables = DT::renderDataTable(
  DT::datatable(
    get_snds_tables(snds_tables),
    filter = "top",
    selection = "single",
    extensions = "Buttons",
    rownames = F,
    options = list(
      lengthMenu = c(10, 20, 50, 100),
      pageLength = 50,
      language = list(
        info = 'Résultats _START_ à _END_ sur une liste de _TOTAL_.',
        paginate = list(previous = 'Précédent', `next` = 'Suivant'),
        search="Rechercher",
        lengthMenu='Afficher _MENU_ résultats'
      )
    ) 
  )
)


tmp_table_snds = reactive({
  input$snds_tables_row_last_clicked
})



## Current table details button
observeEvent(input$snds_tables_row_last_clicked, {
  table_name <- snds_tables[tmp_table_snds(), ] %>% 
    pull(Table)
  table_produit <- snds_tables %>% 
    filter(Table == table_name) %>% 
    pull(Produit)
  if (grepl('PMSI', table_produit)){
    table_produit <- paste0('PMSI/', table_produit) 
  }
  path2table_schema <- paste0(PATH2GITLAB_SCHEMAS, table_produit, '/', table_name, '.json')
  table_modification_text <- paste0('Vous pouvez proposez une correction ou un complément <a href="', path2table_schema, '">à cette adresse</a>.')
  table_creation <- snds_tables[tmp_table_snds(), ] %>% 
    pull(creation)
  table_suppression <- snds_tables[tmp_table_snds(), ] %>% 
    pull(suppression)
  
  showModal(
    modalDialog(
      title <- paste0(
        "Détail sur la table ",
        table_name
      ),
      HTML(
        paste0(
          h4('Libellé : '), snds_tables[tmp_table_snds(), ] %>% select(Libelle), '\n', 
          h4('Historique : \n \n'),
          strong('Date de création de la table : '), table_creation, br(),
          strong('Date de suppression de la table : '), table_suppression,
          br(), br(), table_modification_text
        )
      ),
      easyClose = TRUE
    ))
})

## Help button
observeEvent(input$help_button_2, {
  showModal(modalDialog(
    title = "Guide d'utilisation",
    includeMarkdown(paste0(PATH2MARKDOWNS, "help.Rmd")),
    easyClose = TRUE
  ))
})

## Join keys button
observeEvent(input$show_joinkeys_2, {
  showModal(modalDialog(
    title = "Les 9 clés de jointure du DCIR",
    includeMarkdown(paste0(PATH2MARKDOWNS, "join_keys.Rmd")),
    easyClose = TRUE
  ))
})