# -*- coding: utf-8 -*-
#export ORACLE_HOME=/usr/lib/oracle/11.2/client64
#export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
	
import oracledb
import os
import time
from datetime import datetime
import sys
import subprocess
import pytz


# Ejecutar los comandos en una sola línea
subprocess.run(['export', 'ORACLE_HOME=/usr/lib/oracle/11.2/client64', '&&', 'export', 'LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH'], shell=True)
	
# Obtener el primer argumento (el parámetro pasado)
anomes = sys.argv[1]

# Hacer algo con el parámetro
print("El parámetro recibido es:", anomes)

from pymongo import MongoClient

# Oracle DB Configuration
oracledb.init_oracle_client(lib_dir='/usr/lib/oracle/11.2/client64/lib')
#desa
conn = oracledb.connect(user='inspirait', password='inspirait',dsn='(DESCRIPTION =(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 10.19.34.41)(PORT = 1521)))(CONNECT_DATA =(SID = vucede01)))')

#certi
#conn = oracledb.connect(host='192.168.8.171', port=1521, service_name='vucepr.vuce.gob.pe', user='Sys', password='temporal2028', mode=oracledb.SYSDBA)

#capa
#conn = oracledb.connect(host='XXXXXXXXX', port=1521, service_name='XXXXXXXXXXX', user='XXX', password='XXXXXXX', mode=oracledb.SYSDBA)



#MongoDB Configuration
#desa
mongo_client = MongoClient('mongodb://user-buzon:$user-buzon2022@atdesabd-mongodb01.vuce.gob.pe:27017,atdesabd-mongodb01.vuce.gob.pe:27018,atdesabd-mongodb01.vuce.gob.pe:27019/buzonvuce?replicaSet=vuceRSDev&authSource=buzonvuce')
#mongo_client = MongoClient('mongodb://vucebel:vucebel2025@atdesabd-mongodb01.vuce.gob.pe:27017,atdesabd-mongodb01.vuce.gob.pe:27018,atdesabd-mongodb01.vuce.gob.pe:27019/vuce-buzonelectronico?authSource=vuce-buzonelectronico&replicaSet=vuceRSDev')

#certi
#mongo_client = MongoClient('mongodb://vuce-buzonelectronico:simplEd17y@atcertbd-mongodb01.vuce.gob.pe:27017,atcertbd-mongodb02.vuce.gob.pe:27017,mtcertbd-drpmongodb01.vuce.gob.pe:27017/vuce-buzonelectronico?replicaSet=vuceRSCert&authSource=vuce-buzonelectronico')

#capa
#mongo_client = MongoClient('mongodb://ebaldeon:Kekereke1984@atprodbd-mongodb01.vuce.gob.pe:27017,atprodbd-mongodb02.vuce.gob.pe:27017,mtprodbd-drpmongodb01.vuce.gob.pe:27017/?replicaSet=vuceRSProd')


mongo_db = mongo_client['vuce-buzonelectronico']
mongo_collection = mongo_db['A_'+anomes]

start_time = time.time()

# Format the start message
start_message = f"Process started at {time.asctime()}"

