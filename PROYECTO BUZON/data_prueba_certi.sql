/*==============================================================================
Nombre del Script     : Generar data de prueba de sincronismo
Propósito             : Registrar operaciones de INSERT y UPDATE sobre tablas 
                        relacionadas con mensajes, adjuntos y destinatarios 
                        en la tabla de control VCOBJ.SYNCR_CONTROL para fines
                        de  sincronización.

Fecha                 : 25/04/2025
Autor                 : Hugo Rosales
Versión               : 1.0

Descripción de Variables:
-------------------------
v_fecha_min           : Fecha mínima del rango de análisis
v_fecha_max           : Fecha máxima del rango de análisis
v_user_prueba         : ID del usuario que ejecuta el proceso (para trazabilidad)
vCodResultado         : Código de error en caso de excepción
vMsgResultado         : Mensaje de error en caso de excepción

Listado de Tablas Involucradas:
-------------------------------
VCOBJ.MENSAJE         : Contiene los mensajes registrados
VCOBJ.ADJUNTO         : Adjuntos asociados a los mensajes
VCOBJ.DESTINATARIO    : Información de destinatarios de mensajes
VCOBJ.SYNCR_CONTROL   : Tabla de control para registrar cambios realizados

Query de ayuda para definicion de parametros

select t.Fecha_Registro,a.*
  from VCOBJ.MENSAJE t, VCOBJ.adjunto a,VCOBJ.DESTINATARIO d 
  where t.mensaje_id =a.mensaje_id and d.mensaje_id = t.mensaje_id
  and rownum<=100 order by t.Fecha_Registro desc

UPDATE VCOBJ.ADJUNTO t
SET archivo = (
    SELECT archivo
    FROM VCOBJ.ADJUNTO src
    WHERE src.adjunto_id = 11576674
)
WHERE (t.archivo IS NULL or DBMS_LOB.getlength(t.archivo) = 0)
and t.adjunto_id >= 8540883
and t.adjunto_id < 8541637
==============================================================================*/  

DECLARE
    v_fecha_min date := TO_DATE('01/03/2019','DD/MM/YYYY');
    v_fecha_max date := TO_DATE('30/03/2019','DD/MM/YYYY');
    v_user_prueba number := 441740;
    vCodResultado number:=0;
    vMsgResultado varchar2(2000):='';   
