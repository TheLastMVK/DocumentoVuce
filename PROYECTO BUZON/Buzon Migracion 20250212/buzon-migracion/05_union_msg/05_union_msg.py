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
    # Connect to the database
    mongo_db = mongo_client[db_name]
    coleccion_origen = mongo_db[ "BA_"+ anomes]
    coleccion_destino = mongo_db["envio"]
  
    for doc in coleccion_origen.find():
        # Insertar cada documento en la colección 'envio'
        coleccion_destino.insert_one(doc)

                
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
