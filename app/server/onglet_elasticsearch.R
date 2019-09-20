# Elasticsearch onglet 3

output$query_result_agg_by_index <- DT::renderDataTable(
  DT::datatable(
    result_agg_by_index,
    filter = "top",
    selection = "single",
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

observeEvent(input$term_query, {
  output$query_result_agg_by_index <- DT::renderDataTable(
    DT::datatable(
      get_query_result_agg_by_index(input$term_query, snds_nomenclatures),
      filter = "top",
      selection = "single",
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
})


observeEvent(input$query_result_agg_by_index_row_last_clicked, {
  index_tmp <- input$query_result_agg_by_index_row_last_clicked
  nomenclature <- get_query_result_agg_by_index(input$term_query, snds_nomenclatures)$nomenclature[index_tmp]
  output$query_result <- DT::renderDataTable(
    DT::datatable(
      get_query_result(input$term_query, tolower(nomenclature)),
      filter = "top",
      selection = "single",
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
})