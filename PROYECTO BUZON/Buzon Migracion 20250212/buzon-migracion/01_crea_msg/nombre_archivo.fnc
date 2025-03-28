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
  v_nombre:=  REPLACE(v_nombre,'�','E');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','o');
  v_nombre:=  REPLACE(v_nombre,'�','o');
  v_nombre:=  REPLACE(v_nombre,'�','n');
  v_nombre:=  REPLACE(v_nombre,'�','N');
  v_nombre:=  REPLACE(v_nombre,'�','x');
  v_nombre:=  REPLACE(v_nombre,'�','u');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','O');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','_');
  v_nombre:=  REPLACE(v_nombre,';','_');
  v_nombre:=  REPLACE(v_nombre,':','_');
  v_nombre:=  REPLACE(v_nombre,'.','_');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'*','x');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'+','');
  v_nombre:=  REPLACE(v_nombre,']','_');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'~','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'}','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'[','_');
  v_nombre:=  REPLACE(v_nombre,']',')');
  v_nombre:=  REPLACE(v_nombre,'=','');
  v_nombre:=  REPLACE(v_nombre,'%','');
  v_nombre:=  REPLACE(v_nombre,'?','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,',','');
  v_nombre:=  REPLACE(v_nombre,'$','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'!','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'{','');
  v_nombre:=  REPLACE(v_nombre,'#','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'&','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'@','');
  v_nombre:=  REPLACE(v_nombre,'`','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'^','');
  v_nombre:=  REPLACE(v_nombre,'�','0');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','U');
  v_nombre:=  REPLACE(v_nombre,'�','e');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','I');
  v_nombre:=  REPLACE(v_nombre,'�','E');
  v_nombre:=  REPLACE(v_nombre,'�','a');
  v_nombre:=  REPLACE(v_nombre,'�','a');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','Z');
  v_nombre:=  REPLACE(v_nombre,'�','I');
  v_nombre:=  REPLACE(v_nombre,'�','Y');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','U');
  v_nombre:=  REPLACE(v_nombre,'�','o');
  v_nombre:=  REPLACE(v_nombre,'�','A');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','A');
  v_nombre:=  REPLACE(v_nombre,'�','A');
  v_nombre:=  REPLACE(v_nombre,'�','A');
  v_nombre:=  REPLACE(v_nombre,'�','A');
  v_nombre:=  REPLACE(v_nombre,'�','a');
  v_nombre:=  REPLACE(v_nombre,'�','a');
  v_nombre:=  REPLACE(v_nombre,'�','a');
  v_nombre:=  REPLACE(v_nombre,'�','a');
  v_nombre:=  REPLACE(v_nombre,'�','i');
  v_nombre:=  REPLACE(v_nombre,'�','u');
  v_nombre:=  REPLACE(v_nombre,'�','O');
  v_nombre:=  REPLACE(v_nombre,'�','E');
  v_nombre:=  REPLACE(v_nombre,'�','I');
  v_nombre:=  REPLACE(v_nombre,'�','I');
  v_nombre:=  REPLACE(v_nombre,'�','O');
  v_nombre:=  REPLACE(v_nombre,'�','O');
  v_nombre:=  REPLACE(v_nombre,'�','O');
  v_nombre:=  REPLACE(v_nombre,'�','U');
  v_nombre:=  REPLACE(v_nombre,'�','U');
  v_nombre:=  REPLACE(v_nombre,'�','o');
  v_nombre:=  REPLACE(v_nombre,'�','o');
  v_nombre:=  REPLACE(v_nombre,'�','o');
  v_nombre:=  REPLACE(v_nombre,'�','o');
  v_nombre:=  REPLACE(v_nombre,'�','u');
  v_nombre:=  REPLACE(v_nombre,'�','E');
  v_nombre:=  REPLACE(v_nombre,'�','E');
  v_nombre:=  REPLACE(v_nombre,'�','u');
  v_nombre:=  REPLACE(v_nombre,'�','e');
  v_nombre:=  REPLACE(v_nombre,'�','e');
  v_nombre:=  REPLACE(v_nombre,'�','e');
  v_nombre:=  REPLACE(v_nombre,'�','i');
  v_nombre:=  REPLACE(v_nombre,'�','i');
  v_nombre:=  REPLACE(v_nombre,'�','i');
  v_nombre:=  REPLACE(v_nombre,'�','p');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','y');
  v_nombre:=  REPLACE(v_nombre,'�','');
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
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','A');
  v_nombre:=  REPLACE(v_nombre,'.','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'"','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'�','');
  v_nombre:=  REPLACE(v_nombre,'','');
  v_nombre:=  TRIM(v_nombre);


   -- Abrimos el archivo destino.
  v_nombre:=v_nombre||p_tipo;

  --dbms_output.put_line(v_nombre);
  RETURN v_nombre;

END nombre_archivo;
/
