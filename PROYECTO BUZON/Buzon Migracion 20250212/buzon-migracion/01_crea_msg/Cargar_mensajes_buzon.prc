CREATE OR REPLACE PROCEDURE VCOBJ.Cargar_mensajes_buzon (
      p_fecha       IN string
   )
   as
BEGIN
--  dbms_output.put_line
EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_1 as 
      SELECT m.mensaje_id "codMensaje",
      t.componente||decode(t.cp_modulo,null,'''',''.''||t.cp_modulo) "codComponente",m.de "codEntidad",
       to_char(m.fecha_registro, ''dd-mm-yyyy hh24:mi:ss'') "fechahoraEnvio", ''VAPPBUZON'' "codUsuarioEnvio",
       nvl(mt.tipo_mensaje_buzon,''2'') "codTipoEnvio",
       1 "codTipoContenidoEnvio", m.mensaje_texto_id "codPlantillaContenido",
       to_char(m.de) "codEmisor", cast(0 as integer) "tipoCodEmisor", b.usuario_tipo "codTipoEmisor",
       '' '' "solEmisor",
       u.numero_documento "codDestinatario", u.documento_tipo "tipoCodDestinatario", d.usuario_tipo "codTipoDestinatario",
       u.usuario_sol "solDestinatario", mt.carpeta_documento_buzon "codCarpetaDocumento", m.de "codCarpetaEntidad",
       mt.etiqueta_documento "codEtiquetaDocumento",
       o.ORDEN_ID "idOrden", o.ORDEN "codOrden",
       s.suce "codSuce", d2.dr "codDr", '' '' "codDue",
       0 "importante", mt.estado_documento_buzon "estadoDocumento",
       nd.descripcion "descripcion_notificacion",
       b.asunto "asunto",
       m.mensaje "mensaje",
       s.suce "suce",
       lower(f.formato) "formato",
       case when t.componente = 2  then ''origen'' else lower(f.formato) end as  "pagina",
       '' '' "mto",
       d.leido "leido",
       to_char(d.fecha_lectura,''dd-mm-yyyy hh24:mi:ss'') "fechaLeido",
       a.usuario_id "emisor_id",
       a.usuario_tipo_id "emisor_tipo_id",
       a.documento_tipo "emisor_documento_tipo",
       a.numero_documento "emisor_numero_documento",
       a.usuario_sol "emisor_usuario_sol",
       a.nombre "emisor_nombre",
       a.email  "emisor_email",
       a.empresa_id  "emisor_empresa_id",
       a.entidad_id "emisor_entidad_id",
       u.usuario_id "dest_id",
       u.usuario_tipo_id "dest_tipo_id",
       u.documento_tipo "dest_documento_tipo",
       u.numero_documento "dest_numero_documento",
       u.usuario_sol "dest_usuario_sol",
       u.nombre "dest_nombre",
       u.email  "dest_email",
       u.empresa_id  "dest_empresa_id",
       u.entidad_id "dest_entidad_id"
  FROM vcobj.mensaje m, vcobj.usuario a,vcobj.entidad e,
       vcobj.buzon b, vcobj.mensaje_texto mt,
       vcobj.destinatario d, vcobj.usuario u,
       vcobj.buzon_x_tramite bxt, vcobj.orden o,
       vcobj.tce t, vcobj.suce s,
       vcobj.dr d2,
       vcobj.formato f, vcobj.notificacion n,
       vcobj.notificacion_detalle nd
 WHERE m.de = a.usuario_id
   AND  cast(m.de as integer) = cast(e.entidad_id as integer)
   AND m.buzon_id = b.buzon_id
   AND m.mensaje_texto_id = mt.mensaje_texto_id(+)
   AND m.mensaje_id = d.mensaje_id
   AND d.destinatario = u.usuario_id
   AND d.estado = ''A''
   AND b.buzon_id = bxt.buzon_id
   AND bxt.orden_id = o.orden_id
   AND o.orden_id = t.orden_id
   AND m.envio_tipo IN (2)
   AND nvl(bxt.suce_id,0) = s.suce_id(+)
   AND nvl(m.dr_id,0) = d2.dr_id(+)
   AND t.formato_id = f.formato_id(+)
   AND m.notificacion_id = n.notificacion_id(+)
   AND n.notificacion_id = nd.notificacion_id(+)
   AND NVL(m.mensaje_texto_id,0) NOT IN (SELECT mensaje_texto_id FROM vcobj.mensaje_texto WHERE codigo LIKE ''ALERTA%'')
   AND NVL(m.mensaje_texto_id,0) NOT IN (50)
   AND m.consulta_tecnica_id IS NULL
   AND m.mensaje_texto_id IS NOT NULL
   AND NVL(t.cp_modulo,2) = 2
   AND NOT exists (SELECT 1 FROM vcobj.buzon_x_tramite_extranet WHERE buzon_id = b.buzon_id)
   AND m.fecha_registro >= TO_DATE('''||p_fecha||''',''DD/MM/YYYY'')
   AND m.fecha_registro <  ADD_MONTHS(TO_DATE('''||p_fecha||''',''DD/MM/YYYY''), 1)');-- and rownum <=5');

--  dbms_output.put_line
EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_2 as  
SELECT m.mensaje_id "codMensaje",  t.componente||decode(t.cp_modulo,null,'''',''.''||t.cp_modulo) "codComponente", 
       t.entidad_id "codEntidad", to_char( m.fecha_registro, ''dd-mm-yyyy hh24:mi:ss'') "fechahoraEnvio", ''VAPPBUZON'' "codUsuarioEnvio", 
       nvl(mt.tipo_mensaje_buzon,''2'') "codTipoEnvio", 1 "codTipoContenidoEnvio", m.mensaje_texto_id "codPlantillaContenido", 
       to_char( DECODE(a.usuario_tipo_id,5,a.usuario_id,a.numero_documento)) "codEmisor",
       cast(DECODE(a.usuario_tipo_id,5,0,a.documento_tipo) as integer) "tipoCodEmisor", 
       a.usuario_tipo_id "codTipoEmisor", 
       a.usuario_sol "solEmisor", 
       u.numero_documento "codDestinatario", u.documento_tipo "tipoCodDestinatario", 
       u.usuario_tipo_id "codTipoDestinatario", u.usuario_sol "solDestinatario", mt.carpeta_documento_buzon "codCarpetaDocumento", 
       t.entidad_id "codCarpetaEntidad", mt.etiqueta_documento "codEtiquetaDocumento", o.ORDEN_ID "idOrden", o.ORDEN "codOrden",
       s.suce "codSuce", d2.dr "codDr", 
        '' '' "codDue", 
       0 "importante", mt.estado_documento_buzon "estadoDocumento", 
       nd.descripcion "descripcion_notificacion",
       b.asunto "asunto", 
       m.mensaje "mensaje",
       s.suce "suce", 
       lower(f.formato) "formato", 
       case when t.componente = 2  then ''origen'' else lower(f.formato) end as "pagina",
       '' '' "mto", 
       d.leido "leido", to_char(d.fecha_lectura,''dd-mm-yyyy hh24:mi:ss'') "fechaLeido",
       a.usuario_id "emisor_id",
       a.usuario_tipo_id "emisor_tipo_id",
       a.documento_tipo "emisor_documento_tipo",
       a.numero_documento "emisor_numero_documento",
       a.usuario_sol "emisor_usuario_sol",
       a.nombre "emisor_nombre",
       a.email  "emisor_email",
       a.empresa_id  "emisor_empresa_id",
       a.entidad_id "emisor_entidad_id",
       u.usuario_id "dest_id",
       u.usuario_tipo_id "dest_tipo_id",
       u.documento_tipo "dest_documento_tipo",
       u.numero_documento "dest_numero_documento",
       u.usuario_sol "dest_usuario_sol",
       u.nombre "dest_nombre",
       u.email  "dest_email",
       u.empresa_id  "dest_empresa_id",
       u.entidad_id "dest_entidad_id"       
  FROM vcobj.mensaje m, vcobj.usuario a, vcobj.buzon b, vcobj.mensaje_texto mt, vcobj.destinatario d, 
       vcobj.usuario u, vcobj.buzon_x_tramite bxt, vcobj.orden o, vcobj.tce t, vcobj.suce s,
       vcobj.dr d2, vcobj.formato f, vcobj.notificacion n, vcobj.notificacion_detalle nd 
 WHERE m.de = a.usuario_id AND m.buzon_id = b.buzon_id AND m.mensaje_texto_id = mt.mensaje_texto_id  AND m.mensaje_id = d.mensaje_id 
   AND d.destinatario = u.usuario_id AND d.estado = ''A'' AND b.buzon_id = bxt.buzon_id AND bxt.orden_id = o.orden_id AND o.orden_id = t.orden_id AND m.envio_tipo IN (4,5,6) AND nvl(bxt.suce_id,0) = s.suce_id(+)
   AND nvl(m.dr_id,0) = d2.dr_id(+) AND t.formato_id = f.formato_id(+) AND m.notificacion_id = n.notificacion_id(+) AND n.notificacion_id = nd.notificacion_id(+) AND NVL(m.mensaje_texto_id,0) NOT IN (SELECT mensaje_texto_id FROM vcobj.mensaje_texto WHERE codigo LIKE ''ALERTA%'') 
   AND NVL(m.mensaje_texto_id,0) NOT IN (50) AND m.mensaje_texto_id IS NOT NULL AND m.consulta_tecnica_id IS NULL AND NVL(t.cp_modulo,2) = 2 
   AND NOT exists (SELECT 1 FROM vcobj.buzon_x_tramite_extranet WHERE buzon_id = b.buzon_id)
   AND m.fecha_registro >= TO_DATE('''||p_fecha||''',''DD/MM/YYYY'')
   AND m.fecha_registro <  ADD_MONTHS(TO_DATE('''||p_fecha||''',''DD/MM/YYYY''), 1)');-- and rownum <=5');

