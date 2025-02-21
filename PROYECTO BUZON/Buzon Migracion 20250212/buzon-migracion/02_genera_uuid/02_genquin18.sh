#!/bin/bash
anno=$1
nohup java -jar filenetquin18.jar  "${anno}01" 1 >> 02_genera_uuid_quin_${anno}01.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}02" 1 >> 02_genera_uuid_quin_${anno}02.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}03" 1 >> 02_genera_uuid_quin_${anno}03.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}04" 1 >> 02_genera_uuid_quin_${anno}04.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}05" 1 >> 02_genera_uuid_quin_${anno}05.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}06" 1 >> 02_genera_uuid_quin_${anno}06.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}07" 1 >> 02_genera_uuid_quin_${anno}07.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}08" 1 >> 02_genera_uuid_quin_${anno}08.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}09" 1 >> 02_genera_uuid_quin_${anno}09.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}10" 1 >> 02_genera_uuid_quin_${anno}10.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}11" 1 >> 02_genera_uuid_quin_${anno}11.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}12" 1 >> 02_genera_uuid_quin_${anno}12.log 2>&1 &

nohup java -jar filenetquin18.jar  "${anno}01" 2 >> 02_genera_uuid_quin_${anno}01.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}02" 2 >> 02_genera_uuid_quin_${anno}02.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}03" 2 >> 02_genera_uuid_quin_${anno}03.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}04" 2 >> 02_genera_uuid_quin_${anno}04.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}05" 2 >> 02_genera_uuid_quin_${anno}05.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}06" 2 >> 02_genera_uuid_quin_${anno}06.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}07" 2 >> 02_genera_uuid_quin_${anno}07.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}08" 2 >> 02_genera_uuid_quin_${anno}08.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}09" 2 >> 02_genera_uuid_quin_${anno}09.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}10" 2 >> 02_genera_uuid_quin_${anno}10.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}11" 2 >> 02_genera_uuid_quin_${anno}11.log 2>&1 &
nohup java -jar filenetquin18.jar  "${anno}12" 2 >> 02_genera_uuid_quin_${anno}12.log 2>&1 &
