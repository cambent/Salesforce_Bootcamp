public with sharing class ucl_NightlyProcessor {
  @AuraEnabled
  public static void herokuCall() {
    // Inicialización de variables
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'https://altimetrik-bootcamp.herokuapp.com/LegalAccounts'
    );
    request.setMethod('GET');
    HttpResponse response = http.send(request);

    try {
      if (response.getStatusCode() == 200) {
        List<Object> legalAccountJSON = (List<Object>) JSON.deserializeUntyped(
          response.getBody()
        );
        List<Legal_Advisor__c> legalAdvisorsToUpsert = new List<Legal_Advisor__c>();
        List<Client__c> clientsToUpsert = new List<Client__c>();
        String accountNumber;
        for (Object legalAdvisorObj : legalAccountJSON) {
          Map<String, Object> legalAdvisorMap = (Map<String, Object>) legalAdvisorObj;
          String accountStatus = (String) legalAdvisorMap.get('AccountStatus');

          if (accountStatus != null && accountStatus.equals('Enabled')) {
            Legal_Advisor__c legalAdvisorData = new Legal_Advisor__c();
            accountNumber = (String) legalAdvisorMap.get('AccountNumber');
            String accountName = (String) legalAdvisorMap.get('AccountName');

            // Ajustar el formato de fecha
            String asOfDateString = (String) legalAdvisorMap.get('AsOfDate');
            Date asOfDate = null;

            if (asOfDateString != null) {
              try {
                asOfDate = Date.parse(asOfDateString);
              } catch (Exception e) {
                System.debug('Error de fecha: ' + e.getMessage());

                // Si hay un error, asigna la fecha actual
                asOfDate = Date.today();
              }
            }

            legalAdvisorData.Account_Number__c = accountNumber;
            legalAdvisorData.Account_Name__c = accountName;
            legalAdvisorData.Account_Status__c = accountStatus;
            legalAdvisorData.As_of_date__c = asOfDate;

            legalAdvisorsToUpsert.add(legalAdvisorData);
          }

          // Manejo de la lista de clientes
          List<Object> clientList = (List<Object>) legalAdvisorMap.get(
            'Clients'
          );
          for (Object clientObj : clientList) {
            Map<String, Object> clientMap = (Map<String, Object>) clientObj;

            Client__c clientData = new Client__c();
            clientData.Name = (String) clientMap.get('FirstName');
            clientData.Last_Name__c = (String) clientMap.get('LastName');
            clientData.Email__c = (String) clientMap.get('Email');
            clientData.Phone__c = (String) clientMap.get('Phone');
            clientData.Address__c = (String) clientMap.get('Address');
            String clientNumber =
              (String) clientMap.get('ClientNumber') + accountNumber;
            clientData.Client_Number__c = clientNumber;
            clientData.Account_Number__c = accountNumber;
            //clientData.Legal_Advisor__c = accountNumber;
            System.debug('CLiente ' + clientData);

            // Verifica que la lista de Legal Advisors no esté vacía antes de asignar
            if (!legalAdvisorsToUpsert.isEmpty()) {
              Legal_Advisor__c legalAdvisorData = legalAdvisorsToUpsert[0];
              clientData.Legal_Advisor__c = legalAdvisorData.Id;

              clientsToUpsert.add(clientData);
            } else {
              System.debug(
                'La lista de Legal Advisors para upsert está vacía.'
              );
            }
          }
        }

        // Realizar upsert de Legal Advisors
        if (!legalAdvisorsToUpsert.isEmpty()) {
        }
        upsert legalAdvisorsToUpsert Account_Number__c;
        Map<String, Id> legalAdvisorMap = new Map<String, Id>();
        for (Legal_Advisor__c legalAvisor : legalAdvisorsToUpsert) {
          legalAdvisorMap.put(legalAvisor.Account_Number__c, legalAvisor.Id);
        }
        for (Client__c client : clientsToUpsert) {
          client.Legal_Advisor__c = legalAdvisorMap.get(
            client.Account_Number__c
          );
        }
        System.debug('clientsToUpsert' + clientsToUpsert);
        // Realizar upsert de Clients
        if (!clientsToUpsert.isEmpty()) {
          System.debug('Entro en el if');
          //upsert clientsToUpsert Client_Number__c;
          insert clientsToUpsert;
        }
      } else {
        System.debug(
          'La llamada HTTP no fue exitosa. Código de estado: ' +
          response.getStatusCode()
        );
      }
    } catch (Exception e) {
      // Manejo de la excepción (puedes personalizar esto según tus necesidades)
      System.debug('Error en la llamada HTTP: ' + e.getMessage());
    }
  }
}
