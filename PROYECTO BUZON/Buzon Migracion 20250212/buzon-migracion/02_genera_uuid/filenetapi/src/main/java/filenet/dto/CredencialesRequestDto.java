package filenet.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@SuperBuilder
@NoArgsConstructor
public class CredencialesRequestDto {
    private String clientId;
    private String secretId;
}
