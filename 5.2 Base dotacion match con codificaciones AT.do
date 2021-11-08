use "$salida\Enadelpi_dotacion_2021.dta", clear

decode ocupacion, gen(nombre_2)
gen detalle_nombre2=nombre_puesto_extra_
gen tareas_2 = tareas_puesto_extra_

save "$salida\Enadelpi_dotacion_2021.dta", replace

use "$salida\Enadelpi_dotacion_2021.dta", clear
merge n:m folio nombre_2 tareas_2 using ///
"$dirx\codificacion_regiones_enadelpi2021.dta"
keep if _merge==3 | _merge==1
replace ciuo08=ciuo08_2 if _merge==3
replace nombre_pt_estandar=nombre_pt_estandarizado_2 if _merge==3
drop _merge
save "$dirx\Enadelpi_2021_con_cod.dta", replace


duplicates tag folio nom_proyecto etapa_proyecto ocupacion nombre_puesto_extra_ tareas_puesto_extra_ nt_cd_hoy_ nt_cd_prox12m_, gen(dup)
br if dup>0 & ciuo08!=.

duplicates drop folio nom_proyecto etapa_proyecto ocupacion nombre_puesto_extra_ tareas_puesto_extra_ nt_cd_hoy_ nt_cd_prox12m_ if ciuo08!=., force

gen ciuo08_vf=ciuo08
gen nombre_pt_estandar_vf=nombre_pt_estandar

merge n:m folio ocupacion nombre_puesto_extra_ tareas_puesto_extra_ nom_proyecto using /// 
"$salida\Enadelpi_dotacion_2021.dta"
replace ciuo08=ciuo08_vf if _merge==3
replace nombre_pt_estandar=nombre_pt_estandar_vf if _merge==3
drop _merge
save "$salida\Enadelpi_dotacion_2021.dta", replace


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

gen nombre_=nombre_2

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


drop if nombre_puesto_extra_=="" & tareas_puesto_extra_==""
gen sector_productivo="Construcción"
gen ciiuRev4="F"

foreach r of numlist 1/16{


	export excel folio sector_productivo ciiuRev4  ///
	using "$dirk\Planillas codificación regiones\Planilla de codificación ocupaciones ENADELPI 2021 - copia (`r').xlsx" ///
	if region_que_levanta==`r', ///
    sheet("Puestos M. Datos proyecto") sheetmodify  cell(A2) keepcellfmt 
	
	export excel ciuo08 nivel_confianza_ciuo08 nombre_pt_estandar ocupacion nombre_puesto_extra_ ///
	tareas_puesto_extra ///
	nom_proyecto ///
	using "$dirk\Planillas codificación regiones\Planilla de codificación ocupaciones ENADELPI 2021 - copia (`r').xlsx" ///
	if region_que_levanta==`r', ///
	sheet("Puestos M. Datos proyecto") sheetmodify cell(E2) keepcellfmt 
	
	
}


