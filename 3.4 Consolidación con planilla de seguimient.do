clear all
set more off

global dir0 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD"
global dir1 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Planillas de verificación\Muestra\Planillas finales"

global dir2 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado\Contactos"

foreach i of numlist 1/16{
import excel "$dir1\R`i' - Planilla de verificacion y seguimiento ENADELPI 2021.xlsx", sheet("Verificación y levantamiento") cellrange(A2) firstrow clear
dis "`i'"
 set seed 1
 capture replace Folioidencuesta="" if Folioidencuesta=="-"
 capture destring Folioidencuesta, replace
 drop if Folioidencuesta==.
 *if `i'==13{
 	
 	capture replace Rutempresa="" if Rutempresa=="######" | Rutempresa=="s/i"
	capture replace Rutempresa=subinstr(Rutempresa,".","",.)  
	//quitar puntos
	capture replace Rutempresa=subinstr(Rutempresa,"  ","",.)  
	//quitar espacios internos
	capture replace Rutempresa=subinstr(Rutempresa,",","",.)  
	//quitar comas
	capture replace Rutempresa=strtrim(Rutempresa)
	capture gen byte non_numeric = indexnot(Rutempresa, "0123456789.-")
	capture list Rutempresa if non_numeric
	if _rc==0 list Rutempresa if non_numeric
    if `i'==13 replace Rutempresa="76011422" if non_numeric
	
* } 
 destring Rutempresa Fechainicio Fechafin, replace
 gen region_planilla=`i'
 if `i'==1 save "$dir1\Seguimiento_ENADELPI_2021.dta", replace
 else{
     append using "$dir1\Seguimiento_ENADELPI_2021.dta", force
	 save "$dir1\Seguimiento_ENADELPI_2021.dta", replace
 } 
	
}

foreach vars of varlist AP-AG{
    tab `vars'
	
}

replace AL=Enprocesodeagendar2Agen if AL==. & Enprocesodeagendar2Agen!=.

order region_planilla, after(Regióndelproyecto)

keep Encuestador Folioidencuesta Prioridadenlevantamiento Sector Subsector Rutempresa Dv Nombreempresa Nombredelproyecto Nombredelaobrasoloaplicap Fechainicio Fechafin Montoproyectoenmillonesdepe Montoproyectoenmillonesdedó Regióndelproyecto Empresaconmásdeunproyectoe Empresaconproyectosenmásde Nombrecontacto1 Cargocontacto1 telefonocontacto1 emailcontacto1 Nombrecontacto2 Cargocontacto2 telefonocontacto2 emailcontacto2 nombreinformanteidóneo cargoinformanteidóneo fono1informanteidóneo fono2informanteidóneo emailinformanteidóneo Etapadelproyecto1Enobras Nohanempezadolasobrasdecon Empresacontactadaentregada AL Observaciones Encuestavalidadaporsupervi region_planilla Público2Privado 

rename Público2Privado fuente_financiamiento

drop if Encuestador=="PROYECTO SE ENCUENTRA EN RM"
replace Folioidencuesta=1134570 if Sector=="Forestal" & Folioidencuesta==113457

rename AL estado_encuesta

label define estado_encuesta 1 "1: En proceso de agendar" 2 "2: Agendada" ///
3 "3: Aplicada parcialmente" 4 "4: Aplicada y finalizada" 5 "5: Rechazada" ////
6 "6: Fuera de población objetivo" 7 "7: Sin contacto"
label val estado_encuesta estado_encuesta

rename Empresacontactadaentregada estado_contacto
label define estado_contacto 1 "1: Empresa contactada entrega datos informante del proyecto." ///
2 "2: Empresa contactada pero no entrega datos informante del proyecto." ///
3 "3: Contacto de empresa no responde." ///
4 "4: No se encuentra ningún contacto de la empresa." ///
5 "5: Empresa señala que el proyecto aún no se la han adjudicado." ////
6 "6: Empresa señala que no tiene relación con el proyecto." 

label val estado_contacto estado_contacto

rename Encuestavalidadaporsupervi estado_supervision
label define estado_supervision 1 "1: Encuesta validada por supervisor" ///
2 "2: Encuesta no validada por el supervisor" ///                                                                             
3 "3: Encuesta aún no revisada por el supervisor"
label val estado_supervision estado_supervision
 
 
duplicates tag Folioidencuesta, gen(dup0) 
br if dup0>0

***ESTO ES CASO A CASO, POR ENDE HAY QUE REVISAR SI APLICA EFECTIVAMENTE CON LAS ACTUALIZACIONES
**confirmar si reposición de aceras es vialidad
replace Subsector="Obras de Vialidad" if inlist(Folioidencuesta,1101,1103,1104) 
duplicates drop Folioidencuesta if Folioidencuesta==1382, force
replace Folioidencuesta=1701 if Folioidencuesta==1101 & region_planilla==10
replace Folioidencuesta=1703 if Folioidencuesta==1103 & region_planilla==10
replace Folioidencuesta=1704 if Folioidencuesta==1104 & region_planilla==10

rename Folioidencuesta folio


duplicates tag folio,gen(dup)
br if dup>0 
replace folio=1038520 if folio==103852 & Nombredelproyecto=="CONSTRUCCIÓN CAMINO CALETA EUGENIA- PUERTO TORO, TRAMO I, XII REGION"
replace folio=11259000 if folio==11259 & Rutempresa==93706000


drop dup

keep folio Sector Subsector Rutempresa Dv Nombreempresa Nombredelproyecto Regióndelproyecto region_planilla Etapadelproyecto1Enobras estado_contacto estado_encuesta fuente_financiamiento

merge 1:1 folio using "$dir0\Consolidado\Enadepi_2021.dta"
br if _merge==2
replace estado_encuesta=4 if _merge==3 & (estado_encuesta!=4 & estado_encuesta!=3)



**achico el ancho de todas las variables strings
qui ds *, has(type string)
foreach x of varlist `=r(varlist)' {
   format `x' %12s
}

*keep if estado2==4

replace estado_encuesta=. if estado_encuesta==4 & _merge==1 //está sólo en excels y no es QP

foreach va of varlist Nombreempresa Nombredelproyecto {
	*gen aux_`va'=strtrim(`va') //remover espacios adelante y atrás del texto
	gen aux_`va'=subinstr(ustrlower(ustrregexra(ustrnormalize(strtrim(`va'), "nfd"), "\p{Mark}", "")), " ", "", .)
	//a minusculas y quitar acentos
	*replace aux_`va'=subinstr(`va', " ", "", .) //remover espacios entre medio	
}

