CREATE OR REPLACE PROCEDURE VCOBJ.Cargar_buzon_final (
      p_fecha       IN string,cant_ok out number,cant_error out number 
   )
   as
   v_usuario_defecto VARCHAR2(200):='441740';
   sql_query VARCHAR2(1000);
BEGIN

--dbms_output.put_line('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||' as   

EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||' as 
    SELECT m.mensaje_id "codMensaje",m.envio_tipo "envio_tipo",
       nvl(b.componente,nvl(mt.componente,nvl(t.componente,nvl(t1.componente,nvl(t2.componente,nvl(t3.componente,1)))))) "codComponente",
       CASE
          WHEN m.es_mensaje_notificacion = ''S'' AND t.entidad_id IS NOT NULL THEN t.entidad_id
          WHEN m.notificacion_id IS NOT NULL AND t.entidad_id IS NOT NULL THEN t.entidad_id
          WHEN n.suce_id IS NOT NULL AND t1.entidad_id IS NOT NULL THEN t1.entidad_id
          WHEN m.suce_id IS NOT NULL AND t2.entidad_id IS NOT NULL THEN t2.entidad_id
          WHEN d2.suce_id IS NOT NULL AND t3.entidad_id IS NOT NULL THEN t3.entidad_id
          WHEN m.envio_tipo = 1 AND d.destinatario IS NOT NULL THEN d.destinatario
          WHEN m.envio_tipo = 2 AND NVL(m.de, 1) IS NOT NULL THEN NVL(m.de, 1)
          WHEN m.envio_tipo IN (5, 6) THEN 11
          WHEN m.consulta_tecnica_id IS NOT NULL AND c.entidad_id IS NOT NULL THEN c.entidad_id
          ELSE NULL END as "codEntidad",    
       m.fecha_registro "fechahoraEnvio", nvl(m.usuid_reg_aud,'|| v_usuario_defecto ||') "codUsuarioEnvio",
       case when m.notificacion_id is not NULL then ''NT'' When mt.tipo_mensaje =2 then ''AL'' ELSE ''MS'' end "codTipoEnvio",
       case when mt.tipo_mime = 2 then 2.0 else 1.0 end  "codTipoContenidoEnvio",
       nvl(m.mensaje_texto_id,83) "codPlantillaContenido",
        case when o.orden_id is not NULL then 1  when mt.tipo_mensaje =2 then 3 when b.relacion_tramite =2 then 10 ELSE 2 end "codCarpetaDocumento", 
       CASE WHEN o.orden_id IS NOT NULL THEN 2.0
            WHEN s.suce_id IS NOT NULL THEN 3.0
            WHEN m.dr_id is not NULL THEN 4.0 
            ELSE null END AS "codEtiquetaDocumento",
       o.ORDEN "codOrden",
       s.suce "codSuce",
       d2.dr "codDr", 
       DECODE(m.estado_registro,null,''C'',''P'',''E'',''T'',''Z'',''A'',''A'',''R'',''R'') "estadoDocumento",
       nd.descripcion "descripcion_notificacion",
       b.asunto "asunto",
       m.mensaje "mensaje",
       s.suce "suce",
       NVL(d.leido,''S'') "leido",
       NVL(d.fecha_lectura,m.fecha_registro) "fechaLeido",
        case WHEN m.envio_tipo in ( 2,3) then e.entidad_id
             WHEN m.notificacion_id is not null then e.entidad_id
          else nvl(m.de,'|| v_usuario_defecto ||') end "emisor_id",
        case WHEN m.envio_tipo in ( 2,3) then m.usuario_tipo
             WHEN m.notificacion_id is not null then m.usuario_tipo
          else a.usuario_tipo_id end "emisor_tipo_id",
        case WHEN m.envio_tipo in ( 2,3) then 2
             WHEN m.notificacion_id is not null then 2
          else a.documento_tipo end "emisor_documento_tipo",
        case WHEN m.envio_tipo in ( 2,3) then ee.ruc
             WHEN m.notificacion_id is not null then ee.ruc
          else a.numero_documento end "emisor_numero_documento",
        case WHEN m.envio_tipo in ( 2,3) then ee.ruc
              WHEN m.notificacion_id is not null then ee.ruc
          else a.usuario_sol end "emisor_usuario_sol",
        case WHEN m.envio_tipo in ( 2,3) then e.nombre
           WHEN m.notificacion_id is not null then e.nombre
          else  a.nombre end "emisor_nombre",
        case WHEN m.envio_tipo in ( 2,3) then ee.correo
          WHEN m.notificacion_id is not null then ee.correo
          else  a.email  end "emisor_email",
        case WHEN m.envio_tipo in ( 2,3) then ee.entidad_id
          WHEN m.notificacion_id is not null then ee.entidad_id
          else  a.empresa_id  end "emisor_empresa_id",
        case WHEN m.envio_tipo in ( 2,3) then ee.entidad_id
          WHEN m.notificacion_id is not null then ee.entidad_id
          else  a.entidad_id end "emisor_entidad_id",            
        case WHEN m.envio_tipo in ( 1,3) then e.entidad_id
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then nvl(m.de,'|| v_usuario_defecto ||')
             else nvl(d.destinatario,'|| v_usuario_defecto ||') END "dest_id",
        case WHEN m.envio_tipo in ( 1,3) then m.usuario_tipo
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then a.usuario_tipo_id
          else u.usuario_tipo_id end "dest_tipo_id",
        case WHEN m.envio_tipo in ( 1,3) then 2
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then a.documento_tipo
          else u.documento_tipo end  "dest_documento_tipo",
        case WHEN m.envio_tipo in ( 1,3) then ee.ruc
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then a.numero_documento
          else u.numero_documento end "dest_numero_documento",
        case WHEN m.envio_tipo in ( 1,3) then ee.ruc
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then a.usuario_sol
          else u.usuario_sol end "dest_usuario_sol",
        case WHEN m.envio_tipo in ( 1,3) then e.nombre
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then a.nombre
          else  u.nombre end "dest_nombre",
        case WHEN m.envio_tipo in ( 1,3) then ee.correo
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then a.email
          else  u.email end "dest_email",
        case WHEN m.envio_tipo in ( 1,3) then ee.entidad_id
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then a.empresa_id
          else u.empresa_id end "dest_empresa_id",
        case WHEN m.envio_tipo in ( 1,3) then ee.entidad_id
             WHEN m.envio_tipo = 2 or m.notificacion_id is not null then a.entidad_id
          else  u.entidad_id end "dest_entidad_id", 
       m.fecha_mod_aud "fecha_mod_aud", 
       m.usuid_mod_aud "usu_mod_aud"
  FROM vcobj.mensaje m, 
       vcobj.buzon b,
       vcobj.usuario a,
       vcobj.mensaje_texto mt,
       vcobj.consulta_tecnica c,       
       vcobj.destinatario d,
       vcobj.usuario u,
       vcobj.tce t, 
       vcobj.tce t1, 
       vcobj.tce t2, 
       vcobj.tce t3,
       vcobj.suce s,
       vcobj.dr d2,       
       vcobj.notificacion n,
       vcobj.notificacion_detalle nd,
       vcobj.orden o,
       vcobj.entidad e,
       vcobj.entidad_ruc ee    
 WHERE m.buzon_id = b.buzon_id (+)
   AND m.de = a.usuario_id  (+)
   AND m.mensaje_texto_id = mt.mensaje_texto_id(+)
   AND m.mensaje_id = d.mensaje_id (+)
   AND m.consulta_tecnica_id = c.consulta_tecnica_id (+)   
   AND d.destinatario = u.usuario_id (+)
   AND m.notificacion_id = n.notificacion_id(+)
   AND n.notificacion_id = nd.notificacion_id(+)
   AND n.orden_id = o.orden_id (+)
   AND n.orden_id = t.orden_id (+)
   AND n.suce_id = t1.suce_id (+)
   AND m.suce_id = t2.suce_id (+)
   AND m.dr_id = d2.dr_id(+)  
   AND d2.suce_id = t3.suce_id (+)
   AND m.suce_id = s.suce_id (+) 
   AND e.entidad_id = ee.entidad_id (+) 
   AND CASE WHEN m.es_mensaje_notificacion = ''S'' AND t.entidad_id IS NOT NULL THEN t.entidad_id
            WHEN m.notificacion_id IS NOT NULL AND t.entidad_id IS NOT NULL THEN t.entidad_id
            WHEN n.suce_id IS NOT NULL AND t1.entidad_id IS NOT NULL THEN t1.entidad_id
            WHEN m.suce_id IS NOT NULL AND t2.entidad_id IS NOT NULL THEN t2.entidad_id
            WHEN d2.suce_id IS NOT NULL AND t3.entidad_id IS NOT NULL THEN t3.entidad_id
            WHEN m.envio_tipo = 1 AND d.destinatario IS NOT NULL THEN d.destinatario
            WHEN m.envio_tipo = 2 AND NVL(m.de, 1) IS NOT NULL THEN NVL(m.de, 1)
            WHEN m.envio_tipo IN (5, 6) THEN 11
            WHEN m.consulta_tecnica_id IS NOT NULL AND c.entidad_id IS NOT NULL THEN c.entidad_id
            ELSE NULL END = e.entidad_id
   AND m.fecha_registro >= TO_DATE('''||p_fecha||''',''DD/MM/YYYY'')
   AND m.fecha_registro <  ADD_MONTHS(TO_DATE('''||p_fecha||''',''DD/MM/YYYY''), 1)
   AND nvl(b.componente,nvl(mt.componente,nvl(t.componente,nvl(t1.componente,nvl(t2.componente,nvl(t3.componente,1)))))) in (1,2)');-- and rownum <=5');

