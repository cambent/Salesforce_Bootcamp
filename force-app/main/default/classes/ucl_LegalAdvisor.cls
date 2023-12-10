public with sharing class ucl_LegalAdvisor {
    String accountName;
    String accountNumber;
    String status;
    Date asOfDate;

//constructor
    public ucl_LegalAdvisor(String accountNumber, String accountName, String status, Date asOfDate) {
        this.accountName = accountName;
        this.accountNumber = accountNumber;
        this.status = status;
        this.asOfDate = asOfDate;
    }

    // Query Legal Advisor by Account Number
    public static Legal_Advisor__c getLegalAdvisorByAccountNumber(String accountNumber) {
        return [SELECT 	Account_Number__c, Account_Name__c FROM Legal_Advisor__c WHERE Account_Number__c = :accountNumber LIMIT 1];
    }
}