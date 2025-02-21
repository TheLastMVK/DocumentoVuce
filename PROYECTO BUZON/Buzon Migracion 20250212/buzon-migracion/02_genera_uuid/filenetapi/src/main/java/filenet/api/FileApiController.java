package filenet.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import filenet.model.Documento;
import filenet.model.ErrorResponse;
import filenet.service.FilenetService;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.io.IOException;

@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2023-04-14T15:26:38.049122471Z[GMT]")
@RestController
public class FileApiController implements FileApi {
    @Autowired
    FilenetService filenetService;

    private static final Logger log = LoggerFactory.getLogger(FileApiController.class);

    private final ObjectMapper objectMapper;

    private final HttpServletRequest request;

    @org.springframework.beans.factory.annotation.Autowired
    public FileApiController(ObjectMapper objectMapper, HttpServletRequest request) {
        this.objectMapper = objectMapper;
        this.request = request;
    }

    public ResponseEntity<?> fileDelete(@Parameter(in = ParameterIn.HEADER, description = "Usuario de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetUser", required=true) String filenetUser,@Parameter(in = ParameterIn.HEADER, description = "Password de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetPassword", required=true) String filenetPassword,@Parameter(in = ParameterIn.HEADER, description = "Ambiente de despliegue" ,required=true,schema=@Schema()) @RequestHeader(value="host", required=true) String host,@NotNull @Parameter(in = ParameterIn.QUERY, description = "Id del documento" ,required=true,schema=@Schema()) @Valid @RequestParam(value = "iddocumento", required = true) String iddocumento) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                filenetService.deleteDocument(iddocumento, filenetUser, filenetPassword);
                return new ResponseEntity<>(true, HttpStatus.OK);
            } catch (ApiException e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse(e));
            }
        }

        return new ResponseEntity<ErrorResponse>(HttpStatus.NOT_IMPLEMENTED);
    }

    public ResponseEntity<?> fileGet(@Parameter(in = ParameterIn.HEADER, description = "Usuario de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetUser", required=true) String filenetUser,@Parameter(in = ParameterIn.HEADER, description = "Password de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetPassword", required=true) String filenetPassword,@Parameter(in = ParameterIn.HEADER, description = "Ambiente de despliegue" ,required=true,schema=@Schema()) @RequestHeader(value="host", required=true) String host,@NotNull @Parameter(in = ParameterIn.QUERY, description = "Id del documento" ,required=true,schema=@Schema()) @Valid @RequestParam(value = "iddocumento", required = true) String iddocumento) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                Documento documento = filenetService.getDocument(iddocumento, filenetUser, filenetPassword);

                HttpHeaders header = new HttpHeaders();
                header.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + documento.getNombre());
                header.add("Cache-Control", "no-cache, no-store, must-revalidate");
                header.add("Pragma", "no-cache");
                header.add("Expires", "0");

                ByteArrayResource resource = new ByteArrayResource(documento.getBytes());
                return ResponseEntity.ok().headers(header).contentType(MediaType.parseMediaType("application/octet-stream")).body(resource);
            } catch (ApiException e) {
                //log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse(e));
            }
        }

        return new ResponseEntity<ErrorResponse>(HttpStatus.NOT_IMPLEMENTED);
    }

    public ResponseEntity<?> filePost(@Parameter(in = ParameterIn.HEADER, description = "Usuario de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetUser", required=true) String filenetUser,@Parameter(in = ParameterIn.HEADER, description = "Password de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetPassword", required=true) String filenetPassword,@Parameter(in = ParameterIn.HEADER, description = "Ambiente de despliegue" ,required=true,schema=@Schema()) @RequestHeader(value="host", required=true) String host,@Parameter(in = ParameterIn.DEFAULT, description = "Datos de archivo", required=true, schema=@Schema()) @Valid @RequestBody Documento body) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                Documento documento = filenetService.createDocument(body, filenetUser, filenetPassword);
                return new ResponseEntity<Documento>(documento, HttpStatus.OK);
            } catch (ApiException e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse(e));
            }
        }
        log.error("Error request");
        return new ResponseEntity<ErrorResponse>(HttpStatus.NOT_IMPLEMENTED);
    }
    
    public ResponseEntity<?> filePost2(@Parameter(in = ParameterIn.HEADER, description = "Usuario de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetUser", required=true) String filenetUser,@Parameter(in = ParameterIn.HEADER, description = "Password de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetPassword", required=true) String filenetPassword,@Parameter(in = ParameterIn.HEADER, description = "Ambiente de despliegue" ,required=true,schema=@Schema()) @RequestHeader(value="host", required=true) String host,@Parameter(in = ParameterIn.DEFAULT, description = "Datos de archivo", required=true, schema=@Schema()) @Valid @RequestBody Documento body) {
        try {
            // Asumiendo que ya tienes un token de acceso válido

            // Llama al servicio FileNet con el token
            Documento documento = filenetService.createDocument(body, filenetUser, filenetPassword);
            return new ResponseEntity<>(documento, HttpStatus.OK);
        } catch (ApiException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse(e));
        }
    }
    

    public ResponseEntity<?> filePut(@Parameter(in = ParameterIn.HEADER, description = "Usuario de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetUser", required=true) String filenetUser,@Parameter(in = ParameterIn.HEADER, description = "Password de FileNet" ,required=true,schema=@Schema()) @RequestHeader(value="filenetPassword", required=true) String filenetPassword,@Parameter(in = ParameterIn.HEADER, description = "Ambiente de despliegue" ,required=true,schema=@Schema()) @RequestHeader(value="host", required=true) String host,@Parameter(in = ParameterIn.DEFAULT, description = "Datos de archivo", required=true, schema=@Schema()) @Valid @RequestBody Documento body) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                Documento documento = filenetService.updateDocument(body, filenetUser, filenetPassword);
                return new ResponseEntity<Documento>(documento, HttpStatus.OK);
            } catch (ApiException e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse(e));
            }
        }

        return new ResponseEntity<Documento>(HttpStatus.NOT_IMPLEMENTED);
    }

}
