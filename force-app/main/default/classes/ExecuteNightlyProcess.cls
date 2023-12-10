public class ExecuteNightlyProcess implements Schedulable {
    public void execute(SchedulableContext ctx) {
        try {
            // Obtener asesores legales que no están cerrados y cuya fecha de cierre es anterior a hoy
            List<Legal_Advisor_c> legalAdvisors = queryLegalAdvisors();
            // Recordar a los propietarios mediante una utilidad de tarea
            TaskUtils.remindOwners(legalAdvisors);
        } catch (Exception e) {
            System.debug('Error executing nightly process: ' + e.getMessage());
            // Agregar lógica adicional según sea necesario
        }
    }

    private List<Legal_Advisor_c> queryLegalAdvisors() {
        return [SELECT AccountNumber, AccountName, AccountStatus, AsOfDate 
                FROM Legal_Advisor_c
                WHERE IsClosed = False AND CloseDate < TODAY];
    }
}
