package filenet.repositiry;

import org.springframework.data.jpa.repository.JpaRepository;
import filenet.entity.Configuracion;

public interface ConfiguracionRepository extends JpaRepository<Configuracion, Long> {
    Configuracion getByCodigoComponenteAndCodigoOpcion(String componente, String opcion);
}
