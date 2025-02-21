package filenet.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Getter
@Setter
@javax.persistence.Entity
@Table(name = "configuracion_filenet")
public class Configuracion {
    @Id
    @Basic(optional = false)
    @NotNull
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "entitySequence")
    @SequenceGenerator(name = "entitySequence", sequenceName = "FILENET.configuracion_filenet_seq", allocationSize = 1)
    @Column(name = "configuracion_filenet_id", unique = true, nullable = false, precision = 0)
    Long id;

    @Basic
    @Column(name = "codigo_componente", nullable = false)
    String codigoComponente;

    @Basic
    @Column(name = "codigo_opcion", nullable = false)
    String codigoOpcion;

    @Basic
    @Column(name = "nombre_ruta", nullable = false)
    String nombreRuta;

    @Basic
    @Column(name = "nombre_subruta", nullable = false)
    String nombreSubruta;

    @Basic
    @Column(name = "fecha_registro", nullable = false)
    String fechaRegistro;

    @Basic
    @Column(name = "clase", nullable = false)
    String clase;

    @Basic
    @Column(name = "estado", nullable = false)
    String estado;
}