replace Nombreempresa="Constructora Bravo Izquierdo Dlp Limitada" if Nombreempresa=="bravoizquierdo" & folio==11259
replace Rutempresa=78709650 if folio==11259 //cambió empresa ejecutora, no se levantó Rut, confirmar rut encontrado en internet https://www.genealog.cl/Geneanexus/empresa/CHILE/TNzg3TwMDk2NTAtNg-jTw/nombre-y-rut/CONSTRUCTORA-BRAVO-IZQUIERDO-D-L-P-LIMITADA-78709650-6#gsc.tab=0&gsc.q=Constructora%20Bravo%20Izquierdo%20D%20L%20P%20Limitada

replace Dv="6" if folio==11259
replace Nombreempresa="CONSTRUCTORA TECTON SPA" if aux_Nombreempresa=="tecton" & folio==11069
replace Rutempresa=76407152 if folio==11069 

////cambió empresa ejecutora, pero no se reportó en observaciones y no se levantó Rut, confirmar rut encontrado en internet 

replace Dv="2" if folio==11069

replace Nombreempresa="VECCHIOLA INGENIERIA Y CONSTRUCCION S.A (VICCSA)" if aux_Nombreempresa=="viccsa" & folio==109052
replace Rutempresa=76129826 if folio==109052
replace Dv="7" if folio==109052 ///////cambió empresa ejecutora, pero no se reportó en observaciones y no se levantó Rut, confirmar rut encontrado en internet 

label var etapa_proyecto "Etapa del proyecto informado en proceso de verificación"
label var nombre_proyecto "Nombre del proyecto indicado por el informante idóneo"
label var region_operacion "Región donde opera el proyecto"

gen orden_region=region_operacion
replace orden=0.5 if region_operacion==15
replace orden=5.5 if region_operacion==13
replace orden=7.5 if region_operacion==16
replace orden=9.5 if region_operacion==14
gsort orden_region

drop orden_region

replace Rutempresa=89126400 if folio==1504
replace Dv="3" if folio==1504
replace Nombreempresa="San Felipe S.A" if inlist(folio,1504,1502)
replace Nombreempresa="Constructora 2 TH Ltda." if inlist(folio,1501)

