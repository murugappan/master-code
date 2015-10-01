global class subscriptionscheduler implements Schedulable{
global void execute(SchedulableContext sc) {
NotifyKnowledgeFollowersBatch notifyFollowers = new NotifyKnowledgeFollowersBatch(1);
database.executebatch(notifyFollowers);
}
}