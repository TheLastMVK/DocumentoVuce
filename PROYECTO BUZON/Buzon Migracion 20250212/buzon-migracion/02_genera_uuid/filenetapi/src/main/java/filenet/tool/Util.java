package filenet.tool;

import com.filenet.api.core.ContentTransfer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import filenet.tools.config.Tools;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class Util {
    static final Logger logger = LoggerFactory.getLogger(Util.class);

    /**
     * Para obtener el stream de contenido y descargarlo
     *
     * @param ct
     * @return
     * @throws IOException
     */
    public static byte[] getContentStream(ContentTransfer ct) throws IOException {
        InputStream is = ct.accessContentStream();
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[1024];
        while ((nRead = is.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        buffer.flush();
        return buffer.toByteArray();
    }

    public static String getMimeType(String extension) {
        if (extension.equals("pdf")) {
            return "application/pdf";
        } else if (Tools.in(extension, new String[]{"doc", "dot", "docx", "dotx", "docm", "dotm"})) {
            return "application/msword";
        } else if (Tools.in(extension, new String[]{"xls", "xlst", "xlt"})) {
            return "application/vnd.ms-excel";
        } else if (extension.equals("xml")) {
            return "application/xml";
        } else if (Tools.in(extension, new String[]{"htm", "html"})) {
            return "text/html";
        } else if (extension.equals("csv")) {
            return "text/csv";
        } else if (Tools.in(extension, new String[]{"jpeg", "jpg"})) {
            return "image/jpeg";
        }
        return "application/msword";
    }
}
