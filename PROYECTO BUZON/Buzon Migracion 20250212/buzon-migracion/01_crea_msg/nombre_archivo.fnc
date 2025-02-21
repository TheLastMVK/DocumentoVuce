CREATE OR REPLACE FUNCTION VCOBJ.nombre_archivo (p_nombre  IN  VARCHAR2,
                                            p_id in NUMBER,
                                            p_tipo in VARCHAR2)
RETURN VARCHAR2 as

  --v_posicion  INTEGER := 1;
 -- v_blob_len  INTEGER;
  v_nombre  VARCHAR2(500);
  v_cant INTEGER;

BEGIN
--  v_blob_len := DBMS_LOB.getlength(p_blob);

  if (p_nombre is null) then
    v_nombre:= p_id;
  else
    v_cant:= REGEXP_COUNT(p_nombre,'[.]');
    if (v_cant > 0) then
        v_nombre:= substr(p_nombre,1,INSTR(p_nombre,'.',1,v_cant)-1)||'_'||p_id;
    else
        v_nombre:=p_nombre||'_'||p_id;
    end if;
  end if;
  
  v_nombre:=  REPLACE(v_nombre,'''','');
  v_nombre:=  REPLACE(v_nombre,'(','_');
  v_nombre:=  REPLACE(v_nombre,')','_');
  v_nombre:=  REPLACE(v_nombre,'Æ','E');
  v_nombre:=  REPLACE(v_nombre,'·','');
  v_nombre:=  REPLACE(v_nombre,'±','');
  v_nombre:=  REPLACE(v_nombre,'¿','');
  v_nombre:=  REPLACE(v_nombre,'º','o');
  v_nombre:=  REPLACE(v_nombre,'°','o');
  v_nombre:=  REPLACE(v_nombre,'ñ','n');
  v_nombre:=  REPLACE(v_nombre,'Ñ','N');
  v_nombre:=  REPLACE(v_nombre,'×','x');
  v_nombre:=  REPLACE(v_nombre,'ù','u');
  v_nombre:=  REPLACE(v_nombre,'ª','');
  v_nombre:=  REPLACE(v_nombre,'Ö','O');
  v_nombre:=  REPLACE(v_nombre,'Ç','');
  v_nombre:=  REPLACE(v_nombre,'ç','');
  v_nombre:=  REPLACE(v_nombre,'´','');
  v_nombre:=  REPLACE(v_nombre,'·','_');
  v_nombre:=  REPLACE(v_nombre,';','_');
  v_nombre:=  REPLACE(v_nombre,':','_');
  v_nombre:=  REPLACE(v_nombre,'.','_');
  v_nombre:=  REPLACE(v_nombre,'¼','');
  v_nombre:=  REPLACE(v_nombre,'*','x');
  v_nombre:=  REPLACE(v_nombre,'³','');
  v_nombre:=  REPLACE(v_nombre,'­','');
  v_nombre:=  REPLACE(v_nombre,'ƒ','');
  v_nombre:=  REPLACE(v_nombre,'•','');
  v_nombre:=  REPLACE(v_nombre,'+','');
  v_nombre:=  REPLACE(v_nombre,']','_');
  v_nombre:=  REPLACE(v_nombre,'½','');
  v_nombre:=  REPLACE(v_nombre,'~','');
  v_nombre:=  REPLACE(v_nombre,'‘','');
  v_nombre:=  REPLACE(v_nombre,'¯','');
  v_nombre:=  REPLACE(v_nombre,'Š','');
  v_nombre:=  REPLACE(v_nombre,'¢','');
  v_nombre:=  REPLACE(v_nombre,'¬','');
  v_nombre:=  REPLACE(v_nombre,'º','');
  v_nombre:=  REPLACE(v_nombre,'µ','');
  v_nombre:=  REPLACE(v_nombre,'¨','');
  v_nombre:=  REPLACE(v_nombre,'©','');
  v_nombre:=  REPLACE(v_nombre,'”','');
  v_nombre:=  REPLACE(v_nombre,'ª','');
  v_nombre:=  REPLACE(v_nombre,'}','');
  v_nombre:=  REPLACE(v_nombre,'“','');
  v_nombre:=  REPLACE(v_nombre,'¸','');
  v_nombre:=  REPLACE(v_nombre,'«','');
  v_nombre:=  REPLACE(v_nombre,'[','_');
  v_nombre:=  REPLACE(v_nombre,']',')');
  v_nombre:=  REPLACE(v_nombre,'=','');
  v_nombre:=  REPLACE(v_nombre,'%','');
  v_nombre:=  REPLACE(v_nombre,'?','');
  v_nombre:=  REPLACE(v_nombre,'®','');
  v_nombre:=  REPLACE(v_nombre,'®','');
  v_nombre:=  REPLACE(v_nombre,'»','');
  v_nombre:=  REPLACE(v_nombre,'’','');
  v_nombre:=  REPLACE(v_nombre,'™','');
  v_nombre:=  REPLACE(v_nombre,',','');
  v_nombre:=  REPLACE(v_nombre,'$','');
  v_nombre:=  REPLACE(v_nombre,'£','');
  v_nombre:=  REPLACE(v_nombre,'!','');
  v_nombre:=  REPLACE(v_nombre,'¾','');
  v_nombre:=  REPLACE(v_nombre,'š','');
  v_nombre:=  REPLACE(v_nombre,'{','');
  v_nombre:=  REPLACE(v_nombre,'#','');
  v_nombre:=  REPLACE(v_nombre,'°','');
  v_nombre:=  REPLACE(v_nombre,'&','');
  v_nombre:=  REPLACE(v_nombre,'¡','');
  v_nombre:=  REPLACE(v_nombre,'@','');
  v_nombre:=  REPLACE(v_nombre,'`','');
  v_nombre:=  REPLACE(v_nombre,'¦','');
  v_nombre:=  REPLACE(v_nombre,'‡','');
  v_nombre:=  REPLACE(v_nombre,'§','');
  v_nombre:=  REPLACE(v_nombre,'^','');
  v_nombre:=  REPLACE(v_nombre,'Ø','0');
  v_nombre:=  REPLACE(v_nombre,'ð','');
  v_nombre:=  REPLACE(v_nombre,'Ü','U');
  v_nombre:=  REPLACE(v_nombre,'è','e');
  v_nombre:=  REPLACE(v_nombre,'‰','');
  v_nombre:=  REPLACE(v_nombre,'Î','I');
  v_nombre:=  REPLACE(v_nombre,'Ê','E');
  v_nombre:=  REPLACE(v_nombre,'ã','a');
  v_nombre:=  REPLACE(v_nombre,'ä','a');
  v_nombre:=  REPLACE(v_nombre,'æ','');
  v_nombre:=  REPLACE(v_nombre,'€','');
  v_nombre:=  REPLACE(v_nombre,'Ž','Z');
  v_nombre:=  REPLACE(v_nombre,'Í','I');
  v_nombre:=  REPLACE(v_nombre,'Ý','Y');
  v_nombre:=  REPLACE(v_nombre,'¥','');
  v_nombre:=  REPLACE(v_nombre,'Ù','U');
  v_nombre:=  REPLACE(v_nombre,'ò','o');
  v_nombre:=  REPLACE(v_nombre,'Ã','A');
  v_nombre:=  REPLACE(v_nombre,'¿','');
  v_nombre:=  REPLACE(v_nombre,'Â','A');
  v_nombre:=  REPLACE(v_nombre,'Á','A');
  v_nombre:=  REPLACE(v_nombre,'Ä','A');
  v_nombre:=  REPLACE(v_nombre,'À','A');
  v_nombre:=  REPLACE(v_nombre,'à','a');
  v_nombre:=  REPLACE(v_nombre,'â','a');
  v_nombre:=  REPLACE(v_nombre,'å','a');
  v_nombre:=  REPLACE(v_nombre,'á','a');
  v_nombre:=  REPLACE(v_nombre,'î','i');
  v_nombre:=  REPLACE(v_nombre,'û','u');
  v_nombre:=  REPLACE(v_nombre,'Ò','O');
  v_nombre:=  REPLACE(v_nombre,'É','E');
  v_nombre:=  REPLACE(v_nombre,'Ì','I');
  v_nombre:=  REPLACE(v_nombre,'Ï','I');
  v_nombre:=  REPLACE(v_nombre,'Ó','O');
  v_nombre:=  REPLACE(v_nombre,'Ô','O');
  v_nombre:=  REPLACE(v_nombre,'Õ','O');
  v_nombre:=  REPLACE(v_nombre,'Ú','U');
  v_nombre:=  REPLACE(v_nombre,'Û','U');
  v_nombre:=  REPLACE(v_nombre,'ó','o');
  v_nombre:=  REPLACE(v_nombre,'ô','o');
  v_nombre:=  REPLACE(v_nombre,'õ','o');
  v_nombre:=  REPLACE(v_nombre,'ö','o');
  v_nombre:=  REPLACE(v_nombre,'ú','u');
  v_nombre:=  REPLACE(v_nombre,'È','E');
  v_nombre:=  REPLACE(v_nombre,'Ë','E');
  v_nombre:=  REPLACE(v_nombre,'ü','u');
  v_nombre:=  REPLACE(v_nombre,'ê','e');
  v_nombre:=  REPLACE(v_nombre,'ë','e');
  v_nombre:=  REPLACE(v_nombre,'é','e');
  v_nombre:=  REPLACE(v_nombre,'ì','i');
  v_nombre:=  REPLACE(v_nombre,'ï','i');
  v_nombre:=  REPLACE(v_nombre,'í','i');
  v_nombre:=  REPLACE(v_nombre,'Þ','p');
  v_nombre:=  REPLACE(v_nombre,'ø','');
  v_nombre:=  REPLACE(v_nombre,'ý','y');
  v_nombre:=  REPLACE(v_nombre,'²','');
  v_nombre:=  REPLACE(v_nombre,chr(141),' ');
  v_nombre:=  REPLACE(v_nombre,chr(130),'');
  v_nombre:=  REPLACE(v_nombre,chr(160),'');
  v_nombre:=  REPLACE(v_nombre,chr(129),'');
  v_nombre:=  REPLACE(v_nombre,chr(150),'');
  v_nombre:=  REPLACE(v_nombre,chr(151),'');
  v_nombre:=  REPLACE(v_nombre,chr(155),'');
  v_nombre:=  REPLACE(v_nombre,chr(132),'');
  v_nombre:=  REPLACE(v_nombre,chr(133),'');
  v_nombre:=  REPLACE(v_nombre,chr(136),'');
  v_nombre:=  REPLACE(v_nombre,chr(143),'');
  v_nombre:=  REPLACE(v_nombre,chr(144),'');
  v_nombre:=  REPLACE(v_nombre,chr(185),'');
  v_nombre:=  REPLACE(v_nombre,'¤','');
  v_nombre:=  REPLACE(v_nombre,'÷','');
  v_nombre:=  REPLACE(v_nombre,'Ð','');
  v_nombre:=  REPLACE(v_nombre,'ß','');
  v_nombre:=  REPLACE(v_nombre,'Å','A');
  v_nombre:=  REPLACE(v_nombre,'.','');
  v_nombre:=  REPLACE(v_nombre,'þ','');
  v_nombre:=  REPLACE(v_nombre,'ÿ','');
  v_nombre:=  REPLACE(v_nombre,'œ','');
  v_nombre:=  REPLACE(v_nombre,'˜','');
  v_nombre:=  REPLACE(v_nombre,'"','');
  v_nombre:=  REPLACE(v_nombre,'‹','');
  v_nombre:=  REPLACE(v_nombre,'ž','');
  v_nombre:=  REPLACE(v_nombre,'†','');
  v_nombre:=  REPLACE(v_nombre,'Ÿ','');
  v_nombre:=  REPLACE(v_nombre,'','');
  v_nombre:=  TRIM(v_nombre);


   -- Abrimos el archivo destino.
  v_nombre:=v_nombre||p_tipo;

  --dbms_output.put_line(v_nombre);
  RETURN v_nombre;

END nombre_archivo;
/
