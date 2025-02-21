package filenet.api;

@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2023-02-24T16:54:41.375049197Z[GMT]")
public class ApiException extends Exception {
    private int code;
    private String codigo;

    public ApiException(int code, String msg) {
        super(msg);
        this.code = code;
    }

    public ApiException(String codigo, String msg) {
        super(msg);
        this.codigo = codigo;
    }

    public String getCodigo() {
        return codigo;
    }
}
