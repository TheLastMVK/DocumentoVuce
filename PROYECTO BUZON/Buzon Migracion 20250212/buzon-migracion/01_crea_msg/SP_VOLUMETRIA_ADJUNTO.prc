CREATE OR REPLACE PROCEDURE VCOBJ.SP_VOLUMETRIA_ADJUNTO
   as
   p_fecha VARCHAR2(20):= TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
BEGIN
--  dbms_output.put_line
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2010 as
SELECT 2010 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2010_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2011 as
SELECT 2011 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2011_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2012 as                                                                                                                                                            
SELECT 2012 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2012_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2013                                as   
SELECT 2013 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2013_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2014 as   
SELECT 2014 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2014_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2015 as   
SELECT 2015 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2015_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2016 as   
SELECT 2016 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2016_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2017 as   
SELECT 2017 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2017_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2018 as   
SELECT 2018 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2018_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2019 as   
SELECT 2019 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2019_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2020 as   
SELECT 2020 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2020_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2021 as   
SELECT 2021 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2021_ADJ b WHERE a.adjunto_id = b.adjunto_id');
EXECUTE IMMEDIATE ('create table vcobj.vol_'||p_fecha||'_2022 as   
SELECT 2022 as anno ,sum(NVL(DBMS_LOB.GETLENGTH(a.archivo),0)) AS tamanno FROM VCOBJ.adjunto a, VCOBJ.A_2022_ADJ b WHERE a.adjunto_id = b.adjunto_id');
     
END SP_VOLUMETRIA_ADJUNTO;
/