# Log the start message
##logger.info(start_message)
print(start_message) 
# Batch Processing and MongoDB Insertion
batch_size = 100000
try:
	cursor = conn.cursor()
	query = (
		'SELECT a."codMensaje", a."codComponente", a."codEntidad", '
		'a."fechahoraEnvio", a."codUsuarioEnvio", a."codTipoEnvio", '
		'a."codTipoContenidoEnvio", a."codPlantillaContenido",a."codCarpetaDocumento", '
		' a."codEtiquetaDocumento",'
		'a."codOrden", a."codSuce", a."codDr", '
		'a."estadoDocumento", a."descripcion_notificacion", a."asunto", '
		'a."mensaje", a."suce", '
		'a."leido", a."fechaLeido", a."emisor_id", a."emisor_tipo_id", '
		'a."emisor_documento_tipo", a."emisor_numero_documento", '
		'a."emisor_usuario_sol", a."emisor_nombre", a."emisor_email", '
		'a."emisor_empresa_id", a."emisor_entidad_id", a."dest_id", '
		'a."dest_tipo_id", a."dest_documento_tipo", a."dest_numero_documento", '
		'a."dest_usuario_sol", a."dest_nombre", a."dest_email", '
		'a."dest_empresa_id", '
		'a."dest_entidad_id",a."usu_mod_aud",a."fecha_mod_aud" FROM VCOBJ.A_'+anomes+' a ')
			
	#print(query)
			
	cursor.execute(query)
	batch = []  # Initialize an empty list for documents
	for codMensaje,\
		codComponente,\
		codEntidad,\
		fechahoraEnvio,\
		codUsuarioEnvio          ,\
		codTipoEnvio             ,\
		codTipoContenidoEnvio    ,\
		codPlantillaContenido    ,\
		codCarpetaDocumento      ,\
		codEtiquetaDocumento     ,\
		codOrden                 ,\
		codSuce                  ,\
		codDr                    ,\
		estadoDocumento          ,\
		descripcion_notificacion ,\
		asunto                   ,\
		mensaje                  ,\
		suce                     ,\
		leido                    ,\
		fechaLeido               ,\
		emisor_id                ,\
		emisor_tipo_id           ,\
		emisor_documento_tipo    ,\
		emisor_numero_documento  ,\
		emisor_usuario_sol       ,\
		emisor_nombre            ,\
		emisor_email             ,\
		emisor_empresa_id        ,\
		emisor_entidad_id        ,\
		dest_id                  ,\
		dest_tipo_id             ,\
		dest_documento_tipo      ,\
		dest_numero_documento    ,\
		dest_usuario_sol         ,\
		dest_nombre              ,\
		dest_email               ,\
		dest_empresa_id          ,\
		dest_entidad_id          ,\
		fecha_mod_aud            ,\
		usu_mod_aud              in cursor:
		if mensaje:
					column3_clob = mensaje.read()  # Assuming 'mensaje' is a CLOB object
		document = {
					"codMensaje"            :codMensaje               ,
					"codComponente"         :codComponente            ,
					"codEntidad"            :codEntidad               ,
					"fechahoraEnvio"        :pytz.timezone('America/Lima').localize(fechahoraEnvio).astimezone(pytz.utc)           ,
					"codUsuarioEnvio"       :codUsuarioEnvio          ,
					"codTipoEnvio"          :codTipoEnvio             ,
					"codTipoContenidoEnvio" :codTipoContenidoEnvio    ,
					"codPlantillaContenido" :codPlantillaContenido    ,
					"codCarpetaDocumento"   :codCarpetaDocumento      ,
					"codEtiquetaDocumento"  :codEtiquetaDocumento     ,
					"codOrden"              :codOrden                 ,
					"codSuce"               :codSuce                  ,
					"codDr"                 :codDr                    ,
					"estadoDocumento"       :estadoDocumento          ,
					"descripcion_notificacion":descripcion_notificacion ,
					"asunto"                :asunto                   ,
					"mensaje": column3_clob if mensaje else None,
					"suce"                  :suce                     ,
					"leido"                 :leido                    ,
					"fechaLeido"            :fechaLeido               ,
					"emisor_id"             :emisor_id                ,
					"emisor_tipo_id"        :emisor_tipo_id           ,
					"emisor_documento_tipo" :emisor_documento_tipo    ,
					"emisor_numero_documento":emisor_numero_documento  ,
					"emisor_usuario_sol"    :emisor_usuario_sol       ,
					"emisor_nombre"         :emisor_nombre            ,
					"emisor_email"          :emisor_email             ,
					"emisor_empresa_id"     :emisor_empresa_id        ,
					"emisor_entidad_id"     :emisor_entidad_id        ,
					"dest_id"               :dest_id                  ,
					"dest_tipo_id"          :dest_tipo_id             ,
					"dest_documento_tipo"   :dest_documento_tipo      ,
					"dest_numero_documento" :dest_numero_documento    ,
					"dest_usuario_sol"      :dest_usuario_sol         ,
					"dest_nombre"           :dest_nombre              ,
					"dest_email"            :dest_email               ,
					"dest_empresa_id"       :dest_empresa_id          ,
					"dest_entidad_id"       :dest_entidad_id          ,
					"fecha_mod_aud"         :fecha_mod_aud          ,
					"usu_mod_aud"           :usu_mod_aud          ,
					
					# Handle cases where 'mensaje' might be None
		}

		batch.append(document)

		if len(batch) == batch_size:
			mongo_collection.insert_many(batch)
			batch.clear()
	if batch:
		mongo_collection.insert_many(batch)
        
except oracledb.DatabaseError as e:
    print(f"Error de base de datos: {e}")
except Exception as e:
    print(f"Error general: {e}")
finally:
    cursor.close()
    conn.close()
    mongo_client.close()
    
    end_time = time.time()

    # Calculate the execution time
    execution_time = end_time - start_time

    # Format the end message
    end_message = f"Process ended at {time.asctime()}, execution time: {execution_time:.2f} seconds"

    # Log the end message
    ##logger.info(end_message)
print(end_message) 
print("Data transferencia completeda.")
