----->  Funcionario     --BUSCA CUENTA VUCE
select  
'01' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
	   u.documento_tipo = 4 and --Tipo Extranet
	   u.usuario_tipo_id = 2 and    --Funcionario
   u.numero_documento = 'EXTA3011';
   
usuario_tipo_id
1  SOL
2  Entidad
3. DNI
4. Extranet
5. Sistema VUCE
   
----->  Administrado secundario - con DNI - No es tercero
select  u.usuario_sol, 
'02' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 2 and  --DNI
   u.numero_documento_secundario = '43086803' and empresa_externa_id is null
   and u.numero_documento not like 'EXT%'
   and u.Principal = 'N'
   and u.Estado = 'A';


----->  Administrado secundario - con RUC - No es tercero
select  u.usuario_sol, 
'03' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 1 and 
   u.numero_documento_secundario like '10430868034' and  empresa_externa_id is null
   and u.numero_documento not like 'EXT%'
   and u.Principal = 'N'
   and u.Estado = 'A';

----->  Administrado principal con DNIe
select  
'01' item,
u.* ,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.numero_documento = j.numero_documento 
where 
   u.documento_tipo = 2 and
   u.numero_documento = '43086803'
   and u.Principal = 'S'
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
   u.numero_documento = 10430868034  and u.principal='S' AND u.persona_tipo=1 AND
   u.Estado = 'A';
   
--u.persona_tipo
    --1.Natural
    --2.Juridico
    
----->  Administrado secundario - con DNI es TERCERO (OPERADOR)
select  u.usuario_sol, 
'03' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 2 and 
   u.numero_documento_secundario = '43086803' and empresa_externa_id is not null
   and u.numero_documento not like 'EXT%'
   and u.Principal = 'N'
   and u.Estado = 'A'
   AND u.TIPO_EMPRESA_EXTERNA = 1;

----->  Administrado secundario - con RUC es TERCERO
select  u.usuario_sol, 
'03' item,
 u.*,j.nombre nombre_empresa , j.documento_tipo,  j.numero_documento doc_empresa, j.empresa empresa_flg  
from vcobj.usuario u 
left join ( select documento_tipo,  numero_documento , nombre , empresa, usuario_id   from vcobj.usuario where empresa='S' and documento_tipo= '1' and estado='A' and entidad_id is null ) j on
   u.empresa_externa_id = j.usuario_id
where 
   u.documento_tipo_secundario = 1 and 
   u.numero_documento_secundario like '10430868034' and empresa_externa_id is not null
   and u.numero_documento not like 'EXT%'
   and u.Principal = 'N'
   and u.Estado = 'A';

/* SE VALIDA EN ASOCIAR y HABILITAR NO AQUI
----->  Administrado secundario - con DNI es TERCERO (LABORATORIO)
select  u.usuario_sol, 
'03' item,
 u.*, e.documento_tipo, e.numero_documento doc_empresa, e.nombre nombre_empresa, u.tipo_empresa_externa, e.usuario_id  
from vcobj.usuario u
INNER JOIN vcobj.usuario e on e.empresa='S' AND u.empresa_externa_id = e.usuario_id and e.estado='A'
INNER JOIN vcobj.ITP_LABORATORIO il ON il.RUC = e.NUMERO_DOCUMENTO AND il.ESTADO = 'A'
where 
   u.documento_tipo_secundario = 2 and 
   u.numero_documento_secundario = '43086803' and u.empresa_externa_id is not null
   and u.numero_documento not like 'EXT%'
   and u.Principal = 'N'
   and u.Estado = 'A'
   AND u.TIPO_EMPRESA_EXTERNA = 2;
  */