# Obtener el parámetro pasado al script
#parametro="$1"
anno="2011"
nohup python3 02_genera_para.py "${anno}01"  >>  02_genera_para_${anno}01.log 2>&1 &
nohup python3 02_genera_para.py "${anno}02"  >>  02_genera_para_${anno}02.log 2>&1 &
nohup python3 02_genera_para.py "${anno}03"  >>  02_genera_para_${anno}03.log 2>&1 &
nohup python3 02_genera_para.py "${anno}04"  >>  02_genera_para_${anno}04.log 2>&1 &
nohup python3 02_genera_para.py "${anno}05"  >>  02_genera_para_${anno}05.log 2>&1 &
nohup python3 02_genera_para.py "${anno}06"  >>  02_genera_para_${anno}06.log 2>&1 &
nohup python3 02_genera_para.py "${anno}07"  >>  02_genera_para_${anno}07.log 2>&1 &
nohup python3 02_genera_para.py "${anno}08"  >>  02_genera_para_${anno}08.log 2>&1 &
nohup python3 02_genera_para.py "${anno}09"  >>  02_genera_para_${anno}09.log 2>&1 &
nohup python3 02_genera_para.py "${anno}10"  >>  02_genera_para_${anno}10.log 2>&1 &
nohup python3 02_genera_para.py "${anno}11"  >>  02_genera_para_${anno}11.log 2>&1 &
nohup python3 02_genera_para.py "${anno}12"  >>  02_genera_para_${anno}12.log 2>&1 &