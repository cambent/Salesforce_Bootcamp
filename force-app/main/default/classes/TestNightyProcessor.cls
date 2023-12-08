
@isTest
private class TestNightyProcessor {
    @isTest
    static void TestUpdateInsertLegalAdvisorAccount() {
        // Configurar un mock para simular la llamada HTTP
        Test.setMock(HttpCalloutMock.class, new NightyProcessorMock());

        // Iniciar el entorno de prueba
        Test.startTest();

        // Instanciar NightyProcessor
        NightyProcessor processor = new NightyProcessor();

        // Llamar al método makeGetCallout en la instancia
        HttpResponse response = processor.makeGetCallout();
        Test.stopTest();

        // Verificar la respuesta HTTP
        System.assertEquals(200, response.getStatusCode(), 'La llamada HTTP no devolvió el código 200 OK');
    }
}