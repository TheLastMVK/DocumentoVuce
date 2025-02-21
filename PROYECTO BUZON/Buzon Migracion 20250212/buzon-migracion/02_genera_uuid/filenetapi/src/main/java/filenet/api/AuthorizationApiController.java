package filenet.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import filenet.commons.enums.ErrorEnum;
import filenet.dto.CredencialesRequestDto;
import filenet.dto.TokenDto;
import filenet.model.ErrorResponse;
import filenet.service.AuthorizationService;

import javax.servlet.http.HttpServletRequest;

@RestController
@CrossOrigin
@RequestMapping("authorization")
public class AuthorizationApiController {
    @Autowired
    AuthorizationService authorizationService;

    private static final Logger log = LoggerFactory.getLogger(AuthorizationApiController.class);

    @RequestMapping(method = RequestMethod.POST, path = "/token", produces = "application/json; charset=UTF-8")
    public @ResponseBody ResponseEntity<?> generateToken(@RequestBody CredencialesRequestDto credencialesDto,
                                                         HttpServletRequest request) {
        try {
            TokenDto tokenDto = this.authorizationService.generateToken(credencialesDto);
            return new ResponseEntity<>(tokenDto, HttpStatus.OK);
        } catch (ApiException e) {
            //e.printStackTrace();
            log.error("Error de Acceso Token");
            //ApiException e2 = new ApiException(ErrorEnum.E20.getCodigo(), ErrorEnum.E20.getDesc());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse(e));
        }
    }
}
