----->  Administrado secundario - con DNI - No es tercero
select  u.usuario_sol, 
'01' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 2 and 
   u.numero_documento_secundario = '42571718' and principal = 'N' and empresa_externa_id is null
   and u.numero_documento not like 'EXT%'
   and u.Estado = 'A';


----->  Administrado secundario - con RUC - No es tercero
select  u.usuario_sol, 
'01' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 1 and 
   u.numero_documento_secundario like '10425717184' and principal = 'N' and  empresa_externa_id is null
   and u.numero_documento not like 'EXT%'
   and u.Estado = 'A';

----->  Administrado principal con DNIe --BUSCA CUENTA VUCE
select  
'02' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.documento_tipo = 2 and
   u.numero_documento = '42571718' and principal = 'S';

----->  Administrado principal con RUC10
select  
'03' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.documento_tipo = 1 and 
   u.numero_documento = 10425717184 and u.principal='S' AND u.persona_tipo=1
   and u.numero_documento not like 'EXT%'
   and u.Estado = 'A';

----->  Administrado secundario - con DNI es TERCERO
select  u.usuario_sol, 
'04' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 2 and 
   u.numero_documento_secundario = '42571718' and empresa_externa_id is not null
   and principal = 'N' 
   and u.numero_documento not like 'EXT%'
   and u.Estado = 'A';


----->  Administrado secundario - con RUC es TERCERO
select  u.usuario_sol, 
'04' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 1 and 
   u.numero_documento_secundario like '10425717184' and  empresa_externa_id is not null
   and principal = 'N' 
   and u.numero_documento not like 'EXT%'
   and u.Estado = 'A';


----->  Funcionario con DNI
select  
'05' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.documento_tipo_secundario = 2 and
   u.numero_documento_secundario = '42571718'
   and u.numero_documento like 'EXT%'
   and u.Estado = 'A';

----->  Funcionario con RUC10
select  
'05' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.documento_tipo_secundario = 1 and
   u.numero_documento_secundario = '10425717184'
   and u.numero_documento like 'EXT%'
   and u.Estado = 'A';
