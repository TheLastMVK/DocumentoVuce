package filenet.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.validation.annotation.Validated;

import java.util.Map;
import java.util.Objects;

/**
 * Documento
 */
@Validated
@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2023-03-27T21:49:09.520137751Z[GMT]")


public class Documento {
    @JsonProperty("componente")
    private String componente = null;

    @JsonProperty("opcion")
    private String opcion = null;

    @JsonProperty("foldersExtras")
    private String foldersExtras = null;

    @JsonProperty("iddocumento")
    private String iddocumento = null;

    @JsonProperty("nombre")
    private String nombre = null;

    @JsonProperty("descripcion")
    private String descripcion = null;

    @JsonProperty("propiedades")
    private Map<String, Object> propiedades = null;

    @JsonProperty("bytes")
    private byte[] bytes = null;

    public Documento componente(String componente) {
        this.componente = componente;
        return this;
    }

    /**
     * Id del componente. Asociado a una carpeta en FileNet
     *
     * @return componente
     **/
    @Schema(description = "Id del componente. Asociado a una carpeta en FileNet")

    public String getComponente() {
        return componente;
    }

    public void setComponente(String componente) {
        this.componente = componente;
    }

    public Documento opcion(String opcion) {
        this.opcion = opcion;
        return this;
    }

    /**
     * Id de la opcion del menu. Asociado a una subcarpeta en FileNet
     *
     * @return opcion
     **/
    @Schema(description = "Id de la opcion del menu. Asociado a una subcarpeta en FileNet")

    public String getOpcion() {
        return opcion;
    }

    public void setOpcion(String opcion) {
        this.opcion = opcion;
    }

    public Documento foldersExtras(String foldersExtras) {
        this.foldersExtras = foldersExtras;
        return this;
    }

    /**
     * Folders adicionales a los configurados
     *
     * @return foldersExtras
     **/
    @Schema(description = "Folders adicionales a los configurados")

    public String getFoldersExtras() {
        return foldersExtras;
    }

    public void setFoldersExtras(String foldersExtras) {
        this.foldersExtras = foldersExtras;
    }

    public Documento iddocumento(String iddocumento) {
        this.iddocumento = iddocumento;
        return this;
    }

    /**
     * Id del documento
     *
     * @return iddocumento
     **/
    @Schema(description = "Id del documento")

    public String getIddocumento() {
        return iddocumento;
    }

    public void setIddocumento(String iddocumento) {
        this.iddocumento = iddocumento;
    }

    public Documento nombre(String nombre) {
        this.nombre = nombre;
        return this;
    }

    /**
     * Nombre del documento
     *
     * @return nombre
     **/
    @Schema(description = "Nombre del documento")

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Documento descripcion(String descripcion) {
        this.descripcion = descripcion;
        return this;
    }

    /**
     * Descripcion del documento
     *
     * @return descripcion
     **/
    @Schema(description = "Descripcion del documento")

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Documento propiedades(Map<String, Object> propiedades) {
        this.propiedades = propiedades;
        return this;
    }

    /**
     * Propiedades del documento
     *
     * @return propiedades
     **/
    @Schema(description = "Propiedades del documento")

    public Map<String, Object> getPropiedades() {
        return propiedades;
    }

    public void setPropiedades(Map<String, Object> propiedades) {
        this.propiedades = propiedades;
    }

    public Documento bytes(byte[] bytes) {
        this.bytes = bytes;
        return this;
    }

    /**
     * Documento en bytes
     *
     * @return bytes
     **/
    @Schema(description = "Documento en bytes")

    public byte[] getBytes() {
        return bytes;
    }

    public void setBytes(byte[] bytes) {
        this.bytes = bytes;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Documento documento = (Documento) o;
        return Objects.equals(this.componente, documento.componente) &&
                Objects.equals(this.opcion, documento.opcion) &&
                Objects.equals(this.foldersExtras, documento.foldersExtras) &&
                Objects.equals(this.iddocumento, documento.iddocumento) &&
                Objects.equals(this.nombre, documento.nombre) &&
                Objects.equals(this.descripcion, documento.descripcion) &&
                Objects.equals(this.propiedades, documento.propiedades) &&
                Objects.equals(this.bytes, documento.bytes);
    }

    @Override
    public int hashCode() {
        return Objects.hash(componente, opcion, foldersExtras, iddocumento, nombre, descripcion, propiedades, bytes);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("class Documento {\n");

        sb.append("    componente: ").append(toIndentedString(componente)).append("\n");
        sb.append("    opcion: ").append(toIndentedString(opcion)).append("\n");
        sb.append("    foldersExtras: ").append(toIndentedString(foldersExtras)).append("\n");
        sb.append("    iddocumento: ").append(toIndentedString(iddocumento)).append("\n");
        sb.append("    nombre: ").append(toIndentedString(nombre)).append("\n");
        sb.append("    descripcion: ").append(toIndentedString(descripcion)).append("\n");
        sb.append("    propiedades: ").append(toIndentedString(propiedades)).append("\n");
        sb.append("    bytes: ").append(toIndentedString(bytes)).append("\n");
        sb.append("}");
        return sb.toString();
    }

    /**
     * Convert the given object to string with each line indented by 4 spaces
     * (except the first line).
     */
    private String toIndentedString(Object o) {
        if (o == null) {
            return "null";
        }
        return o.toString().replace("\n", "\n    ");
    }
}
