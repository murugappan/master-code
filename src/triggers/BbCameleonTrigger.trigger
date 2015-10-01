trigger  BbCameleonTrigger on CameleonCPQ__Quote__c (before insert, before update, after insert, after update,before Delete) {


            
            BbCameleonQuoteTriggerHandler handler = new BbCameleonQuoteTriggerHandler();
                
                if(Trigger.isInsert && Trigger.isBefore){
                    handler.OnBeforeInsert(Trigger.new);
                }
                else if(Trigger.isInsert && Trigger.isAfter){
                    handler.OnAfterInsert(Trigger.new, Trigger.newMap);
                }
                
                else if(Trigger.isUpdate && Trigger.isBefore){
                    handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                }
                else if(Trigger.isUpdate && Trigger.isAfter){
                    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                }
                else if(Trigger.IsBefore && Trigger.Isdelete){
                
                   Handler.OnBeforeDelete(Trigger.Old,Trigger.OldMap);
                }
                


}