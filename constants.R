#reading app data
app_df<-readRDS("./www/app_data.rds")

vernacular_name <- unique(app_df$table_data$vernacularName)
scientific_name <- unique(app_df$table_data$scientificName)
