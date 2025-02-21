package filenet.service;

import com.filenet.api.admin.ClassDefinition;
import com.filenet.api.admin.PropertyDefinition;
import com.filenet.api.collection.ContentElementList;
import com.filenet.api.constants.*;
import com.filenet.api.core.*;
import com.filenet.api.exception.EngineRuntimeException;
import com.filenet.api.exception.ExceptionCode;
import com.filenet.api.property.Properties;
import com.filenet.api.util.Id;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import filenet.api.ApiException;
import filenet.commons.enums.ErrorEnum;
import filenet.ecm.FilenetDocumentAbstract;
import filenet.entity.Configuracion;
import filenet.model.Documento;
import filenet.repositiry.ConfiguracionRepository;

import javax.validation.Valid;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.regex.Pattern;

import static com.filenet.api.exception.ExceptionCode.E_BAD_PARAMETER;
import static com.filenet.api.exception.ExceptionCode.E_OBJECT_NOT_FOUND;
import static filenet.tool.Util.getContentStream;
import static filenet.tool.Util.getMimeType;

@Service
public class FilenetService extends FilenetDocumentAbstract {
    static final String DATE_FORMAT = "yyyy-MM-ddTHH:mm:ss.SSS";

    final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    ConfiguracionRepository configuracionRepository;

    public void deleteDocument(@Valid String iddocumento, String user, String password) throws ApiException {

        if ((iddocumento.trim().length()==0)) {
            //throw new ApiException(9, "El parámetro 'iddocumento' debe contener como mínimo 36 dígitos");
            throw new ApiException(ErrorEnum.E9.getCodigo(), ErrorEnum.E9.getDesc());
        }

        try {
            ObjectStore os = getObjectStore(user, password);
            // The getInstance method does not populate the property cache
            Document doc = Factory.Document.getInstance(os, ClassNames.DOCUMENT, new Id(iddocumento));
            doc.delete();
            doc.save(RefreshMode.NO_REFRESH);
        } catch (Exception e) {
            manageException(e);
        }
    }

    public Documento getDocument(String iddocumento, String user, String password) throws ApiException {
        Documento documento = new Documento();

        if (iddocumento.equals("")) {
            //throw new ApiException(2, "El parámetro 'iddocumento' es requerido");
            throw new ApiException(ErrorEnum.E10.getCodigo(), ErrorEnum.E10.getDesc());
        }

        if ((iddocumento.trim().length()<36)) {
            throw new ApiException(ErrorEnum.E9.getCodigo(), ErrorEnum.E9.getDesc());
        }

        if ((iddocumento.trim().length()>36)) {
            throw new ApiException(ErrorEnum.E9.getCodigo(), ErrorEnum.E9.getDesc());
        }

        try {
            ObjectStore os = getObjectStore(user, password);
            // Obtener el objeto Document del repositorio de FileNet
            Document doc = Factory.Document.fetchInstance(os, new Id(iddocumento), null);

            ContentElementList cel = doc.get_ContentElements();
            Iterator<?> it = cel.iterator();
            byte[] fileBytes;

            while (it.hasNext()) {
                ContentElement ce = (ContentElement) it.next();
                fileBytes = getContentStream((ContentTransfer) ce);
                documento.setNombre(((ContentTransfer) ce).get_RetrievalName());
                documento.setBytes(fileBytes);
            }
        } catch (Exception e) {
            manageException(e);
        }

        return documento;
    }

