global salida "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado"
global salida2 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Asistencia Técnica\2022\BBDD"

use "$salida\Enadepi_2021.dta", clear
rename nombre_proyecto nom_proyecto
drop nombre_encuestador nombre_informante

gen nt_contratados_prox12m=e1_nt_contratados_total_prox12m if etapa_proyecto==1
replace nt_contratados_prox12m=e2_nt_contratados_total_prox12m if etapa_proyecto==2

gen nt_contratados_hoy=e2_nt_contratados_total_hoy


forval j=1/6{
	local k= 25 + `j'
	gen e1_nt_contratados_prox12m_`k'=e1_nt_cd_pt`j'_extra_prox12m 
	gen e2_nt_cd_prox12m_`k'=e2_nt_cd_prox12m_pt`j'_extra
	gen e2_nt_cd_hoy_`k'=e2_nt_cd_hoy_pt`j'_extra
	gen e1_nombre_puesto_extra_`k'=e1_nombre_pt`j'_extra_prox12m
    gen e1_tareas_puesto_extra_`k'=e1_tareas_pt`j'_extra_prox12m	
	gen e2_nombre_puesto_extra_`k'=e2_nombre_pt`j'_extra
    gen e2_tareas_puesto_extra_`k'=e2_tareas_pt`j'_extra				
}




forval i=1/31{
	gen nt_cd_prox12m_`i'=e1_nt_contratados_prox12m_`i' if etapa_proyecto==1
	replace nt_cd_prox12m_`i'=e2_nt_cd_prox12m_`i' if etapa_proyecto==2
	
	gen nt_cd_hoy_`i'=e2_nt_cd_hoy_`i'
	
	gen nombre_puesto_extra_`i'=""
	gen tareas_puesto_extra_`i'=""
	
	if `i'>=26{
	  replace nombre_puesto_extra_`i'=e1_nombre_puesto_extra_`i' if etapa_proyecto==1
	  replace nombre_puesto_extra_`i'=e2_nombre_puesto_extra_`i' if etapa_proyecto==2
	  replace tareas_puesto_extra_`i'=e1_tareas_puesto_extra_`i' if etapa_proyecto==1
	  replace tareas_puesto_extra_`i'=e2_tareas_puesto_extra_`i' if etapa_proyecto==2
	} 

}


keep folio nom_proyecto region_que_levanta region_operacion comuna_opera_texto ///
nombre_puesto_extra_* tareas_puesto_extra_* nt_cd_hoy_* nt_cd_prox12m_* nt_contratados_prox12m ///
nt_contratados_hoy etapa_proyecto

reshape long nombre_puesto_extra_ tareas_puesto_extra_ nt_cd_hoy_ nt_cd_prox12m_, i(folio nom_proyecto etapa_proyecto nt_contratados_hoy nt_contratados_prox12m region_que_levanta region_operacion comuna_opera_texto) ///
j(ocupacion)


gen nombre_oficio4=""
gen ciuo08=.
gen nivel_confianza_ciuo08=.
gen nombre_pt_estandar=""



label define ocupacion 1  "Encargados de obra (administradores de obra, jefes de terreno, encargados de bodega, etc.)"
label val ocupacion ocupacion
label define ocupacion 2  "Capataces", modify
label define ocupacion 3  "Electrónicos, electromecánicos e instrumentistas", modify
label define ocupacion 4  "Laboratoristas", modify
label define ocupacion 5  "Electricistas (técnicos y/o maestros)", modify
label define ocupacion 6  "Ingenieros, prevencionistas, arqueólogos, ambientalistas u otros profesionales de la obra", modify
label define ocupacion 7  "Operadores planta asfalto y de áridos", modify
label define ocupacion 8  "Operadores de maquinaria pesada (motoniveladora, retroexcavadora, rigger, camión tolva, grúa horquilla, etc.)", modify
label define ocupacion 9  "Operadores de maquinaria liviana (gravilladora autopropulsada, rodillo manual, martillo picador etc.)", modify
label define ocupacion 10  "Trazadores", modify
label define ocupacion 11  "Mecánicos", modify
label define ocupacion 12  "Soldadores", modify
label define ocupacion 13  "Enfierradores", modify
label define ocupacion 14  "Albañiles", modify
label define ocupacion 15  "Concreteros", modify
label define ocupacion 16  "Carpinteros", modify
label define ocupacion 17  "Pintores", modify
label define ocupacion 18  "Baldoseros y ceramistas", modify
label define ocupacion 19  "Tuberos y operadores de termofusión", modify
label define ocupacion 20  "Sanitarios y gásfiteres", modify
label define ocupacion 21  "Instaladores de gas", modify
label define ocupacion 22  "Otros maestros de primera y segunda", modify
label define ocupacion 23  "Buzos", modify
label define ocupacion 24  "Bodegueros y cardcheckers", modify
label define ocupacion 25  "Jornales, ayudantes y señaleros", modify
label define ocupacion 26  "Otro puesto de trabajo 1", modify
label define ocupacion 27  "Otro puesto de trabajo 2", modify
label define ocupacion 28  "Otro puesto de trabajo 3", modify
label define ocupacion 29  "Otro puesto de trabajo 4", modify
label define ocupacion 30  "Otro puesto de trabajo 5", modify
label define ocupacion 31  "Otro puesto de trabajo 6", modify

drop if inrange(ocupacion,26,31) & nombre_puesto_extra_=="" & tareas_puesto_extra_==""
drop if inrange(ocupacion,1,25) & nt_cd_hoy_==. & nt_cd_prox12m_==.
drop if inrange(ocupacion,1,25) & nt_cd_hoy_==0 & nt_cd_prox12m_==0
drop if inrange(ocupacion,1,25) & nt_cd_hoy_==. & nt_cd_prox12m_==0
drop if inrange(ocupacion,1,25) & nt_cd_hoy_==0 & nt_cd_prox12m_==.

