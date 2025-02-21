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


anomes = sys.argv[1]

# Hacer algo con el parámetro
print("El parámetro recibido es:", anomes)

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
    
    # Definir los parámetros del procedimiento almacenado
    p_fecha = "01/"+ anomes[4:]+"/"+anomes[:4]
    
    cant_ok = cursor.var(int)  # Parametro de salida cant_ok (tipo NUMBER en Oracle)
    cant_error = cursor.var(int) 
    
    # Ejecutar el procedimiento almacenado con los parámetros
    cursor.callproc("VCOBJ.CARGAR_BUZON_OK", [p_fecha, cant_ok, cant_error])
    
    valor_cant_ok = cant_ok.getvalue()
    valor_cant_error = cant_error.getvalue()

    # Imprimir los resultados
    print(f"Registros cargados    = {valor_cant_ok}")
    print(f"Registros Observados  = {valor_cant_error}")
    print(f"Total de registros    = {valor_cant_ok+valor_cant_error}")

except oracledb.DatabaseError as e:
    print(f"Error de base de datos: {e}")
except Exception as e:
    print(f"Error general: {e}")
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
    print("Data transferencia completeda.")