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
jod_id = sys.argv[1]

# Hacer algo con el parámetro
print("El parámetro recibido es:", jod_id)

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
#mongo_client = MongoClient('mongodb://vuce-buzonelectronico:simplEd17y@atcapabd-mongodb01.vuce.gob.pe:27017,atcapabd-mongodb01.vuce.gob.pe:27018,atcapabd-mongodb01.vuce.gob.pe:27019/vuce-buzonelectronico?replicaSet=vuceRSCapacita&authSource=vuce-buzonelectronico')

#prod
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
    componente = db["componente"].find({"ind_estado": "A"})
    tipo_envio = db["tipo_envio"].find({"ind_estado": "A"})
    tipo_contenido = db["tipo_contenido"].find({"ind_estado": "A"})
    plantilla_contenido = db["plantilla_contenido"].find({"estado": "A"})
    estado = db["estado"].find({"ind_estado": "A"})
    entidad = db["entidad"].find({"estado": "A"})
    tipo_documento = db["tipo_documento"].find({"ind_estado": "A"})
    carpeta_documento = db["carpeta_documento"].find({"ind_estado": "A"})

    componente_dict = {comp['componente_id']: comp for comp in componente}
    tipo_envio_dict = {envio['code']: envio for envio in tipo_envio}
    tipo_contenido_dict = {contenido['tipo_contenido_id']: contenido for contenido in tipo_contenido}
    plantilla_contenido_dict = {plantilla['mensaje_texto_id']: plantilla for plantilla in plantilla_contenido}
    estado_dict = {estado_doc['code']: estado_doc for estado_doc in estado}
    entidad_dict = {entidad_doc['entidad_id']: entidad_doc for entidad_doc in entidad}
    tipo_documento_dict = {tipo_doc['code']: tipo_doc for tipo_doc in tipo_documento}
    carpeta_documento_dict = {carpeta['carpeta_documento_id']: carpeta for carpeta in carpeta_documento}
        
    # Define the cant_limit parameter for the procedure
    # Prepare the procedure call
    cursor = conn.cursor()    
    cursor.callproc("VCOBJ.SYNC_BUZON_MENSAJE", [jod_id, None])  # Calling the procedure with cant_limit and an empty ref cursor

    # Fetch the result from the OUT parameter (ref cursor)
    r_syncr = cursor.var(cx_Oracle.CURSOR)
    cursor.callproc("VCOBJ.SYNC_BUZON_MENSAJE", [jod_id, r_syncr])

    # Fetch rows from the ref cursor
    rows = r_syncr.getvalue().fetchall()

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
		usu_mod_aud              in rows:
        
        # Lookup: Componente
        componente_doc = componente_dict.get(codComponente, {})
        
        # Lookup: Tipo Envio
        tipo_envio_doc = tipo_envio_dict.get(codTipoEnvio, {})
        
        # Lookup: Tipo Contenido
        tipo_contenido_doc = tipo_contenido_dict.get(codTipoContenidoEnvio, {})
        
        # Lookup: Plantilla Contenido
        plantilla_contenido_doc = plantilla_contenido_dict.get(codPlantillaContenido, {})
        
        # Lookup: Estado
        estado_doc = estado_dict.get(estadoDocumento, {})
        
        # Lookup: Entidad
        entidad_doc = entidad_dict.get(codEntidad, {})
        
        # Lookup: Tipo Documento
        tipo_documento_doc = tipo_documento_dict.get(codEtiquetaDocumento, {})
        
        # Lookup: Carpeta Documento
        carpeta_documento_doc = carpeta_documento_dict.get(codCarpetaDocumento, {})
        
        if mensaje:
					column3_clob = mensaje.read()  # Assuming 'mensaje' is a CLOB object
		
         transformed_doc = {
            "code_mensaje": codMensaje,
            "componente": {
                "_id": componente_doc.get("_id"),
                "descripcion": componente_doc.get("descripcion"),
                "code": componente_doc.get("code"),
                "icon": componente_doc.get("icon"),
                "auditoria": componente_doc.get("auditoria"),
                "ind_estado": componente_doc.get("ind_estado"),
            },
            "tipo_envio": {
                "_id": tipo_envio_doc.get("_id"),
                "descripcion": tipo_envio_doc.get("descripcion"),
                "code": tipo_envio_doc.get("code"),
                "icon": tipo_envio_doc.get("icon"),
                "backgroundColor": tipo_envio_doc.get("backgroundColor"),
                "titleColor": tipo_envio_doc.get("titleColor"),
                "auditoria": tipo_envio_doc.get("auditoria"),
                "ind_estado": tipo_envio_doc.get("ind_estado"),
            },
            "tipo_contenido": {
                "code": tipo_contenido_doc.get("code"),
                "descripcion": tipo_contenido_doc.get("descripcion"),
            },
            "plantilla_contenido": {
                "mensaje_texto_id": plantilla_contenido_doc.get("mensaje_texto_id"),
                "asunto": plantilla_contenido_doc.get("asunto"),
                "asunto_html": plantilla_contenido_doc.get("asunto_html"),
                "texto_plano": plantilla_contenido_doc.get("texto_plano"),
                "cod_etiqueta_documento": plantilla_contenido_doc.get("tipo_mime"),
                "cod_tipo_envio": plantilla_contenido_doc.get("tipo_envio_mensaje"),
                "cod_carpeta_documento": plantilla_contenido_doc.get("tipo_mensaje"),
            },
            "importante": True,
            "fechaemision": fechahoraEnvio,
            "leido": {
                "indicador": leido == "S",
                "fecha": fechaLeido,
                "usuarioregid": "441740"
            },
            "mensaje": {
                "asunto": asunto,
                "cuerpo": if mensaje else None,
            },
            "tiposlink": plantilla_contenido_doc.get("links", []),
            "estado": {
                "code": estado_doc.get("code"),
                "nombre": estado_doc.get("nombre"),
                "letter": estado_doc.get("letter"),
                "letterColor": estado_doc.get("letterColor"),
                "backgroundColor": estado_doc.get("backgroundColor"),
                "adjuntos_pendientes":0
            },

            "entidad": {
                "code": entidad_doc.get("code"),
                "nombre": entidad_doc.get("nombre")
            },
            "origen_documento": {
                "code": tipo_documento_doc.get("code"),
                "code2": tipo_documento_doc.get("code2"),
                "nombre": tipo_documento_doc.get("nombre"),
                "descripcion": tipo_documento_doc.get("descripcion"),
                "titleColor": tipo_documento_doc.get("titleColor"),
                "backgroundColor": tipo_documento_doc.get("backgroundColor")
            },
            "carpeta_documento": {
                "code": carpeta_documento_doc.get("code"),
                "nombre": carpeta_documento_doc.get("nombre"),
                "icon": carpeta_documento_doc.get("icon"),
            },
            "carpeta_entidad": {
                "_id": entidad_doc.get("_id"),
                "code": entidad_doc.get("code"),
                "nombre": entidad_doc.get("nombre"),
                "ind_estado": entidad_doc.get("estado"),
            },
            "emisor": {
                "_id": emisor_id,
                "usuario_id": emisor_id,
                "usuario_tipo_id": emisor_tipo_id,
                "documento_tipo": emisor_documento_tipo,
                "numero_documento": emisor_numero_documento,
                "usuario_sol": emisor_usuario_sol,
                "nombre": emisor_nombre,
                "email": emisor_email,
                "empresa_id": emisor_empresa_id,
                "entidad_id": emisor_entidad_id,
            },
            "destinatario": {
                "_id": dest_id,
                "usuario_id": dest_id,
                "usuario_tipo_id": dest_tipo_id,
                "documento_tipo": dest_documento_tipo,
                "numero_documento": dest_numero_documento,
                "usuario_sol": dest_usuario_sol,
                "nombre": dest_nombre,
                "email": dest_email,
                "empresa_id": dest_empresa_id,
                "entidad_id": dest_entidad_id
            },
            "adjuntos": [],
            "auditoria": {
                "usuarioregid": codUsuarioEnvio,
                "Fechareg": fechahoraEnvio,
            }
        }
        if descripcion_notificacion is not None:
            transformed_doc["descripcion_notificacion"] = descripcion_notificacion
        if codOrden:
            transformed_doc["orden"] = codOrden

        if codSuce:
            transformed_doc["suce"] = codSuce

        if codDr:
            transformed_doc["dr"] = codDr    
        

		batch.append(transformed_doc)

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
