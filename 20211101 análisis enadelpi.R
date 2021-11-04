# *-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-**-*
# ++ RESULTADOS PRELIMINARES ENADEL 2021 ++ ----------------------------------------------------
# *-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-**-*
#
#
# Héctor Garrido Henríquez
# Analista Cuantitativo. Observatorio Laboral Ñuble
# Docente. Facultad de Ciencias Empresariales
# Universidad del Bío-Bío
# Avenida Andrés Bello 720, Casilla 447, Chillán
# Teléfono: +56-942353973
# http://www.observatoriolaboralnuble.cl

rm(list = ls())


# Si al momento de actualizar los archivos arroja un error la primera vez,
# ejecutar el siguiente código en la powershell de windows de la carpeta del repositorio:
# git pull nombre_repositorio --allow-unrelated-histories


#
Sys.setenv(LANG = "en")


load_pkg <- function(pack){
  create.pkg <- pack[!(pack %in% installed.packages()[, "Package"])]
  if (length(create.pkg))
    install.packages(create.pkg, dependencies = TRUE)
  sapply(pack, require, character.only = TRUE)
}

devtools::install_github("martinctc/surveytoolbox")

packages = c("tidyverse", "stringi", "lubridate", 
             "data.table", "srvyr", "pbapply", 
             "ggrepel", "RColorBrewer", "readstata13", 
             "gtable", "gridExtra", "tidytext", 
             "wordcloud", "kableExtra", "captioner", 
             "foreign", "RPostgres", "haven", 
             "rJava", "openxlsx", "timetk", 
             "forecast","sweep", "tidyquant", 
             "ggmap", "rgeos", "ggalt", "maptools", 
             "rgdal", "readxl", "grid", "scales", 
             "fuzzyjoin", "survey", "directlabels", "microbenchmark", 
             "haven", "sjlabelled", "labelled", "surveytoolbox", "multcomp", "XLConnect")

load_pkg(packages)


file_path = "G:/Mi unidad/OLR Ñuble - Observatorio laboral de Ñuble/Análisis Cuantitativo/SurveyReport-SPSS-8939690-10-31-2021-T221646.sav"

file_path_2 = "G:/Mi unidad/OLR Ñuble - Observatorio laboral de Ñuble/Análisis Cuantitativo/Enadelpi_2021.dta"

enadelpi_1 = haven::read_sav(file_path)

directorio_1 = enadelpi_1 %>% varl_tb()

enadelpi_2 = haven::read_dta(file_path_2)

directorio_2 = enadelpi_2 %>% varl_tb()


# write.csv(directorio_1, file = "directorio_nuble.csv")
# write.csv(directorio_2, file = "directorio_nacional.csv")



