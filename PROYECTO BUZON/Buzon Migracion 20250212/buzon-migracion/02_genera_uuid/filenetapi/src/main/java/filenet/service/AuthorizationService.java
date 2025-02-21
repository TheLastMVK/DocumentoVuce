package filenet.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import filenet.api.ApiException;
import filenet.commons.enums.ErrorEnum;
import filenet.dto.CredencialesRequestDto;
import filenet.dto.TokenDto;
import filenet.jwt.JwtTokenProvider;
import filenet.commons.enums.ErrorEnum;
import filenet.model.ErrorRes;

@Service
public class AuthorizationService {
    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Value("${security.jwt.token.expires-minutes}")
    private long minutesToExpiration;

    @Value("${security.client-id}")
    private String clientId;

    @Value("${security.client-secret}")
    private String secretId;

    public TokenDto generateToken(CredencialesRequestDto credencialesRequestDto) throws ApiException {
        if (credencialesRequestDto.getClientId().trim().equals("")) {
            throw new ApiException(ErrorEnum.E2.getCodigo(), ErrorEnum.E2.getDesc());
        }

        if (credencialesRequestDto.getSecretId().trim().equals("")) {
            throw new ApiException(ErrorEnum.E3.getCodigo(), ErrorEnum.E3.getDesc());
        }

        if (!validateCredencials(credencialesRequestDto)) {
            throw new ApiException(ErrorEnum.E1.getCodigo(), ErrorEnum.E1.getDesc());
        }

        return TokenDto.builder()
                .accessToken(this.jwtTokenProvider.buildJwtToken(credencialesRequestDto, minutesToExpiration))
                .expiresIn(minutesToExpiration)
                .tokenType("JWT")
                .build();
    }

    private boolean validateCredencials(CredencialesRequestDto credencialesRequestDto) {
        return clientId.equals(credencialesRequestDto.getClientId()) && secretId.equals(credencialesRequestDto.getSecretId());
    }
}