replace Subsector="Edificación No Residencial" if inlist(folio,1201,1203,1207,1206,1202, 102,103,105,502,1432,1414,1421,1420,1402,1410,1434,1091,1097,1092)
replace Subsector="Parques y plazas" if inlist(folio,1413)
replace Subsector="" if Subsector=="DOM"
replace Sector="Obras Públicas" if folio==1361

replace Rutempresa=79730880 if folio==403
replace Subsector="Obras Hidráulicas" if folio==403
replace Subsector="Obras de Vialidad" if inlist(folio,202,1435,1480,1030,333,1034,1204,1205)
replace Subsector="Obras Sanitarias" if inlist(folio,702)
replace Rutempresa=77257280 if folio==702
replace Subsector="Edificación No Residencial" if inlist(folio,1445,1401,1701,1093,1076,1064,1096)
replace Subsector="Obras Hidráulicas" if inlist(folio,1361,1022)
replace Subsector="Edificación Residencial" if inlist(folio,927,1404,1408,1418)
replace Subsector="Obras Portuarias" if inlist(folio,1403)

 	
//https://www.mercadopublico.cl/Procurement/Modules/RFB/DetailsAcquisition.aspx?qs=PUVAb71a4ikx+5S/6V0Hog==



label var region_que_levanta "Región que levantó la encuesta"

br if region_que_levanta=="O'higgins" & region_operacion==7

*keep Rutempresa Dv Nombreempresa nombre_proyecto Sector Subsector nombre_informante cargo_informante correo_informante telefono_informante acceso_datos_funcionarios ser_contactado _merge region_operacion

gsort -_merge

*drop _merge

*keep if _merge==3
br if _merge==2

label var region_operacion "Región"
label var Rutempresa "Rut"
label var Dv "dv"
label var Nombreempresa "Nombre empresa"


label var acceso_datos "Consentimiento para que SENCE use los datos"
label var ser_contactado "Querer ser contactado por SENCE"

save "$dir1\Consolidación_planillas_final.dta", replace


	keep if _merge==3
	drop _merge
	
	label var acceso_datos "Consentimiento para que SENCE use los datos"
	label var ser_contactado "Querer ser contactado por SENCE"

	label var recibir_apoyo_4_texto "Otro:¿cuál?"
	label var apoyo_contacto_4_texto "Otro:¿cuál?"
	
	drop aux_Nombreempresa aux_Nombredelproyecto
	
	save "$dir0\Consolidado\Enadelpi_2021.dta", replace

	
	
	
	keep if acceso_datos_funcionarios==1 | ser_contactado==1	

	keep region_operacion Rutempresa Dv Nombreempresa nombre_proyecto Sector Subsector nombre_informante cargo_informante correo_informante telefono_informante ///
	conocimiento_programas_* acceso_datos_funcionarios recibir_apoyo_* ser_contactado apoyo_contacto_* 
	
	order region_operacion Rutempresa Dv Nombreempresa nombre_proyecto Sector Subsector nombre_informante cargo_informante correo_informante telefono_informante ///
	conocimiento_programas_* acceso_datos_funcionarios recibir_apoyo_* ser_contactado apoyo_contacto_* 

	


foreach r of numlist 1/16{
	preserve
	 keep if region_operacion==`r'
	 export excel "$dir2\ENADELPI_2021_contactos_r`r'.xlsx", cell(A2) firstrow(varl) sheet("contactos") sheetreplace 
		putexcel set "$dir2\ENADELPI_2021_contactos_r`r'.xlsx", sheet("contactos") modify
		putexcel A2:BF2, overwritefmt bold 
		putexcel L1="Uso y conocimiento de"
		putexcel L1:R1, overwritefmt hcenter merge bold shrink
		putexcel T1="Acceso a datos: ¿En qué ámbitos específicos le gustaría recibir apoyo?"
		putexcel T1:X1, overwritefmt hcenter merge bold shrink
		putexcel Z1="Ser contactado: ¿En qué ámbitos específicos le gustaría recibir apoyo?"
		putexcel Z1:AD1, overwritefmt hcenter merge bold shrink
	restore
	
	
}





/*

keep folio Sector Subsector Rutempresa Dv

save "$dir0\Planillas de verificación\Consolidado y resultados\Listado_folios_proyectos_con_datos_de_empresa.dta", replace