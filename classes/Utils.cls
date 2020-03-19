/**
    * @author:      oromero@ctconsulting.com.mx
    * @date:        13/03/2020
    * @description: Utiletias para las integraciones de SIO a Salesforce
    * @param:       
    * @return:      
*/
public class Utils {
	/**
    * @author:      oromero@ctconsulting.com.mx
    * @date:        13/03/2020
    * @description: Regresa una lista con los nombres de los campos del objeto especificado del Objeto Catalogo__c
    * @param:       String AreaAsunto,
    * @return:      String
    */
	public static String getCatalogo(String field, String clave, String recordType){
		String respuesta;
    	String query;
        List<Catalogo__c> listCat;
        System.debug('recordType || ' + recordType + ' clave || ' + clave);
    	
        if(recordType != null && clave != '' && recordType == 'AreaPractica'){
            String res;
            System.debug('Dentro del if || ' + recordType + ' clave || ' + clave);
            query = 'SELECT Activo__c, Clave__c, Coordinador__c, CurrencyIsoCode, Ejecutivo__c, Id, Id_Legacy__c, Id_principal__c, Linea__c, Name, RecordType__c, RecordTypeId, Socio__c FROM Catalogo__c WHERE ' + field + ' = '+'\'' + clave + '\'' + ' AND RecordType__c  = '+'\'' + recordType + '\'';
            
            System.debug('Query || ' + query);
            try {
				listCat = Database.Query(query);
            } catch(dmlexception e) {
                System.debug('Error en la consulta || ' + e);
            }
            System.debug('Query || ' + listCat);
            if(listCat.size() > 0){
                for(Catalogo__c cat : listCat){
                    System.debug('Catalogo : ' + cat.Name + 'Id catalogo || ' + cat.RecordType__c);
                    res = cat.Name;
                    //break;
                }
            }
            respuesta = res;
        }else{
            respuesta = 'Error: Faltan valores para la consulta';
        }
		
    	System.debug(respuesta);
        return respuesta;
    }
}