trigger SI_attachment_Insert_Update on Case_Attachment__c (after update) {

   List<Case_Attachment__c> attachments = Trigger.new ;
   
   Set<Id> parentIds = new Set<Id>();
      
   for(Case_Attachment__c attachment : attachments)
   {
       if(attachment.support_incident__c !=null)
       {
          parentIds.add(attachment.support_incident__c);
       }
   }
   
   Set<learnJIRA__c> supportIncidents = new Set<learnJIRA__c>([Select Id from learnJIRA__c where Id in :parentIds]);
   List<learnJIRA__c> supportIncidentsToUpdate = new List<learnJIRA__c>{};
   
   for(learnJIRA__c supportIncident : supportIncidents)
   {
      learnJIRA__c supportIncidentToUpdate = new learnJIRA__c(id=supportIncident.Id);
      if(supportIncidentToUpdate.RecordType.Name != Null && supportIncidentToUpdate.RecordType.Name.contains('Learn')  )
      {
       supportIncidentToUpdate.isChanged__c = true ;
      }
      supportIncidentsToUpdate.add(supportIncidentToUpdate);
   }
   
   update supportIncidentsToUpdate;
}