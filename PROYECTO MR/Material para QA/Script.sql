

--- Conocer datos de la cabecera del requerimiento 
select rp.tramite_id ,  rp.estado_requerimiento_pago_id , rp.ruc_operador, rp.tipo_referencia , * from "GPAG".requerimiento_pago rp 
where rp.codigo_referencia  = 2402003200
order by rp.fecha_reg_aud  desc;	


--Conocer datos edl comprobante de pago
select  rp.estado_pago_id ,  * from "GPAG".requerimiento_pago_detalle rp
where  rp.orden_pago  =2402003200
order by rp.fecha_reg_aud  desc;


--- Scrip para saber el estado del comprobante ed pago
select 
t.tramite_id ,
tve.etapa_tramite ,
rp.requerimiento_pago_id ,
concat(Cast(rp.estado_requerimiento_pago_id as Varchar),' - ', ep_cabecera.nombre_estado ) estado_cabecera ,
concat(Cast(rpd.estado_pago_id  as Varchar),' - ', ep_detalle.nombre_estado ) estado_detalle ,
concat(Cast(t.estado_tramite_id  as Varchar),' - ', et.accion_detonante  ) estado_tramite ,
tve.estado_tramite_id ,
-- concat(Cast(tve.estado_tramite_id  as Varchar),' - ', et.accion_detonante  ) estado_tramite ,
tve.estado_version ,
t.tramite_id ,
rp.requerimiento_pago_id ,
rpd.id_orden_pago ,
rpd.fecha_caducidad ,
rpd.cpb,
rpd.orden_pago ,
rp.monto MontoCabecera,
rpd.monto_exacto,
rpd.fecha_operacion ,
rpd.fecha_procesamiento ,
rpd.canal_pago_id ,
rpd.banco_id ,
rpd.tipo_pago_id 
 from "GPAG".requerimiento_pago rp 
inner join "GPAG".requerimiento_pago_detalle rpd   on rpd.requerimiento_pago_id =rp.requerimiento_pago_id 
inner join "GSOL".tramite_version tv on tv.tramite_id = rp.tramite_id  and  tv.tramite_version  = rp.tramite_version
inner join "MAE".maestro m on m.maestro_id  = tv.etapa_tramite 
inner join "GSOL".tramite t on t.tramite_id = rp.tramite_id
inner join "MAE".estado_pago ep_cabecera on ep_cabecera.estado_pago_id =rp.estado_requerimiento_pago_id  
inner join "MAE".estado_pago ep_detalle  on ep_detalle.estado_pago_id =rpd.estado_pago_id  
inner join  "TRNS".estado_tramite et on et.estado_tramite_id = t.estado_tramite_id  
inner join  "GSOL".tramite_version tve on tve.tramite_id = t.tramite_id 
where  rpd.orden_pago  =2402003200
order by rpd.fecha_reg_aud desc;


-- Consultas de  apoyo
select * from "TRNS".estado_tramite
select * from "MAE".pp_canal_pago
select * from "MAE".pp_banco pb 
select * from "MAE".pp_tipo_pago ptp 
select vigente, * from  "GSOL".tramite_version
select * from "MAE".estado_pago
order by  fecha_reg_aud   ;


-- Consulta paar conoces la etapa de un requerimiento
select m.maestro_id , m.maestro_padre_id ,m.codigo,  m.descripcion , m.estado ,
tv.tramite_id , tv.tramite_version , tv.etapa_tramite  from "MAE".maestro m
inner join "GSOL".tramite_version tv on  m.maestro_id  = tv.etapa_tramite 
where tv.tramite_id  = 3424



