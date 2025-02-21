# -*- coding: utf-8 -*-
import os
import time
import subprocess
import sys
from pymongo import MongoClient

# Obtener el primer argumento (el parámetro pasado)
anomes = sys.argv[1]

# Hacer algo con el parámetro
print("El parámetro recibido es:", anomes)

# MongoDB Configuration
mongo_client = MongoClient('mongodb://ebaldeon:Kekereke1984@atprodbd-mongodb01.vuce.gob.pe:27017,atprodbd-mongodb02.vuce.gob.pe:27017,mtprodbd-drpmongodb01.vuce.gob.pe:27017/?replicaSet=vuceRSProd')

db_name = "vuce-buzonelectronico"
collection_name = "A_" + anomes
new_collection_name = "BA_" + anomes  # Name for the new collection

start_time = time.time()

# Format the start message
start_message = f"Process started at {time.asctime()}"
print(start_message)

# Batch Processing and MongoDB Insertion
batch_size = 2000

try:
    # Connection details (replace with your actual connection details)
    # Pipeline definition
    pipeline = [
        {
            "$lookup": {
                "from": "A_" + anomes + "_ADJ",
                "let": {"codMensaje": "$codMensaje"},
                "pipeline": [
                    {
                        "$match": {
                            "$expr": {
                                "$and": [
                                    {"$eq": ["$mensajes_id", "$$codMensaje"]}
                                ]
                            }
                        }
                    }
                ],
                "as": "adjuntos"
            }
        },
        {
            "$project": {
                "code_mensaje": "$codMensaje",
                "descripcion_notificacion": {"$cond": {"if": {"$eq": ["$descripcion_notificacion", None]}, "then": "$$REMOVE", "else": "$descripcion_notificacion"}},
                "importante": {"$literal": True},
                "fechaemision": "$fechahoraEnvio",
                "leido": {"$cond": {"if": {"$eq": ["$leido", "S"]}, "then": {"indicador": True, "fecha": "$fechaLeido", "usuarioregid": "441740"}, "else": {"indicador": False, "fecha": "$fechaLeido", "usuarioregid": "441740"}}},
                "mensaje": {"asunto": "$asunto", "cuerpo": "$mensaje"},
                "orden": {"$cond": {"if": {"$eq": ["$codOrden", None]}, "then": "$$REMOVE", "else": "$codOrden"}},
                "suce": {"$cond": {"if": {"$eq": ["$codSuce", None]}, "then": "$$REMOVE", "else": "$codSuce"}},
                "dr": {"$cond": {"if": {"$eq": ["$codDr", None]}, "then": "$$REMOVE", "else": "$codDr"}},
                "emisor": {"_id": "$emisor_id", "usuario_id": "$emisor_id", "usuario_tipo_id": "$emisor_tipo_id", "documento_tipo": "$emisor_documento_tipo", "numero_documento": "$emisor_numero_documento", "usuario_sol": "$emisor_usuario_sol", "nombre": "$emisor_nombre", "email": "$emisor_email", "empresa_id": "$emisor_empresa_id", "entidad_id": "$emisor_entidad_id"},
                "destinatario": {"_id": "$dest_id", "usuario_id": "$dest_id", "usuario_tipo_id": "$dest_tipo_id", "documento_tipo": "$dest_documento_tipo", "numero_documento": "$dest_numero_documento", "usuario_sol": "$dest_usuario_sol", "nombre": "$dest_nombre", "email": "$dest_email", "empresa_id": "$dest_empresa_id", "entidad_id": "$dest_entidad_id"},
                "adjuntos": {"$ifNull": ["$adjuntos", []]},
                "auditoria": {"usuarioregid": "$codUsuarioEnvio", "Fechareg": "$fechahoraEnvio"}
            }
        },
    ]

    # Connect to the database
    mongo_db = mongo_client[db_name]
    mongo_collection = mongo_db[collection_name]
    total_documents = mongo_collection.count_documents({})
    # Execute the aggregation in batches
    for batch_start in range(0, total_documents, batch_size):
        batch_pipeline = pipeline + [
            {"$skip": batch_start},  # Skip already processed documents
            {"$limit": batch_size}   # Limit the batch size
        ]
        
        # Agregar el operador $merge al final
        batch_pipeline.append({
            "$merge": {"into": new_collection_name, "whenMatched": "merge", "whenNotMatched": "insert"}
        })
        
        # Ejecutar la agregación
        result = mongo_collection.aggregate(batch_pipeline, batchSize=batch_size)
        

        # Optional check to see if the batch ran successfully
        if result:
           print(f"Procesando documentos del {batch_start} al {batch_start + batch_size - 1}")
        else:
            print("Error occurred during aggregation.")
                
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
    print(end_message)
    print("Data transfer completed.")