    public Documento createDocument(@Valid Documento documento, String user, String password) throws ApiException {
        if (documento.getComponente().equals("")) {
            //throw new ApiException(2, "El parámetro 'componente' es requerido");
            throw new ApiException(ErrorEnum.E6.getCodigo(), ErrorEnum.E6.getDesc());
        }

        if (!validateNumber15(documento.getComponente())) {
            throw new ApiException(ErrorEnum.E21.getCodigo(), ErrorEnum.E21.getDesc());
        }

        if (documento.getOpcion().equals("")) {
            //throw new ApiException(3, "El parámetro 'opcion' es requerido");
            throw new ApiException(ErrorEnum.E7.getCodigo(), ErrorEnum.E7.getDesc());
        }

       // if (!validateNumberLetter(documento.getOpcion())) {
       //     throw new ApiException(ErrorEnum.E22.getCodigo(), ErrorEnum.E22.getDesc());
       //

        //Configuracion configuracion = configuracionRepository.getByCodigoComponenteAndCodigoOpcion(documento.getComponente(), documento.getOpcion());
        //if (configuracion == null) {
            //throw new ApiException(4, "El parámetro 'componente' u 'opcion' es incorrecto");
        //    throw new ApiException(ErrorEnum.E11.getCodigo(), ErrorEnum.E11.getDesc());
        //}

        if (!documento.getFoldersExtras().equals("") && !validateFolderNames(documento.getFoldersExtras())) {
            //throw new ApiException(7, "El parámetro 'foldersExtras' debe contener solo letras, números, guiones bajos y guiones.");
            throw new ApiException(ErrorEnum.E14.getCodigo(), ErrorEnum.E14.getDesc());
        }

        if (documento.getNombre().equals("")) {
            //throw new ApiException(5, "El parámetro 'nombre' es requerido");
            throw new ApiException(ErrorEnum.E12.getCodigo(), ErrorEnum.E12.getDesc());
        }

        if (!validateFileName(documento.getNombre())) {
            /*throw new ApiException(6, "El parámetro 'nombre' debe contener solo letras, números, guiones bajos, guiones y puntos. " +
                    "Además, debe contener la extensión de 3 caracteres solo letras");*/
            throw new ApiException(ErrorEnum.E13.getCodigo(), ErrorEnum.E13.getDesc());
        }

        String adjuntoId = documento.getPropiedades().get("adjunto_id").toString();
        if (adjuntoId.equals("")) {
            //throw new ApiException(8, "El parámetro 'adjunto_id' es requerido");
            throw new ApiException(ErrorEnum.E15.getCodigo(), ErrorEnum.E15.getDesc());
        }

        if (!validateNumber15(adjuntoId)) {
            //throw new ApiException(9, "El parámetro 'adjunto_id' debe contener solo números y como máximo 15 dígitos");
            throw new ApiException(ErrorEnum.E16.getCodigo(), ErrorEnum.E16.getDesc());
        }

        String adjuntoTipo = documento.getPropiedades().get("adjunto_tipo").toString();
        if (adjuntoTipo.equals("")) {
            //throw new ApiException(10, "El parámetro 'adjunto_tipo' es requerido");
            throw new ApiException(ErrorEnum.E17.getCodigo(), ErrorEnum.E17.getDesc());
        }

        if (documento.getBytes() == null) {
            throw new ApiException(ErrorEnum.E18.getCodigo(), ErrorEnum.E18.getDesc());
        }

        try {
            ObjectStore os = getObjectStore(user, password);

           // String path = configuracion.getNombreRuta() + "/" + configuracion.getNombreSubruta();
             String path =  documento.getOpcion();
            if (documento.getFoldersExtras() != null) {
                path += "/" + documento.getFoldersExtras();
            }

            path = createPath(path, user, password);
            Folder folder = filenetConnection.getFolder(os, path);

            String id = createDocument(os, folder, documento, "ADJUNTO"); //configuracion.getClase());
            if (id != null) {
                id = id.replace("{", "").replace("}", "");
                documento.setIddocumento(id);
            }
        } catch (Exception e) {
            manageException(e);
        }

        return documento;
    }

