clear all
set more off

global dir1 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\QP excel"
global salida "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado"


use "$salida\Enadelpi_2021.dta", clear
duplicates tag folio, gen(dup)
qui summ dup
local a=r(mean)
if `a'>0{
    gsort folio
	br if dup>0
	
}
replace folio=10561 if folio==10538 & region_que_levanta=="Biobío"
replace folio=10563 if folio==10540 & region_que_levanta=="Biobío"
replace folio=10564 if folio==10541 & region_que_levanta=="Biobío"
replace folio=11006 if folio==10966 & region_que_levanta=="Biobío"
br

drop dup
duplicates tag folio, gen(dup)
qui summ dup
local a=r(mean)
if `a'>0{
    gsort folio
	br if dup>0
	
}
drop dup

egen multiregion=rowtotal(region_opera_15-region_opera_12)
replace multiregion=0 if multiregion==1
replace multiregion=1 if multiregion>1 & multiregion!=.

gen region_operacion=.
forval i=1/16{
    replace region_operacion=`i' if region_opera_`i'==1 & multiregion==0	
}
replace region_operacion=20 if multiregion==1

# delimit ;
label define region_operacion
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
	20 "Multiregion", 
;
# delimit cr
label val region_operacion region_operacion

**el único proyecto multiregión tiene operaciones en maule y ñuble, pero el proyecto tiene nombre "REPOSICIÓN Y EQUIPAMIENTO SERVICIO MÉDICO LEGAL TALCA", preguntar a maule que onda	
br if multiregion==1
replace region_operacion=7 if folio==11283 //por ahora quedará en maule
drop if folio==11211 & nombre_informante=="Eduardo Lenners"

replace folio=10485 if folio==10462
replace folio=10486 if folio==10463 //en este folio se menciona que se lo adjudicó OTRA EMPRESA
//hay que pedir que si la empresa ejecutora es distinta a la del marco, que la actualicen, RUT y todo.
replace folio=10487 if folio==10464
replace folio=10488 if folio==10465
replace folio=11189 if folio==11141
replace folio=11212 if folio==11164
replace folio=112120 if folio==11212 & nombre_proyecto=="Programa de Pavimentación Participativa 29° Proceso de selección, Grupo 3-A, LP N°23"
**No encuentro ese proyecto folio=112120 en el marco, este folio es nuevo
**Hay regiones que están agregando los folios "nuevos" de proyectos detectados, pero no se han actualizado en las planillas, no están en las planillas

duplicates tag folio, gen(dup)
br if dup>0
replace folio=915 if folio==908 & nombre_informante=="Andres Reyes Sepulveda"
drop dup
duplicates tag folio, gen(dup)
br if dup>0

drop if folio==113 & fecha_encuesta=="15jul2021 15:34:55"
drop if folio==10550 & fecha_encuesta=="19apr2021 21:05:21"
drop dup
duplicates tag folio, gen(dup)
br if dup>0
drop fecha_encuesta dup


save "$salida\Enadelpi_2021.dta", replace

/*
merge 1:1 folio using "$salida\Enadelpi_2021_anterior.dta"
gen fecha_carga="19/07/2021" if _merge==1
replace fecha_carga="12/07/2021" if _merge==3
drop _merge
save "$salida\Enadelpi_2021.dta", replace




/*
use "$salida\Enadelpi_2021.dta", clear
keep if ser_contactado==1 | acceso_datos_funcionarios==1
gen sector_productivo=5 
label define sector_productivo 5 "Construcción"
label val sector_productivo sector_productivo

gen tamano=.

keep rut dv nombre_proyecto sector_productivo tamano nombre_informante cargo_informante correo_informante telefono_informante conocimiento_programas_* acceso_datos_funcionarios recibir_apoyo_* ser_contactado apoyo_contacto_* region_o

order rut dv nombre_proyecto sector_productivo tamano nombre_informante cargo_informante correo_informante telefono_informante conocimiento_programas_* acceso_datos_funcionarios recibir_apoyo_* ser_contactado apoyo_contacto_* region_o

rename nombre_proyecto empresa

save "$salida\contactos_enadel_enadelpi-v1.dta", replace

use "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\ENADEL\2021\BBDD\Consolidado\contactos_enadel_enadelpi.dta", clear
append using "$salida\contactos_enadel_enadelpi-v1.dta"




foreach r of numlist 1/16{
	preserve
	 keep if region_operacion==`r'
	 capture export excel "$salida\Contactos\ENADEL_2021_contactos_r`r'.xlsx", firstrow(varl) sheet("contactos") sheetreplace
		putexcel set "$salida\Contactos\ENADEL_2021_contactos_r`r'.xlsx", sheet("contactos") modify
		putexcel A1:L1, overwritefmt bold 
	restore
	
	
	
}
*/


