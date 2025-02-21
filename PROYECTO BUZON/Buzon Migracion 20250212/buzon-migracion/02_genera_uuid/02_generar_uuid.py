import oracledb
import requests
from requests.auth import HTTPBasicAuth
import json
import os
import base64
import sys
import time
import subprocess

# Ejecutar los comandos en una sola línea
subprocess.run(['export', 'ORACLE_HOME=/usr/lib/oracle/11.2/client64', '&&', 'export', 'LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH'], shell=True)


oracledb.init_oracle_client(lib_dir='/usr/lib/oracle/11.2/client64/lib')
conn = oracledb.connect(host='192.168.8.171', port=1521, service_name='vucepr.vuce.gob.pe', user='Sys', password='temporal2028', mode=oracledb.SYSDBA)

# Parámetros de conexión a FileNet
										
anomes = sys.argv[1]

#BASE_URL = 'https://landing-test.vuce.gob.pe/v1/vuce-services/filenet2'
#USERNAME = 'wasadmin'
#PASSWORD = 'w1s4dm1n20'

base_url = 'https://gateway-apim.vuce.gob.pe/pass-through-https/filenet2/1.0/file'
USERNAME = 'usuariopam'
PASSWORD = 'A123456#'

token_url = 'https://gateway-apim.vuce.gob.pe/pass-through-https/oauth2/v1/token?grant_type=client_credentials'
username_token = "F7vUUpDJH9kwAeJrDwYXV5i5ADoa"
password_token = "88vPFsQ7qHX9DRtkYCIYL6i6u9Ma"

cookie = "citrix_ns_id=AAA76CGiZjsRX5EDAAAAADs03nL7N7kNagMCO6NBSjNemuAeWHgF1HA4igXg2LImOw==vCWiZg==XuPiKBI1agLXNMUHffKEY0Ljx5k=; NSC_ESNS=06b1c6eb-2238-16a2-9678-00e0ed69dc9a_2327115352_2159988557_00000000000111921981"


def genera_uuid(filename,blob_data):

    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }   
    # Metadata del documento
    data = {
        "scope": "filenet:file_create filenet:file_read filenet:file_update filenet:file_delete"
    }
    # Archivo a subir

    # Encabezados de la solicitud
    response = requests.post(token_url, headers=headers, data=data, auth=HTTPBasicAuth(username_token, password_token))

    if response.status_code == 200:
        document_token = response.json()
        bearer_token = document_token.get("access_token")  # Asegúrate de que la clave "id" contiene el UUID del documento
       # print("Documento subido con éxito")

        # Metadata del documento
        data = {
            "componente": "120",
            "opcion": "DATA",
            "foldersExtras": anomes[:4],
            "iddocumento": "",	
            "nombre": filename,
            "propiedades": {
                "adjunto_id": "1",
                "adjunto_tipo": "0"
            },
            "bytes":base64.b64encode(blob_data).decode('utf-8')
        }
        
        # Encabezados de la solicitud
        headers = {
            "Authorization": f"Bearer {bearer_token}",  # Token Bearer
            "filenetUser": USERNAME,
            "filenetPassword": PASSWORD,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Cookie": cookie
          }

        response = requests.post(url=base_url, headers=headers, data=json.dumps(data))
        
        
        if response.status_code == 200:
            document_details = response.json()
            document_uuid = document_details.get("iddocumento")  # Asegúrate de que la clave "id" contiene el UUID del documento
           # print("Documento subido con éxito")
            return document_uuid
        else:
            response.raise_for_status()
            print("Error:", response.status_code)
            print(response.text)
    else:
        response.raise_for_status()
        print("Error:", response.status_code)
        print(response.text)

# Llamar a la función con el nombre del archivo a subir

def main():
    try:
        print('Star Oracle Conn')
        start_time = time.time()

        # Format the start message
        start_message = f"Process started at {time.asctime()}"

        # Log the start message
        ##logger.info(start_message)
        print(start_message)         
        # Conexión a Oracle
        with conn:
            with conn.cursor() as cursor:
                # Consulta para obtener los BLOBs
                cursor.execute("SELECT a.adjunto_id, a.adjunto_tipo,VCOBJ.nombre_archivo(a.nombre_archivo,a.adjunto_id,a.adjunto_tipo) as nombre_archivo, a.archivo FROM VCOBJ.adjunto a, VCOBJ.A_"+anomes+"_ADJ b WHERE a.adjunto_id = b.adjunto_id and trim(b.uuid) is null ")
                rows = cursor.fetchall()

                for row in rows:
                    adjunto_id, adjunto_tipo,nombre_archivo, blob_data = row
                    try:
                        data = blob_data.read() 
                        document_id = genera_uuid(nombre_archivo, data)
                        print("UUID:", document_id)
                        cursor.execute("UPDATE VCOBJ.A_"+anomes+"_ADJ SET uuid = :uuid WHERE adjunto_id = :adjunto_id",
                                       uuid=document_id, adjunto_id=adjunto_id)
                        conn.commit()
                        time.sleep(0.05)                       
                    except Exception as e:
                        print(f"Error processing row {row}: {str(e)}")

            
    except Exception as e:
        print(f"Error general: {str(e)}")
    finally:
        # Cerrar el cursor y la conexión
        if cursor:
            cursor.close()
        if conn:
            conn.close()
        end_time = time.time()

        # Calculate the execution time
        execution_time = end_time - start_time

        # Format the end message
        end_message = f"Process ended at {time.asctime()}, execution time: {execution_time:.2f} seconds"

        # Log the end message
        ##logger.info(end_message)
        print(end_message) 
        print("adjuntos de filenet completeda.")
if __name__ == "__main__":
    main()
    
        