    private String createDocument(ObjectStore os, Folder parent, Documento documento, String classname) throws Exception {
        ContentElementList cel = Factory.ContentElement.createList();
        ContentTransfer ct = Factory.ContentTransfer.createInstance();
        cel.add(ct);

        InputStream inputStream = new ByteArrayInputStream(documento.getBytes());
        ct.setCaptureSource(inputStream);
        ct.set_RetrievalName(documento.getNombre());

        // Se crea el documento en cache local
        Document doc = Factory.Document.createInstance(os, classname);
        doc.set_ContentElements(cel);
        // Esta funcion es para hacer checkin al documento como version mayor
        doc.checkin(AutoClassify.DO_NOT_AUTO_CLASSIFY, CheckinType.MAJOR_VERSION);

        // Se asignan las propiedades
        Properties props = doc.getProperties();
        String[] items = documento.getNombre().split("\\.");
        props.putValue("DocumentTitle", items[0]);
        doc.set_MimeType(getMimeType(items[1]));
        putProperties(os, doc, documento, classname);

        /*
         * El metodo de refresh se coloca como REFRESH cuando se quiere actualizar el
         * objeto en la cache local porque se desea utilizar para otra cosa, como se ve
         * mas abajo, en caso no se necesite utilizar se recomienda colocar NO_REFRESH
         */
        doc.save(RefreshMode.REFRESH);

        /*
         * En caso se desee relacionar el documento a una carpeta puede utilizar el
         * siguiente metodo para relacionarlo a la carpeta El objeto parent es la
         * carpeta y los parametros son: El documento, un enum que indica si el nombre
         * de contencion es automatico o no, el nombre de la clase del documento y el
         * ultimo es un enum que indica si el documento hereda seguridad de la carpeta o
         * no.
         */
        ReferentialContainmentRelationship rcr = parent.file(doc, AutoUniqueName.AUTO_UNIQUE, classname, DefineSecurityParentage.DO_NOT_DEFINE_SECURITY_PARENTAGE);
        rcr.save(RefreshMode.NO_REFRESH);

        return doc.get_Id().toString();
    }

    public Documento updateDocument(@Valid Documento documento, String user, String password) throws ApiException {

        Configuracion configuracion = configuracionRepository.getByCodigoComponenteAndCodigoOpcion(documento.getComponente(), documento.getOpcion());
        if (configuracion == null) {
            //throw new ApiException(4, "El parámetro 'componente' u 'opcion' es incorrecto");
            throw new ApiException(ErrorEnum.E11.getCodigo(), ErrorEnum.E11.getDesc());
        }

        if (!validateFileName(documento.getNombre())) {
            /*throw new ApiException(6, "El parámetro 'nombre' debe contener solo letras, números, guiones bajos, guiones y puntos. " +
                    "Además, debe contener la extensión de 3 caracteres solo letras");*/
            throw new ApiException(ErrorEnum.E13.getCodigo(), ErrorEnum.E13.getDesc());
        }

        if (documento.getIddocumento().equals("")) {
            throw new ApiException(ErrorEnum.E10.getCodigo(), ErrorEnum.E10.getDesc());
        }

        if ((documento.getIddocumento().trim().length()<36)) {
            //throw new ApiException(9, "El parámetro 'iddocumento' debe contener como mínimo 36 dígitos");
            throw new ApiException(ErrorEnum.E9.getCodigo(), ErrorEnum.E9.getDesc());
        }

        if ((documento.getIddocumento().trim().length()>36)) {
            //throw new ApiException(9, "El parámetro 'iddocumento' debe contener como máximo 36 dígitos");
            throw new ApiException(ErrorEnum.E9.getCodigo(), ErrorEnum.E9.getDesc());
        }

        if (!documento.getFoldersExtras().equals("") && !validateFolderNames(documento.getFoldersExtras())) {
            throw new ApiException(ErrorEnum.E14.getCodigo(), ErrorEnum.E14.getDesc());
        }

        String adjuntoId = documento.getPropiedades().get("adjunto_id").toString();
        if (adjuntoId.equals("")) {
            throw new ApiException(ErrorEnum.E15.getCodigo(), ErrorEnum.E15.getDesc());
        }

        if (!validateNumber15(adjuntoId)) {
            throw new ApiException(ErrorEnum.E16.getCodigo(), ErrorEnum.E16.getDesc());
        }

        String adjuntoTipo = documento.getPropiedades().get("adjunto_tipo").toString();
        if (adjuntoTipo.equals("")) {
            throw new ApiException(ErrorEnum.E17.getCodigo(), ErrorEnum.E17.getDesc());
        }

        if (!validateNumberLetter(adjuntoTipo)) {
            throw new ApiException(ErrorEnum.E19.getCodigo(), ErrorEnum.E19.getDesc());
        }

        if (documento.getBytes() == null) {
            throw new ApiException(ErrorEnum.E18.getCodigo(), ErrorEnum.E18.getDesc());
        }

        try {
            ObjectStore os = getObjectStore(user, password);
            // Obtener el objeto Document del repositorio de FileNet
            Document doc = Factory.Document.fetchInstance(os, documento.getIddocumento(), null);

            // Se asignan las propiedades
            Properties props = doc.getProperties();
            String[] items = documento.getNombre().split("\\.");
            props.putValue("DocumentTitle", items[0]);
            // No se puede modificar el atributo MimeType.
            putProperties(os, doc, documento, null);
            doc.save(RefreshMode.NO_REFRESH);
        } catch (Exception e) {
            manageException(e);
        }

        return documento;
    }

