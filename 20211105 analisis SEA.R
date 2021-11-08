#Análisis de datos Servicio de Evaluación Ambiental 

rm(list = ls())

load_pkg <- function(pack){
  create.pkg <- pack[!(pack %in% installed.packages()[, "Package"])]
  if (length(create.pkg))
    install.packages(create.pkg, dependencies = TRUE)
  sapply(pack, require, character.only = TRUE)
}

paquetes = c("tidyverse", "sjPlot", "reshape2", "dummy", "lubridate") 

load_pkg(paquetes)


file_path = "G:/Mi unidad/OLR Ñuble - Observatorio laboral de Ñuble/Análisis Cuantitativo/Proyectos 2017_2021 (actualizado 02.11.2021).xlsx"

data = readxl::read_excel(file_path) %>% 
  mutate(antiguedad = as.numeric(difftime(today(), `Fecha calificación`, units = "days"))/365)



modelo1 = lm(`Mano obra Promedio Operación`~`Inversión (MMU$)`+`Tipología`+`Región`+antiguedad, data = data %>% filter(Estado == "Aprobado"))

modelo2 = lm(`Mano obra Promedio Construcción`~`Inversión (MMU$)`+`Tipología`+`Región`+antiguedad, data = data %>% filter(Estado == "Aprobado"))

hist(residuals(modelo1))

shapiro.test(residuals(modelo))

require(lmtest)

bptest(modelo)

plot(modelo)



