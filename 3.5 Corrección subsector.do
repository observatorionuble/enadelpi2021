clear all
set more off

global dir0 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD"

use "$dir0\Consolidado\Enadelpi_2021.dta", clear

encode Subsector, gen(aux_subsector)
/*
br aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if inrange(aux_subsector,1,4)
br aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if inrange(aux_subsector,5,10)
br aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if inrange(aux_subsector,11,15)
br aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if inrange(aux_subsector,16,20)
br aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if inrange(aux_subsector,21,25)
br aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if inrange(aux_subsector,26,30)

br aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if inlist(aux_subsector,30,27,26,25)

br aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if inlist(aux_subsector,11,25)
*/

recode aux_subsector ///
(19 20 25 31 =1 "Obras de Vialidad") ///
(1 15 =2 "Obras Hidráulicas") ///
(17 24 =3 "Obras Sanitarias") ///
(16 =4 "Obras Portuarias") ///
(14 =5 "Obras Aeroportuarias") ///
(12 =6 "Infraestructura Ferroviaria Urbana y No Urbana") ///
(4 5 8 13 18 28 29 =7 "Edficiación Residencial") ///
(2 6 7 9 30 =8 "Edficiación No Residencial") ///
(11 26 27 =9 "Parques y plazas") ///
(22 =10 "Obras para la Industria Minera") ///
(23 =11 "Obras para la Industria No Minera") ///
(10 21 =12 "Obras para Generación Eléctrica"), gen(subsector2)

gen sector=1 
label define sector 1 "Construcción"
label val sector sector



tab subsector2

br folio aux_subsector Sector Subsector Regióndelproyecto nombre_proyecto fuente_financiamiento region_planilla if subsector2==.

replace subsector2=1 if inlist(folio,216,218,1490,1809,1810,1431,1478,1463,1488,1457,1419,1487,1499,1492,1458,1135001,1802,1470,217,1808,1498,1465,212,211,1803,1439,1135002,1440,722,1409,1497,1424,1801)
replace subsector2=4 if inlist(folio,116,1482)
replace subsector2=2 if inlist(folio,1823,638,641)
replace subsector2=8 if inlist(folio,977,1441,1477,1430,1485,113,1818,1450,1527,1814,1406,1462,115,1469,114,1442,1423,1824,721,1493,1468,1471,1495)
replace subsector2=3 if inlist(folio,644,1443,1822)
replace subsector2=12 if inlist(folio,626,611,615,624,619)
replace subsector2=7 if inlist(folio,1827,503,1827)
replace subsector2=13 if inlist(folio,643,602,652,622,662,610)

label define subsector2 13 "Obras para las Industrias Minera y Agrícola", modify

recode subsector2 ///
(1/11=1 "Obras Públicas") ///
(12 13=2 "Obras Privadas"), gen(subsector1)

save "$dir0\Consolidado\Enadelpi_2021.dta", replace