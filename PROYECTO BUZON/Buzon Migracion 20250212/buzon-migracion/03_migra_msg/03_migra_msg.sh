# Obtener el parámetro pasado al script
#parametro="$1"

export ORACLE_HOME=/usr/lib/oracle/11.2/client64
export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
anno="2012"
# Ejecutar el script Python, pasando el parámetro
#"python3 crea_msg.py "$parametro"
nohup python3 03_migra_msg.py "${anno}01" > migra_msg_${anno}01.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}02" > migra_mgs_${anno}02.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}03" > migra_mgs_${anno}03.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}04" > migra_mgs_${anno}04.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}05" > migra_mgs_${anno}05.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}06" > migra_mgs_${anno}06.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}07" > migra_mgs_${anno}07.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}08" > migra_mgs_${anno}08.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}09" > migra_mgs_${anno}09.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}10" > migra_mgs_${anno}10.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}11" > migra_mgs_${anno}11.log 2>&1 &
nohup python3 03_migra_msg.py "${anno}12" > migra_mgs_${anno}12.log 2>&1 &
#"python3 actualiza_msg.py "$parametro"