package filenet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import filenet.model.Documento;
import filenet.service.FilenetService;
import java.sql.*;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.time.LocalDateTime;

@SpringBootApplication
public class Application implements CommandLineRunner {

	@Autowired
	private FilenetService filenetService;  // Inyectado

	// Constantes de configuración
	private static final String ORACLE_URL = "jdbc:oracle:thin:@//192.168.8.171:1521/vucepr.vuce.gob.pe";
	private static final String ORACLE_USER = "sys as sysdba";
	private static final String ORACLE_PASSWORD = "temporal2028";
	private static final String TOKEN_URL = "https://gateway-apim.vuce.gob.pe/pass-through-https/oauth2/v1/token?grant_type=client_credentials";
	private static final String BASE_URL = "https://gateway-apim.vuce.gob.pe/pass-through-https/filenet2/1.0/file";
	private static final String USERNAME_TOKEN = "F7vUUpDJH9kwAeJrDwYXV5i5ADoa";
	private static final String PASSWORD_TOKEN = "88vPFsQ7qHX9DRtkYCIYL6i6u9Ma";
	private static final String USERNAME = "usuariopam";
	private static final String PASSWORD = "A123456#";
	private static final String COOKIE = "citrix_ns_id=AAA76CGiZjsRX5EDAAAAADs03nL7N7kNagMCO6NBSjNemuAeWHgF1HA4igXg2LImOw==vCWiZg==XuPiKBI1agLXNMUHffKEY0Ljx5k=; NSC_ESNS=06b1c6eb-2238-16a2-9678-00e0ed69dc9a_2327115352_2159988557_00000000000111921981";

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		long startTime = System.currentTimeMillis();

		try {
			// Configuración de conexión a Oracle
			System.out.println("Start Oracle Conn");

			// Conectar a Oracle
			conn = DriverManager.getConnection(ORACLE_URL, ORACLE_USER, ORACLE_PASSWORD);
			conn.setAutoCommit(false); // Para manejar las transacciones manualmente

			// Mensaje de inicio
			String startMessage = "Process started at " + LocalDateTime.now();
			System.out.println(startMessage);

			// Tamaño del lote
			int batchSize = 1000;
			String anomes = args[0];  // Argumento que se pasa en la línea de comandos

			// Realizamos las consultas por lotes
			while (true) {
				System.out.println("inicio del query.");
				String query = String.format(
						"SELECT a.adjunto_id, a.adjunto_tipo, VCOBJ.nombre_archivo(a.nombre_archivo, a.adjunto_id, a.adjunto_tipo) AS nombre_archivo, a.archivo " +
								"FROM VCOBJ.adjunto a, VCOBJ.A_%s_ADJ b " +
								"WHERE a.adjunto_id = b.adjunto_id " +
								"AND TRIM(b.uuid) IS NULL " +
								"AND ROWNUM <= %d " +
								"ORDER BY a.adjunto_id", anomes, batchSize
				);

				// Usamos try-with-resources para manejar automáticamente Statement y ResultSet
				try (Statement statement = conn.createStatement();
					 ResultSet resultSet = statement.executeQuery(query)) {

					if (!resultSet.next()) {
						break; // Si no hay más registros, salir del bucle
					}

					do {
						try {
							int adjuntoId = resultSet.getInt("adjunto_id");
							String adjuntoTipo = resultSet.getString("adjunto_tipo");
							String nombreArchivo = resultSet.getString("nombre_archivo");
							Blob blobData = resultSet.getBlob("archivo");

							byte[] data = blobData.getBytes(1, (int) blobData.length()); // Leer el BLOB

							// Generar UUID
							String documentId = generaUuid(anomes, nombreArchivo, data);
							if (documentId != null && !documentId.trim().isEmpty()) {
								System.out.println("UUID: " + documentId);

								String tableName = "A_" + anomes + "_ADJ";
								String updateQuery = String.format(
										"UPDATE VCOBJ.%s SET uuid = ? WHERE adjunto_id = ?",
										tableName
								);

								try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
									updateStmt.setString(1, documentId);
									updateStmt.setInt(2, adjuntoId);
									updateStmt.executeUpdate();
									conn.commit();
								} catch (SQLException e) {
									// Si ocurre un error al actualizar la base de datos, lo logueamos
									System.err.println("Error al actualizar UUID en la base de datos para adjunto_id " + adjuntoId + ": " + e.getMessage());
								}
							}
							//System.out.println(nombreArchivo);
						} catch (SQLException e) {
							// Si ocurre un error procesando una fila, lo logueamos
							System.err.println("Error al procesar fila: " + e.getMessage());
						}
					} while (resultSet.next());
				} catch (SQLException e) {
					System.err.println("Error en la consulta SQL: " + e.getMessage());
					break; // Si ocurre un error con la consulta, detenemos el proceso
				}

				System.out.println("Adjuntos de FileNet completados.");
			}

		} catch (SQLException e) {
			System.err.println("Error general: " + e.getMessage());
		} finally {
			// Cerrar la conexión y otros recursos
			try {
				if (conn != null) {
					conn.close(); // Cerramos la conexión al final
				}
			} catch (SQLException e) {
				System.err.println("Error cerrando la conexión: " + e.getMessage());
			}

			long endTime = System.currentTimeMillis();
			long executionTime = endTime - startTime;
			String endMessage = String.format("Process ended at %s, execution time: %.2f seconds",
					LocalDateTime.now(), executionTime / 1000.0);
			System.out.println(endMessage);
		}
	}

	// Eliminar el static aquí
	public String generaUuid(String anomes, String filename, byte[] blobData) {
		try {
			// Crear el cuerpo del request
			Documento data = new Documento();
			data.setComponente("120");
			data.setOpcion("DATA");
			data.setFoldersExtras(anomes);
			data.setNombre(filename);
			Map<String, Object> propiedades = new HashMap<>();
			propiedades.put("adjunto_id", "1");
			propiedades.put("adjunto_tipo", "0");
			data.setPropiedades(propiedades);
			data.setBytes(blobData);

			// Aquí invocas el servicio de FileNet
			Documento documento = filenetService.createDocument(data, USERNAME, PASSWORD); // Accede correctamente a filenetService
			// Retorna el ID del documento desde FileNet (esto es solo un ejemplo)
			return documento.getIddocumento();  // Este es el UUID real que obtienes de FileNet
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}

