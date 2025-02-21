# -*- coding: utf-8 -*-
import os
import time
import subprocess
import sys


from pymongo import MongoClient

#subprocess.run(["bash", "-c", "export ORACLE_HOME=/usr/lib/oracle/11.2/client64"])
#subprocess.run(["bash", "-c", "export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH"])
# Obtener el primer argumento (el parámetro pasado)
anomes = sys.argv[1]

# Hacer algo con el parámetro
print("El parámetro recibido es:", anomes)
# Oracle DB Configuration

# MongoDB Configuration
mongo_client = MongoClient('mongodb://ebaldeon:Kekereke1984@atprodbd-mongodb01.vuce.gob.pe:27017,atprodbd-mongodb02.vuce.gob.pe:27017,mtprodbd-drpmongodb01.vuce.gob.pe:27017/?replicaSet=vuceRSProd')

db_name = "vuce-buzonelectronico"
collection_name = "A_"+ anomes
new_collection_name = "BA_"+ anomes  # Name for the new collection

start_time = time.time()

# Format the start message
start_message = f"Process started at {time.asctime()}"

# Log the start message
##logger.info(start_message)
print(start_message) 
# Batch Processing and MongoDB Insertion
batch_size = 50000
try:
    # Connection details (replace with your actual connection details)
    # Connect to the database
    db = mongo_client[db_name]
    collection = db[collection_name]
    new_mongo_collection = db[new_collection_name]    
    componente = db["componente"].find({"ind_estado": "A"})
    tipo_envio = db["tipo_envio"].find({"ind_estado": "A"})
    tipo_contenido = db["tipo_contenido"].find({"ind_estado": "A"})
    plantilla_contenido = db["plantilla_contenido"].find({"estado": "A"})
    estado = db["estado"].find({"ind_estado": "A"})
    entidad = db["entidad"].find({"estado": "A"})
    tipo_documento = db["tipo_documento"].find({"ind_estado": "A"})
    carpeta_documento = db["carpeta_documento"].find({"ind_estado": "A"})
    adjuntos_cursor = db["A_" + anomes + "_ADJ"].find({})
    adjuntos_dict = {}
    for adjunto1 in adjuntos_cursor:
        mensajes_id = adjunto1["mensajes_id"]
        if mensajes_id not in adjuntos_dict:
            adjuntos_dict[mensajes_id] = []
        adjuntos_dict[mensajes_id].append(adjunto1)
    
    # Convertir las colecciones en diccionarios para facilitar el lookup
    componente_dict = {comp['componente_id']: comp for comp in componente}
    tipo_envio_dict = {envio['code']: envio for envio in tipo_envio}
    tipo_contenido_dict = {contenido['tipo_contenido_id']: contenido for contenido in tipo_contenido}
    plantilla_contenido_dict = {plantilla['mensaje_texto_id']: plantilla for plantilla in plantilla_contenido}
    estado_dict = {estado_doc['code']: estado_doc for estado_doc in estado}
    entidad_dict = {entidad_doc['entidad_id']: entidad_doc for entidad_doc in entidad}
    tipo_documento_dict = {tipo_doc['code']: tipo_doc for tipo_doc in tipo_documento}
    carpeta_documento_dict = {carpeta['carpeta_documento_id']: carpeta for carpeta in carpeta_documento}

    documents = collection.find()

    # Lista para almacenar los resultados procesados
    batch = []

    for doc in documents:
    
        # Lookup: Componente
        componente_doc = componente_dict.get(doc['codComponente'], {})
        
        # Lookup: Tipo Envio
        tipo_envio_doc = tipo_envio_dict.get(doc['codTipoEnvio'], {})
        
        # Lookup: Tipo Contenido
        tipo_contenido_doc = tipo_contenido_dict.get(doc['codTipoContenidoEnvio'], {})
        
        # Lookup: Plantilla Contenido
        plantilla_contenido_doc = plantilla_contenido_dict.get(doc['codPlantillaContenido'], {})
        
        # Lookup: Estado
        estado_doc = estado_dict.get(doc['estadoDocumento'], {})
        
        # Lookup: Entidad
        entidad_doc = entidad_dict.get(doc['codEntidad'], {})
        
        # Lookup: Tipo Documento
        tipo_documento_doc = tipo_documento_dict.get(doc['codEtiquetaDocumento'], {})
        
        # Lookup: Carpeta Documento
        carpeta_documento_doc = carpeta_documento_dict.get(doc['codCarpetaDocumento'], {})

        adjuntos_doc = adjuntos_dict.get(doc['codMensaje'], [])          
        # Proyección de salida
        transformed_doc = {
            "_id": doc.get("_id"),
            "code_mensaje": doc.get("codMensaje"),
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
            "fechaemision": doc.get("fechahoraEnvio"),
            "leido": {
                "indicador": doc.get("leido") == "S",
                "fecha": doc.get("fechaLeido"),
                "usuarioregid": "441740"
            },
            "mensaje": {
                "asunto": doc.get("asunto"),
                "cuerpo": doc.get("mensaje"),
            },
            "tiposlink": plantilla_contenido_doc.get("links", []),
            "estado": {
                "code": estado_doc.get("code"),
                "nombre": estado_doc.get("nombre"),
                "letter": estado_doc.get("letter"),
                "letterColor": estado_doc.get("letterColor"),
                "backgroundColor": estado_doc.get("backgroundColor")
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
                "_id": doc.get("emisor_id"),
                "usuario_id": doc.get("emisor_id"),
                "usuario_tipo_id": doc.get("emisor_tipo_id"),
                "documento_tipo": doc.get("emisor_documento_tipo"),
                "numero_documento": doc.get("emisor_numero_documento"),
                "usuario_sol": doc.get("emisor_usuario_sol"),
                "nombre": doc.get("emisor_nombre"),
                "email": doc.get("emisor_email"),
                "empresa_id": doc.get("emisor_empresa_id"),
                "entidad_id": doc.get("emisor_entidad_id"),
            },
            "destinatario": {
                "_id": doc.get("dest_id"),
                "usuario_id": doc.get("dest_id"),
                "usuario_tipo_id": doc.get("dest_tipo_id"),
                "documento_tipo": doc.get("dest_documento_tipo"),
                "numero_documento": doc.get("dest_numero_documento"),
                "usuario_sol": doc.get("dest_usuario_sol"),
                "nombre": doc.get("dest_nombre"),
                "email": doc.get("dest_email"),
                "empresa_id": doc.get("dest_empresa_id"),
                "entidad_id": doc.get("dest_entidad_id")
            },
            "adjuntos": adjuntos_doc if adjuntos_doc else [],
            "auditoria": {
                "usuarioregid": doc.get("codUsuarioEnvio"),
                "Fechareg": doc.get("fechahoraEnvio"),
            }
        }
        if doc.get("descripcion_notificacion") is not None:
            transformed_doc["descripcion_notificacion"] = doc.get("descripcion_notificacion")
        if doc.get("codOrden"):
            transformed_doc["orden"] = doc.get("codOrden")

        if doc.get("codSuce"):
            transformed_doc["suce"] = doc.get("codSuce")

        if doc.get("codDr"):
            transformed_doc["dr"] = doc.get("codDr")            
        # Agregar el documento procesado a la lista
        batch.append(transformed_doc)

        # Insertar los resultados procesados en la nueva colección
        if len(batch) == batch_size:
                new_mongo_collection.insert_many(batch)
                batch.clear()
    if batch:
        new_mongo_collection.insert_many(batch)
        # Mostrar mensaje de éxito
                
except Exception as e:
    print(f"Error general: {e}")
finally:
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
