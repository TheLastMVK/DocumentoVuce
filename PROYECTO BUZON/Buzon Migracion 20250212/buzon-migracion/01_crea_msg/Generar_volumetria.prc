CREATE OR REPLACE PROCEDURE VCOBJ.Generar_volumetria
   as
   p_fecha VARCHAR2(20):= TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
BEGIN
--  dbms_output.put_line
EXECUTE IMMEDIATE ('CREATE TABLE VCOBJ.Vol_'||p_fecha||' as 
  SELECT  TO_CHAR(m.fecha_registro,''YYYY'') as fecha,
               case when m.notificacion_id is not NULL then ''NT'' When mt.tipo_mensaje =2 then ''AL'' ELSE ''MS'' end codTipoEnvio,
                nvl(b.componente,nvl(mt.componente,nvl(t.componente,nvl(t1.componente,nvl(t2.componente,nvl(t3.componente,1)))))) as componente ,
                count(1) as cantidad_total,
                count(distinct nvl(m.de,nvl(m.usuid_reg_aud,0))) as cant_emisor ,
                 count(distinct nvl(d.destinatario,nvl(m.usuid_reg_aud,0))) as cant_dest              
  FROM vcobj.mensaje m, 
       vcobj.buzon b,
       vcobj.usuario a,
       vcobj.mensaje_texto mt,
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
      vcobj.orden o
 WHERE m.buzon_id = b.buzon_id (+)
   AND m.de = a.usuario_id  (+)
   AND m.mensaje_texto_id = mt.mensaje_texto_id(+)
   AND m.mensaje_id = d.mensaje_id (+)
   AND  d.destinatario = u.usuario_id (+)
   AND m.notificacion_id = n.notificacion_id(+)
   AND n.notificacion_id = nd.notificacion_id(+)
   AND n.orden_id = o.orden_id (+)
   AND n.orden_id = t.orden_id (+)
   AND n.suce_id = t1.suce_id (+)
   AND m.suce_id = t2.suce_id (+)
   AND nvl(m.dr_id,0) = d2.dr_id(+)  
   AND d2.suce_id = t3.suce_id (+)
   AND m.suce_id = s.suce_id (+) 
   group by TO_CHAR(m.fecha_registro,''YYYY''),
               case when m.notificacion_id is not NULL then ''NT'' When mt.tipo_mensaje =2 then ''AL'' ELSE ''MS'' END,
   nvl(b.componente,nvl(mt.componente,nvl(t.componente,nvl(t1.componente,nvl(t2.componente,nvl(t3.componente,1)))))) order by 1 desc,2 desc,3 desc');
      
END Generar_volumetria;
/
