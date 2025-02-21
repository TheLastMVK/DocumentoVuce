import os
import time
import subprocess
import sys
from pymongo import MongoClient

# Obtener el primer argumento (el parámetro pasado)
anomes = sys.argv[1]
print("El parámetro recibido es:", anomes)

# MongoDB Configuration
mongo_client = MongoClient('mongodb://ebaldeon:Kekereke1984@atprodbd-mongodb01.vuce.gob.pe:27017,atprodbd-mongodb02.vuce.gob.pe:27017,mtprodbd-drpmongodb01.vuce.gob.pe:27017/?replicaSet=vuceRSProd')

db_name = "vuce-buzonelectronico"
start_time = time.time()

# Formato del mensaje de inicio
start_message = f"Process started at {time.asctime()}"
print(start_message)

# Configuración del tamaño del batch
batch_size = 50000

try:
    # Conexión con la base de datos
    mongo_db = mongo_client[db_name]
    coleccion_origen = mongo_db["BA_" + anomes]
    coleccion_destino = mongo_db["envio"]

    # Inicializar el lote de documentos
    batch = []

    # Procesar los documentos en lotes
    for doc in coleccion_origen.find():
        batch.append(doc)
        # Cuando se llega al tamaño del batch, insertamos los documentos
        if len(batch) == batch_size:
            coleccion_destino.insert_many(batch)
            print(f"Batch de {batch_size} documentos insertados.")
            batch.clear()  # Limpiar el lote

    # Insertar cualquier documento que quede después del último lote
    if batch:
        coleccion_destino.insert_many(batch)
        print(f"{len(batch)} documentos insertados al final.")

except Exception as e:
    print(f"Error general: {e}")

finally:
    mongo_client.close()
    end_time = time.time()

    # Calcular el tiempo de ejecución
    execution_time = end_time - start_time

    # Formato del mensaje de finalización
    end_message = f"Process ended at {time.asctime()}, execution time: {execution_time:.2f} seconds"
    print(end_message)
    print("Data transferencia completada.")

