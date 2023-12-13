public class ucl_ExecuteNightlyProcessor implements Schedulable {
  public void execute(SchedulableContext ctx) {
    ucl_NightlyProcessor.herokuCall();
  }
}