--  dbms_output.put_line
EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.A_'||substr(p_fecha,7,4)||substr(p_fecha,4,2)||'_3 as 
SELECT m.mensaje_id "codMensaje",        
       t.componente||decode(t.cp_modulo,null,'''',''.''||t.cp_modulo) "codComponente",
       t.entidad_id "codEntidad", to_char( m.fecha_registro, ''dd-mm-yyyy hh24:mi:ss'') "fechahoraEnvio",
       ''VAPPBUZON'' "codUsuarioEnvio", 
       nvl(mt.tipo_mensaje_buzon,''2'') "codTipoEnvio",
       1 "codTipoContenidoEnvio",
       m.mensaje_texto_id "codPlantillaContenido",
       to_char( DECODE(a.usuario_tipo_id,5,to_char(a.usuario_id),to_char(a.numero_documento))) "codEmisor",
       cast(DECODE(a.usuario_tipo_id,5,0,a.documento_tipo) as integer) "tipoCodEmisor",
       a.usuario_tipo_id "codTipoEmisor", a.usuario_sol "solEmisor",
       u.numero_documento "codDestinatario",
       u.documento_tipo "tipoCodDestinatario",
       u.usuario_tipo_id "codTipoDestinatario",
       u.usuario_sol "solDestinatario",
       mt.carpeta_documento_buzon "codCarpetaDocumento",
       t.entidad_id "codCarpetaEntidad",
       mt.etiqueta_documento "codEtiquetaDocumento", o.ORDEN_ID "idOrden", o.ORDEN "codOrden",
       s.suce "codSuce", d2.dr "codDr",
       '' '' "codDue",
       0 "importante", mt.estado_documento_buzon "estadoDocumento",
      nd.descripcion "descripcion_notificacion", 
       b.asunto "asunto", 
       m.mensaje "mensaje",
       s.suce "suce",       
       lower(f.formato) "formato", 
       case when t.componente = 2  then ''origen'' else lower(f.formato) end as "pagina",
       '' '' "mto",
       d.leido "leido", to_char(d.fecha_lectura,''dd-mm-yyyy hh24:mi:ss'') "fechaLeido",
       a.usuario_id "emisor_id",
       a.usuario_tipo_id "emisor_tipo_id",
       a.documento_tipo "emisor_documento_tipo",
       a.numero_documento "emisor_numero_documento",
       a.usuario_sol "emisor_usuario_sol",
       a.nombre "emisor_nombre",
       a.email  "emisor_email",
       a.empresa_id  "emisor_empresa_id",
       a.entidad_id "emisor_entidad_id",
       u.usuario_id "dest_id",
       u.usuario_tipo_id "dest_tipo_id",
       u.documento_tipo "dest_documento_tipo",
       u.numero_documento "dest_numero_documento",
       u.usuario_sol "dest_usuario_sol",
       u.nombre "dest_nombre",
       u.email  "dest_email",
       u.empresa_id  "dest_empresa_id",
       u.entidad_id "dest_entidad_id"          
  FROM vcobj.mensaje m, vcobj.entidad e,
       vcobj.buzon b, vcobj.mensaje_texto mt,
       vcobj.destinatario d, vcobj.usuario u,
       vcobj.buzon_x_tramite_extranet bxte,
       vcobj.orden o, vcobj.tce t,
       vcobj.suce s, vcobj.dr d2,
       vcobj.formato f,
       vcobj.usuario a,
       vcobj.notificacion n, vcobj.notificacion_detalle nd
 WHERE m.de = a.usuario_id
   AND m.buzon_id = b.buzon_id
   AND m.mensaje_texto_id = mt.mensaje_texto_id(+)
   AND m.mensaje_id = d.mensaje_id
   AND d.destinatario = u.usuario_id
   AND d.estado = ''A''
   AND b.buzon_id = bxte.buzon_id
   AND bxte.suce_id = s.suce_id
   AND s.suce_id = t.suce_id
   AND t.orden_id = o.orden_id(+) 
   AND m.envio_tipo IN (4,5,6)
   AND m.dr_id = d2.dr_id(+)
   AND t.formato_id = f.formato_id
   AND m.notificacion_id = n.notificacion_id(+)
   AND n.notificacion_id = nd.notificacion_id(+)
   AND NVL(m.mensaje_texto_id,0) NOT IN (SELECT mensaje_texto_id FROM vcobj.mensaje_texto WHERE codigo LIKE ''ALERTA%'') 
   AND NVL(m.mensaje_texto_id,0) NOT IN (50)
   AND m.mensaje_texto_id IS NOT NULL
   AND m.consulta_tecnica_id IS NULL
   AND NVL(t.cp_modulo,2) = 2
   AND NOT exists (SELECT 1 FROM vcobj.buzon_x_tramite WHERE buzon_id = b.buzon_id)
   AND m.fecha_registro >= TO_DATE('''||p_fecha||''',''DD/MM/YYYY'')
   AND m.fecha_registro <  ADD_MONTHS(TO_DATE('''||p_fecha||''',''DD/MM/YYYY''), 1)'); -- and rownum <=5'); 
   
END Cargar_mensajes_buzon;
/
