clear all
set more off

global dir1 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\QP excel"
global salida "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado"

**Antigua Enadelpi_2021**
*use "$salida\Enadelpi_2021.dta", clear
*keep folio fecha_carga
*save "$salida\Enadelpi_2021_anterior.dta", replace

local aux=1
local files : dir "$dir1" files "*.xlsx", respectcase
foreach file of local files {
quietly{
  import excel using "$dir1\\`file'", sheet("Datos sin procesar") case(lower) clear
  drop if _n==1   //elimino nombre de columnas
  local x=1
  foreach v of varlist *{
  	rename `v' v`x'
	local `++x'
  }
  
  noisily dis "`file'"
  foreach var of numlist 66/117 121(4)141 122(4)142 148/255 259(6)289 260(6)290 261(6)291 262(6)292 345/349{
      
	  *local var=66
	  
	  replace v`var'=ustrlower(v`var')
	  replace v`var'="35" if v`var'=="entre 30 y 40"
	  replace v`var'="45" if v`var'=="40-50"
	  replace v`var'="17" if v`var'=="15-20"
	  replace v`var'="4" if v`var'=="4-5"
	  replace v`var'="9" if v`var'=="8-10"
	  replace v`var'="3" if v`var'=="3-4"
	  replace v`var'="5" if v`var'=="5-6"
	  replace v`var'="7" if v`var'=="6-8"
	  replace v`var'="5" if v`var'=="4-6"
	  replace v`var'="12" if v`var'=="10 a 15"
	  replace v`var'="110" if v`var'=="100-120"
	  replace v`var'="12" if v`var'=="15 a un 20% de 60"   //20% de 60 es 12 	  
  	  replace v`var'="11" if v`var'=="10-12"
  	  replace v`var'="102" if v`var'=="30% de 340"	  
  	  replace v`var'="16" if v`var'=="40% de 40"
	  replace v`var'="4" if v`var'=="04"
	  replace v`var'="0" if inlist(v`var', "´0","'0")
	  replace v`var'="" if inlist(v`var', "ns","nr","na","x","o","si","2 b y c","45 xmes","40%") | v`var'=="50%"
      destring v`var', replace force
  
  }
  
  
   destring v18 v21 v34-v49 v51-v55 v61-v65 v66-v118 v143 v256 v294-v305 ///
   v307 v309 v311 v313 v325-v334 v335 v337 v339 v341 v343 v345-v350 ///
   v352 v354 v356 v358 v360-v389 v391-v400 v402-v404 v406 v414-v420 ///
   v422-v425 v427-v430, replace
   ///v401 "Otra" podría ser texto
   drop v1-v3 v5-v17 v20 v22-v28 v56-v60 v293 v390 v421
   
   ///Introducción y módulo A///
   rename v4 fecha_encuesta
   rename v18 folio
   rename v19 nombre_encuestador
   rename v21 pregunta_consentimiento
   rename v29 nombre_informante
   rename v30 cargo_informante
   rename v31 correo_informante
   rename v32 telefono_informante
   rename v33 nombre_proyecto
   
	label var folio "Folio encuesta"
	label var nombre_encuestador "Nombre encuestador que aplica instrumento"
	label var pregunta_consentimiento "¿Acepta participar de la encuesta?"
	label var nombre_informante "Nombre informante"
	label var cargo_informante "Cargo informante"
	label var correo_informante "Correo electrónico informante"
	label var telefono_informante "Telefono informante"
	label var nombre_proyecto "Nombre del proyecto indicado por informante"

	label define pregunta_consentimiento 1 "Sí"
	label val pregunta_consentimiento pregunta_consentimiento
   
   ***Regiones donde opera el proyecto
   rename v34 region_opera_15
   rename v35 region_opera_1
   rename v36 region_opera_2
   rename v37 region_opera_3
   rename v38 region_opera_4
   rename v39 region_opera_5
   rename v40 region_opera_13
   rename v41 region_opera_6
   rename v42 region_opera_7
   rename v43 region_opera_16
   rename v44 region_opera_8
   rename v45 region_opera_9
   rename v46 region_opera_14
   rename v47 region_opera_10
   rename v48 region_opera_11
   rename v49 region_opera_12
     
	label var region_opera_15 "Opera en Arica y Parinacota"
	label var region_opera_1 "Opera en Tarapacá"
	label var region_opera_2 "Opera en Antofagasta"
	label var region_opera_3 "Opera en Atacama"
	label var region_opera_4 "Opera en Coquimbo"
	label var region_opera_5 "Opera en Valparaíso"
	label var region_opera_13 "Opera en Metropolitana"
	label var region_opera_6 "Opera en O'higgins"
	label var region_opera_7 "Opera en Maule"
	label var region_opera_16 "Opera en Ñuble"
	label var region_opera_8 "Opera en Biobío"
	label var region_opera_9 "Opera en La Araucanía"
	label var region_opera_14 "Opera en Los Ríos"
	label var region_opera_10 "Opera en Los Lagos"
	label var region_opera_11 "Opera en Aysén"
	label var region_opera_12 "Opera en Magallanes"
	
	forval i=1/16{
		label define region_opera_`i' 1 "Sí"
		label val region_opera_`i' region_opera_`i'
		
	}
	
   
   ***Comuna donde opera el proyecto
   rename v50 comuna_opera_texto
   label var comuna_opera_texto "Comuna que concentra la mayor parte de las obras"
   rename v51 monto_inversion_pesos
   rename v52 monto_inversion_dolares
   rename v53 monto_inversion_NoResponde
   rename v54 monto_inversion_NoSabe
   
   label var monto_inversion_pesos "Presupuesto para ejecutar las obras o monto de contrato (millones de pesos)"
   label var monto_inversion_dolares "Presupuesto para ejecutar las obras o monto de contrato (millones de dólares)"
   label var monto_inversion_NoSabe "Informante NO SABE sobre monto presupuesto o contrato"
   label var monto_inversion_NoResponde "Informante NO RESPONDE sobre monto presupuesto o contrato"
 
	rename v55 es_informante_idoneo
	label var es_informante_idoneo "¿Maneja información de puestos de trabajo y procesos de reclutamiento?"
	
	rename v61 etapa_proyecto
	label var etapa_proyecto "¿En qué etapa de desarrollo se encuentran las obras asociadas al proyecto?"
	label define etapa_proyecto 1 "Aún no comienzan las obras" ///
	2 "Ya empezaron las obras"
	label val etapa_proyecto etapa_proyecto
	
	rename (v62 v63 v64 v65) (a1_ano a1_mes a2_ano a2_mes)
	label var a1_ano "¿En qué año proyecta que van a empezar las contrataciones para el proyecto?" 
	label var a1_mes "¿Y en qué mes? "
	label var a2_ano "¿Y en qué año proyecta que van a concluir las obras de construcción?"
	label var a2_mes "¿Y en qué mes? "

	label define a1_ano 1 "2021" 2 "2022" 3 "2023" 4 "2024 o más"
	label val a1_ano a1_ano
	label define a2_ano 1 "2021" 2 "2022" 3 "2023" 4 "2024" 5 "2025" 6 "2026 o más"
	label val a2_ano a2_ano
	label define a1_mes 1 "Enero"
	label val a1_mes a1_mes
	label define a2_mes 1 "Enero"
	label val a2_mes a2_mes

	label define a1_mes 1  "Enero", modify
	label define a1_mes 2  "Febrero", modify
	label define a1_mes 3  "Marzo", modify
	label define a1_mes 4  "Abril", modify
	label define a1_mes 5  "Mayo", modify
	label define a1_mes 6  "Junio", modify
	label define a1_mes 7  "Julio", modify
	label define a1_mes 8  "Agosto", modify
	label define a1_mes 9  "Septiembre", modify
	label define a1_mes 10  "Octubre", modify
	label define a1_mes 11  "Noviembre", modify
	label define a1_mes 12  "Diciembre", modify
	label define a2_mes 1  "Enero", modify
	label define a2_mes 2  "Febrero", modify
	label define a2_mes 3  "Marzo", modify
	label define a2_mes 4  "Abril", modify
	label define a2_mes 5  "Mayo", modify
	label define a2_mes 6  "Junio", modify
	label define a2_mes 7  "Julio", modify
	label define a2_mes 8  "Agosto", modify
	label define a2_mes 9  "Septiembre", modify
	label define a2_mes 10  "Octubre", modify
	label define a2_mes 11  "Noviembre", modify
	label define a2_mes 12  "Diciembre", modify

	///Módulo B////
	
	//Dotación: 
	
	rename (v66 v67) (e1_nt_contratados_total_prox12m e1_nt_subcontrato_total_prox12m)
	label var e1_nt_contratados_total_prox12m "Etapa1 Cantidad de trabajadores que se requerirán primeros 12 meses (contrato directo)"
	label var e1_nt_subcontrato_total_prox12m "Etapa1 Cantidad de trabajadores que se requerirán primeros 12 meses (subcontrato)"

	rename v68 e1_nt_contratados_prox12m_1
	rename v69 e1_nt_subcontrato_prox12m_1
	rename v70 e1_nt_contratados_prox12m_2
	rename v71 e1_nt_subcontrato_prox12m_2
	rename v72 e1_nt_contratados_prox12m_3
	rename v73 e1_nt_subcontrato_prox12m_3
	rename v74 e1_nt_contratados_prox12m_4
	rename v75 e1_nt_subcontrato_prox12m_4
	rename v76 e1_nt_contratados_prox12m_5
	rename v77 e1_nt_subcontrato_prox12m_5
	rename v78 e1_nt_contratados_prox12m_6
	rename v79 e1_nt_subcontrato_prox12m_6
	rename v80 e1_nt_contratados_prox12m_7
	rename v81 e1_nt_subcontrato_prox12m_7
	rename v82 e1_nt_contratados_prox12m_8
	rename v83 e1_nt_subcontrato_prox12m_8
	rename v84 e1_nt_contratados_prox12m_9
	rename v85 e1_nt_subcontrato_prox12m_9
	rename v86 e1_nt_contratados_prox12m_10
	rename v87 e1_nt_subcontrato_prox12m_10
	rename v88 e1_nt_contratados_prox12m_11
	rename v89 e1_nt_subcontrato_prox12m_11
	rename v90 e1_nt_contratados_prox12m_12
	rename v91 e1_nt_subcontrato_prox12m_12
	rename v92 e1_nt_contratados_prox12m_13
	rename v93 e1_nt_subcontrato_prox12m_13
	rename v94 e1_nt_contratados_prox12m_14
	rename v95 e1_nt_subcontrato_prox12m_14
	rename v96 e1_nt_contratados_prox12m_15
	rename v97 e1_nt_subcontrato_prox12m_15
	rename v98 e1_nt_contratados_prox12m_16
	rename v99 e1_nt_subcontrato_prox12m_16
	rename v100 e1_nt_contratados_prox12m_17
	rename v101 e1_nt_subcontrato_prox12m_17
	rename v102 e1_nt_contratados_prox12m_18
	rename v103 e1_nt_subcontrato_prox12m_18
	rename v104 e1_nt_contratados_prox12m_19
	rename v105 e1_nt_subcontrato_prox12m_19
	rename v106 e1_nt_contratados_prox12m_20
	rename v107 e1_nt_subcontrato_prox12m_20
	rename v108 e1_nt_contratados_prox12m_21
	rename v109 e1_nt_subcontrato_prox12m_21
	rename v110 e1_nt_contratados_prox12m_22
	rename v111 e1_nt_subcontrato_prox12m_22
	rename v112 e1_nt_contratados_prox12m_23
	rename v113 e1_nt_subcontrato_prox12m_23
	rename v114 e1_nt_contratados_prox12m_24
	rename v115 e1_nt_subcontrato_prox12m_24
	rename v116 e1_nt_contratados_prox12m_25
	rename v117 e1_nt_subcontrato_prox12m_25
		
	label var e1_nt_contratados_prox12m_1 "Etapa1 No. trab. Contrato directo prox 12 meses: Encargados de obra (administradores de obra, jefes de terreno, encargados de bodega, etc.)"
	label var e1_nt_subcontrato_prox12m_1 "Etapa1 No. trab. Subcontrato prox 12 meses:Encargados de obra (administradores de obra, jefes de terreno, encargados de bodega, etc.)"
	label var e1_nt_contratados_prox12m_2 "Etapa1 No. trab. Contrato directo prox 12 meses: Capataces"
	label var e1_nt_subcontrato_prox12m_2 "Etapa1 No. trab. Subcontrato prox 12 meses:Capataces"
	label var e1_nt_contratados_prox12m_3 "Etapa1 No. trab. Contrato directo prox 12 meses: Electrónicos, electromecánicos e instrumentistas"
	label var e1_nt_subcontrato_prox12m_3 "Etapa1 No. trab. Subcontrato prox 12 meses:Electrónicos, electromecánicos e instrumentistas"
	label var e1_nt_contratados_prox12m_4 "Etapa1 No. trab. Contrato directo prox 12 meses: Laboratoristas"
	label var e1_nt_subcontrato_prox12m_4 "Etapa1 No. trab. Subcontrato prox 12 meses:Laboratoristas"
	label var e1_nt_contratados_prox12m_5 "Etapa1 No. trab. Contrato directo prox 12 meses: Electricistas (técnicos y/o maestros)"
	label var e1_nt_subcontrato_prox12m_5 "Etapa1 No. trab. Subcontrato prox 12 meses:Electricistas (técnicos y/o maestros)"
	label var e1_nt_contratados_prox12m_6 "Etapa1 No. trab. Contrato directo prox 12 meses: Ingenieros, prevencionistas, arqueólogos, ambientalistas u otros profesionales de la obra"
	label var e1_nt_subcontrato_prox12m_6 "Etapa1 No. trab. Subcontrato prox 12 meses:Ingenieros, prevencionistas, arqueólogos, ambientalistas u otros profesionales de la obra"
	label var e1_nt_contratados_prox12m_7 "Etapa1 No. trab. Contrato directo prox 12 meses: Operadores planta asfalto y de áridos"
	label var e1_nt_subcontrato_prox12m_7 "Etapa1 No. trab. Subcontrato prox 12 meses:Operadores planta asfalto y de áridos"
	label var e1_nt_contratados_prox12m_8 "Etapa1 No. trab. Contrato directo prox 12 meses: Operadores de maquinaria pesada (motoniveladora, retroexcavadora, rigger, camión tolva, grúa horquilla, etc.)"
	label var e1_nt_subcontrato_prox12m_8 "Etapa1 No. trab. Subcontrato prox 12 meses:Operadores de maquinaria pesada (motoniveladora, retroexcavadora, rigger, camión tolva, grúa horquilla, etc.)"
	label var e1_nt_contratados_prox12m_9 "Etapa1 No. trab. Contrato directo prox 12 meses: Operadores de maquinaria liviana (gravilladora autopropulsada, rodillo manual, martillo picador etc.)"
	label var e1_nt_subcontrato_prox12m_9 "Etapa1 No. trab. Subcontrato prox 12 meses:Operadores de maquinaria liviana (gravilladora autopropulsada, rodillo manual, martillo picador etc.)"
	label var e1_nt_contratados_prox12m_10 "Etapa1 No. trab. Contrato directo prox 12 meses: Trazadores"
	label var e1_nt_subcontrato_prox12m_10 "Etapa1 No. trab. Subcontrato prox 12 meses:Trazadores"
	label var e1_nt_contratados_prox12m_11 "Etapa1 No. trab. Contrato directo prox 12 meses: Mecánicos"
	label var e1_nt_subcontrato_prox12m_11 "Etapa1 No. trab. Subcontrato prox 12 meses:Mecánicos"
	label var e1_nt_contratados_prox12m_12 "Etapa1 No. trab. Contrato directo prox 12 meses: Soldadores"
	label var e1_nt_subcontrato_prox12m_12 "Etapa1 No. trab. Subcontrato prox 12 meses:Soldadores"
	label var e1_nt_contratados_prox12m_13 "Etapa1 No. trab. Contrato directo prox 12 meses: Enfierradores"
	label var e1_nt_subcontrato_prox12m_13 "Etapa1 No. trab. Subcontrato prox 12 meses:Enfierradores"
	label var e1_nt_contratados_prox12m_14 "Etapa1 No. trab. Contrato directo prox 12 meses: Albañiles"
	label var e1_nt_subcontrato_prox12m_14 "Etapa1 No. trab. Subcontrato prox 12 meses:Albañiles"
	label var e1_nt_contratados_prox12m_15 "Etapa1 No. trab. Contrato directo prox 12 meses: Concreteros"
	label var e1_nt_subcontrato_prox12m_15 "Etapa1 No. trab. Subcontrato prox 12 meses:Concreteros"
	label var e1_nt_contratados_prox12m_16 "Etapa1 No. trab. Contrato directo prox 12 meses: Carpinteros"
	label var e1_nt_subcontrato_prox12m_16 "Etapa1 No. trab. Subcontrato prox 12 meses:Carpinteros"
	label var e1_nt_contratados_prox12m_17 "Etapa1 No. trab. Contrato directo prox 12 meses: Pintores"
	label var e1_nt_subcontrato_prox12m_17 "Etapa1 No. trab. Subcontrato prox 12 meses:Pintores"
	label var e1_nt_contratados_prox12m_18 "Etapa1 No. trab. Contrato directo prox 12 meses: Baldoseros y ceramistas"
	label var e1_nt_subcontrato_prox12m_18 "Etapa1 No. trab. Subcontrato prox 12 meses:Baldoseros y ceramistas"
	label var e1_nt_contratados_prox12m_19 "Etapa1 No. trab. Contrato directo prox 12 meses: Tuberos y operadores de termofusión"
	label var e1_nt_subcontrato_prox12m_19 "Etapa1 No. trab. Subcontrato prox 12 meses:Tuberos y operadores de termofusión"
	label var e1_nt_contratados_prox12m_20 "Etapa1 No. trab. Contrato directo prox 12 meses: Sanitarios y gásfiteres"
	label var e1_nt_subcontrato_prox12m_20 "Etapa1 No. trab. Subcontrato prox 12 meses:Sanitarios y gásfiteres"
	label var e1_nt_contratados_prox12m_21 "Etapa1 No. trab. Contrato directo prox 12 meses: Instaladores de gas"
	label var e1_nt_subcontrato_prox12m_21 "Etapa1 No. trab. Subcontrato prox 12 meses:Instaladores de gas"
	label var e1_nt_contratados_prox12m_22 "Etapa1 No. trab. Contrato directo prox 12 meses: Otros maestros de primera y segunda"
	label var e1_nt_subcontrato_prox12m_22 "Etapa1 No. trab. Subcontrato prox 12 meses:Otros maestros de primera y segunda"
	label var e1_nt_contratados_prox12m_23 "Etapa1 No. trab. Contrato directo prox 12 meses: Buzos"
	label var e1_nt_subcontrato_prox12m_23 "Etapa1 No. trab. Subcontrato prox 12 meses:Buzos"
	label var e1_nt_contratados_prox12m_24 "Etapa1 No. trab. Contrato directo prox 12 meses: Bodegueros y cardcheckers"
	label var e1_nt_subcontrato_prox12m_24 "Etapa1 No. trab. Subcontrato prox 12 meses:Bodegueros y cardcheckers"
	label var e1_nt_contratados_prox12m_25 "Etapa1 No. trab. Contrato directo prox 12 meses: Jornales, ayudantes y señaleros"
	label var e1_nt_subcontrato_prox12m_25 "Etapa1 No. trab. Subcontrato prox 12 meses:Jornales, ayudantes y señaleros"


	rename v118 e1_falto_pt
	label var e1_falto_pt "Etapa1: ¿Faltó algún puesto de trabajo importante para la construcción del proyecto? "
	label define e1_falto_pt 1 "Sí" 2 "No"
	label val e1_falto_pt e1_falto_pt
	
	rename v119 e1_nombre_pt1_extra_prox12m
	rename v120 e1_tareas_pt1_extra_prox12m
	rename v121 e1_nt_cd_pt1_extra_prox12m
	rename v122 e1_nt_subc_pt1_extra_prox12m
	rename v123 e1_nombre_pt2_extra_prox12m
	rename v124 e1_tareas_pt2_extra_prox12m
	rename v125 e1_nt_cd_pt2_extra_prox12m
	rename v126 e1_nt_subc_pt2_extra_prox12m
	rename v127 e1_nombre_pt3_extra_prox12m
	rename v128 e1_tareas_pt3_extra_prox12m
	rename v129 e1_nt_cd_pt3_extra_prox12m
	rename v130 e1_nt_subc_pt3_extra_prox12m
	rename v131 e1_nombre_pt4_extra_prox12m
	rename v132 e1_tareas_pt4_extra_prox12m
	rename v133 e1_nt_cd_pt4_extra_prox12m
	rename v134 e1_nt_subc_pt4_extra_prox12m
	rename v135 e1_nombre_pt5_extra_prox12m
	rename v136 e1_tareas_pt5_extra_prox12m
	rename v137 e1_nt_cd_pt5_extra_prox12m
	rename v138 e1_nt_subc_pt5_extra_prox12m
	rename v139 e1_nombre_pt6_extra_prox12m
	rename v140 e1_tareas_pt6_extra_prox12m
	rename v141 e1_nt_cd_pt6_extra_prox12m
	rename v142 e1_nt_subc_pt6_extra_prox12m

	label var e1_nombre_pt1_extra_prox12m "Etapa1, Puesto 1 faltante: Nombre del puesto de trabajo"
	label var e1_tareas_pt1_extra_prox12m "Etapa1, Puesto 1 faltante: Principales tareas"
	label var e1_nt_cd_pt1_extra_prox12m "Etapa1, Puesto 1 faltante: Trabajadores contratados directamente"
	label var e1_nt_subc_pt1_extra_prox12m "Etapa1, Puesto 1 faltante: Trabajadores subcontratados "
	label var e1_nombre_pt2_extra_prox12m "Etapa1, Puesto 2 faltante: Nombre del puesto de trabajo"
	label var e1_tareas_pt2_extra_prox12m "Etapa1, Puesto 2 faltante: Principales tareas"
	label var e1_nt_cd_pt2_extra_prox12m "Etapa1, Puesto 2 faltante: Trabajadores contratados directamente"
	label var e1_nt_subc_pt2_extra_prox12m "Etapa1, Puesto 2 faltante: Trabajadores subcontratados "
	label var e1_nombre_pt3_extra_prox12m "Etapa1, Puesto 3 faltante: Nombre del puesto de trabajo"
	label var e1_tareas_pt3_extra_prox12m "Etapa1, Puesto 3 faltante: Principales tareas"
	label var e1_nt_cd_pt3_extra_prox12m "Etapa1, Puesto 3 faltante: Trabajadores contratados directamente"
	label var e1_nt_subc_pt3_extra_prox12m "Etapa1, Puesto 3 faltante: Trabajadores subcontratados "
	label var e1_nombre_pt4_extra_prox12m "Etapa1, Puesto 4 faltante: Nombre del puesto de trabajo"
	label var e1_tareas_pt4_extra_prox12m "Etapa1, Puesto 4 faltante: Principales tareas"
	label var e1_nt_cd_pt4_extra_prox12m "Etapa1, Puesto 4 faltante: Trabajadores contratados directamente"
	label var e1_nt_subc_pt4_extra_prox12m "Etapa1, Puesto 4 faltante: Trabajadores subcontratados "
	label var e1_nombre_pt5_extra_prox12m "Etapa1, Puesto 5 faltante: Nombre del puesto de trabajo"
	label var e1_tareas_pt5_extra_prox12m "Etapa1, Puesto 5 faltante: Principales tareas"
	label var e1_nt_cd_pt5_extra_prox12m "Etapa1, Puesto 5 faltante: Trabajadores contratados directamente"
	label var e1_nt_subc_pt5_extra_prox12m "Etapa1, Puesto 5 faltante: Trabajadores subcontratados "
	label var e1_nombre_pt6_extra_prox12m "Etapa1, Puesto 6 faltante: Nombre del puesto de trabajo"
	label var e1_tareas_pt6_extra_prox12m "Etapa1, Puesto 6 faltante: Principales tareas"
	label var e1_nt_cd_pt6_extra_prox12m "Etapa1, Puesto 6 faltante: Trabajadores contratados directamente"
	label var e1_nt_subc_pt6_extra_prox12m "Etapa1, Puesto 6 faltante: Trabajadores subcontratados "

	destring v143 v144 v145 v146 v147, replace
	rename v143 b1_ano
	rename v144 b1_mes
	rename v145 b1_estado_avance
	rename v146 b2_ano
	rename v147 b2_mes
	
	label define b1_ano 1 "2016 o antes" 2 "2017" 3 "2018" 4 "2019" 5 "2020" 6 "2021"
	label val b1_ano b1_ano
	label define b2_ano 1 "2021" 2 "2022" 3 "2023" 4 "2024" 5 "2025" 6 "2026 o más"
	label val b2_ano b2_ano
	label define b1_mes 1 "Enero"
	label val b1_mes b1_mes
	label define b2_mes 1 "Enero"
	label val b2_mes b2_mes

	label define b1_mes 1  "Enero", modify
	label define b1_mes 2  "Febrero", modify
	label define b1_mes 3  "Marzo", modify
	label define b1_mes 4  "Abril", modify
	label define b1_mes 5  "Mayo", modify
	label define b1_mes 6  "Junio", modify
	label define b1_mes 7  "Julio", modify
	label define b1_mes 8  "Agosto", modify
	label define b1_mes 9  "Septiembre", modify
	label define b1_mes 10  "Octubre", modify
	label define b1_mes 11  "Noviembre", modify
	label define b1_mes 12  "Diciembre", modify
	label define b2_mes 1  "Enero", modify
	label define b2_mes 2  "Febrero", modify
	label define b2_mes 3  "Marzo", modify
	label define b2_mes 4  "Abril", modify
	label define b2_mes 5  "Mayo", modify
	label define b2_mes 6  "Junio", modify
	label define b2_mes 7  "Julio", modify
	label define b2_mes 8  "Agosto", modify
	label define b2_mes 9  "Septiembre", modify
	label define b2_mes 10  "Octubre", modify
	label define b2_mes 11  "Noviembre", modify
	label define b2_mes 12  "Diciembre", modify

	
	
	label var b1_ano "¿En qué año comenzaron las obras del proyecto?"
	label var b1_mes "¿Y en qué mes?"
	label var b1_estado_avance "¿Cuál es el estado de avance de las obras en términos porcentuales? (estimación)"
	label var b2_ano "¿Y en qué año proyecta que van a concluir las obras de construcción que están a cargo de su empresa?"
	label var b2_mes "¿Y en qué mes?"

	rename v148 e2_nt_contratados_total_hoy
	rename v149 e2_nt_contratados_mujeres_hoy
	rename v150 e2_nt_contratados_jovenes_hoy
	rename v151 e2_nt_subcontrato_total_hoy
	rename v152 e2_nt_subcontrato_mujeres_hoy
	rename v153 e2_nt_subcontrato_jovenes_hoy
	rename v154 e2_nt_contratados_total_prox12m
	rename v155 e2_nt_subcontrato_total_prox12m

	label var e2_nt_contratados_total_hoy "Etapa2 No. trab. Contrato directo hoy Total"
	label var e2_nt_contratados_mujeres_hoy "Etapa2 No. trab. Contrato directo hoy Mujeres"
	label var e2_nt_contratados_jovenes_hoy "Etapa2 No. trab. Contrato directo hoy Jóvenes"
	label var e2_nt_subcontrato_total_hoy "Etapa2 No. trab. Subcontrato hoy Total"
	label var e2_nt_subcontrato_mujeres_hoy "Etapa2 No. trab. Subcontrato hoy Mujeres"
	label var e2_nt_subcontrato_jovenes_hoy "Etapa2 No. trab. Subcontrato hoy Jóvenes"
	label var e2_nt_contratados_total_prox12m "Etapa2 No. trab. Contrato directo prox 12 meses Total"
	label var e2_nt_subcontrato_total_prox12m "Etapa2 No. trab. Subcontrato prox 12 meses Total"

	rename v156 e2_nt_cd_hoy_1
	rename v157 e2_nt_subc_hoy_1
	rename v158 e2_nt_cd_prox12m_1
	rename v159 e2_nt_subc_prox12m_1
	rename v160 e2_nt_cd_hoy_2
	rename v161 e2_nt_subc_hoy_2
	rename v162 e2_nt_cd_prox12m_2
	rename v163 e2_nt_subc_prox12m_2
	rename v164 e2_nt_cd_hoy_3
	rename v165 e2_nt_subc_hoy_3
	rename v166 e2_nt_cd_prox12m_3
	rename v167 e2_nt_subc_prox12m_3
	rename v168 e2_nt_cd_hoy_4
	rename v169 e2_nt_subc_hoy_4
	rename v170 e2_nt_cd_prox12m_4
	rename v171 e2_nt_subc_prox12m_4
	rename v172 e2_nt_cd_hoy_5
	rename v173 e2_nt_subc_hoy_5
	rename v174 e2_nt_cd_prox12m_5
	rename v175 e2_nt_subc_prox12m_5
	rename v176 e2_nt_cd_hoy_6
	rename v177 e2_nt_subc_hoy_6
	rename v178 e2_nt_cd_prox12m_6
	rename v179 e2_nt_subc_prox12m_6
	rename v180 e2_nt_cd_hoy_7
	rename v181 e2_nt_subc_hoy_7
	rename v182 e2_nt_cd_prox12m_7
	rename v183 e2_nt_subc_prox12m_7
	rename v184 e2_nt_cd_hoy_8
	rename v185 e2_nt_subc_hoy_8
	rename v186 e2_nt_cd_prox12m_8
	rename v187 e2_nt_subc_prox12m_8
	rename v188 e2_nt_cd_hoy_9
	rename v189 e2_nt_subc_hoy_9
	rename v190 e2_nt_cd_prox12m_9
	rename v191 e2_nt_subc_prox12m_9
	rename v192 e2_nt_cd_hoy_10
	rename v193 e2_nt_subc_hoy_10
	rename v194 e2_nt_cd_prox12m_10
	rename v195 e2_nt_subc_prox12m_10
	rename v196 e2_nt_cd_hoy_11
	rename v197 e2_nt_subc_hoy_11
	rename v198 e2_nt_cd_prox12m_11
	rename v199 e2_nt_subc_prox12m_11
	rename v200 e2_nt_cd_hoy_12
	rename v201 e2_nt_subc_hoy_12
	rename v202 e2_nt_cd_prox12m_12
	rename v203 e2_nt_subc_prox12m_12
	rename v204 e2_nt_cd_hoy_13
	rename v205 e2_nt_subc_hoy_13
	rename v206 e2_nt_cd_prox12m_13
	rename v207 e2_nt_subc_prox12m_13
	rename v208 e2_nt_cd_hoy_14
	rename v209 e2_nt_subc_hoy_14
	rename v210 e2_nt_cd_prox12m_14
	rename v211 e2_nt_subc_prox12m_14
	rename v212 e2_nt_cd_hoy_15
	rename v213 e2_nt_subc_hoy_15
	rename v214 e2_nt_cd_prox12m_15
	rename v215 e2_nt_subc_prox12m_15
	rename v216 e2_nt_cd_hoy_16
	rename v217 e2_nt_subc_hoy_16
	rename v218 e2_nt_cd_prox12m_16
	rename v219 e2_nt_subc_prox12m_16
	rename v220 e2_nt_cd_hoy_17
	rename v221 e2_nt_subc_hoy_17
	rename v222 e2_nt_cd_prox12m_17
	rename v223 e2_nt_subc_prox12m_17
	rename v224 e2_nt_cd_hoy_18
	rename v225 e2_nt_subc_hoy_18
	rename v226 e2_nt_cd_prox12m_18
	rename v227 e2_nt_subc_prox12m_18
	rename v228 e2_nt_cd_hoy_19
	rename v229 e2_nt_subc_hoy_19
	rename v230 e2_nt_cd_prox12m_19
	rename v231 e2_nt_subc_prox12m_19
	rename v232 e2_nt_cd_hoy_20
	rename v233 e2_nt_subc_hoy_20
	rename v234 e2_nt_cd_prox12m_20
	rename v235 e2_nt_subc_prox12m_20
	rename v236 e2_nt_cd_hoy_21
	rename v237 e2_nt_subc_hoy_21
	rename v238 e2_nt_cd_prox12m_21
	rename v239 e2_nt_subc_prox12m_21
	rename v240 e2_nt_cd_hoy_22
	rename v241 e2_nt_subc_hoy_22
	rename v242 e2_nt_cd_prox12m_22
	rename v243 e2_nt_subc_prox12m_22
	rename v244 e2_nt_cd_hoy_23
	rename v245 e2_nt_subc_hoy_23
	rename v246 e2_nt_cd_prox12m_23
	rename v247 e2_nt_subc_prox12m_23
	rename v248 e2_nt_cd_hoy_24
	rename v249 e2_nt_subc_hoy_24
	rename v250 e2_nt_cd_prox12m_24
	rename v251 e2_nt_subc_prox12m_24
	rename v252 e2_nt_cd_hoy_25
	rename v253 e2_nt_subc_hoy_25
	rename v254 e2_nt_cd_prox12m_25
	rename v255 e2_nt_subc_prox12m_25


	label var e2_nt_cd_hoy_1 "Etapa2 No. trab. Contrato directo hoy: Encargados de obra (administradores de obra, jefes de terreno, encargados de bodega, etc.)"
	label var e2_nt_subc_hoy_1 "Etapa2 No. trab. Subcontrato hoy:Encargados de obra (administradores de obra, jefes de terreno, encargados de bodega, etc.)"
	label var e2_nt_cd_prox12m_1 "Etapa2 No. trab. Contrato directo prox 12 meses: Encargados de obra (administradores de obra, jefes de terreno, encargados de bodega, etc.)"
	label var e2_nt_subc_prox12m_1 "Etapa2 No. trab. Subcontrato prox 12 meses:Encargados de obra (administradores de obra, jefes de terreno, encargados de bodega, etc.)"
	label var e2_nt_cd_hoy_2 "Etapa2 No. trab. Contrato directo hoy: Capataces"
	label var e2_nt_subc_hoy_2 "Etapa2 No. trab. Subcontrato hoy:Capataces"
	label var e2_nt_cd_prox12m_2 "Etapa2 No. trab. Contrato directo prox 12 meses: Capataces"
	label var e2_nt_subc_prox12m_2 "Etapa2 No. trab. Subcontrato prox 12 meses:Capataces"
	label var e2_nt_cd_hoy_3 "Etapa2 No. trab. Contrato directo hoy: Electrónicos, electromecánicos e instrumentistas"
	label var e2_nt_subc_hoy_3 "Etapa2 No. trab. Subcontrato hoy:Electrónicos, electromecánicos e instrumentistas"
	label var e2_nt_cd_prox12m_3 "Etapa2 No. trab. Contrato directo prox 12 meses: Electrónicos, electromecánicos e instrumentistas"
	label var e2_nt_subc_prox12m_3 "Etapa2 No. trab. Subcontrato prox 12 meses:Electrónicos, electromecánicos e instrumentistas"
	label var e2_nt_cd_hoy_4 "Etapa2 No. trab. Contrato directo hoy: Laboratoristas"
	label var e2_nt_subc_hoy_4 "Etapa2 No. trab. Subcontrato hoy:Laboratoristas"
	label var e2_nt_cd_prox12m_4 "Etapa2 No. trab. Contrato directo prox 12 meses: Laboratoristas"
	label var e2_nt_subc_prox12m_4 "Etapa2 No. trab. Subcontrato prox 12 meses:Laboratoristas"
	label var e2_nt_cd_hoy_5 "Etapa2 No. trab. Contrato directo hoy: Electricistas (técnicos y/o maestros)"
	label var e2_nt_subc_hoy_5 "Etapa2 No. trab. Subcontrato hoy:Electricistas (técnicos y/o maestros)"
	label var e2_nt_cd_prox12m_5 "Etapa2 No. trab. Contrato directo prox 12 meses: Electricistas (técnicos y/o maestros)"
	label var e2_nt_subc_prox12m_5 "Etapa2 No. trab. Subcontrato prox 12 meses:Electricistas (técnicos y/o maestros)"
	label var e2_nt_cd_hoy_6 "Etapa2 No. trab. Contrato directo hoy: Ingenieros, prevencionistas, arqueólogos, ambientalistas u otros profesionales de la obra"
	label var e2_nt_subc_hoy_6 "Etapa2 No. trab. Subcontrato hoy:Ingenieros, prevencionistas, arqueólogos, ambientalistas u otros profesionales de la obra"
	label var e2_nt_cd_prox12m_6 "Etapa2 No. trab. Contrato directo prox 12 meses: Ingenieros, prevencionistas, arqueólogos, ambientalistas u otros profesionales de la obra"
	label var e2_nt_subc_prox12m_6 "Etapa2 No. trab. Subcontrato prox 12 meses:Ingenieros, prevencionistas, arqueólogos, ambientalistas u otros profesionales de la obra"
	label var e2_nt_cd_hoy_7 "Etapa2 No. trab. Contrato directo hoy: Operadores planta asfalto y de áridos"
	label var e2_nt_subc_hoy_7 "Etapa2 No. trab. Subcontrato hoy:Operadores planta asfalto y de áridos"
	label var e2_nt_cd_prox12m_7 "Etapa2 No. trab. Contrato directo prox 12 meses: Operadores planta asfalto y de áridos"
	label var e2_nt_subc_prox12m_7 "Etapa2 No. trab. Subcontrato prox 12 meses:Operadores planta asfalto y de áridos"
	label var e2_nt_cd_hoy_8 "Etapa2 No. trab. Contrato directo hoy: Operadores de maquinaria pesada (motoniveladora, retroexcavadora, rigger, camión tolva, grúa horquilla, etc.)"
	label var e2_nt_subc_hoy_8 "Etapa2 No. trab. Subcontrato hoy:Operadores de maquinaria pesada (motoniveladora, retroexcavadora, rigger, camión tolva, grúa horquilla, etc.)"
	label var e2_nt_cd_prox12m_8 "Etapa2 No. trab. Contrato directo prox 12 meses: Operadores de maquinaria pesada (motoniveladora, retroexcavadora, rigger, camión tolva, grúa horquilla, etc.)"
	label var e2_nt_subc_prox12m_8 "Etapa2 No. trab. Subcontrato prox 12 meses:Operadores de maquinaria pesada (motoniveladora, retroexcavadora, rigger, camión tolva, grúa horquilla, etc.)"
	label var e2_nt_cd_hoy_9 "Etapa2 No. trab. Contrato directo hoy: Operadores de maquinaria liviana (gravilladora autopropulsada, rodillo manual, martillo picador etc.)"
	label var e2_nt_subc_hoy_9 "Etapa2 No. trab. Subcontrato hoy:Operadores de maquinaria liviana (gravilladora autopropulsada, rodillo manual, martillo picador etc.)"
	label var e2_nt_cd_prox12m_9 "Etapa2 No. trab. Contrato directo prox 12 meses: Operadores de maquinaria liviana (gravilladora autopropulsada, rodillo manual, martillo picador etc.)"
	label var e2_nt_subc_prox12m_9 "Etapa2 No. trab. Subcontrato prox 12 meses:Operadores de maquinaria liviana (gravilladora autopropulsada, rodillo manual, martillo picador etc.)"
	label var e2_nt_cd_hoy_10 "Etapa2 No. trab. Contrato directo hoy: Trazadores"
	label var e2_nt_subc_hoy_10 "Etapa2 No. trab. Subcontrato hoy:Trazadores"
	label var e2_nt_cd_prox12m_10 "Etapa2 No. trab. Contrato directo prox 12 meses: Trazadores"
	label var e2_nt_subc_prox12m_10 "Etapa2 No. trab. Subcontrato prox 12 meses:Trazadores"
	label var e2_nt_cd_hoy_11 "Etapa2 No. trab. Contrato directo hoy: Mecánicos"
	label var e2_nt_subc_hoy_11 "Etapa2 No. trab. Subcontrato hoy:Mecánicos"
	label var e2_nt_cd_prox12m_11 "Etapa2 No. trab. Contrato directo prox 12 meses: Mecánicos"
	label var e2_nt_subc_prox12m_11 "Etapa2 No. trab. Subcontrato prox 12 meses:Mecánicos"
	label var e2_nt_cd_hoy_12 "Etapa2 No. trab. Contrato directo hoy: Soldadores"
	label var e2_nt_subc_hoy_12 "Etapa2 No. trab. Subcontrato hoy:Soldadores"
	label var e2_nt_cd_prox12m_12 "Etapa2 No. trab. Contrato directo prox 12 meses: Soldadores"
	label var e2_nt_subc_prox12m_12 "Etapa2 No. trab. Subcontrato prox 12 meses:Soldadores"
	label var e2_nt_cd_hoy_13 "Etapa2 No. trab. Contrato directo hoy: Enfierradores"
	label var e2_nt_subc_hoy_13 "Etapa2 No. trab. Subcontrato hoy:Enfierradores"
	label var e2_nt_cd_prox12m_13 "Etapa2 No. trab. Contrato directo prox 12 meses: Enfierradores"
	label var e2_nt_subc_prox12m_13 "Etapa2 No. trab. Subcontrato prox 12 meses:Enfierradores"
	label var e2_nt_cd_hoy_14 "Etapa2 No. trab. Contrato directo hoy: Albañiles"
	label var e2_nt_subc_hoy_14 "Etapa2 No. trab. Subcontrato hoy:Albañiles"
	label var e2_nt_cd_prox12m_14 "Etapa2 No. trab. Contrato directo prox 12 meses: Albañiles"
	label var e2_nt_subc_prox12m_14 "Etapa2 No. trab. Subcontrato prox 12 meses:Albañiles"
	label var e2_nt_cd_hoy_15 "Etapa2 No. trab. Contrato directo hoy: Concreteros"
	label var e2_nt_subc_hoy_15 "Etapa2 No. trab. Subcontrato hoy:Concreteros"
	label var e2_nt_cd_prox12m_15 "Etapa2 No. trab. Contrato directo prox 12 meses: Concreteros"
	label var e2_nt_subc_prox12m_15 "Etapa2 No. trab. Subcontrato prox 12 meses:Concreteros"
	label var e2_nt_cd_hoy_16 "Etapa2 No. trab. Contrato directo hoy: Carpinteros"
	label var e2_nt_subc_hoy_16 "Etapa2 No. trab. Subcontrato hoy:Carpinteros"
	label var e2_nt_cd_prox12m_16 "Etapa2 No. trab. Contrato directo prox 12 meses: Carpinteros"
	label var e2_nt_subc_prox12m_16 "Etapa2 No. trab. Subcontrato prox 12 meses:Carpinteros"
	label var e2_nt_cd_hoy_17 "Etapa2 No. trab. Contrato directo hoy: Pintores"
	label var e2_nt_subc_hoy_17 "Etapa2 No. trab. Subcontrato hoy:Pintores"
	label var e2_nt_cd_prox12m_17 "Etapa2 No. trab. Contrato directo prox 12 meses: Pintores"
	label var e2_nt_subc_prox12m_17 "Etapa2 No. trab. Subcontrato prox 12 meses:Pintores"
	label var e2_nt_cd_hoy_18 "Etapa2 No. trab. Contrato directo hoy: Baldoseros y ceramistas"
	label var e2_nt_subc_hoy_18 "Etapa2 No. trab. Subcontrato hoy:Baldoseros y ceramistas"
	label var e2_nt_cd_prox12m_18 "Etapa2 No. trab. Contrato directo prox 12 meses: Baldoseros y ceramistas"
	label var e2_nt_subc_prox12m_18 "Etapa2 No. trab. Subcontrato prox 12 meses:Baldoseros y ceramistas"
	label var e2_nt_cd_hoy_19 "Etapa2 No. trab. Contrato directo hoy: Tuberos y operadores de termofusión"
	label var e2_nt_subc_hoy_19 "Etapa2 No. trab. Subcontrato hoy:Tuberos y operadores de termofusión"
	label var e2_nt_cd_prox12m_19 "Etapa2 No. trab. Contrato directo prox 12 meses: Tuberos y operadores de termofusión"
	label var e2_nt_subc_prox12m_19 "Etapa2 No. trab. Subcontrato prox 12 meses:Tuberos y operadores de termofusión"
	label var e2_nt_cd_hoy_20 "Etapa2 No. trab. Contrato directo hoy: Sanitarios y gásfiteres"
	label var e2_nt_subc_hoy_20 "Etapa2 No. trab. Subcontrato hoy:Sanitarios y gásfiteres"
	label var e2_nt_cd_prox12m_20 "Etapa2 No. trab. Contrato directo prox 12 meses: Sanitarios y gásfiteres"
	label var e2_nt_subc_prox12m_20 "Etapa2 No. trab. Subcontrato prox 12 meses:Sanitarios y gásfiteres"
	label var e2_nt_cd_hoy_21 "Etapa2 No. trab. Contrato directo hoy: Instaladores de gas"
	label var e2_nt_subc_hoy_21 "Etapa2 No. trab. Subcontrato hoy:Instaladores de gas"
	label var e2_nt_cd_prox12m_21 "Etapa2 No. trab. Contrato directo prox 12 meses: Instaladores de gas"
	label var e2_nt_subc_prox12m_21 "Etapa2 No. trab. Subcontrato prox 12 meses:Instaladores de gas"
	label var e2_nt_cd_hoy_22 "Etapa2 No. trab. Contrato directo hoy: Otros maestros de primera y segunda"
	label var e2_nt_subc_hoy_22 "Etapa2 No. trab. Subcontrato hoy:Otros maestros de primera y segunda"
	label var e2_nt_cd_prox12m_22 "Etapa2 No. trab. Contrato directo prox 12 meses: Otros maestros de primera y segunda"
	label var e2_nt_subc_prox12m_22 "Etapa2 No. trab. Subcontrato prox 12 meses:Otros maestros de primera y segunda"
	label var e2_nt_cd_hoy_23 "Etapa2 No. trab. Contrato directo hoy: Buzos"
	label var e2_nt_subc_hoy_23 "Etapa2 No. trab. Subcontrato hoy:Buzos"
	label var e2_nt_cd_prox12m_23 "Etapa2 No. trab. Contrato directo prox 12 meses: Buzos"
	label var e2_nt_subc_prox12m_23 "Etapa2 No. trab. Subcontrato prox 12 meses:Buzos"
	label var e2_nt_cd_hoy_24 "Etapa2 No. trab. Contrato directo hoy: Bodegueros y cardcheckers"
	label var e2_nt_subc_hoy_24 "Etapa2 No. trab. Subcontrato hoy:Bodegueros y cardcheckers"
	label var e2_nt_cd_prox12m_24 "Etapa2 No. trab. Contrato directo prox 12 meses: Bodegueros y cardcheckers"
	label var e2_nt_subc_prox12m_24 "Etapa2 No. trab. Subcontrato prox 12 meses:Bodegueros y cardcheckers"
	label var e2_nt_cd_hoy_25 "Etapa2 No. trab. Contrato directo hoy: Jornales, ayudantes y señaleros"
	label var e2_nt_subc_hoy_25 "Etapa2 No. trab. Subcontrato hoy:Jornales, ayudantes y señaleros"
	label var e2_nt_cd_prox12m_25 "Etapa2 No. trab. Contrato directo prox 12 meses: Jornales, ayudantes y señaleros"
	label var e2_nt_subc_prox12m_25 "Etapa2 No. trab. Subcontrato prox 12 meses:Jornales, ayudantes y señaleros"

	
	rename v256 e2_falto_pt
	label var e2_falto_pt "Etapa2: ¿Faltó algún puesto de trabajo importante para la construcción del proyecto? "
	label define e2_falto_pt 1 "Sí" 2 "No"
	label val e2_falto_pt e2_falto_pt
	
	
	rename v257 e2_nombre_pt1_extra
	rename v258 e2_tareas_pt1_extra
	rename v259 e2_nt_cd_hoy_pt1_extra
	rename v260 e2_nt_subc_hoy_pt1_extra
	rename v261 e2_nt_cd_prox12m_pt1_extra
	rename v262 e2_nt_subc_prox12m_pt1_extra
	rename v263 e2_nombre_pt2_extra
	rename v264 e2_tareas_pt2_extra
	rename v265 e2_nt_cd_hoy_pt2_extra
	rename v266 e2_nt_subc_hoy_pt2_extra
	rename v267 e2_nt_cd_prox12m_pt2_extra
	rename v268 e2_nt_subc_prox12m_pt2_extra
	rename v269 e2_nombre_pt3_extra
	rename v270 e2_tareas_pt3_extra
	rename v271 e2_nt_cd_hoy_pt3_extra
	rename v272 e2_nt_subc_hoy_pt3_extra
	rename v273 e2_nt_cd_prox12m_pt3_extra
	rename v274 e2_nt_subc_prox12m_pt3_extra
	rename v275 e2_nombre_pt4_extra
	rename v276 e2_tareas_pt4_extra
	rename v277 e2_nt_cd_hoy_pt4_extra
	rename v278 e2_nt_subc_hoy_pt4_extra
	rename v279 e2_nt_cd_prox12m_pt4_extra
	rename v280 e2_nt_subc_prox12m_pt4_extra
	rename v281 e2_nombre_pt5_extra
	rename v282 e2_tareas_pt5_extra
	rename v283 e2_nt_cd_hoy_pt5_extra
	rename v284 e2_nt_subc_hoy_pt5_extra
	rename v285 e2_nt_cd_prox12m_pt5_extra
	rename v286 e2_nt_subc_prox12m_pt5_extra
	rename v287 e2_nombre_pt6_extra
	rename v288 e2_tareas_pt6_extra
	rename v289 e2_nt_cd_hoy_pt6_extra
	rename v290 e2_nt_subc_hoy_pt6_extra
	rename v291 e2_nt_cd_prox12m_pt6_extra
	rename v292 e2_nt_subc_prox12m_pt6_extra

	
	label var e2_nombre_pt1_extra "Etapa2, Puesto 1 faltante: Nombre del puesto de trabajo"
	label var e2_tareas_pt1_extra "Etapa2, Puesto 1 faltante: Principales tareas"
	label var e2_nt_cd_hoy_pt1_extra "Etapa2, Puesto 1 faltante: Trabajadores contratados directamente"
	label var e2_nt_subc_hoy_pt1_extra "Etapa2, Puesto 1 faltante: Trabajadores subcontratados "
	label var e2_nt_cd_prox12m_pt1_extra "Etapa2, Puesto 1 faltante: Demanda adicional próx. 12 meses trabajadores contratados directamente"
	label var e2_nt_subc_prox12m_pt1_extra "Etapa2, Puesto 1 faltante: Demanda adicional próx. 12 meses trabajadores subcontratados"
	label var e2_nombre_pt2_extra "Etapa2, Puesto 2 faltante: Nombre del puesto de trabajo"
	label var e2_tareas_pt2_extra "Etapa2, Puesto 2 faltante: Principales tareas"
	label var e2_nt_cd_hoy_pt2_extra "Etapa2, Puesto 2 faltante: Trabajadores contratados directamente"
	label var e2_nt_subc_hoy_pt2_extra "Etapa2, Puesto 2 faltante: Trabajadores subcontratados "
	label var e2_nt_cd_prox12m_pt2_extra "Etapa2, Puesto 2 faltante: Demanda adicional próx. 12 meses trabajadores contratados directamente"
	label var e2_nt_subc_prox12m_pt2_extra "Etapa2, Puesto 2 faltante: Demanda adicional próx. 12 meses trabajadores subcontratados"
	label var e2_nombre_pt3_extra "Etapa2, Puesto 3 faltante: Nombre del puesto de trabajo"
	label var e2_tareas_pt3_extra "Etapa2, Puesto 3 faltante: Principales tareas"
	label var e2_nt_cd_hoy_pt3_extra "Etapa2, Puesto 3 faltante: Trabajadores contratados directamente"
	label var e2_nt_subc_hoy_pt3_extra "Etapa2, Puesto 3 faltante: Trabajadores subcontratados "
	label var e2_nt_cd_prox12m_pt3_extra "Etapa2, Puesto 3 faltante: Demanda adicional próx. 12 meses trabajadores contratados directamente"
	label var e2_nt_subc_prox12m_pt3_extra "Etapa2, Puesto 3 faltante: Demanda adicional próx. 12 meses trabajadores subcontratados"
	label var e2_nombre_pt4_extra "Etapa2, Puesto 4 faltante: Nombre del puesto de trabajo"
	label var e2_tareas_pt4_extra "Etapa2, Puesto 4 faltante: Principales tareas"
	label var e2_nt_cd_hoy_pt4_extra "Etapa2, Puesto 4 faltante: Trabajadores contratados directamente"
	label var e2_nt_subc_hoy_pt4_extra "Etapa2, Puesto 4 faltante: Trabajadores subcontratados "
	label var e2_nt_cd_prox12m_pt4_extra "Etapa2, Puesto 4 faltante: Demanda adicional próx. 12 meses trabajadores contratados directamente"
	label var e2_nt_subc_prox12m_pt4_extra "Etapa2, Puesto 4 faltante: Demanda adicional próx. 12 meses trabajadores subcontratados"
	label var e2_nombre_pt5_extra "Etapa2, Puesto 5 faltante: Nombre del puesto de trabajo"
	label var e2_tareas_pt5_extra "Etapa2, Puesto 5 faltante: Principales tareas"
	label var e2_nt_cd_hoy_pt5_extra "Etapa2, Puesto 5 faltante: Trabajadores contratados directamente"
	label var e2_nt_subc_hoy_pt5_extra "Etapa2, Puesto 5 faltante: Trabajadores subcontratados "
	label var e2_nt_cd_prox12m_pt5_extra "Etapa2, Puesto 5 faltante: Demanda adicional próx. 12 meses trabajadores contratados directamente"
	label var e2_nt_subc_prox12m_pt5_extra "Etapa2, Puesto 5 faltante: Demanda adicional próx. 12 meses trabajadores subcontratados"
	label var e2_nombre_pt6_extra "Etapa2, Puesto 6 faltante: Nombre del puesto de trabajo"
	label var e2_tareas_pt6_extra "Etapa2, Puesto 6 faltante: Principales tareas"
	label var e2_nt_cd_hoy_pt6_extra "Etapa2, Puesto 6 faltante: Trabajadores contratados directamente"
	label var e2_nt_subc_hoy_pt6_extra "Etapa2, Puesto 6 faltante: Trabajadores subcontratados "
	label var e2_nt_cd_prox12m_pt6_extra "Etapa2, Puesto 6 faltante: Demanda adicional próx. 12 meses trabajadores contratados directamente"
	label var e2_nt_subc_prox12m_pt6_extra "Etapa2, Puesto 6 faltante: Demanda adicional próx. 12 meses trabajadores subcontratados"

	******Módulo C: Vacantes
	
	rename v294 e1_experiencia_previa_regional
	rename v295 e1_contratacion
	rename v296 e2_contratacion
	
	
	label var e1_experiencia_previa_regional "¿Tiene experiencia en la región desarrollando proyectos u obras similares al proyecto?"
	label var e1_contratacion "¿Tuvo vacantes o contrató personal durante los últimos 12 meses?"
	label var e2_contratacion "¿Tuvo vacantes o contrató personal nuevo durante los últimos 12 meses para la ejecución del proyecto u otros proyectos similares en la misma región?"

	label define e1_experiencia_previa_regional 1 "Sí"
	label val e1_experiencia_previa_regional e1_experiencia_previa_regional
	label define e1_contratacion 1 "Sí"
	label val e1_contratacion e1_contratacion
	label define e2_contratacion 1 "Sí"
	label val e2_contratacion e2_contratacion

	label define e1_experiencia_previa_regional 1  "Sí", modify
	label define e1_experiencia_previa_regional 2  "No", modify
	label define e1_experiencia_previa_regional 3  "No sabe", modify

	label define e1_contratacion 1  "Sí", modify
	label define e1_contratacion 2  "No", modify

	label define e2_contratacion 1  "Sí", modify
	label define e2_contratacion 2  "No", modify

	
	
	rename v297 dificultades_1
	rename v298 dificultades_2
	rename v299 dificultades_3
	rename v300 dificultades_4
	rename v301 dificultades_5
	rename v302 dificultades_6
	rename v303 dificultades_7
	
	label var dificultades_1 "Escasez de postulantes en la región "
	label var dificultades_2 "Candidatos sin competencias o habilidades técnicas necesarias"
	label var dificultades_3 "Candidatos sin licencias o certificaciones requeridas"
	label var dificultades_4 "Falta de experiencia laboral"
	label var dificultades_5 "Condiciones laborales no son aceptadas"
	label var dificultades_6 "Otra razón"
	label var dificultades_7 "No, ninguna dificultad"

	**Separando texto de números en una misma variable
	capture tostring dificultades_6, replace
	replace dificultades_6="" if dificultades_6=="."
	gen dificultades_6_texto=dificultades_6
	replace dificultades_6="1" if dificultades_6!=""
	destring dificultades_6, replace
	
	label define dificultades_1 1 "Sí"
	label define dificultades_2 1 "Sí"
	label define dificultades_3 1 "Sí"
	label define dificultades_4 1 "Sí"
	label define dificultades_5 1 "Sí"
	label define dificultades_6 1 "Sí"
	label define dificultades_7 1 "Sí"

	label val dificultades_1 dificultades_1
	label val dificultades_2 dificultades_2
	label val dificultades_3 dificultades_3
	label val dificultades_4 dificultades_4
	label val dificultades_5 dificultades_5
	label val dificultades_6 dificultades_6
	label val dificultades_7 dificultades_7

	rename v304 n_puestos_dificultades
	label var n_puestos_dificultades "¿En cuántos puestos de trabajo tuvo dificultades para llenar sus vacantes?"

	label define n_puestos_dificultades 1  "Solo en un puesto de trabajo"
	label val n_puestos_dificultades n_puestos_dificultades
	label define n_puestos_dificultades 2  "En dos puestos de trabajo distintos", modify
	label define n_puestos_dificultades 3  "En tres puestos de trabajo distintos", modify
	label define n_puestos_dificultades 4  "En cuatro puestos de trabajo distintos", modify
	label define n_puestos_dificultades 5  "En cinco o más puestos de trabajo distintos", modify

	rename v305 nombre_puesto_1
	rename v306 nombre_otro_puesto_1
	rename v307 nombre_puesto_2
	rename v308 nombre_otro_puesto_2
	rename v309 nombre_puesto_3
	rename v310 nombre_otro_puesto_3
	rename v311 nombre_puesto_4
	rename v312 nombre_otro_puesto_4
	rename v313 nombre_puesto_5
	rename v314 nombre_otro_puesto_5
	
	label var nombre_puesto_1 "Selección de lista nombre puesto 1 (1 a 26)"
	label var nombre_otro_puesto_1 "Texto abierto de selección 26: otro puesto de trabajo 1"
	label var nombre_puesto_2 "Selección de lista nombre puesto 2 (1 a 26)"
	label var nombre_otro_puesto_2 "Texto abierto de selección 26: otro puesto de trabajo 2"
	label var nombre_puesto_3 "Selección de lista nombre puesto 3 (1 a 26)"
	label var nombre_otro_puesto_3 "Texto abierto de selección 26: otro puesto de trabajo 3"
	label var nombre_puesto_4 "Selección de lista nombre puesto 4 (1 a 26)"
	label var nombre_otro_puesto_4 "Texto abierto de selección 26: otro puesto de trabajo 4"
	label var nombre_puesto_5 "Selección de lista nombre puesto 5 (1 a 26)"
	label var nombre_otro_puesto_5 "Texto abierto de selección 26: otro puesto de trabajo 5"

  foreach o of numlist 1/5{
       
	label define nombre_puesto_`o' 1  "Encargados de obra (administradores de obra, jefes de terreno, encargados de bodega, etc.)"
	label val nombre_puesto_`o' nombre_puesto_`o'
	label define nombre_puesto_`o' 2  "Capataces", modify
	label define nombre_puesto_`o' 3  "Electrónicos, electromecánicos e instrumentistas", modify
	label define nombre_puesto_`o' 4  "Laboratoristas", modify
	label define nombre_puesto_`o' 5  "Electricistas (técnicos y/o maestros)", modify
	label define nombre_puesto_`o' 6  "Ingenieros, prevencionistas, arqueólogos, ambientalistas u otros profesionales de la obra", modify
	label define nombre_puesto_`o' 7  "Operadores planta asfalto y de áridos", modify
	label define nombre_puesto_`o' 8  "Operadores de maquinaria pesada (motoniveladora, retroexcavadora, rigger, camión tolva, grúa horquilla, etc.)", modify
	label define nombre_puesto_`o' 9  "Operadores de maquinaria liviana (gravilladora autopropulsada, rodillo manual, martillo picador etc.)", modify
	label define nombre_puesto_`o' 10  "Trazadores", modify
	label define nombre_puesto_`o' 11  "Mecánicos", modify
	label define nombre_puesto_`o' 12  "Soldadores", modify
	label define nombre_puesto_`o' 13  "Enfierradores", modify
	label define nombre_puesto_`o' 14  "Albañiles", modify
	label define nombre_puesto_`o' 15  "Concreteros", modify
	label define nombre_puesto_`o' 16  "Carpinteros", modify
	label define nombre_puesto_`o' 17  "Pintores", modify
	label define nombre_puesto_`o' 18  "Baldoseros y ceramistas", modify
	label define nombre_puesto_`o' 19  "Tuberos y operadores de termofusión", modify
	label define nombre_puesto_`o' 20  "Sanitarios y gásfiteres", modify
	label define nombre_puesto_`o' 21  "Instaladores de gas", modify
	label define nombre_puesto_`o' 22  "Otros maestros de primera y segunda", modify
	label define nombre_puesto_`o' 23  "Buzos", modify
	label define nombre_puesto_`o' 24  "Bodegueros y cardcheckers", modify
	label define nombre_puesto_`o' 25  "Jornales, ayudantes y señaleros", modify
	label define nombre_puesto_`o' 26  "Otro puesto de trabajo", modify
	
	   
	   
	   
   }
	

	rename v315 nombre_detalle_otro_puesto_1
	rename v316 tareas_otro_puesto_1
	rename v317 nombre_detalle_otro_puesto_2
	rename v318 tareas_otro_puesto_2
	rename v319 nombre_detalle_otro_puesto_3
	rename v320 tareas_otro_puesto_3
	rename v321 nombre_detalle_otro_puesto_4
	rename v322 tareas_otro_puesto_4
	rename v323 nombre_detalle_otro_puesto_5
	rename v324 tareas_otro_puesto_5
	
	label var nombre_detalle_otro_puesto_1 "Otro puesto 1, Nombre detalle: ¿Cree que es necesario especificar con más detalle el cargo? "
	label var tareas_otro_puesto_1 "Otro puesto 1, Tareas: ¿Cree que es necesario especificar con más detalle el cargo?"
	label var nombre_detalle_otro_puesto_2 "Otro puesto 2, Nombre detalle: ¿Cree que es necesario especificar con más detalle el cargo? "
	label var tareas_otro_puesto_2 "Otro puesto 2, Tareas: ¿Cree que es necesario especificar con más detalle el cargo?"
	label var nombre_detalle_otro_puesto_3 "Otro puesto 3, Nombre detalle: ¿Cree que es necesario especificar con más detalle el cargo? "
	label var tareas_otro_puesto_3 "Otro puesto 3, Tareas: ¿Cree que es necesario especificar con más detalle el cargo?"
	label var nombre_detalle_otro_puesto_4 "Otro puesto 4, Nombre detalle: ¿Cree que es necesario especificar con más detalle el cargo? "
	label var tareas_otro_puesto_4 "Otro puesto 4, Tareas: ¿Cree que es necesario especificar con más detalle el cargo?"
	label var nombre_detalle_otro_puesto_5 "Otro puesto 5, Nombre detalle: ¿Cree que es necesario especificar con más detalle el cargo? "
	label var tareas_otro_puesto_5 "Otro puesto 5, Tareas: ¿Cree que es necesario especificar con más detalle el cargo?"


	rename v325 experiencia_puesto_1
	rename v326 experiencia_puesto_2
	rename v327 experiencia_puesto_3
	rename v328 experiencia_puesto_4
	rename v329 experiencia_puesto_5

	rename v330 educ_puesto_1
	rename v331 educ_puesto_2
	rename v332 educ_puesto_3
	rename v333 educ_puesto_4
	rename v334 educ_puesto_5


	label var experiencia_puesto_1 "Indique la experiencia que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 1"
	label var experiencia_puesto_2 "Indique la experiencia que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 2"
	label var experiencia_puesto_3 "Indique la experiencia que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 3"
	label var experiencia_puesto_4 "Indique la experiencia que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 4"
	label var experiencia_puesto_5 "Indique la experiencia que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 5"
	label var educ_puesto_1 "Indique el nivel educativo que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 1"
	label var educ_puesto_2 "Indique el nivel educativo que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 2"
	label var educ_puesto_3 "Indique el nivel educativo que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 3"
	label var educ_puesto_4 "Indique el nivel educativo que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 4"
	label var educ_puesto_5 "Indique el nivel educativo que solicita la empresa al momento de realizar el proceso de búsqueda y selección puesto 5"

	
	
	label define experiencia_puesto_1 1  "No se requiere experiencia"
	label val experiencia_puesto_1 experiencia_puesto_1
	label define experiencia_puesto_1 2  "1 a 2 años", modify
	label define experiencia_puesto_1 3  "3 a 5 años", modify
	label define experiencia_puesto_1 4  "Más de 5 años.", modify

	label define experiencia_puesto_2 1  "No se requiere experiencia"
	label val experiencia_puesto_2 experiencia_puesto_2
	label define experiencia_puesto_2 2  "1 a 2 años", modify
	label define experiencia_puesto_2 3  "3 a 5 años", modify
	label define experiencia_puesto_2 4  "Más de 5 años.", modify

	label define experiencia_puesto_3 1  "No se requiere experiencia"
	label val experiencia_puesto_3 experiencia_puesto_3
	label define experiencia_puesto_3 2  "1 a 3 años", modify
	label define experiencia_puesto_3 3  "3 a 5 años", modify
	label define experiencia_puesto_3 4  "Más de 5 años.", modify

	label define experiencia_puesto_4 1  "No se requiere experiencia"
	label val experiencia_puesto_4 experiencia_puesto_4
	label define experiencia_puesto_4 2  "1 a 4 años", modify
	label define experiencia_puesto_4 3  "4 a 5 años", modify
	label define experiencia_puesto_4 4  "Más de 5 años.", modify


	label define experiencia_puesto_5 1  "No se requiere experiencia"
	label val experiencia_puesto_5 experiencia_puesto_5
	label define experiencia_puesto_5 2  "1 a 4 años", modify
	label define experiencia_puesto_5 3  "4 a 5 años", modify
	label define experiencia_puesto_5 4  "Más de 5 años.", modify


	label define educ_puesto_1 1  "Sin requisito"
	label val educ_puesto_1 educ_puesto_1
	label define educ_puesto_1 2  "Básica completa", modify
	label define educ_puesto_1 3  "Media", modify
	label define educ_puesto_1 4  "Media técnico profesional", modify
	label define educ_puesto_1 5  "Técnico nivel superior", modify
	label define educ_puesto_1 6  "Profesional o más", modify


	label define educ_puesto_2 1  "Sin requisito"
	label val educ_puesto_2 educ_puesto_2
	label define educ_puesto_2 2  "Básica completa", modify
	label define educ_puesto_2 3  "Media", modify
	label define educ_puesto_2 4  "Media técnico profesional", modify
	label define educ_puesto_2 5  "Técnico nivel superior", modify
	label define educ_puesto_2 6  "Profesional o más", modify

	label define educ_puesto_3 1  "Sin requisito"
	label val educ_puesto_3 educ_puesto_3
	label define educ_puesto_3 2  "Básica completa", modify
	label define educ_puesto_3 3  "Media", modify
	label define educ_puesto_3 4  "Media técnico profesional", modify
	label define educ_puesto_3 5  "Técnico nivel superior", modify
	label define educ_puesto_3 6  "Profesional o más", modify

	label define educ_puesto_4 1  "Sin requisito"
	label val educ_puesto_4 educ_puesto_4
	label define educ_puesto_4 2  "Básica completa", modify
	label define educ_puesto_4 3  "Media", modify
	label define educ_puesto_4 4  "Media técnico profesional", modify
	label define educ_puesto_4 5  "Técnico nivel superior", modify
	label define educ_puesto_4 6  "Profesional o más", modify

	label define educ_puesto_5 1  "Sin requisito"
	label val educ_puesto_5 educ_puesto_5
	label define educ_puesto_5 2  "Básica completa", modify
	label define educ_puesto_5 3  "Media", modify
	label define educ_puesto_5 4  "Media técnico profesional", modify
	label define educ_puesto_5 5  "Técnico nivel superior", modify
	label define educ_puesto_5 6  "Profesional o más", modify

	rename v335 certificacion_licencia_puesto_1
	rename v336 glosa_licencia_puesto_1
	rename v337 certificacion_licencia_puesto_2
	rename v338 glosa_licencia_puesto_2
	rename v339 certificacion_licencia_puesto_3
	rename v340 glosa_licencia_puesto_3
	rename v341 certificacion_licencia_puesto_4
	rename v342 glosa_licencia_puesto_4
	rename v343 certificacion_licencia_puesto_5
	rename v344 glosa_licencia_puesto_5
	
	label var certificacion_licencia_puesto_1 "Indique si su empresa solicita certificación, licencia o exámenes especiales al momento de realizar el proceso de búsqueda y selección puesto 1"	
	label var glosa_licencia_puesto_1 "Glosa de certificación, licencia o exámenes especiales puesto 1"	
	label var certificacion_licencia_puesto_2 "Indique si su empresa solicita certificación, licencia o exámenes especiales al momento de realizar el proceso de búsqueda y selección puesto 2"	
	label var glosa_licencia_puesto_2 "Glosa de certificación, licencia o exámenes especiales puesto 2"	
	label var certificacion_licencia_puesto_3 "Indique si su empresa solicita certificación, licencia o exámenes especiales al momento de realizar el proceso de búsqueda y selección puesto 3"	
	label var glosa_licencia_puesto_3 "Glosa de certificación, licencia o exámenes especiales puesto 3"	
	label var certificacion_licencia_puesto_4 "Indique si su empresa solicita certificación, licencia o exámenes especiales al momento de realizar el proceso de búsqueda y selección puesto 4"	
	label var glosa_licencia_puesto_4 "Glosa de certificación, licencia o exámenes especiales puesto 4"	
	label var certificacion_licencia_puesto_5 "Indique si su empresa solicita certificación, licencia o exámenes especiales al momento de realizar el proceso de búsqueda y selección puesto 5"	
	label var glosa_licencia_puesto_5 "Glosa de certificación, licencia o exámenes especiales puesto 5"	

	label define certificacion_licencia_puesto_1 1  "Sí"
	label val certificacion_licencia_puesto_1 certificacion_licencia_puesto_1
	label define certificacion_licencia_puesto_1 2  "", modify

	label define certificacion_licencia_puesto_2 1  "Sí"
	label val certificacion_licencia_puesto_2 certificacion_licencia_puesto_2
	label define certificacion_licencia_puesto_2 2  "No", modify

	label define certificacion_licencia_puesto_3 1  "Sí"
	label val certificacion_licencia_puesto_3 certificacion_licencia_puesto_3
	label define certificacion_licencia_puesto_3 2  "No", modify

	label define certificacion_licencia_puesto_4 1  "Sí"
	label val certificacion_licencia_puesto_4 certificacion_licencia_puesto_4
	label define certificacion_licencia_puesto_4 2  "No", modify

	label define certificacion_licencia_puesto_5 1  "Sí"
	label val certificacion_licencia_puesto_5 certificacion_licencia_puesto_5
	label define certificacion_licencia_puesto_5 2  "No", modify

	
	rename v345 n_vacantes_puesto_1
	rename v346 n_vacantes_puesto_2
	rename v347 n_vacantes_puesto_3
	rename v348 n_vacantes_puesto_4
	rename v349 n_vacantes_puesto_5

	label var n_vacantes_puesto_1 "Indique el número total estimado de vacantes que tuvo en los últimos 12 meses puesto 1"
	label var n_vacantes_puesto_2 "Indique el número total estimado de vacantes que tuvo en los últimos 12 meses puesto 2"
	label var n_vacantes_puesto_3 "Indique el número total estimado de vacantes que tuvo en los últimos 12 meses puesto 3"
	label var n_vacantes_puesto_4 "Indique el número total estimado de vacantes que tuvo en los últimos 12 meses puesto 4"
	label var n_vacantes_puesto_5 "Indique el número total estimado de vacantes que tuvo en los últimos 12 meses puesto 5"

	
	rename v350 principal_dificultad_puesto_1
	rename v351 glosa_otra_puesto_1
	rename v352 principal_dificultad_puesto_2
	rename v353 glosa_otra_puesto_2
	rename v354 principal_dificultad_puesto_3
	rename v355 glosa_otra_puesto_3
	rename v356 principal_dificultad_puesto_4
	rename v357 glosa_otra_puesto_4
	rename v358 principal_dificultad_puesto_5
	rename v359 glosa_otra_puesto_5

	
	label var principal_dificultad_puesto_1 "Principal dificultad que ha tenido para llenar sus vacantes puesto 1"
	label var glosa_otra_puesto_1 "Glosa Otra principal dificultad que ha tenido para llenar sus vacantes puesto 1"
	label var principal_dificultad_puesto_2 "Principal dificultad que ha tenido para llenar sus vacantes puesto 2"
	label var glosa_otra_puesto_2 "Glosa Otra principal dificultad que ha tenido para llenar sus vacantes puesto 2"
	label var principal_dificultad_puesto_3 "Principal dificultad que ha tenido para llenar sus vacantes puesto 3"
	label var glosa_otra_puesto_3 "Glosa Otra principal dificultad que ha tenido para llenar sus vacantes puesto 3"
	label var principal_dificultad_puesto_4 "Principal dificultad que ha tenido para llenar sus vacantes puesto 4"
	label var glosa_otra_puesto_4 "Glosa Otra principal dificultad que ha tenido para llenar sus vacantes puesto 4"
	label var principal_dificultad_puesto_5 "Principal dificultad que ha tenido para llenar sus vacantes puesto 5"
	label var glosa_otra_puesto_5 "Glosa Otra principal dificultad que ha tenido para llenar sus vacantes puesto 5"

	
	label define principal_dificultad_puesto_1 1  "Escasez de postulantes en la región"
	label val principal_dificultad_puesto_1 principal_dificultad_puesto_1
	label define principal_dificultad_puesto_1 2  "Candidatos sin competencias o habilidades técnicas", modify
	label define principal_dificultad_puesto_1 3  "Candidatos sin licencias, certificaciones o requisitos legales requeridos para ejercer su oficio", modify
	label define principal_dificultad_puesto_1 4  "Falta de experiencia laboral", modify
	label define principal_dificultad_puesto_1 5  "Las condiciones laborales no son aceptadas", modify
	label define principal_dificultad_puesto_1 6  "Otra dificultad", modify

	label define principal_dificultad_puesto_2 1  "Escasez de postulantes en la región"
	label val principal_dificultad_puesto_2 principal_dificultad_puesto_2
	label define principal_dificultad_puesto_2 2  "Candidatos sin competencias o habilidades técnicas", modify
	label define principal_dificultad_puesto_2 3  "Candidatos sin licencias, certificaciones o requisitos legales requeridos para ejercer su oficio", modify
	label define principal_dificultad_puesto_2 4  "Falta de experiencia laboral", modify
	label define principal_dificultad_puesto_2 5  "Las condiciones laborales no son aceptadas", modify
	label define principal_dificultad_puesto_2 6  "Otra dificultad", modify

	label define principal_dificultad_puesto_3 1  "Escasez de postulantes en la región"
	label val principal_dificultad_puesto_3 principal_dificultad_puesto_3
	label define principal_dificultad_puesto_3 2  "Candidatos sin competencias o habilidades técnicas", modify
	label define principal_dificultad_puesto_3 3  "Candidatos sin licencias, certificaciones o requisitos legales requeridos para ejercer su oficio", modify
	label define principal_dificultad_puesto_3 4  "Falta de experiencia laboral", modify
	label define principal_dificultad_puesto_3 5  "Las condiciones laborales no son aceptadas", modify
	label define principal_dificultad_puesto_3 6  "Otra dificultad", modify

	label define principal_dificultad_puesto_4 1  "Escasez de postulantes en la región"
	label val principal_dificultad_puesto_4 principal_dificultad_puesto_4
	label define principal_dificultad_puesto_4 2  "Candidatos sin competencias o habilidades técnicas", modify
	label define principal_dificultad_puesto_4 3  "Candidatos sin licencias, certificaciones o requisitos legales requeridos para ejercer su oficio", modify
	label define principal_dificultad_puesto_4 4  "Falta de experiencia laboral", modify
	label define principal_dificultad_puesto_4 5  "Las condiciones laborales no son aceptadas", modify
	label define principal_dificultad_puesto_4 6  "Otra dificultad", modify

	label define principal_dificultad_puesto_5 1  "Escasez de postulantes en la región"
	label val principal_dificultad_puesto_5 principal_dificultad_puesto_5
	label define principal_dificultad_puesto_5 2  "Candidatos sin competencias o habilidades técnicas", modify
	label define principal_dificultad_puesto_5 3  "Candidatos sin licencias, certificaciones o requisitos legales requeridos para ejercer su oficio", modify
	label define principal_dificultad_puesto_5 4  "Falta de experiencia laboral", modify
	label define principal_dificultad_puesto_5 5  "Las condiciones laborales no son aceptadas", modify
	label define principal_dificultad_puesto_5 6  "Otra dificultad", modify

	
	
	rename v360 sin_educS_c_reclutamiento_1
	rename v361 con_educS_c_reclutamiento_1
	rename v362 sin_educS_c_reclutamiento_2
	rename v363 con_educS_c_reclutamiento_2
	rename v364 sin_educS_c_reclutamiento_3
	rename v365 con_educS_c_reclutamiento_3
	rename v366 sin_educS_c_reclutamiento_4
	rename v367 con_educS_c_reclutamiento_4
	rename v368 sin_educS_c_reclutamiento_5
	rename v369 con_educS_c_reclutamiento_5
	rename v370 sin_educS_c_reclutamiento_6
	rename v371 con_educS_c_reclutamiento_6
	rename v372 sin_educS_c_reclutamiento_7
	rename v373 con_educS_c_reclutamiento_7
	rename v374 sin_educS_c_reclutamiento_8
	rename v375 con_educS_c_reclutamiento_8
	rename v376 sin_educS_c_reclutamiento_9
	rename v377 con_educS_c_reclutamiento_9
	rename v378 sin_educS_c_reclutamiento_10
	rename v379 con_educS_c_reclutamiento_10
	rename v380 sin_educS_c_reclutamiento_11
	rename v381 con_educS_c_reclutamiento_11
	rename v382 sin_educS_c_reclutamiento_12
	rename v383 con_educS_c_reclutamiento_12
	rename v384 sin_educS_c_reclutamiento_13
	rename v385 con_educS_c_reclutamiento_13
	rename v386 sin_educS_c_reclutamiento_14
	rename v387 con_educS_c_reclutamiento_14
	rename v388 sin_educS_c_reclutamiento_15
	rename v389 con_educS_c_reclutamiento_15

	label var sin_educS_c_reclutamiento_1 "Sin educ. superior: Traspaso de trabajadores de la misma constructora desde otra obra"
	label var con_educS_c_reclutamiento_1 "Con educ. superior: Traspaso de trabajadores de la misma constructora desde otra obra"
	label var sin_educS_c_reclutamiento_2 "Sin educ. superior: Diario o radio"
	label var con_educS_c_reclutamiento_2 "Con educ. superior: Diario o radio"
	label var sin_educS_c_reclutamiento_3 "Sin educ. superior: Plataforma web de empleo pagada (trabajando.com, laborum, linkedin)"
	label var con_educS_c_reclutamiento_3 "Con educ. superior: Plataforma web de empleo pagada (trabajando.com, laborum, linkedin)"
	label var sin_educS_c_reclutamiento_4 "Sin educ. superior: Plataforma web privada gratuita (Yapo u otra)  (exluyendo redes sociales)"
	label var con_educS_c_reclutamiento_4 "Con educ. superior: Plataforma web privada gratuita (Yapo u otra)  (exluyendo redes sociales)"
	label var sin_educS_c_reclutamiento_5 "Sin educ. superior: Redes sociales (facebook, twitter, instagram, etc.)"
	label var con_educS_c_reclutamiento_5 "Con educ. superior: Redes sociales (facebook, twitter, instagram, etc.)"
	label var sin_educS_c_reclutamiento_6 "Sin educ. superior: Bolsa Nacional de Empleo (BNE)"
	label var con_educS_c_reclutamiento_6 "Con educ. superior: Bolsa Nacional de Empleo (BNE)"
	label var sin_educS_c_reclutamiento_7 "Sin educ. superior: Oficina Municipal de Información Laboral (OMIL)"
	label var con_educS_c_reclutamiento_7 "Con educ. superior: Oficina Municipal de Información Laboral (OMIL)"
	label var sin_educS_c_reclutamiento_8 "Sin educ. superior: Redes de profesionales o egresados (mailing list)"
	label var con_educS_c_reclutamiento_8 "Con educ. superior: Redes de profesionales o egresados (mailing list)"
	label var sin_educS_c_reclutamiento_9 "Sin educ. superior: Recomendaciones de trabajadores de la empresa u otros actores. Ej: boca a boca. "
	label var con_educS_c_reclutamiento_9 "Con educ. superior: Recomendaciones de trabajadores de la empresa u otros actores. Ej: boca a boca. "
	label var sin_educS_c_reclutamiento_10 "Sin educ. superior: Contratación de empresas de reclutamiento"
	label var con_educS_c_reclutamiento_10 "Con educ. superior: Contratación de empresas de reclutamiento"
	label var sin_educS_c_reclutamiento_11 "Sin educ. superior: Intermediadores o enganchadores"
	label var con_educS_c_reclutamiento_11 "Con educ. superior: Intermediadores o enganchadores"
	label var sin_educS_c_reclutamiento_12 "Sin educ. superior: Avisos en las inmediaciones de la empresa o banco de Curriculums."
	label var con_educS_c_reclutamiento_12 "Con educ. superior: Avisos en las inmediaciones de la empresa o banco de Curriculums."
	label var sin_educS_c_reclutamiento_13 "Sin educ. superior: Redes personales del empleador"
	label var con_educS_c_reclutamiento_13 "Con educ. superior: Redes personales del empleador"
	label var sin_educS_c_reclutamiento_14 "Sin educ. superior: Otro canal"
	label var con_educS_c_reclutamiento_14 "Con educ. superior: Otro canal"
	label var sin_educS_c_reclutamiento_15 "Sin educ. superior: No aplica"
	label var con_educS_c_reclutamiento_15 "Con educ. superior: No aplica"

	
		**Separando texto de números en una misma variable
	capture tostring sin_educS_c_reclutamiento_14, replace
	replace sin_educS_c_reclutamiento_14="" if sin_educS_c_reclutamiento_14=="."	
		
	gen sin_educS_c_reclut_14_texto=sin_educS_c_reclutamiento_14
	replace sin_educS_c_reclutamiento_14="1" if sin_educS_c_reclutamiento_14!=""
	destring sin_educS_c_reclutamiento_14, replace
	
	capture tostring con_educS_c_reclutamiento_14, replace
	replace con_educS_c_reclutamiento_14="" if con_educS_c_reclutamiento_14=="."	
	
    gen con_educS_c_reclut_14_texto=con_educS_c_reclutamiento_14
	replace con_educS_c_reclutamiento_14="1" if con_educS_c_reclutamiento_14!=""
	destring con_educS_c_reclutamiento_14, replace
	
	label define sin_educS_c_reclutamiento_1 1  "Sí"
	label val sin_educS_c_reclutamiento_1 sin_educS_c_reclutamiento_1
	label define con_educS_c_reclutamiento_1 1  "Sí"
	label val con_educS_c_reclutamiento_1 con_educS_c_reclutamiento_1
	label define sin_educS_c_reclutamiento_2 1  "Sí"
	label val sin_educS_c_reclutamiento_2 sin_educS_c_reclutamiento_2
	label define con_educS_c_reclutamiento_2 1  "Sí"
	label val con_educS_c_reclutamiento_2 con_educS_c_reclutamiento_2
	label define sin_educS_c_reclutamiento_3 1  "Sí"
	label val sin_educS_c_reclutamiento_3 sin_educS_c_reclutamiento_3
	label define con_educS_c_reclutamiento_3 1  "Sí"
	label val con_educS_c_reclutamiento_3 con_educS_c_reclutamiento_3
	label define sin_educS_c_reclutamiento_4 1  "Sí"
	label val sin_educS_c_reclutamiento_4 sin_educS_c_reclutamiento_4
	label define con_educS_c_reclutamiento_4 1  "Sí"
	label val con_educS_c_reclutamiento_4 con_educS_c_reclutamiento_4
	label define sin_educS_c_reclutamiento_5 1  "Sí"
	label val sin_educS_c_reclutamiento_5 sin_educS_c_reclutamiento_5
	label define con_educS_c_reclutamiento_5 1  "Sí"
	label val con_educS_c_reclutamiento_5 con_educS_c_reclutamiento_5
	label define sin_educS_c_reclutamiento_6 1  "Sí"
	label val sin_educS_c_reclutamiento_6 sin_educS_c_reclutamiento_6
	label define con_educS_c_reclutamiento_6 1  "Sí"
	label val con_educS_c_reclutamiento_6 con_educS_c_reclutamiento_6
	label define sin_educS_c_reclutamiento_7 1  "Sí"
	label val sin_educS_c_reclutamiento_7 sin_educS_c_reclutamiento_7
	label define con_educS_c_reclutamiento_7 1  "Sí"
	label val con_educS_c_reclutamiento_7 con_educS_c_reclutamiento_7
	label define sin_educS_c_reclutamiento_8 1  "Sí"
	label val sin_educS_c_reclutamiento_8 sin_educS_c_reclutamiento_8
	label define con_educS_c_reclutamiento_8 1  "Sí"
	label val con_educS_c_reclutamiento_8 con_educS_c_reclutamiento_8
	label define sin_educS_c_reclutamiento_9 1  "Sí"
	label val sin_educS_c_reclutamiento_9 sin_educS_c_reclutamiento_9
	label define con_educS_c_reclutamiento_9 1  "Sí"
	label val con_educS_c_reclutamiento_9 con_educS_c_reclutamiento_9
	label define sin_educS_c_reclutamiento_10 1  "Sí"
	label val sin_educS_c_reclutamiento_10 sin_educS_c_reclutamiento_10
	label define con_educS_c_reclutamiento_10 1  "Sí"
	label val con_educS_c_reclutamiento_10 con_educS_c_reclutamiento_10
	label define sin_educS_c_reclutamiento_11 1  "Sí"
	label val sin_educS_c_reclutamiento_11 sin_educS_c_reclutamiento_11
	label define con_educS_c_reclutamiento_11 1  "Sí"
	label val con_educS_c_reclutamiento_11 con_educS_c_reclutamiento_11
	label define sin_educS_c_reclutamiento_12 1  "Sí"
	label val sin_educS_c_reclutamiento_12 sin_educS_c_reclutamiento_12
	label define con_educS_c_reclutamiento_12 1  "Sí"
	label val con_educS_c_reclutamiento_12 con_educS_c_reclutamiento_12
	label define sin_educS_c_reclutamiento_13 1  "Sí"
	label val sin_educS_c_reclutamiento_13 sin_educS_c_reclutamiento_13
	label define con_educS_c_reclutamiento_13 1  "Sí"
	label val con_educS_c_reclutamiento_13 con_educS_c_reclutamiento_13
	label define sin_educS_c_reclutamiento_14 1  "Sí"
	label val sin_educS_c_reclutamiento_14 sin_educS_c_reclutamiento_14
	label define con_educS_c_reclutamiento_14 1  "Sí"
	label val con_educS_c_reclutamiento_14 con_educS_c_reclutamiento_14
	label define sin_educS_c_reclutamiento_15 1  "Sí"
	label val sin_educS_c_reclutamiento_15 sin_educS_c_reclutamiento_15
	label define con_educS_c_reclutamiento_15 1  "Sí"
	label val con_educS_c_reclutamiento_15 con_educS_c_reclutamiento_15

	
	***Módulo D: Capacitación
	
	
	rename v391 capacitacion_ultimos_12m_general
	label var capacitacion_ultimos_12m_general "Empresa capacitó a trabajadores durante últimos 12 meses (no considerar inducciones o capacitaciones en seguridad y salud ocupacional)"
	label define capacitacion_ultimos_12m_general 1 "Sí" 2 "No" 3 "No sabe"
	label val capacitacion_ultimos_12m_general capacitacion_ultimos_12m_general
	
	rename v392 capacitacion_ultimos_12meses_1
	rename v393 capacitacion_ultimos_12meses_2
	rename v394 capacitacion_ultimos_12meses_3
	rename v395 capacitacion_ultimos_12meses_4

	label var capacitacion_ultimos_12meses_1 "Operativo inicial/básico (jornal, ayudante, señalero, alarife)"
	label var capacitacion_ultimos_12meses_2 "Operativo avanzado y especialista (maestro de primera y de segunda, operadores de equipos y de maquinaria)"
	label var capacitacion_ultimos_12meses_3 "Encargado y líder de equipo (capataz, supervisor, inspector certificador, instructor senior, administrativo de obra)"
	label var capacitacion_ultimos_12meses_4 "Profesionales y técnicos de nivel superior (ingenieros, prevencionistas, topógrafos, laboratorista)"

	rename v396 fuentes_financiamiento_1
	rename v397 fuentes_financiamiento_2
	rename v398 fuentes_financiamiento_3
	rename v399 fuentes_financiamiento_4
	rename v400 fuentes_financiamiento_5
	rename v401 fuentes_financiamiento_6
	rename v402 fuentes_financiamiento_7
	
	
	label var fuentes_financiamiento_1 "Financiamiento vía franquicia tributaria"
	label var fuentes_financiamiento_2 "Programa público de capacitación (FOSIS, MINEDUC, CORFO, Bono empresa y Negocio, otro)"
	label var fuentes_financiamiento_3 "Recursos propios de la empresa"
	label var fuentes_financiamiento_4 "Beca de institución privada"
	label var fuentes_financiamiento_5 "Mutual de seguridad / Instituto de Seguridad Laboral (ISL)"
	label var fuentes_financiamiento_6 "Otra"
	label var fuentes_financiamiento_7 "No sabe"

	capture tostring fuentes_financiamiento_6 replace
	replace fuentes_financiamiento_6="" if fuentes_financiamiento_6=="."	
	
    gen fuentes_financiamiento_6_texto=fuentes_financiamiento_6
	replace fuentes_financiamiento_6="1" if fuentes_financiamiento_6!=""
	destring fuentes_financiamiento_6, replace
	
	label define fuentes_financiamiento_1 1  "Sí"
	label val fuentes_financiamiento_1 fuentes_financiamiento_1
	label define fuentes_financiamiento_2 1  "Sí"
	label val fuentes_financiamiento_2 fuentes_financiamiento_2
	label define fuentes_financiamiento_3 1  "Sí"
	label val fuentes_financiamiento_3 fuentes_financiamiento_3
	label define fuentes_financiamiento_4 1  "Sí"
	label val fuentes_financiamiento_4 fuentes_financiamiento_4
	label define fuentes_financiamiento_5 1  "Sí"
	label val fuentes_financiamiento_5 fuentes_financiamiento_5
	label define fuentes_financiamiento_6 1  "Sí"
	label val fuentes_financiamiento_6 fuentes_financiamiento_6
	label define fuentes_financiamiento_7 1  "Sí"
	label val fuentes_financiamiento_7 fuentes_financiamiento_7

	rename v403 inversion_capacitacion
	label var inversion_capacitacion "¿Tiene pensado invertir en la capacitación de algún grupo de trabajadores para mejorar su desempeño? Considere el uso de recursos propios o de Franquicia Tributaria."
	label define inversion_capacitacion 1  "Sí"
	label val inversion_capacitacion inversion_capacitacion
	label define inversion_capacitacion 2  "No", modify
	label define inversion_capacitacion 3  "No sabe", modify


	rename v404 no_inversion_capacitacion
	label var no_inversion_capacitacion "¿Por qué no?"
	label define no_inversion_capacitacion 1  "La empresa no tiene los recursos disponibles, pero le gustaría capacitar a sus trabajadores"
	label val no_inversion_capacitacion no_inversion_capacitacion
	label define no_inversion_capacitacion 2  "Nuestro equipo de trabajo ya cuenta con las competencias requeridas para ejercer sus funciones", modify
	label define no_inversion_capacitacion 3  "La empresa capacita de forma interna a sus trabajadores a través de otros trabajadores", modify
	label define no_inversion_capacitacion 4  "No hay oferta de capacitación en áreas o contenidos relevantes para la empresa", modify
	label define no_inversion_capacitacion 5  "La empresa no dispone de tiempo para capacitar a sus trabajadores", modify
	label define no_inversion_capacitacion 6  "La calidad de la oferta de capacitación no es satisfactoria", modify
	label define no_inversion_capacitacion 7  "la capacitación no es una prioridad para la empresa", modify
	label define no_inversion_capacitacion 8  "Otra razón", modify

	rename v405 no_inversion_capacitacion_texto 
	label var no_inversion_capacitacion_texto "Otra razón de no inversión capacitación: texto"
	rename v406 capacitacion_grupo_ocupacional 
	label var capacitacion_grupo_ocupacional "¿Podría señalar en qué grupo ocupacional se desempeñan los trabajadores que considera más prioritario capacitar?"
	label define capacitacion_grupo_ocupacional 1  "Operativo inicial/básico (jornal, ayudante, señalero, alarife)"
	label val capacitacion_grupo_ocupacional capacitacion_grupo_ocupacional
	label define capacitacion_grupo_ocupacional 2  "Operativo avanzado y especialista (maestro de primera y de segunda, operadores de equipos y de maquinaria)", modify
	label define capacitacion_grupo_ocupacional 3  "Encargado y líder de equipo (capataz, supervisor, inspector certificador, instructor senior, administrativo de obra)", modify
	label define capacitacion_grupo_ocupacional 4  "Profesionales y técnicos de nivel superior (ingenieros, prevencionistas, topógrafos, laboratorista)", modify

	rename v407 competencias1_grupo_prioritario
	rename v408 competencias2_grupo_prioritario
	rename v409 competencias3_grupo_prioritario
	rename v410 competencias4_grupo_prioritario
	rename v411 competencias5_grupo_prioritario
	rename v412 competencias6_grupo_prioritario
	
	label var competencias1_grupo_prioritario "Competencias básicas (aquellas esenciales para desenvolverse en la vida adulta, que se desarrollan en la educación escolar, como alfabetización y matemáticas)"
	label var competencias2_grupo_prioritario "Competencias técnicas (aquellas específicas a un oficio concreto)"
	label var competencias3_grupo_prioritario "Competencias en tecnologías de la información (aplicadas a la utilización de sistemas de información y comunicación, como uso de softwares o equipos)"
	label var competencias4_grupo_prioritario "Competencias conductuales (relacionadas a comportamientos y actitudes observables de manera permanente en el desempeño laboral)"
	label var competencias5_grupo_prioritario "Higiene, salud y seguridad ocupacional"
	label var competencias6_grupo_prioritario "Otras competencias"

	
	forval i=1/6{
		capture tostring competencias`i'_grupo_prioritario
		replace competencias`i'_grupo_prioritario="" if competencias`i'_grupo_prioritario=="."
		gen competencias`i'_grupo_prior_texto=competencias`i'_grupo_prioritario
		replace competencias`i'_grupo_prioritario="1" if competencias`i'_grupo_prioritario!=""
		destring competencias`i'_grupo_prioritario, replace
		
		label define competencias`i'_grupo_prioritario 1 "Sí"
		label val competencias`i'_grupo_prioritario competencias`i'_grupo_prioritario
		
	}


	rename v413 capacitacion_abierta_texto
	label var capacitacion_abierta_texto "¿Le gustaría agregar algo más relativo a la capacitación de sus trabajadores?"

	rename v414 conocimiento_programas_1
	rename v415 conocimiento_programas_2
	rename v416 conocimiento_programas_3
	rename v417 conocimiento_programas_4
	rename v418 conocimiento_programas_5
	rename v419 conocimiento_programas_6
	rename v420 conocimiento_programas_7

	label var conocimiento_programas_1 "Subsidio al Empleo (Línea Regresa, Contrata, Subsidio Empleo Joven y Bono Trabajo Mujer)"
	label var conocimiento_programas_2 "Ley de Protección al Empleo "
	label var conocimiento_programas_3 "Sistema Nacional de Certificación de Competencias Laborales – ChileValora"
	label var conocimiento_programas_4 "Franquicia Tributaria"
	label var conocimiento_programas_5 "Bolsa Nacional de Empleo (BNE)"
	label var conocimiento_programas_6 "Ferias Laborales de SENCE/MINTRAB"
	label var conocimiento_programas_7 "Oficinas Municipales de Información Laboral (OMIL)"


	label define conocimiento_programas_1 1  "Lo conoce y lo utiliza"
	label val conocimiento_programas_1 conocimiento_programas_1
	label define conocimiento_programas_1 2  "Lo conoce, pero no lo utiliza", modify
	label define conocimiento_programas_1 3  "No lo conoce", modify
	label define conocimiento_programas_1 4  "Desconoce si su empresa usa o conoce estos programas", modify

	label define conocimiento_programas_2 1  "Lo conoce y lo utiliza"
	label val conocimiento_programas_2 conocimiento_programas_2
	label define conocimiento_programas_2 2  "Lo conoce, pero no lo utiliza", modify
	label define conocimiento_programas_2 3  "No lo conoce", modify
	label define conocimiento_programas_2 4  "Desconoce si su empresa usa o conoce estos programas", modify

	label define conocimiento_programas_3 1  "Lo conoce y lo utiliza"
	label val conocimiento_programas_3 conocimiento_programas_3
	label define conocimiento_programas_3 2  "Lo conoce, pero no lo utiliza", modify
	label define conocimiento_programas_3 3  "No lo conoce", modify
	label define conocimiento_programas_3 4  "Desconoce si su empresa usa o conoce estos programas", modify

	label define conocimiento_programas_4 1  "Lo conoce y lo utiliza"
	label val conocimiento_programas_4 conocimiento_programas_4
	label define conocimiento_programas_4 2  "Lo conoce, pero no lo utiliza", modify
	label define conocimiento_programas_4 3  "No lo conoce", modify
	label define conocimiento_programas_4 4  "Desconoce si su empresa usa o conoce estos programas", modify

	label define conocimiento_programas_5 1  "Lo conoce y lo utiliza"
	label val conocimiento_programas_5 conocimiento_programas_5
	label define conocimiento_programas_5 2  "Lo conoce, pero no lo utiliza", modify
	label define conocimiento_programas_5 3  "No lo conoce", modify
	label define conocimiento_programas_5 4  "Desconoce si su empresa usa o conoce estos programas", modify

	label define conocimiento_programas_6 1  "Lo conoce y lo utiliza"
	label val conocimiento_programas_6 conocimiento_programas_6
	label define conocimiento_programas_6 2  "Lo conoce, pero no lo utiliza", modify
	label define conocimiento_programas_6 3  "No lo conoce", modify
	label define conocimiento_programas_6 4  "Desconoce si su empresa usa o conoce estos programas", modify

	label define conocimiento_programas_7 1  "Lo conoce y lo utiliza"
	label val conocimiento_programas_7 conocimiento_programas_7
	label define conocimiento_programas_7 2  "Lo conoce, pero no lo utiliza", modify
	label define conocimiento_programas_7 3  "No lo conoce", modify
	label define conocimiento_programas_7 4  "Desconoce si su empresa usa o conoce estos programas", modify


	*****Módulo E: Cierre y consentimiento
	
	rename v422 acceso_datos_funcionarios
	rename v423 recibir_apoyo_1
	rename v424 recibir_apoyo_2
	rename v425 recibir_apoyo_3
	rename v426 recibir_apoyo_4
	rename v427 ser_contactado
	rename v428 apoyo_contacto_1
	rename v429 apoyo_contacto_2
	rename v430 apoyo_contacto_3
	rename v431 apoyo_contacto_4

	
	label var acceso_datos_funcionarios "¿Acepta que funcionarios del MinTrab, SENCE  y de otros servicios asociados, tengan acceso a los datos aportados en esta encuesta para apoyarla en sus procesos de capacitación, certificación y reclutamiento de trabajadores?"
	label var recibir_apoyo_1 "Reclutamiento de trabajadores (Oficinas Municipales de Información Laboral y Ejecutivos de SENCE) "
	label var recibir_apoyo_2 "Acceso a Franquicia Tributaria, capacitación en general y subsidios a la contratación (Ejecutivos de SENCE)"
	label var recibir_apoyo_3 "Certificación de competencias laborales a través del Sistema Nacional de Certificación de Competencias Laborales (Chile Valora)"
	label var recibir_apoyo_4 "Otro"
	label var ser_contactado "¿Le interesa ser contactado por profesionales del MinTrab, el SENCE y otros servicios asociados para apoyarlo en sus necesidades de capacitación, certificación y reclutamiento de trabajadores, pero sin que tengan acceso a los datos aportados en esta encuesta?"
	label var apoyo_contacto_1 "Reclutamiento de trabajadores (Oficinas Municipales de Información Laboral y Ejecutivos de SENCE) "
	label var apoyo_contacto_2 "Acceso a Franquicia Tributaria, capacitación en general y subsidios a la contratación (Ejecutivos de SENCE)"
	label var apoyo_contacto_3 "Certificación de competencias laborales a través del Sistema Nacional de Certificación de Competencias Laborales (Chile Valora)"
	label var apoyo_contacto_4 "Otro"

	label define acceso_datos_funcionarios 1 "Sí" 2 "No"
	label val acceso_datos_funcionarios acceso_datos_funcionarios
	
	label define ser_contactado 1 "Sí" 2 "No"
	label val ser_contactado ser_contactado
	
	capture tostring recibir_apoyo_4
	replace recibir_apoyo_4="" if recibir_apoyo_4=="."
	
	gen recibir_apoyo_4_texto=recibir_apoyo_4
	replace recibir_apoyo_4="1" if recibir_apoyo_4!=""
	destring recibir_apoyo_4, replace
	
	capture tostring apoyo_contacto_4
	replace apoyo_contacto_4="" if apoyo_contacto_4=="."	
	
	gen apoyo_contacto_4_texto=apoyo_contacto_4
	replace apoyo_contacto_4="1" if apoyo_contacto_4!=""
	destring apoyo_contacto_4, replace

	forval i=1/4{
		label define recibir_apoyo_`i' 1 "Sí"
		label val recibir_apoyo_`i' recibir_apoyo_`i'
		
		label define apoyo_contacto_`i' 1 "Sí"
		label val apoyo_contacto_`i' apoyo_contacto_`i'
	}
	
	**correcciones finales**
	tostring monto_inversion_pesos monto_inversion_dolares, replace
	
	gen region_que_levanta=substr("`file'",1,strpos("`file'",".xlsx")-1)

	if `aux'==1{
		save "$salida\Enadelpi_2021.dta", replace
		
		
	}
	else{
		append using "$salida\Enadelpi_2021.dta", force 
		save "$salida\Enadelpi_2021.dta", replace
	}
	
	local `++aux'
	
 }
}

capture destring monto_inversion_dolares, replace
drop if folio==.
order sin_educS_c_reclut_14_texto con_educS_c_reclut_14_texto, after(con_educS_c_reclutamiento_14)
order fuentes_financiamiento_6_texto, after(fuentes_financiamiento_6)
order competencias1_grupo_prior_texto-competencias6_grupo_prior_texto, after(competencias6_grupo_prioritario)
order recibir_apoyo_4_texto, after(recibir_apoyo_4)
order apoyo_contacto_4_texto, after(apoyo_contacto_4)

drop if folio==1213 //eliminar por solicitud de Magallanes

save "$salida\Enadelpi_2021.dta", replace