    private void putProperties(ObjectStore os, Document doc, Documento documento, String classname) throws Exception {
        if (classname == null) {
            classname = doc.get_ClassDescription().get_Name();
        }

        ClassDefinition classDef = Factory.ClassDefinition.fetchInstance(os, classname, null);

        for (Map.Entry<String, Object> entry : documento.getPropiedades().entrySet()) {
            String key = entry.getKey();
            String value = (String) entry.getValue();

            switch (getDataType(classDef, key)) {
                case "STRING":
                    doc.getProperties().putValue(key, value);
                    break;
                case "DATE":
                    Date date = new SimpleDateFormat(DATE_FORMAT).parse(value);
                    doc.getProperties().putValue(key, date);
                    break;
                default:
                    throw new Exception("No existe el atributo en la clase del documento");
            }
        }
    }

    private String getDataType(ClassDefinition classDef, String key) {
        for (Object o : classDef.get_PropertyDefinitions()) {
            PropertyDefinition definition = (PropertyDefinition) o;
            if (definition.get_Name().equalsIgnoreCase(key)) {
                return definition.get_DataType().toString();
            }
        }

        return "NULL";
    }

    private void manageException(Exception e) throws ApiException {
        boolean printError = true;

        if (e instanceof EngineRuntimeException) {
            ExceptionCode exceptionCode = ((EngineRuntimeException) e).getExceptionCode();
            if (exceptionCode == E_BAD_PARAMETER || exceptionCode == E_OBJECT_NOT_FOUND) {
                printError = false;
            }
        }

        if (printError) {
            logger.error(e.getMessage(), e);
        }

        throw new ApiException(2, "Error: " + e.getMessage());
    }

    /*
     * https://stackoverflow.com/questions/6768779/test-filename-with-regular-expression
     *
     * En esta expresión regular busca una cadena que cumpla con los siguientes criterios:
     * [\w,\s-] coincide con uno o más caracteres alfanuméricos, comas, espacios en blanco o guiones.
     * + indica que el grupo anterior (la clase de caracteres) debe coincidir una o más veces.
     * \. coincide literalmente con un punto.
     * [A-Za-z]{3} coincide con exactamente tres letras mayúsculas o minúsculas.
     *
     */
    public static boolean validateFileName(String input) {
        String regex = "^[\\w,\\s-]+\\.[A-Za-z]{3}$";
        return Pattern.matches(regex, input);
    }

    /*
     * https://stackoverflow.com/questions/72923904/regex-for-valid-directory-path
     *
     * En esta expresión regular busca una cadena que cumpla con los siguientes criterios:
     * / coincide literalmente con un slash.
     * [a-zA-Z0-9-_] coincide con caracteres alfanuméricos, guiones bajos y guiones.
     * + indica que el grupo anterior (la clase de caracteres) debe coincidir una o más veces.
     *
     */
    public static boolean validateFolderNames(String input) {
        input = "/" + input; // Se adiciona el slash inicial porque no se pone en el parámetro pero debe estar para el match.
        String regex = "^((/[a-zA-Z0-9-_]+)+)$";
        return Pattern.matches(regex, input);
    }

    public static boolean validateNumber15(String input) {
        String regex = "^-?\\d{1,15}(\\.\\d{1,15})?$";
        return Pattern.matches(regex, input);
    }

    public static boolean validateNumberLetter(String input) {
        String regex = "^[a-zA-Z ][0-9]?$";
        return Pattern.matches(regex, input);
    }

    public static boolean validateNumber36(String input) {
        String regex = "^(?:\\D*\\d){36}\\D*$";
        return Pattern.matches(regex, input);
    }
}
