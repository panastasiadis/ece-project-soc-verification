# Connect Core Power

globalNetConnect vdd! -type pgpin -pin vdd! -inst * -verbose
globalNetConnect vss! -type pgpin -pin vss! -inst * -verbose
# globalNetConnect vdd! -type tiehi -pin vdd! -inst * 
# globalNetConnect vss! -type tielo -pin vss! -inst * 

globalNetConnect vdd! -type pgpin -instanceBasename vdd_2 -pin pad -verbose 
globalNetConnect vss! -type pgpin -instanceBasename vss_2 -pin pad -verbose 

globalNetConnect vdd! -type tiehi -instanceBasename * -pin * -verbose 
globalNetConnect vss! -type tielo -instanceBasename * -pin * -verbose
