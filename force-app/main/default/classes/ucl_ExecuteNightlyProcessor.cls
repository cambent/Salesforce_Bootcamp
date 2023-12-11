public class ucl_ExecutNightlyProcessor implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Legal_Advisor__c> legalAdvisors = [SELECT AccountStatus, AccountNumber, Asofdatec FROM Legal_Advisor__c WHERE IsClosed = False AND CloseDate < TODAY];
        
        if (!legalAdvisors.isEmpty()) {

            TaskUtils.remindOwners(legalAdvisors);
        } else {
            System.debug('No legal advisors found for processing');
        }
    }
}
