/**
 * @author oromero@ctconsulting.com.mx
 * @date 10/03/20
 * @group Lead
 * @description Clase de prueba para clase del Servicio Web wsContactos.
 */
@IsTest
private class wsContactos_Test {
    @isTest static void testCreateContact(){
         String recordId = createTestRecord();
         System.debug('ID enviada al servicio web ' + recordId);
         RestRequest request = new RestRequest();
         request.requestURI = 'https://olivaresqa--ctc1.cs14.my.salesforce.com/services/apexrest/wsCreateContact/';
         request.httpMethod = 'POST';

        // RestContext.request = request;
        // System.debug('respuesta ' + wsCuentas.createAccount());
        // wsCuentas.ResponseWrapper objectAccount = wsCuentas.createAccount();

        //objectAccount = wsCuentas.createAccount();
        //Account thisAccount = wsCuentas.createAccount();
    }

    static String createTestRecord(){
        Lead prospecto = new Lead();

        prospecto.AreaPractica__c = 'Marcas';
        prospecto.City = 'Hermosillo';
        prospecto.Clave_SIO__c = 'AVA';
        prospecto.Company = 'AVA';
        prospecto.Country = 'Coca-Cola';
        prospecto.Description = 'ok';
        prospecto.Email = 'test@gmail.com'; 
        prospecto.Fax = '598 2916 5740';
        prospecto.FirstName = 'Nancy Fabian';
        prospecto.Grupo__c = 'Ciencias de la Vida';
        prospecto.IdAsunto__c = 'E0010';
        prospecto.IdTramite__c = 'E0010';
        prospecto.Departamento__c = 'Patentes';
        prospecto.Industria__c = 'Comercio';
        prospecto.LastName = 'Gerrero';
        prospecto.LeadSource = 'Recomendación';
  
        insert prospecto; 
        System.debug('Contacto - Lead crado con el ID' + prospecto.Id + ' y con el Id Asunto creado ' +prospecto.IdAsunto__c);
        return prospecto.Id;
        
    }
}