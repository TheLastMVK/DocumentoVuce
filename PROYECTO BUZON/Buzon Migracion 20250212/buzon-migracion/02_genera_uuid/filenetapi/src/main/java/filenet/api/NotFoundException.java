package filenet.api;

@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2023-02-24T16:54:41.375049197Z[GMT]")
public class NotFoundException extends ApiException {
    private int code;

    public NotFoundException(int code, String msg) {
        super(code, msg);
        this.code = code;
    }
}
