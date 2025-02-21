import oracledb
import os
import sys
import time
import subprocess

# Ejecutar los comandos en una sola línea

# Ejecutar los comandos en una sola línea
#oracle_home = "/usr/lib/oracle/11.2/client64"
#os.environ["ORACLE_HOME"] = oracle_home
#os.environ["LD_LIBRARY_PATH"] = "/usr/lib/oracle/11.2/client64/lib"
oracledb.init_oracle_client(lib_dir='/usr/lib/oracle/11.2/client64/lib')

# Inicializar el cliente de Oracle con la biblioteca correcta

try:
    # Conectar a la base de datos
    start_time = time.time()

    # Format the start message
    start_message = f"Process started at {time.asctime()}"

    # Log the start message
    ##logger.info(start_message)
    print(start_message) 

    conn = oracledb.connect(host='192.168.8.171', port=1521, service_name='vucepr.vuce.gob.pe', user='Sys', password='temporal2028', mode=oracledb.SYSDBA)
    
    # Crear un cursor
    cursor = conn.cursor()
    cursor_out = conn.cursor()
    # Definir los parámetros del procedimiento almacenado
    
      
    # Ejecutar el procedimiento almacenado con los parámetros
    cursor.callproc("VCOBJ.CARGAR_VIEWBUZON", (cursor_out,))

    # Recorrer y mostrar los resultados
    # Obtener los resultados del cursor
    for año, total, con_uuid in cursor_out:
        print(f"Año: {año} | Total: {total} | Con UUID: {con_uuid}")

except Exception as e:
    print(f"Error general: {e}")
finally:
    # Cerrar el cursor y la conexión
    if cursor:
        cursor.close()
        cursor_out.close()
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
    print("Data transferencia completeda.")