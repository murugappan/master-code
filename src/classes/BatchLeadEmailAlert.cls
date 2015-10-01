global class BatchLeadEmailAlert implements Schedulable
{
    public static String CRON_EXP = '0 0 * * * ?';

    List<Lead> queryList1{get;set;}
   
    List<id> lead_id1=new List<id>();
    List<id> manager_email1=new List<id>();
        
    List<id> lead_id2=new List<id>();
    List<id> manager_email2=new List<id>();
    global static String scheduleIt() 
    {
        BatchLeadEmailAlert bla = new BatchLeadEmailAlert ();
        return System.schedule('Daily Reconciliation', CRON_EXP, bla);
    }

        
    global void execute(SchedulableContext ctx)
    {
       
        queryList1=new List<Lead>();
        queryList1= [Select id,status,true_age__c,firstname,lastname,owner__r.name,Owner.id,Owner__r.manager.id from Lead where (Country='USA' OR Country='CANADA') AND (Lead_Vertical__c='NAHE' OR Lead_Vertical__c ='ProEd') AND (((Status ='New')AND( True_Age__c>3)) OR ((Status ='Working')AND( True_Age__c>45)) )AND  (Owner.type!='Queue') AND (( Owner__r.Name!='Greg Milosovic') OR (Owner__r.Name!='Tasha Stanley')  OR(Owner__r.Name !='Kevin Powers') OR (Owner__r.Name!='Sandy Greene')) AND (RecordTypeId ='01270000000DdX4')];        
       
        for(Lead l : queryList1)
        {
            if(l.id!=null)
            {   
                if(l.Status =='New' &&  l.True_Age__c > 3)
                {
                    lead_id1.add(l.id);
                    manager_email1.add(l.Owner__r.manager.id);
                }
                else if(l.Status =='Working' &&  l.True_Age__c > 45)
                {
                    lead_id2.add(l.id);
                    manager_email2.add(l.Owner__r.manager.id);
                }
                else
                {
                }
            }   
        }
        
        if(lead_id1.size()>0)
        {
           sendmail1(lead_id1,manager_email1);         
        }
        
        
        if(lead_id2.size()>0)
        {
           sendmail2(lead_id2,manager_email2);         
        }
        
    }   
    
    
    //For Alert-1
    public void sendmail1(List<id> ownerstr,List<id> mgrstr)
    {
       for(id i: ownerstr)
       {
           Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                //  string [] toaddress=new String[]{'sneha.maheshwary@blackboard.com'};
                //  String[] ccAddresses=new String[]{'mgrstr','sneha.maheshwary@blackboard.com'};
                //  email.setToAddresses(toaddress);
                //  email.setCcAddresses(ccAddresses);
                //  EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'lead_aging_email_alert'];
           Lead details=[select firstname,lastname,owner.id,owner__r.name from lead where id =:i];
           email.setTargetObjectId(details.owner.id);
           email.setSubject('Lead Aging Email Alert'); 
           String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + details.Id;
           String messageBody= '<html><body>*** Lead Aging Alert *** <br/><br/>Hello' +' '+
                                  details.owner__r.name + 
                                  '<br/> The lead '+ details.firstname+' '+details.lastname +' '+
                                  'has been in the \"New\" status for more than 3 days. Please take necessary action to move it to \"Working\" status.<br/>'+
                                  'Link to the lead record:<a href='+fullRecordURL+'>'+fullRecordURL+'</a><br/><br/>' +
                                  'Thank you.<br/>Sales & Marketing Management Teams'+
                                  '</body></html>';
           email.setHtmlBody(messageBody);
                //  email.setTemplateId(et.id);
                //  email.setWhatId(i); 
           email.saveAsActivity = false;
           Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
        }
    }
    
    //For Alert-2
    public void sendmail2(List<Id> ownerstr,List<Id> mgrstr)
    {
       for(id i:ownerstr)
       {
           Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               //String[] ccAddresses=new String[]{'sneha.maheshwary@blackboard.com'};
               // email.setCcAddresses(ccAddresses);
           //EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'Lead_Aging_Alert_for_Above_45_Days'];
           Lead details=[select firstname,lastname,owner.id,owner__r.name from lead where id =:i];
           email.setTargetObjectId(details.owner.id);
           email.setSubject('Lead Aging Email Alert'); 
           String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + details.Id;
           String messageBody= '<html><body>*** Lead Aging Alert *** <br/><br/>Hello' +' '+ 
                                  details.owner__r.name + 
                                  '<br/> The lead '+ details.firstname+' '+details.lastname +' '+
                                  'has been in the \"Working\" status for more than 45 days.Please take necessary action to either convert to a Contact and/or Opportunity or move to Nurture/Rejected/Trash status.'+
                                  'Link to the lead record:<a href='+fullRecordURL+'>'+fullRecordURL+'</a><br/><br/>' +
                                  'Thank you.<br/>Sales & Marketing Management Teams'+
                                  '</body></html>';
           email.setHtmlBody(messageBody);
           //email.setTemplateId(et.id);
           //email.setWhatId(i); 
           email.saveAsActivity = false;
           Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
        }   
    }
}