@IsTest
private class wsCuentas_Test {
    
    @isTest static void testCreateAccount(){
        Integer recordId = createTestRecord();
		System.debug('ID enviada al servicio web ' + recordId);
        RestRequest request = new RestRequest();
        request.requestURI = 'https://olivaresqa--ctc1.cs14.my.salesforce.com/services/apexrest/wsCreateAccount/'+recordId;
        request.httpMethod = 'GET';
		RestResponse res = new RestResponse();
        RestContext.request = request;
        //System.debug('respuesta ' + wsCuentas.getAccount());
        wsCuentas.ResponseWrapper objectAccount = wsCuentas.getAccount();
        System.debug('Respuesta ' + res);
        
        //objectAccount = wsCuentas.createAccount();
        //Account thisAccount = wsCuentas.createAccount();
    }

    static Integer createTestRecord(){
        
        Account acc = new Account();

        acc.Industria__c = 'Nanotecnología';
        acc.Rating = 'Alta';
        acc.ShippingPostalCode = '55104';
        acc.ShippingState = '';
        acc.Website = 'www.prueba.com';
        acc.AccountSource = 'Recomendación';
        acc.AreaPractica__c = 'Marcas';
        acc.BillingCity = 'Ciudad de México';
        acc.BillingCountry = 'Mexico';
        acc.BillingPostalCode = '11000';
        acc.BillingState = 'Ciudad de México';
        acc.BillingStreet = 'Avenida Del Parque';
        acc.Clave_SIO__c = 'AVA';
        acc.Coordinador__c = 'Lista Seleccion';
        acc.E_mail_corporativo_general__c = 'mail@gmail.com';
        acc.Ejecutivo__c = 'Lista Seleccion';
        acc.Estatus_del_cliente__c = 'Bloqueada';
        acc.Fax = '598 2916 5740';
        acc.Id_Principal__c = 1010;
        acc.Idioma__c = 'Español';
        acc.CurrencyIsoCode = 'USD';
        acc.Moneda_tarifa__c = 'Dólares';
        acc.Name = 'TEST 1';
        //acc.OwnerId =
        //acc.ParentId = listBody.Holding;
        acc.Razon_de_Bloqueo__c = 'Falta de pago';
        acc.RFC__c = 'GOVB900209M00';
        acc.Socio_Responsable__c = 'ABRAHAM DIAZ ARCEO';
        acc.Tipo_de_Facturaci_n__c = 'F (Fee Statemet)';
        acc.TratamientoEspecial__c = 'Tarifas';
        acc.Type = 'Cliente';

        insert acc;
        System.debug('Cuneta creada con el ID' + acc.Id + ' y con el Id Principal creado ' +acc.Id_Principal__c);
        return Integer.valueOf(acc.Id_Principal__c);
       
    }
}