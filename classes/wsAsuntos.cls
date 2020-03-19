/**
 * @author oromero@ctconsulting.com.mx
 * @date 13/03/20
 * @group Asunto__c
 * @description Clase de Web service utilizado para crear y actualizar los Asuntos de SIO hacia Salesforce.
 */
@RestResource(urlMapping='/wsCrearAsuntos/*')
global with sharing class wsAsuntos {
	
    /*******************************************************************************************************
    * @description Metodo del Servicio web para crear los Asuntos de la correspondencia en salesforce
    * @param @HttpPost Objeto de tipo JSON en el cuerpo de la solicitud
    * @return Id del Asunto creado / actualizada o mensaje de error
    * @example
    * 
    */

    @HttpPost
    global static ResponseWrapper crearAsuntos(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        ResponseWrapper response = new ResponseWrapper();
        List<WrapperAsuntos> jsonBody = new List<WrapperAsuntos>();
        List<Asunto__c> result = new List<Asunto__c>();
        
        try{
            String aux_claveArea;
        	jsonBody = (List<WrapperAsuntos>) JSON.deserialize(request.requestBody.toString(),List<WrapperAsuntos>.class);
            if(jsonBody.size() > 0 && jsonBody != null){
                for(WrapperAsuntos ids : jsonBody){
                    aux_claveArea = ids.ClaveArea;
                }
            }
            System.debug('Tamaño de la lista ||' + result.size());
            if(result.size() < 1){
                System.debug('Cuenta encontrada result ||' + result);

                for(WrapperAsuntos listBody : jsonBody){
                }
            }else{
                System.debug('Cuenta existente ||' + aux_claveArea);
            }

        }catch(Exception e){
           	System.debug('Error en  ||' + e);
            response.StatusCode = res.StatusCode = 500;
            response.status = 'Error';
            response.message = 'Error al crear la cuenta : '+ e.getMessage() + 'En la linea :' + e.getLineNumber() + ' error ' + e.getTypeName() ;
        }
        return response;
    }
    
    public class WrapperAsuntos{
        
        public String ClaveArea;    
        public String ClaveAsunto;
        public String Contacto;   
        public String Coordinador;
        public String Ejecutivo;
        public String EstatusAsunto;
        public Date FechaAsunto;
        public String IdAsunto;
        public String IdKWD1;
        public String IdKWD2;
        public String IdLegacyActor;
        public String IdLegacyCliente;
        public String IdLegacyCoordinador;
        public String IdLegacyCorresponsal;
        public String IdLegacyDemandado;
        public String IdLeagacyEjecutivo;
        public String IdLegacyFacturar_a;
        public String IdLegacySocio;
        public String IdLegacyTerceroPerjudiado;
        public String IdLegacyTitular;
        public String IdPrincipalEjecutivo;
        public String IdPrincipalActor;
        public String IdPrincipalCoordinador;
        public String IdPrincipalDemandado;
        public String IdPrincipaSocio;
        public String IdPrincipaTerceroPerjudicado;
        public String IdPrincipalCliente;
        public String IdPrincipalCorresonsal;
        public String IdPrincipalFacturar_a;
        public String IdPrincipalTitular;
        public String Name;
        
    }
    global class ResponseWrapper{
        public List<Asunto__c> asunto {get; set;}
        public String Status;
        public String Message;
        public Integer StatusCode;
        public String AsuntosID;
        public ResponseWrapper(){}

    }
}