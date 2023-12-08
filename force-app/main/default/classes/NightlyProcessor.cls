public static class NightlyProcessor {
    public HttpResponse makeGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        // Verificar si la solicitud fue exitosa y parsear la respuesta JSON.
        if (response.getStatusCode() == 200) {
            List<Object> legalAccountJSONList = (List<Object>)JSON.deserializeUntyped(response.getBody.toString());
            List<Legal_Advisor__c> legalAdvisorToUpsert = new List<Legal_Advisor__c>();
            
            // Iterar sobre la lista de cuentas legales JSON
            for (Object legalAccountJSON : legalAccountJSONList) {
                Map<String, Object> legalAdvisorJSONMap = (Map<String, Object>)legalAccountJJSON;
                String accountStatus = (String)legalAdvisorJSONMap.get('AccountStatus');

                if (accountStatus != null && accountStatus.equals('Enabled')) {
                    String accountName = (String)legalAccountJSONMap.get('AccountName');
                    String accountNumber = (String)legalAccountJSONMap.get('AccountNumber');
                    Date asOfDate = Date.parse((String)legalAccountJSONMap.get('AsOfDate'));}

                    try {
                        asOfDate = Date.parse((String)legalAccountJSONMap.get('AsOfDate'));
                    } catch (Exception e) {
                        System.debug('Error de fecha: ' + e.getMessage());
                        asOfDate = Date.today();
                    }

                    Legal_Advisor__c legalAdvisor = new Legal_Advisor__c(
                        AccountNumber__c = accountNumber,
                        AccountName__c = accountName,
                        AccountStatus__c = accountStatus,
                        AsOfDate__c = asOfDate
                    );
            
                    legalAdvisorToUpsert.add(legalAdvisor);
                     } else if (accountStatus.equals('Disabled')) {
                    String accountNumber = (String)legalAdvisorJSONMap.get('AccountNumber');
                    List<Legal_Advisor__c> legalAdvisors = [SELECT Id FROM Legal_Advisor__c WHERE AccountNumber__c = :accountNumber LIMIT 1];

                    if (!legalAdvisors.isEmpty()) {
                        Legal_Advisor__c legalAdvisor = legalAdvisors[0];
                        legalAdvisor.AccountStatus__c = accountStatus;

                       
                        update legalAdvisor;
                    }
                }
            }
            
            //Lista clientes

            List<Object> ClientList = List<Object> legalAccountJSONList.get ('Clients');
            for(Object ClientObj : ClientList){
                Map<String, Object> ClientMap = (Map<String, Object>) clientObj;
                
                Client_c clientData = insert new Client_c();
                ClientData.Client_Number_c = (String) clientMap.get('ClientNumber');
                upsert clienttoUpsert Client_Number_c;
            }

            // Realizar la operación de upsert después de la iteración
            if (!legalAdvisorToUpsert.isEmpty()) {
                upsert legalAdvisorToUpsert AccountNumber__c;
            }
        }
        return response;
    }


public class ExecuteNightlyProcess implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Legal_Advisor__c> legalAdvisors = [SELECT AccountNumber, AccountName, AccountStatus, AsOfDate FROM Legal_Advisor__c
                                                WHERE IsClosed = False AND CloseDate < TODAY];
        // Create a task for each opportunity in the list
        TaskUtils.remindOwners(legalAdvisors);
    }
}

//Return Exist client

private static Client_c returnExistingClient(String clientNumber){
    List<Client_c> existingClient = [
        SELECT
        Client_Number_c
        First_Name_c
       Email_c
      Phone_c
    Address_c
    FROM Client_c = clientNumber
    LIMIT 1
    ];
}


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