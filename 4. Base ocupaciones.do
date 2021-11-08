global salida "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado"
global salida2 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Asistencia Técnica\2022\BBDD"

use "$salida\Enadelpi_2021.dta", clear

gen nt_contratados=e2_nt_contratados_total_hoy
replace nt_contratados=e1_nt_contratados_total_prox12m if nt_contratados==.
rename nombre_proyecto nom_proyecto
drop nombre_encuestador nombre_informante

foreach o of numlist 1/5{
	decode nombre_puesto_`o', gen(nombre_puesto_texto_`o')
	drop nombre_puesto_`o'
	rename nombre_puesto_texto_`o' nombre_puesto_`o'
	order nombre_puesto_`o', after(n_puestos_dificultades)
	replace nombre_puesto_`o'=nombre_otro_puesto_`o' if nombre_otro_puesto_`o'!="" 
	
}
drop nombre_otro_puesto_*

rename nombre_detalle_otro_puesto_* detalle_nombre_puesto_*
rename tareas_otro_puesto_* detalle_tareas_puesto_*

keep folio nt_contratados nom_proyecto comuna_opera_texto etapa_proyecto nombre_* ///
experiencia_* educ_* glosa_licencia_* n_vacantes_* principal_dificultad_* ///
glosa_otra_* region_operacion detalle_* region_que_levanta 

greshape long nombre_ detalle_nombre_ detalle_tareas_ experiencia_ educ_ glosa_licencia_ principal_dificultad_ glosa_otra_ ///
n_vacantes_, ///
by(region_operacion region_que_levanta comuna_opera_texto folio nom_proyecto nt_contratados) keys(puesto) string

gen id_puesto=.
forval i=1/5{
	replace id_puesto=`i' if puesto=="puesto_`i'"
}

gsort folio id_puesto

keep if nombre_!=""

		label define experiencia_ 1  "No se requiere experiencia"
		label val experiencia_ experiencia_
		label define experiencia_ 2  "1 a 2 años", modify
		label define experiencia_ 3  "3 a 5 años", modify
		label define experiencia_ 4  "Más de 5 años.", modify
		
		
		 label define principal_dificultad_ 1  "Escasez de postulantes en la región" ///
		 2  "Candidatos sin competencias o habilidades técnicas" ///
		 3  "Candidatos sin licencias, certificaciones o requisitos legales requeridos para ejercer su oficio" ///
		 4  "Falta de experiencia laboral" ///
		 5  "Las condiciones laborales no son aceptadas" ///
		 6  "Otra dificultad"
		label val principal_dificultad_ principal_dificultad_


	    label define educ_ 1  "Sin requisito" ///
	    2  "Básica completa" ///
	    3  "Media" ///
	    4  "Media técnico profesional" ///
	    5  "Técnico nivel superior" ///
	    6  "Profesional o más" 
		label val educ_ educ_
		


gen nombre_oficio4=""
gen ciuo08=.
gen nivel_confianza_ciuo08=.
gen nombre_pt_estandar=""

order folio nom_proyecto nombre_oficio4 ciuo08 ///
nivel_confianza_ciuo08 puesto nombre_pt_estandar nombre_ detalle_nombre_ detalle_tareas_ glosa_licencia_ educ_ nt_contratados ///
nom_proyecto experiencia_ principal_dificultad_ glosa_otra_ n_vacantes_ region_que_levanta region_operacion comuna_opera_texto , first


