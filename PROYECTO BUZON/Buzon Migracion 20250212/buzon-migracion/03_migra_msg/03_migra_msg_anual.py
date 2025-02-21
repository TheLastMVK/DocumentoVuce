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
#conn = oracledb.connect(host='XXXXXXXXX', port=1521, service_name='XXXXXXXXXXX', user='XXX', password='XXXXXXX', mode=oracledb.SYSDBA)

#certi
conn = oracledb.connect(host='192.168.8.171', port=1521, service_name='vucepr.vuce.gob.pe', user='Sys', password='temporal2028', mode=oracledb.SYSDBA)

#capa
#conn = oracledb.connect(host='XXXXXXXXX', port=1521, service_name='XXXXXXXXXXX', user='XXX', password='XXXXXXX', mode=oracledb.SYSDBA)
#MongoDB Configuration

#desa
#mongo_client = MongoClient('mongodb://ebaldeon:Kekereke1984@atcertbd-mongodb01.vuce.gob.pe,atcertbd-mongodb01.vuce.gob.pe:27017,atcertbd-mongodb01.vuce.gob.pe:27017/mensajes?authSource=admin&replicaSet=vuceRSCert')

#certi
# mongo_client = MongoClient('mongodb://ebaldeon:Kekereke1984@atcertbd-mongodb01.vuce.gob.pe,atcertbd-mongodb01.vuce.gob.pe:27017,atcertbd-mongodb01.vuce.gob.pe:27017/mensajes?authSource=admin&replicaSet=vuceRSCert')

#capa
mongo_client = MongoClient('mongodb://ebaldeon:Kekereke1984@atprodbd-mongodb01.vuce.gob.pe:27017,atprodbd-mongodb02.vuce.gob.pe:27017,mtprodbd-drpmongodb01.vuce.gob.pe:27017/?replicaSet=vuceRSProd')


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
        
	cursor.execute("SELECT a.mensaje_id,a.adjunto_id,a.adjunto_tipo,a.nombre_archivo,a.uuid FROM VCOBJ.A_"+anomes+"_ADJ a")
	rows = cursor.fetchall()

	# Conexión a MongoDB
	collection = mongo_db["A_"+anomes+"_ADJ"]
	batch1 = [] 
	# Transformación y inserción de datos
	for row in rows:
		# Suponiendo que row es una tupla
		doc = {
			"code": row[1],
			"tipo": row[2],
			"nombre":row[3],
			"guid": row[4],
			"mensajes_id": row[0]	        	
		}
		batch1.append(doc)
		if len(batch1) == batch_size:
			collection.insert_many(batch1)
			batch1.clear()

	if batch1:
		collection.insert_many(batch1)	  

	cursor.execute("SELECT a.usuario_id,a.usuario_tipo_id,a.documento_tipo,a.numero_documento,a.nombre,a.usuario_sol,a.avatar,a.email,a.telefono,a.principal,a.empresa_id,a.entidad_id FROM VCOBJ.A_"+anomes+"_USER a")
	rows = cursor.fetchall()

	# Conexión a MongoDB
	collection = mongo_db["A_"+anomes+"_USER"]
	batch2 = [] 
	# Transformación y inserción de datos
	for row in rows:
		# Suponiendo que row es una tupla
		doc = {
			"usuario_id": row[0],
			"usuario_tipo_id": row[1],
			"documento_tipo":row[2],
			"numero_documento": row[3],
			"nombre": row[4],
			"usuario_sol": row[5],
			"avatar": row[6],
			"email": row[7],
			"telefono": row[8],
			"principal": row[9],
			"empresa_id": row[10],
			"entidad_id": row[11],
            "ind_estado": 'A',
            "auditoria" : {
                "usuarioregid" : "441740",
                "Fechareg": pytz.timezone('America/Lima').localize(datetime.now()) 
            }            
		}
		batch2.append(doc)
		if len(batch2) == batch_size:
			collection.insert_many(batch2)
			batch2.clear()

	if batch2:
		collection.insert_many(batch2)	

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
