# Poland Biodiversity Application

The shiny application allows for an interactive exploration of the biodiversity data for Poland.

**Data source**: The data is obtained from [Global Biodiversity Information Facility](https://www.gbif.org/occurrence/search?dataset_key=8a863029-f435-446a-821e-275f4f641165)

My submission is hosted here: [Poland Biodiversity Application](https://brianmwangy.shinyapps.io/PolandBiodiversityApplication/)

# App Structure

- `app.R` app file (UI and server logic live)
- `constants.R` data constants file
- `data.R`data loading and manipulation file
- `www/app_data.rds` app clean data
- `www/poland.csv` app raw data
- `modules/charts_module.R` module for chart display
- `modules/search_module.R` module for drop down search that does the map and table filtering


# Data

My first step was to explore the data, what is the data structure (variables,size)? The data was huge (20GB) and I prepped to write the data to SQL.I used the R studio great guide on [database using R](https://db.rstudio.com/getting-started/overview). Exploring the Global Biodiversity website facilitated a deeper understanding of the data. Using this Appsilon guide: https://appsilon.com/fast-data-loading-from-files-to-r/ , I opted to use the Rds function for enhanced performance.The server-side selectize also offers faster performance when loading and selecting data variables.

# App UI

Appsilon offers great UI options for developing enterprise shiny applications (https://appsilon.com/shiny-templates-available/). I used the appealing Semantic UI to structure the app layout. You can explore the detailed [guide](https://github.com/Appsilon/shiny.semantic). [Fluent UI](https://github.com/Appsilon/shiny.fluent) is also a great UI option worth exploring.

# App modules

The search module takes in a variable, filters the data and outputs the filtered data on the data-table and the map.

The chart module is static and displays a sum total of species occurence per month and year.

Using this guide (https://appsilon.com/leaflet-vs-tmap-build-interactive-maps-with-r-shiny/) I was able to leverage leaflet package for interactive mapping.

# Performance Testing

The [testServer()](https://shiny.rstudio.com/articles/server-function-testing.html) function makes it possible to test code in server functions and modules. I used the function to validate my module's outputs.

# App optimization

The bindCache()  function enables the app to automatically retrieve the values saved in the cache instead of having to compute them again.Guide on caching:https://shiny.rstudio.com/articles/caching.html
