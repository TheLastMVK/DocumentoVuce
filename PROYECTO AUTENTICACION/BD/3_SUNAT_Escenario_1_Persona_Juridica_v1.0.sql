--Administrado principal Jurídico   --CUENTA VUCE
select  
'01' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.usuario_sol = 'LLORRAVE' and
   u.documento_tipo = 1 and 
   u.numero_documento = 20523958101 and u.principal='S' AND u.persona_tipo='2';

--Empresa
/*
select  
'01' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.usuario_sol is null and
   u.documento_tipo = 1 and 
   u.numero_documento = 20523958101 and u.principal='S' AND u.persona_tipo='2' and u.empresa = 'S';
*/
