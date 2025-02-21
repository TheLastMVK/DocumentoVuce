CREATE OR REPLACE PROCEDURE VCOBJ.CARGAR_adjuntos_OK(anomes IN VARCHAR2) AS


    v_url VARCHAR2(4000);

    -- URL y credenciales para el API de FileNet
    v_token_url VARCHAR2(4000) := 'https://gateway-apim.vuce.gob.pe/pass-through-https/oauth2/v1/token?grant_type=client_credentials';
    username_token VARCHAR2(100) := 'F7vUUpDJH9kwAeJrDwYXV5i5ADoa';
    password_token VARCHAR2(100) := '88vPFsQ7qHX9DRtkYCIYL6i6u9Ma';
    v_bearer_token VARCHAR2(4000) := '';
    v_file_url VARCHAR2(4000) := 'https://gateway-apim.vuce.gob.pe/pass-through-https/filenet2/1.0/file';

    v_json_data VARCHAR2(4000);

    -- Variables de respuesta
    v_http_request  UTL_HTTP.REQ;
    v_http_response UTL_HTTP.RESP;
    v_buffer         VARCHAR2(4000);

    -- Variables para almacenar la respuesta del API
    v_uuid VARCHAR2(4000);
    v_blob_data BLOB;
    v_filename VARCHAR2(255);
    v_adjunto_id NUMBER;
    v_adjunto_tipo NUMBER;

    -- Variables para la consulta SQL dinámica
    v_sql VARCHAR2(4000);
    v_url VARCHAR2(4000) := 'https://gateway-apim.vuce.gob.pe/pass-through-https/oauth2/v1/token?grant_type=client_credentials';
    v_response CLOB;
    v_data VARCHAR2(4000);

    -- Variables para manejar el HTTP request
    v_auth_header VARCHAR2(4000);
    v_headers VARCHAR2(4000);

    -- Cursor para los registros de adjuntos
    TYPE ref_cursor IS REF CURSOR;
    c_adjuntos ref_cursor;


