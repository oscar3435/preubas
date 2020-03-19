@RestResource(urlMapping='/getResponseSF1/*')
global with sharing class TestComunicacionWS_SF_REST {
    @HttpGet
    global static String getStatusConnection() {
        
        return 'Conexion exitosa Status Ok 200';
    }
}