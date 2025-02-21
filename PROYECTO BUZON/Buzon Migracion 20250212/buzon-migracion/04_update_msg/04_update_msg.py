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
batch_size = 100000
try:
# Connection details (replace with your actual connection details)
    # Pipeline definition
  pipeline = [
      {
        "$lookup": {
         "from" : "componente",
         "let" : { "codComponente" :  "$codComponente"} ,
          "pipeline" : [
            {
              "$match" : {
                "$expr" : {
                "$and" : [
                    { "$eq" : ["$componente_id" , "$$codComponente" ] },
                    { "$eq" : ["$ind_estado", "A"] } 
                  ]
                }
              }
            }
          ],
          "as" : "componente"
        }
      },
      {
        "$unwind" : { 
          "path" : "$componente",
          "preserveNullAndEmptyArrays" : True
        }
      },
      {
        "$lookup": {
         "from" : "tipo_envio",
         "let" : { "codTipoEnvio": "$codTipoEnvio" },
          "pipeline" : [
            {
                
              "$match" : {
                "$expr" : {
                "$and" : [
                  { "$eq" : [ "$code" , "$$codTipoEnvio" ]},              
                  { "$eq" : ["$ind_estado", "A"] } 
                ]    
                }
              }
            }
          ],
          "as" : "tipo_envio"
        }
      },
      {
        "$unwind" : { 
          "path" : "$tipo_envio",
          "preserveNullAndEmptyArrays" : True
        }
      },  
      {
        "$lookup": {
         "from" : "tipo_contenido",
         "let" : { "codTipoContenidoEnvio": "$codTipoContenidoEnvio" },
          "pipeline" : [
            {
                
              "$match" : {
                "$expr" : {
                "$and" : [
                  { "$eq" : [ "$tipo_contenido_id" , {"$toDouble":"$$codTipoContenidoEnvio" }]},              
                  { "$eq" : ["$ind_estado", "A"] } 
                ]    
                }
              }
            }

          ],
          "as" : "tipo_contenido"
        }
      },
      {
        "$unwind" : { 
          "path" : "$tipo_contenido",
          "preserveNullAndEmptyArrays" : True
        }       
      },    
      {
      "$lookup": {
     "from" : "plantilla_contenido",
     "let" : { "codPlantillaContenido": "$codPlantillaContenido" },
          "pipeline" : [
            {
              "$match" : {
                "$expr" : {
                "$and" : [
                  { "$eq" : ["$mensaje_texto_id", "$$codPlantillaContenido"] },              
                  { "$eq" : ["$estado", "A"] } 
                  
                ]    
                }
              }
            }
          ],
          "as" : "plantilla_contenido"      
        }
      },
      {
        "$unwind" : { 
          "path" : "$plantilla_contenido",
            "preserveNullAndEmptyArrays" : True
        }         
      }, 
      {
      "$lookup": {
     "from" : "estado",
     "let" : { "estadoDocumento": "$estadoDocumento" },
          "pipeline" : [
            {
              "$match" : {
                "$expr" : {
                "$and" : [
                  { "$eq" : ["$code", "$$estadoDocumento"] },              
                  { "$eq" : ["$ind_estado", "A"] } 
                  
                ]    
                }
              }
            }
          ],
          "as" : "estado"      
        }
      },
      {
        "$unwind" : { 
          "path" : "$estado",
            "preserveNullAndEmptyArrays" : True 
        }         
      },    
      {
        "$lookup": {
         "from" : "entidad",
         "let" : { "codEntidad": "$codEntidad" },
          "pipeline" : [
            {
              "$match" : {
                "$expr" : {
                "$and" : [
                    { "$eq" : ["$entidad_id", {"$toDouble":"$$codEntidad"}] }, 
                    { "$eq" : ["$estado", "A"] }                  
                  ]
                }
              }
            }
          ],
          "as" : "entidad"      
        }
      },
      {
        "$unwind" : { 
          "path" : "$entidad",
            "preserveNullAndEmptyArrays" : True
        }         
      }, 
      {
        "$lookup": {
         "from" : "tipo_documento",
         "let" : { "codEtiquetaDocumento": "$codEtiquetaDocumento" },
          "pipeline" : [
            {
                
              "$match" : {
                "$expr" : {
                "$and" : [
                  { "$eq" : ["$code", {"$toDouble":"$$codEtiquetaDocumento"}] }, 
                  { "$eq" : ["$ind_estado", "A"] } 
                ]    
                }
              }
            }
          ],
          "as" : "tipo_documento"
      }
      },   
      {
        "$unwind" : { 
          "path" : "$tipo_documento",
            "preserveNullAndEmptyArrays" : True
        }         
      }, 
      {
          "$lookup": {
         "from" : "carpeta_documento",
         "let" : { "codCarpetaDocumento": "$codCarpetaDocumento",   "componente_code":"$componente.code"  },
          "pipeline" : [
            {
              "$match" : {
                "$expr" : {
                "$and" : [
                  { "$eq" : [ "$carpeta_documento_id" , "$$codCarpetaDocumento"]} ,
                  { "$eq" : ["$ind_estado", "A"] } ,
                  { "$eq" : ["$componente.code", "$$componente_code"] } 
                ]    
                }
              }
            }
          ],
          "as" : "carpeta_documento"
        }
      },
      {
        "$unwind" : { 
          "path" : "$carpeta_documento",
            "preserveNullAndEmptyArrays" : True 
        }         
      },    
      {
        "$lookup": {
         "from" :  "A_"+ anomes+"_ADJ",
         "let" : { "codMensaje" :  "$codMensaje"} ,
          "pipeline" : [
            {
              "$match" : {
                "$expr" : {
                "$and" : [
                    { "$eq" : ["$mensajes_id" , "$$codMensaje" ] },
                  ]
                }
              }
            }
          ],
          "as" : "adjuntos"
        }
      },
      {
      "$project" : {
            "code_mensaje": "$codMensaje",
            "componente": {
                "_id": "$componente._id",
                "descripcion": "$componente.descripcion",
                "code": "$componente.code",
                "icon": "$componente.icon",
                "auditoria": "$componente.auditoria",
                "ind_estado": "$componente.ind_estado",
            },
            "descripcion_notificacion": 
              {
                "$cond": {
                  "if": { "$eq": ["$descripcion_notificacion", None] },  
                  "then": "$$REMOVE",  
                  "else": "$descripcion_notificacion"  
                }
              }
            ,
            "tipo_envio": {
                "_id": "$tipo_envio._id",
                "descripcion": "$tipo_envio.descripcion",
                "code": "$tipo_envio.code",
                "icon": "$tipo_envio.icon",
                "backgroundColor": "$tipo_envio.backgroundColor",
                "titleColor": "$tipo_envio.titleColor",
                "auditoria": "$tipo_envio.auditoria",
                "ind_estado": "$tipo_envio.ind_estado",
            },
            "tipo_contenido": {
                "code": "$tipo_contenido.code",
                "descripcion": "$tipo_contenido.descripcion",
            },
            "plantilla_contenido": {
                "mensaje_texto_id": "$plantilla_contenido.mensaje_texto_id",
                "asunto": "$plantilla_contenido.asunto",
                "asunto_html": "$plantilla_contenido.asunto_html",
                "texto_plano": "$plantilla_contenido.texto_plano",
                "cod_etiqueta_documento": "$plantilla_contenido.tipo_mime",
                "cod_tipo_envio": "$plantilla_contenido.tipo_envio_mensaje",
                "cod_carpeta_documento": "$plantilla_contenido.tipo_mensaje",
            },                
            "importante": {"$literal": True},
            "fechaemision": "$fechahoraEnvio",
            "leido": {
                "$cond": {
                    "if": {"$eq": ["$leido", "S"]},
                    "then": {"indicador": True, "fecha": "$fechaLeido", "usuarioregid": "441740"},
                    "else": {"indicador": False, "fecha": "$fechaLeido", "usuarioregid": "441740"}
                }
            },
            "mensaje": {
                "asunto": "$asunto",
                "cuerpo": "$mensaje",
            },
            "tiposlink": "$plantilla_contenido.links",
            "estado": {
                "code": "$estado.code",
                "nombre": "$estado.nombre",
                "letter": "$estado.letter",
                "letterColor": "$estado.letterColor",
                "backgroundColor": "$estado.backgroundColor"
            },
            "orden": 
              {
                "$cond": {
                  "if": { "$eq": ["$codOrden", None] }, 
                  "then": "$$REMOVE",  
                  "else": "$codOrden"  
                }
              },
            "suce": 
              {
                "$cond": {
                  "if": { "$eq": ["$codSuce", None] },  
                  "then": "$$REMOVE",   
                  "else": "$codSuce" 
                }
              },            
            "dr": 
              {
                "$cond": {
                  "if": { "$eq": ["$codDr", None] },  
                  "then": "$$REMOVE",  
                  "else": "$codDr" 
                }
              },             
            "entidad": {
                "code": "$entidad.code",
                "nombre": "$entidad.nombre"
            },
            "origen_documento": {
                "code": "$tipo_documento.code",
                "code2": "$tipo_documento.code2",
                "nombre": "$tipo_documento.nombre",
                "descripcion": "$tipo_documento.descripcion",
                "titleColor": "$tipo_documento.titleColor",
                "backgroundColor": "$tipo_documento.backgroundColor"
            },
            "carpeta_documento": {
                "code": "$carpeta_documento.code",
                "nombre": "$carpeta_documento.nombre",
                "icon": "$carpeta_documento.icon",
            },
            "carpeta_entidad": {
                "_id": "$entidad._id",
                "code": "$entidad.code",
                "nombre": "$entidad.nombre",
                "ind_estado": "$entidad.estado",
            },
            "emisor": {
                "_id": "$emisor_id",
                "usuario_id": "$emisor_id",
                "usuario_tipo_id": "$emisor_tipo_id",
                "documento_tipo": "$emisor_documento_tipo",
                "numero_documento": "$emisor_numero_documento",
                "usuario_sol": "$emisor_usuario_sol",
                "nombre": "$emisor_nombre",
                "email": "$emisor_email",
                "empresa_id": "$emisor_empresa_id",
                "entidad_id": "$emisor_entidad_id",
            },
            "destinatario": {
                "_id": "$dest_id",
                "usuario_id": "$dest_id",
                "usuario_tipo_id": "$dest_tipo_id",
                "documento_tipo": "$dest_documento_tipo",
                "numero_documento": "$dest_numero_documento",
                "usuario_sol": "$dest_usuario_sol",
                "nombre": "$dest_nombre",
                "email": "$dest_email",
                "empresa_id": "$dest_empresa_id",
                "entidad_id": "$dest_entidad_id"
            },
            "adjuntos": { "$ifNull": ["$adjuntos", []] },
            "auditoria": {
                "usuarioregid": "$codUsuarioEnvio",
                "Fechareg": "$fechahoraEnvio",
            }
      }, 
      },     
	    #{
	    #  "$limit": 10 
	    #}, 
      # Add more aggregation stages here as needed (e.g., $group, $project)
      { "$out": new_collection_name},  # Output stage to store results
  ]
    # Connect to the database
  mongo_db = mongo_client[db_name]
  mongo_collection = mongo_db[collection_name]

    # Execute the aggregation
  result = mongo_collection.aggregate(pipeline)

    # Check for successful execution (optional)
  if result:
        print(f"Aggregation completed. Results stored in: {new_collection_name}")
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
    ##logger.info(end_message)
print(end_message) 
print("Data transferencia completeda.")
