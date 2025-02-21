CREATE OR REPLACE PROCEDURE VCOBJ.Cargar_viewbuzon (p_cursor OUT SYS_REFCURSOR) AS
BEGIN
    -- Abre un cursor que ejecuta la consulta y devuelve los resultados
    OPEN p_cursor FOR
        select '2010' as ano, count(1) as total, sum(case when trim(uuid) is null then 0 else 1 end) as cargados from VCOBJ.A_2010_ADJ t union
        select '2011', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2011_ADJ t union
        select '2012', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2012_ADJ t union
        select '2013', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2013_ADJ t union                        
        select '2014', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2014_ADJ t union
        select '2015', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2015_ADJ t union
        select '2016', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2016_ADJ t union
        select '2017', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2017_ADJ t union
        select '2018', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2018_ADJ t union
        select '2019', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2019_ADJ t union
        select '2020', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2020_ADJ t union
        select '2021', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2021_ADJ t union
        select '2022', count(1), sum(case when trim(uuid) is null then 0 else 1 end) from VCOBJ.A_2022_ADJ t;
     
END Cargar_viewbuzon;
/
