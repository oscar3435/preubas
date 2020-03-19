/**
 * @author oromero@ctconsulting.com.mx
 * @date 10/03/20
 * @group Lead
 * @description Clase del se Servicio Web utilizado para crear y actualizar los Contactos de SIO hacia Salesforce.
 */
@RestResource(urlMapping='/wsCreateContact/*')
global with sharing class wsContactos {
	
    /*******************************************************************************************************
    * @description Metodo del Servicio web para crear un Contacto nuevo en salesforce
    * @param @HttpPost Objeto de tipo JSON en el cuerpo de la solicitud
    * @return Id del Contacto creada o actualizado mensaje de error
    * @example
    * 
    */
    
    @HttpPost
    global static ResponseWrapper createContact(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response; 
        ResponseWrapper response = new ResponseWrapper();
        List<Lead> listLead = new List<Lead>();
        List<Lead> result = new List<Lead>();
        List<User> listUser = new List<User>();
        //ResponseWrapper response = new ResponseWrapper();
        List<WrapperContact> jsonBody = new List<WrapperContact>();
        Id idCuenta;
        String aux_claveSIO;
        String aux_Id_Socio;
        String aux_IdAsunto ;
        
        try{
            jsonBody = (List<WrapperContact>) JSON.deserialize(request.requestBody.toString(),List<WrapperContact>.class);
            if(jsonBody.size() > 0 && jsonBody != null){
                for(WrapperContact ids : jsonBody){
                    aux_IdAsunto = ids.IdAsunto;
                    aux_claveSIO = ids.ClaveSIO;
                }
                result= [SELECT Clave_SIO__c, Grupo__c, Id, IdAsunto__c, IdTramite__c, Name
                    FROM Lead 
                    WHERE IdAsunto__c  =: aux_IdAsunto ];//OR Clave_SIO__c =: aux_claveSIO];

                listUser = [SELECT AccountId, FirstName, Id, Name, Socio_Id_SIO__c 
                    FROM User 
                    WHERE Socio_Id_SIO__c =: aux_Id_Socio];

                if(result.size() > 0){
                    idCuenta = result[0].Id;
                }
                if(result.size() < 1){
                    System.debug('Lead encontrada result ||' + result);
                	System.debug('Tamaño de la lista ||' + result.size());
               	 	//System.debug('Id Principal' + result[0].Id);
                    
                    for(WrapperContact listBody : jsonBody){
                        Lead cont = new Lead();

                        cont.AreaPractica__c = listBody.AreaPractica;
                        cont.City = listBody.AreaPractica;
                        cont.Clave_SIO__c = listBody.ClaveSIO;  
                        cont.Company = listBody.Compania;
                        cont.Country = listBody.Pais;
                        cont.Description = listBody.Comentario;
                        cont.Email = listBody.CorreoElectronico;
                        cont.Fax = listBody.Fax;
                        cont.FirstName = listBody.NombreContacto;
                        cont.Grupo__c = listBody.Grupo;
                        cont.IdAsunto__c = listBody.IdAsunto;
                        cont.IdTramite__c = listBody.IdTramite;
                        cont.Departamento__c = listBody.Departamento;
                        cont.Industria__c = listBody.Industria;
                        cont.LastName = listBody.Apellidos;
                        cont.LeadSource = listBody.OrigenContacto;
        
                        if(listBody.ClaveSIO == null || listBody.ClaveSIO == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Clave SIO del Contacto es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 404;
                        }else if(listBody.CorreoElectronico == null || listBody.CorreoElectronico == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Email del Contacto es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 404;
                        }else if(listBody.IdAsunto == null || listBody.IdAsunto == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro IdAsunto del Contacto es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 404;
                        }else if(listBody.Apellidos == null || listBody.Apellidos == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Apellidos del Contacto es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 404;
                        }else if(listBody.OrigenContacto == null || listBody.OrigenContacto == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Origen del Contacto es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 404;
                        }else{
                            listLead.add(cont);                            
                            if(listLead.size() > 0){
                                insert listLead;
                                response.StatusCode = res.StatusCode = 200;
                                response.status = 'Success';
                                response.ContactID = listLead[0].Id;
                                response.message = 'El Contacto con el Id '+ listLead[0].Id +' se creo exitosamente';
                            } 
                        }
                    }
                }else{
					response.status = 'Warning';
                    response.message = 'El Contacto que desea crear ya existe en Salesforce';
                    response.StatusCode = res.StatusCode = 201;
                    response.ContactID = idCuenta;
                    response.cont = result;
                }     

            }
        System.debug('Lista de Leads ||' + listLead);
        }catch(Exception e){
           	System.debug('Error en  ||' + e);
            response.StatusCode = res.StatusCode = 500;
            //response.acc = listLead; 
            //response.contList = null;
            response.status = 'Error';
            response.message = 'Error al crear el Contacto : '+ e.getMessage();
        }
        return response;
    }

    public class WrapperContact
    {
        public String AreaPractica;    
        public String Ciudad;
        public String ClaveSIO;   
        public String Compania;
        public String Pais;
        public String Comentario;
        public String CorreoElectronico;
        public String Fax;
        public String NombreContacto;
        public String Apellidos;
        public String Grupo;
        public String IdAsunto;
        public String IdTramite;
        public String Departamento;
        public String Industria;
        public String OrigenContacto;

    }
    global class ResponseWrapper{
        public List<Lead> cont {get; set;}
        public String status;
        public String message;
        public Integer StatusCode;
        public String ContactID;
        public ResponseWrapper(){}

    }
}