BEGIN
    execute immediate('truncate table VCOBJ.SYNCR_CONTROL');
    execute immediate('truncate table VCOBJ.SYNCR_CONTROL_HISTORICO');
    execute immediate('truncate table VCOBJ.SYNCR_LOGERROR');       
    INSERT INTO VCOBJ.SYNCR_CONTROL (
          id_control, nombre_tabla,operacion, campos_control, id_registro, datos_anteriores, datos_nuevos, estado, usuario
    )
    select
         VCOBJ.SYNCR_CONTROL_SEQ.NEXTVAL,     -- Usamos la variable para el ID generado
        'MENSAJE',                            -- Nombre de la tabla
        'INSERT',                             -- Tipo de operación
        'fecha_registro, estado_registro',    -- Campos involucrados
        l.mensaje_id,
        NULL,                                 -- Datos anteriores (NULL para INSERT)
        l.Fecha_Registro || ', ' || l.Estado_Registro,  -- Concatenamos los nuevos datos
        'C',                                  -- Estado: 'C' de CREADO
         v_user_prueba                           -- Usuario que realizó la operación (puedes ajustarlo)
    from (   
    select t.mensaje_id , max(t.Fecha_Registro) as Fecha_Registro ,Max(t.Estado_Registro) as   Estado_Registro                   -- Usuario que realizó la operación (puedes ajustarlo)
    from VCOBJ.MENSAJE t, VCOBJ.adjunto a,VCOBJ.DESTINATARIO d 
    where t.mensaje_id =a.mensaje_id and d.mensaje_id = t.mensaje_id 
    and t.Fecha_Registro >= v_fecha_min  and t.Fecha_Registro < v_fecha_max 
    group by t.mensaje_id) l; 
    
    INSERT INTO VCOBJ.SYNCR_control ( 
          id_control,
        nombre_tabla,
        operacion,
        campos_control,
        id_registro,
        datos_anteriores,
        datos_nuevos,
        estado,
        usuario
    )
    select 
        VCOBJ.SYNCR_control_seq.NEXTVAL,                         -- Usamos la variable para el ID generado
        'ADJUNTO',                           -- Nombre de la tabla
        'INSERT',                             -- Tipo de operación
        'guid, adjunto_tipo,nombre_archivo, fecha_reg_aud, estado',    -- Campos involucrados
        a.adjunto_id,
        NULL,                                 -- Datos anteriores (NULL para INSERT)
        ', '|| a.adjunto_tipo || ', '|| a.nombre_archivo || ', '  || TO_CHAR(a.FECHA_REG_AUD,'YYYYMMDD')|| ', '  ||  a.estado,  -- Concatenamos los nuevos datos
        'C',                                  -- Estado: 'C' de CREADO
        v_user_prueba                            -- Usuario que realizó la operación (puedes ajustarlo)
    from VCOBJ.MENSAJE t, VCOBJ.adjunto a,VCOBJ.DESTINATARIO d 
    where t.mensaje_id =a.mensaje_id and d.mensaje_id = t.mensaje_id
    and t.Fecha_Registro >= v_fecha_min  and t.Fecha_Registro < v_fecha_max;
     
    INSERT INTO VCOBJ.SYNCR_control (
        id_control,
        nombre_tabla,
        operacion,
        campos_control,
        id_registro,
        datos_anteriores,
        datos_nuevos,
        estado,
        usuario
    )
    select 
        VCOBJ.SYNCR_control_seq.NEXTVAL,
        'ADJUNTOREL',                           -- Nombre de la tabla
        'UPDATE',                                 -- Tipo de operación
        'mensaje_id',                                  -- Campo involucrado
        a.adjunto_id,                          -- ID del registro actualizado (valor OLD)
        null ,  -- Datos anteriores (valores OLD)
        a.mensaje_id,  -- Datos nuevos (valores NEW)
        'C',                                      -- Estado: 'C' para CREADO
       v_user_prueba                                -- Usuario que realizó la operación (puedes ajustarlo)
    from VCOBJ.MENSAJE t, VCOBJ.adjunto a,VCOBJ.DESTINATARIO d 
    where t.mensaje_id =a.mensaje_id and d.mensaje_id = t.mensaje_id
    and t.Fecha_Registro >= v_fecha_min  and t.Fecha_Registro < v_fecha_max  ;
     
     
    INSERT INTO VCOBJ.SYNCR_CONTROL (
          id_control, nombre_tabla,operacion, campos_control, id_registro, datos_anteriores, datos_nuevos, estado, usuario
    )
    select
         VCOBJ.SYNCR_CONTROL_SEQ.NEXTVAL,                         -- Usamos la variable para el ID generado
        'LEIDO',                           -- Nombre de la tabla
        'UPDATE',                             -- Tipo de operación
        'leido, fecha_mod_aud, usuid_mod_aud',    -- Campos involucrados
        l.mensaje_id,
        NULL,                                 -- Datos anteriores (NULL para INSERT)
        l.leido || ', ' ||l.fecha_mod_aud || ', ' || l.usuid_mod_aud,  -- Concatenamos los nuevos datos
        'C'  ,                                -- Estado: 'C' de CREADO
        v_user_prueba 
    from (   
    select t.mensaje_id , max(d.leido) as leido,Max(d.fecha_mod_aud) as fecha_mod_aud,Max(d.usuid_mod_aud) as usuid_mod_aud                    -- Usuario que realizó la operación (puedes ajustarlo)
    from VCOBJ.MENSAJE t, VCOBJ.adjunto a,VCOBJ.DESTINATARIO d 
    where t.mensaje_id =a.mensaje_id and d.mensaje_id = t.mensaje_id 
    and t.Fecha_Registro >= v_fecha_min  and t.Fecha_Registro < v_fecha_max and d.leido ='N'
    group by t.mensaje_id) l;  
    commit;
EXCEPTION
    WHEN OTHERS THEN
           vCodResultado:= SQLCODE;
           vMsgResultado:= SUBSTR(SQLERRM, 1, 2000);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('PROCESO: ' || 'error_data');
      DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || vCodResultado);
      DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || vMsgResultado);

End;

