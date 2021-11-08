
global dirx "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\ENADEL\2021\Codificación ocupaciones\Codificación AT"
global salida "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado"
global dirk "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\Codificación"

**AT
{
use "$dirx\codificacion_regiones_enadelpi2021.dta", clear

keep folio ciuo08 nombre_puesto nombre_pt_estandarizado tareas_puesto certificaciones nivel_educativo experiencia competencias 
rename (nombre_puesto tareas_puesto certificaciones nivel_educativo  experiencia competencias) ///
(nombre_ tareas_ certificacion_ educ_ exper_ glosa_dificultad_)


gsort folio ciuo08 nombre_pt_estandarizado nombre_ tareas_ certificacion_ educ_ exper_ glosa_dificultad_
replace exper_="1" if exper_=="No se requiere experiencia"
replace exper_="2" if exper_=="1 a 2 años"
replace exper_="3" if exper_=="3 a 5 años"
replace exper_="4" if exper_=="Más de 5 años"

replace educ_="1" if educ_=="Sin requisito"
replace educ_="2" if educ_=="Básica completa"
replace educ_="3" if educ_=="Media"
replace educ_="4" if educ_=="Media técnico profesional"
replace educ_="5" if educ_=="Técnico nivel superior"
replace educ_="6" if educ_=="Profesional o más"

rename exper_ exper_2
rename educ_ educ_2

replace educ_2="1" if educ_2=="Sin requisito"
replace educ_2="2" if educ_2=="Básica completa" | educ_2=="Basica completa" | educ_2=="Basica completa " 
replace educ_2="3" if educ_2=="Media" | educ_2=="Media "  | educ_2=="Educación Media Científico Humanista" ///
| educ_2=="Bascia Completa, Media"
replace educ_2="4" if educ_2=="Media técnico profesional" | educ_2=="Educación Media Técnico Profesional"
replace educ_2="5" if educ_2=="Técnico nivel superior" | educ_2=="Técnico Nivel Superior"
replace educ_2="6" if educ_2=="Profesional o más" | educ_2=="Profesional"


replace exper_2="1" if exper_2=="No se requiere experiencia" | exper_2=="1 año" | exper_2=="No se requiere experiencia previa"
replace exper_2="2" if exper_2=="1 a 2 años" | exper_2=="2 años"
replace exper_2="3" if exper_2=="3 a 5 años" | exper_2=="3 años" | exper_2=="3 años "
replace exper_2="4" if exper_2=="Más de 5 años" | exper_2=="4 años" | exper_2=="Más de 5 años."


duplicates tag folio ciuo08 nombre_ tareas_ certificacion_ educ_2 exper_2 glosa_dificultad_, gen(dup)
br if dup>0
duplicates drop folio ciuo08 nombre_ tareas_ certificacion_ educ_2 exper_2 glosa_dificultad_, force

drop dup
rename ciuo08 ciuo08_2
rename nombre_ nombre_2
rename tareas_ tareas_2
rename certificacion_ glosa_licencia_2
rename glosa_dificultad_ glosa_dificultad_2
rename nombre_pt_estandarizado nombre_pt_estandarizado_2
save "$dirx\codificacion_regiones_enadelpi2021.dta", replace
}
****

use "$salida\Enadelpi_ocupaciones_2021.dta", clear
		
		
gen exper_2 =experiencia_
gen educ_2 = educ_
gen nombre_2 = nombre_
gen detalle_nombre2=detalle_nombre_
gen tareas_2 = detalle_tareas_
gen glosa_licencia_2 = glosa_licencia_


tostring exper_2 educ_2, replace

replace educ_2="1" if educ_2=="Sin requisito"
replace educ_2="2" if educ_2=="Básica completa" | educ_2=="Basica completa"
replace educ_2="3" if educ_2=="Media" | educ_2=="Media "  | educ_2=="Educación Media Científico Humanista" ///
| educ_2=="Bascia Completa, Media"
replace educ_2="4" if educ_2=="Media técnico profesional" | educ_2=="Educación Media Técnico Profesional"
replace educ_2="5" if educ_2=="Técnico nivel superior" | educ_2=="Técnico Nivel Superior"
replace educ_2="6" if educ_2=="Profesional o más" | educ_2=="Profesional"


replace exper_2="1" if exper_2=="No se requiere experiencia" | exper_2=="1 año" | exper_2=="No se requiere experiencia previa"
replace exper_2="2" if exper_2=="1 a 2 años" | exper_2=="2 años"
replace exper_2="3" if exper_2=="3 a 5 años" | exper_2=="3 años" | exper_2=="3 años "
replace exper_2="4" if exper_2=="Más de 5 años" | exper_2=="4 años" | exper_2=="Más de 5 años."

save "$salida\Enadelpi_ocupaciones_2021.dta", replace

use "$salida\Enadelpi_ocupaciones_2021.dta", clear
merge n:m folio nombre_2 tareas_2 glosa_licencia_2 educ_2 exper_2 using ///
"$dirx\codificacion_regiones_enadelpi2021.dta"
keep if _merge==3 | _merge==1
replace ciuo08=ciuo08_2 if _merge==3
replace nombre_pt_estandar=nombre_pt_estandarizado_2 if _merge==3
drop _merge
save "$dirx\Enadelpi_2021_con_cod_v1.dta", replace


