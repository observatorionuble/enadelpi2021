
global salida "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado"


use "$salida\Enadelpi_2021.dta", clear
summ folio

use "$salida\Enadelpi_2021_autoaplicada.dta", clear
replace folio=1353 if nombre_informante=="Mauricio Encina"
replace folio=11238 if nombre_informante=="jose camus"
save "$salida\Enadelpi_2021_autoaplicada.dta", replace


use "$salida\Enadelpi_2021.dta", clear
append using "$salida\Enadelpi_2021_autoaplicada.dta"
save "$salida\Enadelpi_2021.dta", replace

