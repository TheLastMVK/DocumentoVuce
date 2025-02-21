package filenet.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.validation.annotation.Validated;
import filenet.api.ApiException;

import java.util.Objects;

/**
 * Objeto usado para retornar mensaje de error 500
 */
@Schema(description = "Objeto usado para retornar mensaje de error 500")
@Validated
@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2023-02-24T16:54:41.375049197Z[GMT]")


public class ErrorResponse   {
  @JsonProperty("type")
  private String type = null;

  @JsonProperty("code")
  private String alias = null;

  @JsonProperty("description")
  private String description = null;

  public ErrorResponse (ApiException e) {
    description = e.getMessage();
    alias = e.getCodigo();
    type = e.getClass().getSimpleName();
  }

  public ErrorResponse (Exception e) {
    description = e.getMessage();
    type = e.getClass().getSimpleName();
  }

  public ErrorResponse type(String type) {
    this.type = type;
    return this;
  }

  /**
   * Tipo de mensaje de error
   * @return type
   **/
  @Schema(description = "Tipo de mensaje de error")
  
    public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public ErrorResponse alias(String alias) {
    this.alias = alias;
    return this;
  }

  /**
   * Descripcion corta del mensaje del error
   * @return alias
   **/
  @Schema(description = "Descripcion corta del mensaje del error")
  
    public String getAlias() {
    return alias;
  }

  public void setAlias(String alias) {
    this.alias = alias;
  }

  public ErrorResponse description(String description) {
    this.description = description;
    return this;
  }

  /**
   * Descripcion larga del mensaje del error
   * @return description
   **/
  @Schema(description = "Descripcion larga del mensaje del error")
  
    public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }


  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ErrorResponse errorResponse = (ErrorResponse) o;
    return Objects.equals(this.type, errorResponse.type) &&
        Objects.equals(this.alias, errorResponse.alias) &&
        Objects.equals(this.description, errorResponse.description);
  }

  @Override
  public int hashCode() {
    return Objects.hash(type, alias, description);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ErrorResponse {\n");
    
    sb.append("    type: ").append(toIndentedString(type)).append("\n");
    sb.append("    alias: ").append(toIndentedString(alias)).append("\n");
    sb.append("    description: ").append(toIndentedString(description)).append("\n");
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