use "$salida\Enadelpi_ocupaciones_2021.dta", clear
merge n:m folio nombre_2 tareas_2 glosa_licencia_2 educ_2 using "$dirx\codificacion_regiones_enadelpi2021.dta"
keep if _merge==3 | _merge==1
replace ciuo08=ciuo08_ if _merge==3
replace nombre_pt_estandar=nombre_pt_estandarizado_2 if _merge==3
drop _merge
save "$dirx\Enadelpi_2021_con_cod_v2.dta", replace

use "$salida\Enadelpi_ocupaciones_2021.dta", clear
merge n:m folio nombre_2 tareas_2 educ_2 using "$dirx\codificacion_regiones_enadelpi2021.dta"
keep if _merge==3 | _merge==1
replace ciuo08=ciuo08_ if _merge==3
replace nombre_pt_estandar=nombre_pt_estandarizado_2 if _merge==3
drop _merge
save "$dirx\Enadelpi_2021_con_cod_v3.dta", replace

use "$salida\Enadelpi_ocupaciones_2021.dta", clear
merge n:m folio nombre_2 tareas_2 using "$dirx\codificacion_regiones_enadelpi2021.dta"
keep if _merge==3 | _merge==1
replace ciuo08=ciuo08_ if _merge==3
replace nombre_pt_estandar=nombre_pt_estandarizado_2 if _merge==3
drop _merge
save "$dirx\Enadelpi_2021_con_cod_v4.dta", replace

use "$dirx\Enadelpi_2021_con_cod_v1.dta", clear
merge n:m folio ciuo08 nombre_pt_estandar nombre_2 tareas_2 educ_2 exper_2 using "$dirx\Enadelpi_2021_con_cod_v2.dta"
keep if _merge==3 | _merge==2
drop _merge
merge n:m folio ciuo08 nombre_pt_estandar nombre_2 tareas_2 educ_2 exper_2 using "$dirx\Enadelpi_2021_con_cod_v3.dta"
keep if _merge==3 | _merge==2
drop _merge
merge n:m folio ciuo08 nombre_pt_estandar nombre_2 tareas_2 educ_2 exper_2 using "$dirx\Enadelpi_2021_con_cod_v4.dta"
keep if _merge==3 | _merge==2
drop _merge

save "$dirx\Enadelpi_2021_con_cod_final.dta", replace
erase "$dirx\Enadelpi_2021_con_cod_v1.dta"
erase "$dirx\Enadelpi_2021_con_cod_v2.dta"
erase "$dirx\Enadelpi_2021_con_cod_v3.dta"
erase "$dirx\Enadelpi_2021_con_cod_v4.dta"

duplicates tag folio nombre_ detalle_tareas_ glosa_licencia_ educ_ experiencia_ principal_dificultad_, gen(dup)
gsort folio nombre_ detalle_tareas_ glosa_licencia_ educ_ experiencia_ principal_dificultad_
br if dup>0 & ciuo08!=.

duplicates drop folio nombre_ detalle_tareas_ glosa_licencia_ educ_ experiencia_ principal_dificultad_ if ciuo08!=., force

gen ciuo08_vf=ciuo08
gen nombre_pt_estandar_vf=nombre_pt_estandar

merge n:m folio nombre_ detalle_tareas_ glosa_licencia_ educ_ experiencia_ principal_dificultad_ using ///
"$salida\Enadelpi_ocupaciones_2021.dta"
replace ciuo08=ciuo08_vf if _merge==3
replace nombre_pt_estandar=nombre_pt_estandar_vf if _merge==3
drop _merge
duplicates drop folio nombre_pt_estandar ciuo08 nombre_ detalle_tareas_ glosa_licencia_ educ_ experiencia_ principal_dificultad_ , force
merge n:m folio nombre_ detalle_tareas_ glosa_licencia_ educ_ principal_dificultad_ using ///
"$salida\Enadelpi_ocupaciones_2021.dta"


save "$dirx\Enadelpi_2021_con_cod_final.dta", replace

use "$dirx\Enadelpi_2021_con_cod_final.dta", clear

encode region_que_levanta, gen(region_levantamiento)
drop region_que_levanta
recode region_levantamiento (2=15) (14=1) (1=2) (3=3) ///
(6=4) (15=5) (12=13) (13=6) (11=7) (16=16) (5=8) (7=9) ///
(9=14) (8=10) (4=11) (10=12), gen(region_que_levanta)

# delimit ;
label define region_que_levanta
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
	16 "Región del Ñuble"
;
# delimit cr

label val region_que_levanta region_que_levanta
drop if puesto=="informante"
encode puesto, gen(id_puesto2)


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


drop if detalle_nombre_=="" & detalle_tareas_==""
gen sector_productivo="Construcción"
gen ciiuRev4="F"
*replace nivel_confianza_ciuo08=""
gsort folio id_puesto2

foreach r of numlist 1/16{


	export excel folio sector_productivo ciiuRev4  ///
	using "$dirk\Planillas codificación regiones\Planilla de codificación ocupaciones ENADELPI 2021 - copia (`r').xlsx" ///
	if region_que_levanta==`r', ///
    sheet("Puesto M. Vacantes") sheetmodify  cell(A2) keepcellfmt 
	
	export excel ciuo08 nivel_confianza_ciuo08 nombre_pt_estandar puesto nombre_ detalle_nombre_ ///
	detalle_tareas_ glosa_licencia_ educ_ experiencia_ nom_proyecto ///
	using "$dirk\Planillas codificación regiones\Planilla de codificación ocupaciones ENADELPI 2021 - copia (`r').xlsx" ///
	if region_que_levanta==`r', ///
	sheet("Puesto M. Vacantes") sheetmodify cell(E2) keepcellfmt 
	
	
}


