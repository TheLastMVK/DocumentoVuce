package filenet.ecm;

import com.filenet.api.constants.RefreshMode;
import com.filenet.api.core.*;
import com.filenet.api.exception.EngineRuntimeException;
import com.filenet.api.exception.ExceptionCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import java.util.Arrays;

import static com.filenet.api.exception.ExceptionCode.E_OBJECT_NOT_FOUND;

public abstract class FilenetDocumentAbstract {
    @Autowired
    public FilenetConnection filenetConnection;

    @Value("${filenet.hostname}")
    String hostname;
    @Value("${filenet.objectstore}")
    public String objectstore;

    protected String createPath(String folders, String user, String password) {
        ObjectStore os = getObjectStore(user, password);

        String[] folderList = folders.split("/");
        StringBuilder folderPath = new StringBuilder();

        for (String folder : folderList) {
            folderPath.append("/").append(folder);
            try {
                // Verifica si existe el folder.
                filenetConnection.getFolder(os, folderPath.toString());
            } catch (Exception e) {
                ExceptionCode exceptionCode = null;

                if (e instanceof EngineRuntimeException) {
                    exceptionCode = ((EngineRuntimeException) e).getExceptionCode();
                    if (exceptionCode == E_OBJECT_NOT_FOUND) {
                        // Creating folder.
                        Folder newFolder = Factory.Folder.createInstance(os, null);
                        Folder parentFolder;

                        // Establece el folder parent al primer folder de la cadena.
                        if (Arrays.asList(folderList).indexOf(folder) == 0) {
                            parentFolder = os.get_RootFolder();
                        } else {
                            String parentPath = folderPath.substring(0, folderPath.lastIndexOf("/"));
                            System.out.println("parentPath: " + parentPath);
                            parentFolder = filenetConnection.getFolder(os, parentPath);
                        }

                        newFolder.set_Parent(parentFolder);
                        newFolder.set_FolderName(folder);
                        newFolder.save(RefreshMode.REFRESH);
                    }
                }

                // En cualquier otro caso propaga la excepcion.
                if (exceptionCode != E_OBJECT_NOT_FOUND) {
                    throw e;
                }
            }
        }

        return folderPath.toString();
    }

    protected ObjectStore getObjectStore(String user, String password) {
        Connection conn = filenetConnection.getCEConnection(user, password);
        Domain dom = filenetConnection.getDomain(conn);
        return filenetConnection.getObjectStore(dom, objectstore);
    }
}
