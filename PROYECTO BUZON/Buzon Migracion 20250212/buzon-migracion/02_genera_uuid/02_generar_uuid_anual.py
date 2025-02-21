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


def genera_uuid(filename, blob_data):
    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }

    # Metadata del documento
    data = {
        "scope": "filenet:file_create filenet:file_read filenet:file_update filenet:file_delete"
    }

    # Solicitud para obtener el token
    response = requests.post(token_url, headers=headers, data=data, auth=HTTPBasicAuth(username_token, password_token))

    if response.status_code == 200:

        document_token = response.json()
        bearer_token = document_token.get("access_token")  # Asegúrate de que la clave "access_token" contiene el token

        file_base64 = base64.b64encode(blob_data).decode('utf-8')
        #print(file_base64)
        # Metadata del documento
        data = {
            "componente": "120",
            "opcion": "DATA",
            "foldersExtras": anomes,
            "iddocumento": "",	
            "nombre": filename,
            "propiedades": {
                "adjunto_id": "1",
                "adjunto_tipo": "0"
            },
            "bytes": file_base64  # Asegúrate de que 'blob_data' se lee correctamente
        }
        
        headers = {
            "Authorization": f"Bearer {bearer_token}",
            "filenetUser": USERNAME,
            "filenetPassword": PASSWORD,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Cookie": cookie
        }
        print("llego3")
        # Realizar la solicitud POST para subir el documento
        response = requests.post(url=base_url, headers=headers, data=json.dumps(data))
        
        if response.status_code == 200:
            document_details = response.json()
            document_uuid = document_details.get("iddocumento")  # Asegúrate de que la clave "iddocumento" contiene el UUID
            return document_uuid
        else:
            print(f"Error al subir el documento. Código de estado: {response.status_code}")
            print(response.text)
            response.raise_for_status()
    else:
        print(f"Error al obtener token. Código de estado: {response.status_code}")
        print(response.text)
        response.raise_for_status()

# Función principal
def main():
    try:
        print('Start Oracle Conn')
        start_time = time.time()

        # Formatear el mensaje de inicio
        start_message = f"Process started at {time.asctime()}"
        print(start_message)

        # Conexión a Oracle
        conn = oracledb.connect(
            host='192.168.8.171', port=1521, service_name='vucepr.vuce.gob.pe', 
            user='Sys', password='temporal2028', mode=oracledb.SYSDBA
        )
        
        batch_size = 1000  # Tamaño de cada bloque de registros a procesar
        
        # Primer query (rango de adjunto_id)
        sql_range_query = """
        WITH ranked_data AS (
            SELECT
                b.adjunto_id,
                ROW_NUMBER() OVER (ORDER BY b.adjunto_id) AS row_num
            FROM VCOBJ.A_{}_ADJ b WHERE TRIM(b.uuid) IS NULL
        )
        SELECT
            MIN(adjunto_id) AS range_start,
            MAX(adjunto_id) AS range_end
        FROM ranked_data
        GROUP BY FLOOR((row_num - 1) / {})
        ORDER BY range_start
        """.format(anomes, batch_size)
        
        # Ejecutar la primera consulta para obtener los rangos
        cursor = conn.cursor()
        cursor.execute(sql_range_query)
        
        # Procesar cada rango y ejecutar la segunda consulta directamente
        for row in cursor:
            range_start = row[0]
            range_end = row[1]
            
            # Segundo query: Usar los rangos obtenidos para ejecutar la segunda consulta
            sql_detail_query = """
            SELECT a.adjunto_id, a.adjunto_tipo, 
                VCOBJ.nombre_archivo(a.nombre_archivo, a.adjunto_id, a.adjunto_tipo) AS nombre_archivo,
                a.archivo
            FROM VCOBJ.adjunto a, VCOBJ.A_{}_ADJ b
            WHERE a.adjunto_id = b.adjunto_id
                AND TRIM(b.uuid) IS NULL
                AND a.adjunto_id >= {} and a.adjunto_id < {}
            """.format(anomes, range_start, range_end)
            
            # Ejecutar la segunda consulta para obtener los detalles
            cursor.execute(sql_detail_query)
            for detail_row in cursor:
                adjunto_id = detail_row[0]
                adjunto_tipo = detail_row[1]
                nombre_archivo = detail_row[2]
                blob_data = detail_row[3]

                # Aquí procesar los datos como sea necesario
                print(f"Adjunto ID: {adjunto_id}, Tipo: {adjunto_tipo}")
                try:
                    blob_content = blob_data.read()   # Cambia 'utf-8' si la codificación es diferente
                    print(f"Nombre: {nombre_archivo}")
                    # Generar el UUID para el archivo
                    document_id = genera_uuid(nombre_archivo, blob_content)
                    print(f"UUID: {document_id}")

                    if document_id and document_id.strip():  # Si el document_id no es None o vacío
                        table_name = f"A_{sys.argv[1]}_ADJ"
                        update_query = f"""
                            UPDATE VCOBJ.{table_name} 
                            SET uuid = :uuid 
                            WHERE adjunto_id = :adjunto_id
                        """
                        # Ejecutar la actualización con el UUID generado
                        cursor.execute(update_query, uuid=document_id, adjunto_id=adjunto_id)
                        conn.commit()
                    else:
                        print(f"UUID no válido para adjunto_id {adjunto_id}, no se realiza el UPDATE")

                except Exception as e:
                    print(f"Error processing row {row}: {str(e)}")                
                # Aquí puedes añadir el código para manejar el archivo, por ejemplo, subirlo a FileNet

        print("Adjuntos de FileNet completados.")

    except Exception as e:
        print(f"Error general: {str(e)}")
    finally:
        if conn:
            conn.close()
        
        end_time = time.time()
        execution_time = end_time - start_time
        end_message = f"Process ended at {time.asctime()}, execution time: {execution_time:.2f} seconds"
        print(end_message)

if __name__ == "__main__":
    main()
        


