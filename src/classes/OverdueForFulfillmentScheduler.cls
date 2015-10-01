global class OverdueForFulfillmentScheduler implements Schedulable{

   global void execute(SchedulableContext sc) {
       OverdueForFulfillment b = new OverdueForFulfillment(); 
      database.executebatch(b);
   }
}