--  dbms_output.put_line

EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_TMP as 
  SELECT  a."codMensaje" mensaje_id,RPAD('' '', 100) uuid,a."codUsuarioEnvio" as usuario_id,a."usu_mod_aud"  as usu_mod,
  case WHEN a."envio_tipo" in ( 2,3) THEN null else a."emisor_id" end as emisor_id,
   case WHEN a."envio_tipo" in ( 1,3) THEN null else a."dest_id" end as dest_id from VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||' a');
   
EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_ADJ as 
  SELECT  a.mensaje_id,b.adjunto_id,b.adjunto_tipo,nvl(b.nombre_archivo,''sinnombre'') as nombre_archivo,a.uuid from VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_TMP a,VCOBJ.adjunto b
  WHERE a.mensaje_id = b.mensaje_id and b.estado=''A''');

EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_USER as 
  SELECT  distinct u.USUARIO_ID usuario_id,u.USUARIO_TIPO_ID usuario_tipo_id,u.DOCUMENTO_TIPO documento_tipo, 
u.NUMERO_DOCUMENTO numero_documento,u.NOMBRE nombre, u.USUARIO_SOL usuario_sol,''a'' avatar,u.EMAIL email, u.TELEFONO telefono,
u.PRINCIPAL principal, u.EMPRESA_ID empresa_id, u.ENTIDAD_ID entidad_id from VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_TMP b,VCOBJ.usuario u
  WHERE (b.usuario_id = u.usuario_id or b.usu_mod  = u.usuario_id or b.emisor_id  = u.usuario_id  or b.dest_id = u.usuario_id  ) ');
  
EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_ERR as 
  select m.mensaje_id 
  from vcobj.mensaje m,
       vcobj.buzon b,
       vcobj.mensaje_texto mt,       
       vcobj.notificacion n,
       vcobj.orden o,
       vcobj.dr d2,         
       vcobj.tce t, 
       vcobj.tce t1, 
       vcobj.tce t2, 
       vcobj.tce t3  
  where m.buzon_id = b.buzon_id (+)
   AND m.mensaje_texto_id = mt.mensaje_texto_id(+)  
   AND m.notificacion_id = n.notificacion_id(+)   
   AND n.orden_id = o.orden_id (+)
   AND n.orden_id = t.orden_id (+)
   AND n.suce_id = t1.suce_id (+)
   AND m.suce_id = t2.suce_id (+)
   AND m.dr_id = d2.dr_id(+)  
   AND d2.suce_id = t3.suce_id (+)  
  and m.fecha_registro >= TO_DATE('''||p_fecha||''',''DD/MM/YYYY'')
  and nvl(b.componente,nvl(mt.componente,nvl(t.componente,nvl(t1.componente,nvl(t2.componente,nvl(t3.componente,1)))))) in (1,2)
   AND m.fecha_registro <  ADD_MONTHS(TO_DATE('''||p_fecha||''',''DD/MM/YYYY''), 1)
   MINUS 
  SELECT  a."codMensaje" mensaje_id from VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||' a ');  
 

      
END Cargar_buzon_final;
/
