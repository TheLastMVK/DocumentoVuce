package filenet.jwt;

import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import filenet.dto.CredencialesRequestDto;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.util.Base64;
import java.util.Collections;
import java.util.Date;
import java.util.UUID;

@Component
public class JwtTokenProvider {
    @Value("${security.jwt.token.secret-key}")
    private String secretKey;

    @PostConstruct
    protected void init() {
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    }

    public String buildJwtToken(CredencialesRequestDto credencialesRequestDto, long expiresInMinutes) {
        Date now = new Date();
        Date validity = new Date(now.getTime() + (expiresInMinutes * 60 * 1000));
        JwtBuilder jwtBuilder = Jwts.builder();
        jwtBuilder
                .setSubject(credencialesRequestDto.getClientId())
                .setId(UUID.randomUUID().toString());
        return jwtBuilder
                .setIssuedAt(now)
                .setExpiration(validity)
                .signWith(SignatureAlgorithm.HS256, this.secretKey)
                .compact();
    }

    public String getUsername(String token) {
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody().getSubject();
    }

    public String resolveToken(HttpServletRequest req) {
        String bearerToken = req.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7, bearerToken.length());
        }
        return null;
    }

    public boolean validateToken(String token) throws Exception {
        try {
            Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            throw new Exception("Missing, invalid or expired token");
        }
    }

    public Authentication getAuthentication(String token) {
        String userName = getUsername(token);
        return new UsernamePasswordAuthenticationToken(userName, null, Collections.emptyList());
    }
}
