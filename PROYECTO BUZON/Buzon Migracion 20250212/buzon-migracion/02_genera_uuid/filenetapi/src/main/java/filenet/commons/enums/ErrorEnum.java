package filenet.commons.enums;

/**
 * JONCEBAY
 */
public enum ErrorEnum {
    E1 (1, "E0001", "Error en autenticación, revisar credenciales"),
    E2 (2, "E0002", "Ingresar valor para clientId"),
    E3 (3, "E0003", "Ingresar valor para secretId"),
    E4 (4, "E0004", "No se encuentra el valor de componente"),
    E5 (5, "E0005", "No se encuentra el valor de opción"),
    E6 (6, "E0006", "El parámetro 'componente' es requerido"),
    E7 (7, "E0007", "El parámetro 'opcion' es requerido"),
    E8 (8, "E0008", "Ingresar valor para filepost"),
    E9 (9, "E0009", "El parámetro 'iddocumento' debe contener 36 caracteres"),
    E10 (10, "E0010", "El parámetro 'iddocumento' es requerido"),
    E11 (11, "E0011", "El parámetro 'componente' u 'opcion' es incorrecto"),
    E12 (12, "E0012", "El parámetro 'nombre' es requerido"),
    //E13 (13, "E0013", "El parámetro 'nombre' debe contener solo letras, números, guiones bajos, guiones y puntos. No pueden contener los siguientes caracteres \\:*?\"<>|/. Además, debe contener la extensión de 3 caracteres solo letras"),
    E13 (13, "E0013", "Error en parámetro 'nombre'. El nombre del documento no debe contener los siguientes caracteres \"/:*?<>|. El nombre debe contener solo letras, números, guiones bajos, guiones y puntos. Además, debe contener la extensión de 3 caracteres solo letras"),
    //E14 (14, "E0014", "El parámetro 'foldersExtras' debe contener solo letras, números, guiones bajos y guiones. No pueden contener los siguientes caracteres \\:*?\"<>|/"),
    E14 (14, "E0014", "Error en parámetro 'foldersExtras'. Los nombres de archivo no deben contener los siguientes caracteres :*?\"<>|/"),
    E15 (15, "E0015", "El parámetro 'adjunto_id' es requerido"),
    E16 (16, "E0016", "El parámetro 'adjunto_id' debe contener solo números y como máximo 15 dígitos"),
    E17 (17, "E0017", "El parámetro 'adjunto_tipo' es requerido"),
    E18 (18, "E0018", "El parámetro 'bytes' es requerido"),
    E19 (19, "E0019", "El parámetro 'adjunto_tipo' no debe contener caracteres incorrectos"),
    E20 (20, "E0020", "Error de acceso, token inválido"),
    E21 (21, "E0021", "El parámetro 'componente' debe contener solo letras y números. No pueden contener los siguientes caracteres :*?\"<>|/."),
    E22 (22, "E0022", "Error El parámetro 'opcion' debe contener letras y números"),
    E23 (23, "E0023", "Error E0023"),
    E24 (24, "E0024", "Error E0024"),
    E25 (25, "E0025", "Error E0025"),
    E26 (26, "E0026", "Error E0026"),
    E27 (27, "E0027", "Error E0027"),
    E28 (28, "E0028", "Error E0028"),
    E29 (29, "E0029", "Error E0029"),
    E30 (30, "E0030", "Error E0030");

    private Integer id;
    private String codigo;
    private String desc;

    ErrorEnum(Integer id, String codigo, String desc) {
        this.id = id;
        this.codigo = codigo;
        this.desc = desc;
    }

    @Override
    public String toString() {
        return "ErrorEnum{" +
                "id=" + id +
                ", codigo='" + codigo + '\'' +
                ", desc='" + desc + '\'' +
                '}';
    }

    public Integer getId() { return id; }

    public String getCodigo() { return codigo; }

    public String getDesc() { return desc; }

    public static ErrorEnum getErrorEnumById(Integer id) {
        for (ErrorEnum type : values()) {
            if (type.id.equals(id)) {
                return type;
            }
        }
        return null;
    }

    public static ErrorEnum getErrorEnumByCodigo(String codigo) {
        for (ErrorEnum type : values()) {
            if (type.codigo.equals(codigo)) {
                return type;
            }
        }
        return null;
    }

}