label var nombre_oficio4 "Nombre Oficio4 CIUO.08 CL"
label var ciuo08 "Código CIUO.08 CL"
label var nivel_confianza_ciuo08 "Nivel de confianza clasificación CIUO.08 CL (1,2,3,4) "
label var nombre_pt_estandar "Nombre puesto de trabajo estandarizado"
label var ocupacion "Nombre puesto de trabajo (dotación)"
label var nombre_puesto_extra_ "Nombre otro puesto de trabajo"
label var tareas_puesto_extra_ "Tareas otro puesto de trabajo"
 label var nt_cd_hoy_ "N° de trabajadores actual (puesto de trabajo)"
label var folio "Folio ENADELPI 2021"
label var nt_cd_prox12m_ "Número de trabajadores contratados próximos 12 meses (puesto de trabajo)"
*label var fecha_carga "Fecha de carga de datos"
label var etapa_proyecto "Etapa del proyecto"
label var nt_contratados_hoy "Total de trabajadores del proyecto contratados directamente hoy"
label var nt_contratados_prox12m "Total de trabajadores proyecto contratados directamente próx. 12 meses"
label var region_que_levanta "Región que levantó encuesta"
label var region_operacion "Región operacion (en caso de que donde se levanten no hay trabajadores)"



# delimit ;
capture label define region_operacion
	1 "Región de Tarapacá"
	2 "Región de Antofagasta" 
	3 "Región de Atacama" 
	4 "Región de Coquimbo" 
	5 "Región de Valparaíso" 
	6 "Región de O'Higgins" 
	7 "Región del Maule" 
	8 "Región del Biobío" 
	9 "Región de la Araucanía" 
	10 "Región de Los Lagos" 
	11 "Región de Aysén" 
	12 "Región de Magallanes" 
	13 "Región Metropolitana de Santiago" 
	14 "Región de Los Ríos" 
	15 "Región de Arica y Parinacota"
	16 "Región del Ñuble", 
;
# delimit cr

label val region_operacion region_operacion
*order fecha_carga, last

order folio nom_proyecto etapa_proyecto nombre_oficio4 ciuo08 ///
nivel_confianza_ciuo08 nombre_pt_estandar ocupacion nombre_puesto_extra_ tareas_puesto_extra_ ///
nt_cd_hoy_ nt_cd_prox12m_ nt_contratados_hoy nt_contratados_prox12m region_que_levanta region_operacion comuna_opera_texto, first

*export excel "$salida2\ENADELPI_2021.xlsx", firstrow(varl) sheet("Puestos M. Datos proyecto") sheetreplace		

save "$salida\Enadelpi_dotacion_2021.dta", replace

/*
use "$salida\Enadelpi_dotacion_2021.dta", clear
gen ciuo08=.
gen nombre_oficio4=""

replace ciuo08=3123 if ocupacion=="Capataces"
replace nombre_oficio4="Supervisores de la construcción" if ocupacion=="Capataces"

replace ciuo08=3111 if ocupacion=="Laboratoristas"
replace nombre_oficio4="Técnicos en ciencias físicas y químicas" if ocupacion=="Laboratoristas"

replace ciuo08=7119 if ocupacion=="Trazadores"
replace nombre_oficio4="Otros operarios de la construcción (obra gruesa) no clasificados previamente" if ocupacion=="Trazadores"

replace ciuo08=7212 if ocupacion=="Soldadores"
replace nombre_oficio4="Soldadores y oxicortadores" if ocupacion=="Soldadores"

replace ciuo08=7126 if ocupacion=="Sanitarios y gásfiteres"
replace nombre_oficio4="Gasfíter e instaladores de tuberías" if ocupacion=="Sanitarios y gásfiteres"

replace ciuo08=7126 if ocupacion=="Instaladores de gas"
replace nombre_oficio4="Gasfíter e instaladores de tubería" if ocupacion=="Instaladores de gas"

replace ciuo08=7131 if ocupacion=="Pintores"
replace nombre_oficio4="Pintores y empapeladores de paredes" if ocupacion=="Pintores"

replace ciuo08=7231 if ocupacion=="Mecánicos"
replace nombre_oficio4="Mecánicos y reparadores de vehículos de motor" if ocupacion=="Mecánicos"

replace ciuo08=9312 if ocupacion=="Jornales, ayudantes y señaleros"
replace nombre_oficio4="Obreros de obras públicas" if ocupacion=="Jornales, ayudantes y señaleros"

replace ciuo08=7221 if ocupacion=="Enfierradores"
replace nombre_oficio4="Herreros y forjadores" if ocupacion=="Enfierradores"

replace ciuo08=7114 if ocupacion=="Concreteros"
replace nombre_oficio4="Operarios en cemento armado" if ocupacion=="Concreteros"

replace ciuo08=7115 if ocupacion=="Carpinteros"
replace nombre_oficio4="Carpinteros de obra" if ocupacion=="Carpinteros"

replace ciuo08=9333 if ocupacion=="Bodegueros y cardcheckers"
replace nombre_oficio4="Obreros de carga" if ocupacion=="Bodegueros y cardcheckers"

replace ciuo08=7122 if ocupacion=="Baldoseros y ceramistas"
replace nombre_oficio4="Instaladores de parqué, cerámicas, baldosas y alfombras" if ocupacion=="Baldoseros y ceramistas"

replace ciuo08=7112 if ocupacion=="Albañiles"
replace nombre_oficio4="Albañiles" if ocupacion=="Albañiles"
