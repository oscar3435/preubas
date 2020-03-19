@RestResource(urlMapping='/testComunicacionOlivaresSF/*')
global with sharing class WS_Comunicacion_Olivates_Test {
    @HttpGet
    global static String getRecord() {
        return 'Conexion exitosa con Salesforce';
    }
}