BEGIN
    -- Aquí invocas el proceso que sube el BLOB a FileNet y obtiene el UUID
    -- Este es el punto donde interactúas con la API de FileNet usando el v_token
    --v_uuid := subir_a_filenet(v_filename, v_blob_data, v_token); -- Llamada a la función para subir el archivo
      -- Preparar datos para solicitud de token
  
    v_data := 'grant_type=client_credentials';

    -- Realizar la solicitud para obtener el token (autenticación básica)
    --v_auth_header := 'Basic ' || UTL_ENCODE.BASE64_ENCODE( username_token || ':' || password_token );
    v_auth_header := 'Basic ' || UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(username_token || ':' || password_token));
    v_bearer_token :='';
    -- Realizar solicitud HTTP para obtener el token
    v_http_request := UTL_HTTP.BEGIN_REQUEST(v_token_url, 'POST');
    UTL_HTTP.SET_HEADER(v_http_request, 'Content-Type', 'application/x-www-form-urlencoded');
    UTL_HTTP.SET_HEADER(v_http_request, 'Authorization', v_auth_header);
    UTL_HTTP.WRITE_TEXT(v_http_request, v_data);
    v_http_response := UTL_HTTP.GET_RESPONSE(v_http_request);

    -- Leer la respuesta de la solicitud HTTP
    BEGIN
        LOOP
            UTL_HTTP.READ_TEXT(v_http_response, v_buffer);
            v_bearer_token := v_bearer_token || v_buffer;
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;  -- Fin de la lectura
    END;

    -- SQL dinámico para obtener los adjuntos
    v_sql := 'SELECT a.adjunto_id, a.adjunto_tipo, VCOBJ.nombre_archivo(a.nombre_archivo, a.adjunto_id, a.adjunto_tipo) AS nombre_archivo, a.archivo ' ||
             'FROM VCOBJ.adjunto a, VCOBJ.A_' || anomes || '_ADJ b ' ||
             'WHERE a.adjunto_id = b.adjunto_id AND TRIM(b.uuid) IS NULL';

    -- Abrir el cursor con la consulta dinámica
    OPEN c_adjuntos FOR v_sql;

    -- Procesar cada fila de adjuntos
    LOOP
        FETCH c_adjuntos INTO v_adjunto_id, v_adjunto_tipo, v_filename, v_blob_data;
        EXIT WHEN c_adjuntos%NOTFOUND;

        BEGIN
         -- Extraer el token de la respuesta (simulamos que obtenemos el token)
          -- Usamos JSON_VALUE para obtener el token de la respuesta, aquí deberías tener la lógica real
         -- v_bearer_token := 'ACCESS_TOKEN_EXAMPLE'; -- Reemplazar con la lógica que parsea la respuesta JSON
              -- Preparar datos para la solicitud POST a FileNet
              v_json_data := '{"componente": "120", "opcion": "DATA", "foldersExtras": "' || anomes || '", "iddocumento": "", ' ||
                             '"nombre": "' || v_filename || '", "propiedades": {"adjunto_id": "1", "adjunto_tipo": "0"}, ' ||
                             '"bytes": "' || UTL_ENCODE.BASE64_ENCODE(v_blob_data) || '"}';

              -- Preparar encabezados para la solicitud a FileNet
              v_headers := 'Authorization: Bearer ' || v_bearer_token ||
                           ' Content-Type: application/json';

              -- Realizar la solicitud HTTP POST a FileNet
              v_http_request := UTL_HTTP.BEGIN_REQUEST(v_file_url, 'POST');
              UTL_HTTP.SET_HEADER(v_http_request, 'Authorization', 'Bearer ' || v_bearer_token);
              UTL_HTTP.SET_HEADER(v_http_request, 'Content-Type', 'application/json');
              UTL_HTTP.SET_HEADER(v_http_request, 'Accept', 'application/json');
              UTL_HTTP.SET_HEADER(v_http_request, 'Cookie', 'your_cookie_value'); -- Si necesitas agregar cookies
              UTL_HTTP.WRITE_TEXT(v_http_request, v_json_data);
              v_http_response := UTL_HTTP.GET_RESPONSE(v_http_request);

              -- Leer la respuesta de la solicitud HTTP
              BEGIN
                  LOOP
                      UTL_HTTP.READ_TEXT(v_http_response, v_buffer);
                      v_response := v_response || v_buffer;
                  END LOOP;
              EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                      NULL;  -- Fin de la lectura
              END;

              -- Extraer el UUID del documento de la respuesta (simulamos que obtenemos el UUID)
              -- Utilizamos JSON_VALUE o un método similar para obtener el UUID real
             -- v_uuid := 'UUID_FROM_RESPONSE';  -- Aquí deberías obtener el UUID de la respuesta JSON
              v_uuid := SUBSTR(v_response, INSTR(v_response, '"iddocumento":"') + 15, INSTR(v_response, '"', INSTR(v_response, '"iddocumento":"') + 15) - (INSTR(v_response, '"iddocumento":"') + 15));
             
            DBMS_OUTPUT.PUT_LINE('UUID del archivo: ' || v_uuid);
            -- Actualizar el UUID en la base de datos
            EXECUTE IMMEDIATE 'UPDATE VCOBJ.A_' || anomes || '_ADJ SET uuid = :uuid WHERE adjunto_id = :adjunto_id'
            USING v_uuid, v_adjunto_id;

            COMMIT;  -- Asegúrate de confirmar los cambios

        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20003, 'Error procesando el adjunto ' || v_adjunto_id || ': ' || SQLERRM);
        END;
    END LOOP;

    -- Cerrar el cursor
    CLOSE c_adjuntos;

    -- Mensaje de finalización
    DBMS_OUTPUT.PUT_LINE('Proceso completado.');
END CARGAR_adjuntos_OK;
/
