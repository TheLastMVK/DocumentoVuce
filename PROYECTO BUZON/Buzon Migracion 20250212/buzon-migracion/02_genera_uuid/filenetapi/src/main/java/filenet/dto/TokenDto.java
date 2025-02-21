package filenet.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@SuperBuilder
@NoArgsConstructor
public class TokenDto {
    private String accessToken;
    private String tokenType;
    private Long expiresIn;
}
