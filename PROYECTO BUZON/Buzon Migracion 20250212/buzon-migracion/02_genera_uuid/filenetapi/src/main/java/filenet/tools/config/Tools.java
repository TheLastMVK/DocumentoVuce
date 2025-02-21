package filenet.tools.config;

import org.springframework.stereotype.Component;

@Component
public class Tools {
    /**
     * Este metodo define null o vacios
     * @param texto a validar
     * @return devuelve null o vacio
     */
    public static boolean isNullOrEmpty(String texto) {
        return texto == null || texto.isEmpty();
    }

    public static boolean isNullEmptyOrCero(String texto) {
        return texto == null || texto.isEmpty() || texto.equals("0");
    }

    /**
     * Este metodo define la validaciones de objetos si son nulos
     * @param <T>  para m�todo de extensi�n gen�rico para verificar si su objeto es nulo o no.
     * @param objeto a validar 
     * @param reemplazo objeto de reemplazar
     * @return
     */
    public static <T> T isnull(T objeto, T reemplazo) {
        if (objeto == null)
            return reemplazo;
        return objeto;
    }

    /**
     * Este metodo generico se sefine para validar y comparar dos matrices que ser�an del mismo tip
     * @param <T>
     * @param objeto a validar
     * @param arreglo matriz a validar
     * @return false si es incorrecto y true si es correcto la validacion
     */
    public static <T> boolean in(T objeto, T[] arreglo) {
        for (T o : arreglo) {
            if (objeto.equals(o))
                return true;
        }
        return false;
    }
}
