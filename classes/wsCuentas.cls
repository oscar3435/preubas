/**
 * @author oromero@ctconsulting.com.mx
 * @date 20/02/20
 * @group Account
 * @description Clase de Web service utilizado para crear y actualizar las cuentas de SIO hacia Salesforce.
 */
@RestResource(urlMapping='/wsCreateAccount/*')
global with sharing class wsCuentas {
    /*******************************************************************************************************
    * @description Metodo para recuperar una Cuenta en salesforce.
    * @param @HttpGet Id de la Cuenta solicitud.
    * @return Id de la cuenta creada o actualizada mensaje de error.
    * @example
    * 
    */
    
    @HttpGet
    global static ResponseWrapper getAccount(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response; 
        ResponseWrapper response = new ResponseWrapper();

        String accountId = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);
        List<Account> result = [SELECT Name,AccountNumber,Type,BillingAddress,Id_Principal__c
                        FROM Account
                        WHERE Id_Principal__c = : Integer.valueOf(accountId)];
        if(result != null && result.size() > 0 ){
            // response.acc = result[0];
            response.StatusCode = res.StatusCode = 200;
            response.AccountID = result[0].Id;
            response.acc = result;
            response.status = 'Success';
            response.message = 'Id de la Cuenta encontrada  '+ result[0].Id;
        }else{
            response.acc = null;
            response.status = 'Error';
            response.message = 'No se encontro el numero de Cuenta, por favor intente de nuevo o verifique el número de cuenta que ingresó.';
            response.StatusCode = res.StatusCode = 404;
        }

        return response;
    }
	
    /*******************************************************************************************************
    * @description Metodo del Servicio web para crear una cuenta nueva si no existe en salesforce
    * @param @HttpPost Objeto de tipo JSON en el cuerpo de la solicitud
    * @return Id de la cuenta creada o actualizada mensaje de error
    * @example
    * 
    */
    
    @HttpPost
    global static ResponseWrapper createAccount(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response; 
        ResponseWrapper response = new ResponseWrapper();
        List<Account> listAcc = new List<Account>();
        List<Account> result = new List<Account>();
        List<User> listUser = new List<User>();
        //ResponseWrapper response = new ResponseWrapper();
        List<WrapperAccount> jsonBody = new List<WrapperAccount>();
        Id idCuenta;
        String aux_claveSIO;
        String aux_nombre;
        Integer aux_Id_Principal;
        String principal;
        String aux_ejecutivo;
        String aux_coordinador = 'AFA';
        //String EjecutivoCordinador;
        String aux_IdSocioAsignado;

        try{
            jsonBody = (List<WrapperAccount>) JSON.deserialize(request.requestBody.toString(),List<WrapperAccount>.class);
            if(jsonBody.size() > 0 && jsonBody != null){
                for(WrapperAccount ids : jsonBody){
                    aux_Id_Principal = ids.IdPrincipal;
                    aux_claveSIO = ids.IdLegacy;
                    aux_ejecutivo = ids.Ejecutivo;
                    aux_coordinador = ids.Coordinador;
                    aux_nombre = ids.NombreCuenta;
                    aux_IdSocioAsignado = ids.IdSocioAsignado;
                    
                }
                //Valida si la Cuenta ya existe 
                result = [SELECT Id, Name, Id_Principal__c, Clave_SIO__c
                    	FROM Account 
                    	WHERE Id_Principal__c =: aux_Id_Principal OR Clave_SIO__c =: aux_claveSIO OR Name =:aux_nombre];
                System.debug('Cuenta existente ||' + result);
                if(result.size() < 1){
                	listUser = [SELECT AccountId, FirstName, Id, Name, Socio_Id_SIO__c 
                    		FROM User 
                    		WHERE Socio_Id_SIO__c =: aux_IdSocioAsignado];
                	System.debug('Socio Asignado || ' + listUser[0].Socio_Id_SIO__c + ' Con el Id : ' + listUser[0].Id);
                }
                if(result.size() > 0){
                    idCuenta = result[0].Id;
                }
                System.debug('Tamaño de la lista ||' + result.size());
                if(result.size() < 1){
                    System.debug('Cuenta encontrada result ||' + result);

                    for(WrapperAccount listBody : jsonBody){
                        Account acc = new Account();

                        acc.Industria__c = listBody.Industria;
                        acc.Rating = listBody.ValoracionCuenta;
                        acc.ShippingPostalCode = listBody.CodigoPostalEnvio;
                        acc.ShippingState = listBody.EstadoProvinciaEnvio;
                        acc.Website = listBody.SitioWeb;
                        acc.AccountSource = listBody.OrigenCuenta;
                        acc.AreaPractica__c = listBody.AreaPractica;
                        acc.BillingCity = listBody.Ciudad;
                        acc.BillingCountry = listBody.Pais;
                        acc.BillingPostalCode = listBody.CodigoPostal;
                        acc.BillingState = listBody.EstadoProvincia;
                        acc.BillingStreet = listBody.Calle;
                        acc.Clave_SIO__c = listBody.IdLegacy;
                        /* acc.Coordinador__c = Utils.getCatalogo('Clave__c', aux_coordinador, 'AreaPractica');
                        System.debug('acc.Coordinador__c || ' + acc.Coordinador__c); */
                        acc.E_mail_corporativo_general__c = listBody.EmailCorporativo;
                        //acc.Ejecutivo__c = listBody.Ejecutivo;
                        acc.Ejecutivo__c = Utils.getCatalogo('Clave__c', aux_ejecutivo, 'AreaPractica');
                        System.debug('acc.Ejecutivo__c || ' + acc.Ejecutivo__c);
                        acc.Estatus_del_cliente__c = listBody.EstatusCleinte;
                        acc.Fax = listBody.Fax;
                        acc.Id_Principal__c = listBody.IdPrincipal;
                        acc.Idioma__c = listBody.Idioma;
                        acc.CurrencyIsoCode = 'USD';
                        // if(listBody.DivisaCuenta == 'USD'){
                        //     acc.CurrencyIsoCode = 'Dólares';
                        // }else if(listBody.DivisaCuenta == 'MXN'){
                        //     acc.CurrencyIsoCode = 'Pesos';
                        // }else if(listBody.DivisaCuenta == 'EUR'){
                        //     acc.CurrencyIsoCode = 'Euros';
                        // }
                        acc.Moneda_tarifa__c = listBody.MonedaTarifa;
                        acc.Name = listBody.NombreCuenta;   
  
                        if(listUser.size() > 0){
                            System.debug('Id Propietario asignado || ' + listUser[0].Id);
                            acc.OwnerId = listUser[0].Id;
                        }else{
                            response.status = 'Error';
                            response.message = 'No hay un Propitario para asignar en la Cuenta que desa crear';
                            response.StatusCode = res.StatusCode = 403;
                        }
                        //acc.ParentId = listBody.Holding;
                        acc.Razon_de_Bloqueo__c = listBody.RazonBloqueo;
                        acc.RFC__c = listBody.Rfc;
                        acc.Socio_Responsable__c = listBody.SocioResponsable;
                        if(listBody.TipoFacturacion == 'F'){
                            acc.Tipo_de_Facturaci_n__c = 'F (Fee Statemet)';
                        }else if(listBody.TipoFacturacion == 'E'){
                            acc.Tipo_de_Facturaci_n__c = 'E (Electrónica e-billing)';
                        }else if(listBody.TipoFacturacion == 'N'){
                            acc.Tipo_de_Facturaci_n__c = 'N (Normal)';
                        }else if(listBody.TipoFacturacion == 'M'){
                            acc.Tipo_de_Facturaci_n__c = 'M (Paquete Mensual)';
                        }

                        acc.TratamientoEspecial__c = listBody.TratamientoEspecial;
                        acc.Type = listBody.TipoCuenta;
                        //acc.IsPersonAccount = listBody.EsCunetaPersonal;

                        if(listBody.Industria == null || listBody.Industria == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Industria es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.ValoracionCuenta == null || listBody.ValoracionCuenta == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Valoracion de la Cuenta es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.CodigoPostalEnvio == null || listBody.CodigoPostalEnvio == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Codigo Postal de Envio es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        // }else if(listBody.EstadoProvinciaEnvio == null || listBody.EstadoProvinciaEnvio == ''){
                        //     response.status = 'Error';
                        //     response.message = 'El parámetro ' + listBody.EstadoProvinciaEnvio +' es obligatorio, pero no tiene valor o es nulo';
                        //     response.StatusCode = res.StatusCode = 404;
                        }else if(listBody.OrigenCuenta == null || listBody.OrigenCuenta == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Origen de la Cuenta es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.AreaPractica == null || listBody.AreaPractica == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Area de Práctica es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.Coordinador == null || listBody.Coordinador == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Coordinador es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.Ejecutivo == null || listBody.Ejecutivo == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Ejecutivo es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.EstatusCleinte == null || listBody.EstatusCleinte == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Estatus del cliente es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.IdPrincipal == null || listBody.IdPrincipal == 0){
                            response.status = 'Error';
                            response.message = 'El parámetro Id Principal es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.Idioma == null || listBody.Idioma == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Idioma es obligatorio pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.DivisaCuenta == null || listBody.DivisaCuenta == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Divisa de la Cuenta es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.MonedaTarifa == null || listBody.MonedaTarifa == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Moneda tarifa es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.NombreCuenta == null || listBody.NombreCuenta == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Nombre de la cuenta es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.SocioResponsable == null || listBody.SocioResponsable == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Socio Responsable es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.SocioResponsable == null || listBody.SocioResponsable == ''){
                            response.status = 'Error'; 
                            response.message = 'El parámetro Tipo de Facturación es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else if(listBody.TipoCuenta == null || listBody.TipoCuenta == ''){
                            response.status = 'Error';
                            response.message = 'El parámetro Tipo de Cuenta es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403;
                        }else{
                        /*  if(listBody.EsCunetaPersonal == null){
                            response.status = 'Error';
                            response.message = 'El parámetro EsCuntaPersonal es obligatorio, pero no tiene valor o es nulo';
                            response.StatusCode = res.StatusCode = 403; */
                        //}else{
                            listAcc.add(acc);
                            
                            if(listAcc.size() > 0){
                                insert listAcc;
                                response.StatusCode = res.StatusCode = 200;
                                response.status = 'Success';
                                response.AccountID = listAcc[0].Id;
                                response.message = 'La Cuenta con el Id '+ listAcc[0].Id +' se creo exitosamente';
                                response.acc = result;
                            } 
                        }
                    }
                }else{
					response.status = 'Warning';
                    response.message = 'La Cuenta que desea crear ya existe en Salesforce.';
                    response.StatusCode = res.StatusCode = 201;
                    response.AccountID = idCuenta;
                    response.acc = result;
                }
                    
            }
        	System.debug('Lista de Cuenta ||' + listAcc);
        }catch(Exception e){
           	System.debug('Error en  ||' + e);
            response.StatusCode = res.StatusCode = 500;
           // response.acc = listAcc; 
            //response.contList = null;
            response.status = 'Error';
            response.message = 'Error al crear la cuenta : '+ e.getMessage() + 'En la linea :' + e.getLineNumber() + ' error ' + e.getTypeName() ;
        }
        return response;
    }

    public class WrapperAccount
    {
        public String Industria;    
        public String ValoracionCuenta;
        public String CodigoPostalEnvio;   
        public String EstadoProvinciaEnvio;
        public String SitioWeb;
        public String OrigenCuenta;
        public String AreaPractica;
        public String Ciudad;
        public String Pais;
        public String CodigoPostal;
        public String EstadoProvincia;
        public String Calle;
        public String IdLegacy;
        public String Coordinador;
        public String EmailCorporativo;
        public String Ejecutivo;
        public String EstatusCleinte;
        public String Fax;
        public Integer IdPrincipal;
        public String Idioma;
        public String DivisaCuenta;
        public String MonedaTarifa;
        public String NombreCuenta;
        public String IdSocioAsignado;
        public String Holding;
        public String RazonBloqueo;
        public String Rfc;
        public String SocioResponsable;
        public String TipoFacturacion;
        public String TratamientoEspecial;
        public String TipoCuenta;
        //public Boolean EsCunetaPersonal;
    }
    global class ResponseWrapper{
        public List<Account> acc {get; set;}
        public String status;
        public String message;
        public Integer StatusCode;
        public String AccountID;
        public ResponseWrapper(){}

    }
}