label var puesto "Tipo de puesto de trabajo u orden del puesto de trabajo"
label var nombre_oficio4 "Nombre Oficio4 CIUO.08 CL"
label var ciuo08 "Código CIUO.08 CL"
label var nivel_confianza_ciuo08 "Nivel de confianza clasificación CIUO.08 CL (1,2,3,4) "
label var nombre_pt_estandar "Nombre puesto de trabajo estandarizado"
label var nombre_ "Nombre puesto de trabajo"
label var detalle_nombre_ "Detalle nombre puesto de trabajo"
label var detalle_tareas_ "Tareas puesto de trabajo"
label var glosa_licencia_ "Certificaciones, licencias u otros requisitos"
label var educ_ "Nivel educativo requerido"
label var nom_proyecto "Nombre proyecto"
label var experiencia_ "Experiencia requerida (años)"
label var principal_dificultad_ "Tipo de dificultad"
label var glosa_otra_ "Otra dificultad (glosa)"
label var n_vacantes_ "N° de vacantes últimos 12 meses"
label var folio "Folio ENADELPI 2021"
label var nt_contratados "Número de trabajadores que requiere el proyecto"
*label var fecha_carga "Fecha de carga de datos"
*label var fecha_carga "Fecha de carga de datos"
label var region_que_levanta "Región que levanta encuesta"
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
drop id_puesto
*order fecha_carga, last
		
*export excel "$salida2\ENADELPI_2021.xlsx", firstrow(varl) sheet("Puestos M. Vacantes") sheetreplace		

save "$salida\Enadelpi_ocupaciones_2021.dta", replace

/*
use "$salida\Enadelpi_ocupaciones_2021.dta", clear
gen ciuo08=.
gen nombre_oficio4=""

replace ciuo08=3123 if nombre_=="Capataces"
replace nombre_oficio4="Supervisores de la construcción" if nombre_=="Capataces"

replace ciuo08=3111 if nombre_=="Laboratoristas"
replace nombre_oficio4="Técnicos en ciencias físicas y químicas" if nombre_=="Laboratoristas"

replace ciuo08=7119 if nombre_=="Trazadores"
replace nombre_oficio4="Otros operarios de la construcción (obra gruesa) no clasificados previamente" if nombre_=="Trazadores"

replace ciuo08=7212 if nombre_=="Soldadores"
replace nombre_oficio4="Soldadores y oxicortadores" if nombre_=="Soldadores"

replace ciuo08=7126 if nombre_=="Sanitarios y gásfiteres"
replace nombre_oficio4="Gasfíter e instaladores de tuberías" if nombre_=="Sanitarios y gásfiteres"

replace ciuo08=7126 if nombre_=="Instaladores de gas"
replace nombre_oficio4="Gasfíter e instaladores de tubería" if nombre_=="Instaladores de gas"

replace ciuo08=7131 if nombre_=="Pintores"
replace nombre_oficio4="Pintores y empapeladores de paredes" if nombre_=="Pintores"

replace ciuo08=7231 if nombre_=="Mecánicos"
replace nombre_oficio4="Mecánicos y reparadores de vehículos de motor" if nombre_=="Mecánicos"

replace ciuo08=9312 if nombre_=="Jornales, ayudantes y señaleros"
replace nombre_oficio4="Obreros de obras públicas" if nombre_=="Jornales, ayudantes y señaleros"

replace ciuo08=7221 if nombre_=="Enfierradores"
replace nombre_oficio4="Herreros y forjadores" if nombre_=="Enfierradores"

replace ciuo08=7114 if nombre_=="Concreteros"
replace nombre_oficio4="Operarios en cemento armado" if nombre_=="Concreteros"

replace ciuo08=7115 if nombre_=="Carpinteros"
replace nombre_oficio4="Carpinteros de obra" if nombre_=="Carpinteros"

replace ciuo08=9333 if nombre_=="Bodegueros y cardcheckers"
replace nombre_oficio4="Obreros de carga" if nombre_=="Bodegueros y cardcheckers"

replace ciuo08=7122 if nombre_=="Baldoseros y ceramistas"
replace nombre_oficio4="Instaladores de parqué, cerámicas, baldosas y alfombras" if nombre_=="Baldoseros y ceramistas"

replace ciuo08=7112 if nombre_=="Albañiles"
replace nombre_oficio4="Albañiles" if nombre_=="Albañiles"

save "$salida\Enadelpi_ocupaciones_2021.dta", replace
