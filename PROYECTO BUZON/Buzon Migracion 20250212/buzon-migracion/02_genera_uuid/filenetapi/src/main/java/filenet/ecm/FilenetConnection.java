package filenet.ecm;

import com.filenet.api.core.*;
import com.filenet.api.util.UserContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.security.auth.Subject;

@Component
public class FilenetConnection {
    final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Value("${filenet.hostname}")
    String hostname;
    @Value("${filenet.port}")
    String port;
    @Value("${filenet.domain}")
    String domain;

    /**
     * Este metodo es el de Conexion, de preferencia usar un archivo properties
     * donde pongan la URL de conexion de FileNet
     * @return conexion establecida
     */
    public Connection getCEConnection(String username, String password) {
        //logger.info("INICIO: getCEConnection");

        Connection conn = Factory.Connection.getConnection("http://" + hostname + ":" + port + "/wsi/FNCEWS40MTOM");
        String msg = "Connection: " + conn;
        //logger.info(msg);
        Subject sub = UserContext.createSubject(conn, username, password, null);
       // logger.info("Subject: " + sub);
        UserContext uc = UserContext.get();
        String msg2 = "UserContext: " + uc;
       // logger.info(msg2);
        uc.pushSubject(sub);
       // logger.info("FIN: getCEConnection");
        return conn;
    }

    /**
     * Este metodo es para obtener el dominio, el nombre deberia ir en un properties
     * o como parte del body
     *
     * @return dominio
     */
    public Domain getDomain(Connection conn) {
        return Factory.Domain.fetchInstance(conn, domain, null);
    }

    /**
     * Este metodo es para obtener un Object Store especifico con el objetivo de
     * hacer cargas o descargar al mismo
     *
     * @return ObjectStore
     */
    public ObjectStore getObjectStore(Domain dom, String osname) {
        return Factory.ObjectStore.fetchInstance(dom, osname, null);
    }

    /**
     * Este metodo define el obtener carpeta
     *
     * @param os
     * @param path
     * @return fetchInstance
     */
    public Folder getFolder(ObjectStore os, String path) {
        return Factory.Folder.fetchInstance(os, path, null);
    }
}
