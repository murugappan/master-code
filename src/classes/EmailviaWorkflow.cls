public  class EmailviaWorkflow {
/* ============================================================
*  Created by : Varghese George
*  Description: This class contains methods to send mail via workflows of Email__c object. 
*
 * ============================================================
 */

/****The following method sends mail directly from Messaging.SingleEmailMessage****/
public static void sendworflowemail(Messaging.SingleEmailMessage mail)
{
    email__c emailrecord= new email__c();
    list<email__c> emaillist=new list<email__c>();   // list to be inserted
    
    if(mail.getToAddresses()!=null)
    for(string s:mail.getToAddresses())
    {
        emailrecord = new email__c();
        emailrecord.email__c=s;
        emailrecord.subject__c=mail.getsubject();
        emailrecord.body__c=mail.gethtmlbody();
        emaillist.add(emailrecord);
    }
    
    if(mail.getccAddresses()!=null)
    for(string s:mail.getccAddresses())
    {
        emailrecord = new email__c();
        emailrecord.email__c=s;
        emailrecord.subject__c=mail.getsubject();
        emailrecord.body__c=mail.gethtmlbody();
        emaillist.add(emailrecord);
    }
    
    if(mail.getbccAddresses()!=null)
    for(string s:mail.getbccAddresses())
    {
        emailrecord = new email__c();
        emailrecord.email__c=s;
        emailrecord.subject__c=mail.getsubject();
        emailrecord.body__c=mail.gethtmlbody();
        emaillist.add(emailrecord);
    }
    if(emaillist!= null && !emaillist.isempty())
      insert emaillist;
}

/** The following method sends mail directly from Messaging.SingleEmailMessage and associate 
     case to email__c record inorder to trigger core license specific workflows **/
public static void sendworflowemail(Messaging.SingleEmailMessage mail,case c)
{
    email__c emailrecord= new email__c();
    list<email__c> emaillist=new list<email__c>();   // list to be inserted
    if(mail.getToAddresses()!=null)
    for(string s:mail.getToAddresses())
    {
        emailrecord = new email__c();
        emailrecord.email__c=s;
        emailrecord.subject__c=mail.getsubject();
        emailrecord.body__c=mail.gethtmlbody();
        emailrecord.case__c=c.id;
        emaillist.add(emailrecord);
    }
    if(mail.getccAddresses()!=null)
    for(string s:mail.getccAddresses())
    {
        emailrecord = new email__c();
        emailrecord.email__c=s;
        emailrecord.subject__c=mail.getsubject();
        emailrecord.body__c=mail.gethtmlbody();
        emailrecord.case__c=c.id;
        emaillist.add(emailrecord);
    }
    if(mail.getbccAddresses()!=null)
    for(string s:mail.getbccAddresses())
    {
        emailrecord = new email__c();
        emailrecord.email__c=s;
        emailrecord.subject__c=mail.getsubject();
        emailrecord.body__c=mail.gethtmlbody();
        emailrecord.case__c=c.id;
        emaillist.add(emailrecord);
    }
    if(emaillist!= null && !emaillist.isempty())
      insert emaillist;
}


/****The following method sends multiple mails directly from Messaging.SingleEmailMessage****/
    public static void sendworflowemail(list<Messaging.SingleEmailMessage> mails)
    {
        email__c emailrecord= new email__c();
        list<email__c> emaillist=new list<email__c>();   // list to be inserted
        for(Messaging.SingleEmailMessage mail: mails)   
        {   
            if(mail.getToAddresses()!=null)
            for(string s:mail.getToAddresses())
            {
                emailrecord = new email__c();
                emailrecord.email__c=s;
                emailrecord.subject__c=mail.getsubject();
                emailrecord.body__c=mail.gethtmlbody();
                emaillist.add(emailrecord);
            }
            if(mail.getccAddresses()!=null)
            for(string s:mail.getccAddresses())
            {
                emailrecord = new email__c();
                emailrecord.email__c=s;
                emailrecord.subject__c=mail.getsubject();
                emailrecord.body__c=mail.gethtmlbody();
                emaillist.add(emailrecord);
            }
            if(mail.getbccAddresses()!=null)
            for(string s:mail.getbccAddresses())
            {
                emailrecord = new email__c();
                emailrecord.email__c=s;
                emailrecord.subject__c=mail.getsubject();
                emailrecord.body__c=mail.gethtmlbody();
                emaillist.add(emailrecord);
            }
            
        }
        if(emaillist!= null && !emaillist.isempty())
              insert emaillist;
    }
    
/******The following method sends mail to case contact and cced case team members and extra cced email ids *****/   
    Public static void sendcaseteamemail(case c,list <string> emailaddress,string body, string subject )
    {   
        case c1=[select workflow_email1__c,workflow_email2__c,workflow_email3__c,workflow_email4__c,
                   workflow_email5__c,workflow_email_body__c,workflow_email_subject__c,send_email_external__c from case where id=:c.id];
                   
        c1.workflow_email1__c=c1.workflow_email2__c=c1.workflow_email3__c=c1.workflow_email4__c=c1.workflow_email5__c='';
        if(emailaddress != null && emailaddress.size()>0)
        {
         for(integer i= 0; i<emailaddress.size(); i++)
         {
            if(i == 0)
                c1.workflow_email1__c=emailaddress[i];
            else if(i == 1)
                c1.workflow_email2__c=emailaddress[i];
            else if(i == 2)
                c1.workflow_email3__c=emailaddress[i];
            else if(i == 3)
                c1.workflow_email4__c=emailaddress[i];
            else if(i == 4)
                c1.workflow_email5__c=emailaddress[i];
         }
        }
        c1.workflow_email_body__c= body;
        c1.workflow_email_subject__c=subject;
        system.debug('send mail count--'+c1.send_email_external__c);
        if(c1.send_email_external__c != null)
            c1.send_email_external__c=c1.send_email_external__c+1;
        else
           c1.send_email_external__c=1;
           
        update c1;
    }
    
/******The following method sends mail to case contact and cced case team members  *****/   
    Public static void sendcaseteamemail(case c,string body, string subject )
    {   
        case c1=[select workflow_email1__c,workflow_email2__c,workflow_email3__c,workflow_email4__c,
                   workflow_email5__c,workflow_email_body__c,workflow_email_subject__c,send_email_external__c from case where id=:c.id];
                   
        c1.workflow_email1__c=c1.workflow_email2__c=c1.workflow_email3__c=c1.workflow_email4__c=c1.workflow_email5__c='';
        c1.workflow_email_body__c= body;
        c1.workflow_email_subject__c=subject;
        system.debug('send mail count--'+c1.send_email_external__c);
        if(c1.send_email_external__c != null)
            c1.send_email_external__c=c1.send_email_external__c+1;
        else
           c1.send_email_external__c=1;
           
        update c1;
    }
    
/******The following method sends mail to  cced case team members(Internal staff members)  *****/   
    Public static void mailStaffCaseTeam(case c,string body, string subject )
    {   
        case c1=[select workflow_email1__c,workflow_email2__c,workflow_email3__c,workflow_email4__c,
                   workflow_email5__c,workflow_email_body__c,workflow_email_subject__c,send_email_internal__c from case where id=:c.id];
                   
        c1.workflow_email1__c=c1.workflow_email2__c=c1.workflow_email3__c=c1.workflow_email4__c=c1.workflow_email5__c='';
        c1.workflow_email_body__c= body;
        c1.workflow_email_subject__c=subject;
        system.debug('send mail count--'+c1.send_email_internal__c);
        if(c1.send_email_internal__c != null)
            c1.send_email_internal__c=c1.send_email_internal__c+1;
        else
           c1.send_email_internal__c=1;
           
        update c1;
    }   
    
/******The following method sends mail to case contact and cced case team members (To be used with triggers on Case object) *****/  
    Public static void sendcaseteamemailTrigger(case c,string body, string subject )
    {
                   
        c.workflow_email1__c=c.workflow_email2__c=c.workflow_email3__c=c.workflow_email4__c=c.workflow_email5__c='';
        if(c.ccemail1__c!= null)
          c.workflow_email1__c=c.ccemail1__c;
        if(c.ccemail2__c!= null)
          c.workflow_email2__c=c.ccemail2__c;
        if(c.ccemail3__c!= null)
          c.workflow_email3__c=c.ccemail3__c;
        if(c.ccemail4__c!= null)
          c.workflow_email4__c=c.ccemail4__c;
        if(c.ccemail5__c!= null)
          c.workflow_email5__c=c.ccemail5__c;
              
        c.workflow_email_body__c= body;
        c.workflow_email_subject__c=subject;
        system.debug('send mail count--'+c.send_email_external__c);
        if(c.send_email_external__c != null)
            c.send_email_external__c=c.send_email_external__c+1;
        else
           c.send_email_external__c=1;
    }      

        
    Public static void sendowneremail(case c,list <string> emailaddress,string body, string subject )
    {   
        case c1=[select workflow_email1__c,workflow_email2__c,workflow_email3__c,workflow_email4__c,
                   workflow_email5__c,workflow_email_body__c,workflow_email_subject__c,send_email_owner__c from case where id=:c.id];
                   
        c1.workflow_email1__c=c1.workflow_email2__c=c1.workflow_email3__c=c1.workflow_email4__c=c1.workflow_email5__c='';
        if(emailaddress != null && emailaddress.size()>0)
        {
         for(integer i= 0; i<emailaddress.size(); i++)
         {
            if(i == 0)
                c1.workflow_email1__c=emailaddress[i];
            else if(i == 1)
                c1.workflow_email2__c=emailaddress[i];
            else if(i == 2)
                c1.workflow_email3__c=emailaddress[i];
            else if(i == 3)
                c1.workflow_email4__c=emailaddress[i];
            else if(i == 4)
                c1.workflow_email5__c=emailaddress[i];
         }
        }
        c1.workflow_email_body__c= body;
        c1.workflow_email_subject__c=subject;
        system.debug('send mail count--'+c1.send_email_owner__c);
        if(c1.send_email_owner__c != null)
            c1.send_email_owner__c=c1.send_email_owner__c+1;
        else
           c1.send_email_owner__c=1;
           
        update c1;
    }
}