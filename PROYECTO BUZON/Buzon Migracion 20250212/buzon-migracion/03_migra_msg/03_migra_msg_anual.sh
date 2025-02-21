# Obtener el parámetro pasado al script
#parametro="$1"

export ORACLE_HOME=/usr/lib/oracle/11.2/client64
export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH

# Ejecutar el script Python, pasando el parámetro
#"python3 crea_msg.py "$parametro"
nohup python3 03_migra_msg_anual.py "2010" > migra_msg_anual_2010.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2011" > migra_msg_anual_2011.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2012" > migra_msg_anual_2012.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2013" > migra_msg_anual_2013.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2014" > migra_msg_anual_2014.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2015" > migra_msg_anual_2015.log 2>&1 &

nohup python3 03_migra_msg_anual.py "2016" > migra_msg_anual_2016.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2017" > migra_msg_anual_2017.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2018" > migra_msg_anual_2018.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2019" > migra_msg_anual_2019.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2020" > migra_msg_anual_2020.log 2>&1 &

nohup python3 03_migra_msg_anual.py "2021" > migra_msg_anual_2021.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2022" > migra_msg_anual_2022.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2023" > migra_msg_anual_2023.log 2>&1 &
nohup python3 03_migra_msg_anual.py "2024" > migra_msg_anual_2024.log 2>&1 &
#"python3 actualiza_msg.py "$parametro"