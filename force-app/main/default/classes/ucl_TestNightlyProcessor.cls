@isTest
private class ucl_TestNightlyProcessor {
    @isTest
    static void TestUpdateInsertLegalAdvisorAccount() {
        // Configurar un mock para simular la llamada HTTP
        Test.setMock(HttpCalloutMock.class, new NightyProcessorMock());

        // Iniciar el entorno de prueba
        Test.startTest();

        // Instanciar ucl_NightyProcessor
        ucl_NightlyProcessor processor = new  NightlyProcessor();

        // Llamar al método herokuCall en la instancia
        HttpResponse response = processor.herokuCall();
        Test.stopTest();

        // Verificar la respuesta HTTP
        System.assertEquals(200, response.getStatusCode(), 'La llamada HTTP no devolvió el código 200 OK');
    }
}