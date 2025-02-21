#!/bin/bash
anno="2012"
nohup python3 01_crea_msg.py "${anno}01" > crea_msg_${anno}01.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}02" > crea_msg_${anno}02.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}03" > crea_msg_${anno}03.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}04" > crea_msg_${anno}04.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}05" > crea_msg_${anno}05.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}06" > crea_msg_${anno}06.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}07" > crea_msg_${anno}07.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}08" > crea_msg_${anno}08.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}09" > crea_msg_${anno}09.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}10" > crea_msg_${anno}10.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}11" > crea_msg_${anno}11.log 2>&1 &
nohup python3 01_crea_msg.py "${anno}12" > crea_msg_${anno}12.log 2>&1 &
#"python3 actualiza_msg.py "$parametro"
