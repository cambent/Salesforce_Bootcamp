@isTest
private class Test_ucl_NightlyProcessor {
    // Creamos una clase simulada para HttpCalloutMock
    private class MockHttpCallout implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            // Puedes ajustar el cuerpo de la respuesta según tus necesidades de prueba
            res.setBody('[{"AccountStatus": "Enabled", "AccountNumber": "123", "AccountName": "Test Account", "AsOfDate": "2023-01-01", "Clients": [{"FirstName": "John", "LastName": "Doe", "Email": "john.doe@example.com", "Phone": "123-456-7890", "Address": "123 Main St", "ClientNumber": "C123"}]}]');
            return res;
        }
    }

    @isTest
    static void testHerokuCall() {
        // Configuramos el mock para la llamada HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());

        // Llamamos al método que queremos probar
        Test.startTest();
        ucl_NightlyProcessor.herokuCall();
        Test.stopTest();

    }
}
