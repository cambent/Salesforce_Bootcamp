public with sharing class ucl_NightlyProcessor {
    @AuraEnabled
    
    public static HttpResponse herokuCall() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // Verificar si la solicitud fue exitosa y parsear la respuesta JSON
        if (response.getStatusCode() == 200) {
            List<Object> legalAccountJSONList = (List<Object>)JSON.deserializeUntyped(response.getBody());
            List<Legal_Advisor__c> legalAdvisorToUpsert = new List<Legal_Advisor__c>();
        
            // Iterar sobre la lista de cuentas legales JSON
            for (Object legalAccountJSON : legalAccountJSONList) {
                Map<String, Object> legalAdvisorJSONMap = (Map<String, Object>)legalAccountJSON;
                String accountStatus = (String)legalAdvisorJSONMap.get('AccountStatus');
                String accountNumber = (String)legalAdvisorJSONMap.get('AccountNumber'); // Move the declaration outside the if block
        
                if (accountStatus != null && accountStatus.equals('Enabled')) {
                    String accountName = (String)legalAdvisorJSONMap.get('AccountName');
                    Date asOfDate;
        
                    try {
                        asOfDate = Date.parse((String)legalAdvisorJSONMap.get('AsOfDate'));
                    } catch (Exception e) {
                        System.debug('Error de fecha: ' + e.getMessage());
                        asOfDate = Date.today();
                    }
        
                    Legal_Advisor__c legalAdvisor = new Legal_Advisor__c(
                        Account_Number__c = accountNumber,
                        Account_Name__c = accountName,
                        Account_Status__c = accountStatus,
                        As_Of_Date__c = asOfDate
                    );
        
                    legalAdvisorToUpsert.add(legalAdvisor);
                } else if (accountStatus.equals('Disabled')) {
                    // Now you can use accountNumber here
                    List<Legal_Advisor__c> legalAdvisors = [SELECT Id FROM Legal_Advisor__c WHERE Account_Number__c = :accountNumber LIMIT 1];
        
                    if (!legalAdvisors.isEmpty()) {
                        Legal_Advisor__c legalAdvisor = legalAdvisors[0];
                        legalAdvisor.Account_Status__c = accountStatus;
        
                        update legalAdvisor;
                    }
                }
        
                List<Object> clientList = (List<Object>)legalAdvisorJSONMap.get('Clients');
                for(Object clientObj : clientList) {
                    Map<String, Object> clientMap = (Map<String, Object>)clientObj;
                    
                    Client_c clientObj = insert new Client_c();
                 clientObj Client_Number_c = (String) clientMap.get('ClientNumber');
                    upsert clienttoUpsert Client_Number_c;
                }
            }
        
            // Realizar la operación de upsert después de la iteración
            if (!legalAdvisorToUpsert.isEmpty()) {
                upsert legalAdvisorToUpsert Account_Number__c;
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
List<Client_c> existingClient = [SELECT  Client_Number_c, First_Name_c, Email_c, Phone_c, Address_c FROM Client_c = clientNumber LIMIT 1]
}
        
 }
        
}