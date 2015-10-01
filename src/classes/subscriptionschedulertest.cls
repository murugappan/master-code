@isTest
public class subscriptionschedulertest {
static testmethod void test() {
String jobId = System.schedule('testBasicScheduledApex','00 00 06 6 11 ? 2022',new subscriptionscheduler());
CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];

}
}