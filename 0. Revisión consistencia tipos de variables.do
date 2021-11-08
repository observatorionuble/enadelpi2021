
cls
clear all
set more off

global dir1 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\QP excel"
global salida "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado"

*ssc install egenmore

save base1, emptyok replace

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
          
				  egen N = sieve(v`var'), keep(n)
				  capture assert N == v`var'
				  if _rc{
				      //presenta letras
				      egen S = sieve(v`var'), keep(a)
					  capture assert S = v`var'
					  if _rc{
					      //es una mezcla entre texto y números
						  preserve
						   keep if N!="" 
						   //me quedó solo con las filas que tienen letras
							replace v`var'=ustrlower(v`var') 
							
							duplicates drop v`var', force
							noisily list v`var' 
							rename v`var' variable_string
	
					
						    append using base1
							save base1, replace
						
					         
						  restore
						  
					  }
					  else{
					      //sólo texto
						  preserve
						    keep if N!=""
							replace v`var'=ustrlower(v`var')
						    
							replace v`var'=ustrlower(v`var') 
							duplicates drop v`var', force
							
							noisily list v`var' 
							
							rename v`var' variable_string


							append using base1
							save base1, replace

						  restore
						  
					  }
					  
					  
				  }
				  else{
				    //sólo números
					 //estos casos no interesan  
				  }
				  capture drop N
				  capture drop S

					
			
		
	}
 }
}

**revisando los valores string, listado único
use base1, clear
duplicates drop variable_string, force
list variable_string
erase base1.dta
 
 ***Revisando errores**
 
import excel using "$dir1\\Valparaíso.xlsx", sheet("Datos sin procesar") case(lower) clear
 drop if _n==1   //elimino nombre de columnas
  local x=1
  foreach v of varlist *{
  	rename `v' v`x'
	local `++x'
  }
 br v82 if _n==1
 destring v82, replace force
 
 /*

global dir1 "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\QP excel autoaplicada"
global salida "C:\Users\asand\OneDrive - Servicio Nacional de Capacitación y empleo\Encuesta Proyectos de Inversión\BBDD\Consolidado"


local files : dir "$dir1" files "*.xlsx", respectcase
local aux=1
foreach file of local files {
quietly{
  import excel using "$dir1\\`file'", sheet("Datos sin procesar") case(lower) clear
  gen folio=.
  gen encuestador=""
  gen A8_no_responde=""
  order folio encuestador, after(Q)
  order A8_no_responde,after(AX)
  
  drop if _n==1   //elimino nombre de columnas
  local x=1
  foreach v of varlist *{
  	rename `v' v`x'
	local `++x'
  }
  
  noisily dis "`file'"
			   gen byte non_num=.
  
				foreach var of numlist 66/117 121(4)141 122(4)142 148/255 259(6)289 260(6)290 261(6)291 262(6)292 345/349{
                  *noisily display " v`var' "  _col(20) "`: type v`var''"
				  if "`:type v`var''" == "byte" | "`:type v`var''" == "int" | "`:type v`var''" == "long"{
					
				  }
				  else{
				   replace non_num = indexnot(substr(v`var',1,1), "0123456789")
				  * noisily list v`var' if non_num
				  preserve
					keep if non_num
					replace v`var'=ustrlower(v`var') 
					rename v`var' variable_string
					if `aux'==1 save base1, replace
					else{
					    append using base1
						save base1, replace
						
					}
					
					
				  restore
				   local `++aux'
					
				   replace v`var'="" if v`var'=="ESTAN LIQUIDANDO TODO,CERRANDO,PARA EL PROXIMO AÑO COMENZAR CON UN NUEVO GIRO"
				   replace v`var'=ustrlower(v`var') 
				   replace v`var'="" if inlist(v`var', "ns","nr","na","x","o","si")
			       *noisily destring `var', replace
				  }	
	             }	
  
  
   
	
 }
}
 
 **revisando los valores string, listado único
use base1, clear
capture duplicates drop variable_string, force
capture list variable_string
erase base1.dta