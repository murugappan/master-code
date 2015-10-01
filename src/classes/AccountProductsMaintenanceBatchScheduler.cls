global class AccountProductsMaintenanceBatchScheduler implements Schedulable{

   global void execute(SchedulableContext sc) {
       AccountProductsMaintenanceBatch b = new AccountProductsMaintenanceBatch(); 
      database.executebatch(b);
   }
}