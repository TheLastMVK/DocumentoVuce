----->  Administrado principal con DNIe
select  
'01' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.documento_tipo = 2 and
   u.numero_documento = '07602652'  --'42571718';
   and u.Estado = 'A';

----->  Administrado principal con RUC10
select  
'02' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.documento_tipo = 1 and 
   u.numero_documento = 10076026527  and u.principal='S' AND u.persona_tipo=1
   and u.Estado = 'A';

----->  Administrado secundario - con DNI
select  u.usuario_sol, 
'03' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 2 and 
   u.numero_documento_secundario = '07602652' and u.empresa_externa_id is not null
   and u.numero_documento not like '%EXT%'
   and COALESCE(u.usuario_sol, '-') <> '07602652'
   and u.Estado = 'A';


----->  Administrado secundario - con RUC
select  u.usuario_sol, 
'03' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 1 and 
   u.numero_documento_secundario like '10076026527'
   and COALESCE(u.usuario_sol, '-') <> '07602652'
   and u.empresa_externa_id is not null
   and principal = 'N'
   and u.numero_documento not like '%EXT%'
   and u.Estado = 'A';

----->  Administrado secundario - El Caso con Clave SOL --CUENTA VUCE
    select  u.usuario_sol, 
    '03' item,
     u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
    from vcobj.usuario u 
    left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
       u.empresa_externa_id = j.usuario_id
    where 
       u.usuario_sol = '07602652' and 
       u.documento_tipo = 1 
       and u.numero_documento = '10430868034' 
       and u.empresa_externa_id is not null
       and principal = 'N'
       and u.numero_documento not like '%EXT%';

----->  Funcionario con DNI -- 
select  
'05' item,
u.* ,j.*
from vcobj.usuario u 
left join ( select entidad_id, entidad, nombre, estado, extranet, siglas from vcobj.entidad where estado='A') j on
   u.entidad_id = j.entidad_id
where 
   u.documento_tipo_secundario = 2 and
   u.numero_documento_secundario = '07602652'
   and u.numero_documento like 'EXT%'
   and u.Estado = 'A';

----->  Funcionario con RUC10
select  
'05' item,
u.* ,j.*
from vcobj.usuario u 
left join ( select entidad_id, entidad, nombre, estado, extranet, siglas from vcobj.entidad where estado='A') j on
   u.entidad_id = j.entidad_id
where 
   u.documento_tipo_secundario = 1 and
   u.numero_documento_secundario = '10076026527'
   and u.numero_documento like 'EXT%'
   and u.Estado = 'A';

