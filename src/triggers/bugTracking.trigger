trigger bugTracking on Related_Bug__c (before insert, before update) {


if (Trigger.isBefore) {
    for(Related_Bug__c rb : Trigger.new){
        if(rb.Name != null || rb.Status__c != null || rb.Not_Fixed_Reason__c != null){
             rb.KI_Bug_Information_Last_Modified__c  = system.now();
        }
        
        if(rb.Name.contains('B2') || rb.Name.contains('b2')){
        rb.addError('Bugs with Major Verion containing B2 cannot be inserted!');
        }
    }

}

else if(Trigger.isUpdate){

    for (Related_Bug__c newBug : Trigger.new) {
        Related_Bug__c oldBug = Trigger.oldMap.get(newBug.Id);
            if (oldBug.Name != newBug.Name || oldBug.Status__c != newBug.Status__c || oldBug.Not_Fixed_Reason__c != newBug.Not_Fixed_Reason__c) {
                 newBug.KI_Bug_Information_Last_Modified__c  = system.now();
            }
    }
    
}

}