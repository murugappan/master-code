public with sharing class BBW_CaseListGrabCase {
    public String CaseNumber{get;set;}
    public user curUser{get;set;}
    public String sortcon;
    public String OwnerName{get;set;}
    public String Severity{get;set;}
    public String Priority{get;set;}
    public String CreatedDate{get;set;}
    public String Status{get;set;}
    public String Subject{get;set;}
    public String AccName{get;set;}
     public String LastModifiedDate{get;set;}
    public String coreLicense{get; set;}
   public string Age{get;set;}
public string SLA_Expiry_time{get;set;}
public string Time_left_for_SLA_Expiry{get;set;}
public string Event_Type{get;set;}
public string CLAtime{get;set;}
string sortorder{get;set;}    
    public list<string> statusList{get; set;}
    public string curUserPrimaryGroup{get;set;}
    public string PsftCaseId{get;set;}
 map<id,milestonetype>milestonemap = new  map<id,milestonetype>([select id,name from milestonetype where name like '%Closure%']); 
    public List<CaseWrapper> caseList {get; set;} //...from this list
  //public List<CaseWrapper> newList {get; set;}
    public BBW_CaseListGrabCase(){ 
       // myCases = new List<Case>();
        //User curUser=[select id,Primary_Group__c from User where Id = :userInfo.getUserId()];
         //Builds a list of cases we can select from
        CaseNumber='Case #';
        OwnerName = 'Owner Name';
        Severity='Case Severity';
        Priority='Priority';
        CreatedDate='Date/Time Opened';
        Status='Status';
        Subject='Subject';
        AccName='Account Name';
         LastModifiedDate='Last Modified Date';
         PsftCaseId='Psft CaseId';
         CoreLicense = 'Core License';
Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';

        buildCaseSelectList();
   }
  
    public Pagereference updatelist(){
 
        curUser=[select id,Primary_Group__c from User where Id = :userInfo.getUserId()]; /* 'shirish.barsainya1@wipro.com']; */
       caseList.clear();
        statusList=new list<string>();
        statusList.add('Open - New');
        statusList.add('Open - Assigned');
        statusList.add('Open - Escalating');
        statusList.add('Open - Pend Dev');
        statusList.add('Open - On Hold');
        statusList.add('Open – Needs Attention');
        statusList.add('Open - Researching');
        statusList.add('Open - Chg Request');
        statusList.add('Open - PendChRq');
        statusList.add('Open - Pending User');

        sortcon = ApexPages.CurrentPage().getParameters().get('firstParam');
          if(sortcon==null)
        {
            if(sortorder!=null && sortorder!='')
            {
                sortcon=sortorder;
                Casenumber=CaseNumber.contains('&uarr;')?CaseNumber.replace('&uarr;','&darr;'):CaseNumber.replace('&darr;','&uarr;');
                OwnerName=OwnerName.contains('&uarr;')?OwnerName.replace('&uarr;','&darr;'):OwnerName.replace('&darr;','&uarr;');
                Severity=Severity.contains('&uarr;')?Severity.replace('&uarr;','&darr;'):Severity.replace('&darr;','&uarr;');
                Priority=Priority.contains('&uarr;')?Priority.replace('&uarr;','&darr;'):Priority.replace('&darr;','&uarr;');
                CreatedDate=CreatedDate.contains('&uarr;')?CreatedDate.replace('&uarr;','&darr;'):CreatedDate.replace('&darr;','&uarr;');
                Status=Status.contains('&uarr;')?Status.replace('&uarr;','&darr;'):Status.replace('&darr;','&uarr;');
                Subject=Subject.contains('&uarr;')?Subject.replace('&uarr;','&darr;'):Subject.replace('&darr;','&uarr;');
                AccName=AccName.contains('&uarr;')?AccName.replace('&uarr;','&darr;'):AccName.replace('&darr;','&uarr;');
                LastModifiedDate=LastModifiedDate.contains('&uarr;')?LastModifiedDate.replace('&uarr;','&darr;'):LastModifiedDate.replace('&darr;','&uarr;');
                PsftCaseId=PsftCaseId.contains('&uarr;')?PsftCaseId.replace('&uarr;','&darr;'):PsftCaseId.replace('&darr;','&uarr;');
                CoreLicense=CoreLicense.contains('&uarr;')?CoreLicense.replace('&uarr;','&darr;'):CoreLicense.replace('&darr;','&uarr;');
                Age=Age.contains('&uarr;')?Age.replace('&uarr;','&darr;'):Age.replace('&darr;','&uarr;');
                SLA_Expiry_time=SLA_Expiry_time.contains('&uarr;')?SLA_Expiry_time.replace('&uarr;','&darr;'):SLA_Expiry_time.replace('&darr;','&uarr;');
                Time_left_for_SLA_Expiry=Time_left_for_SLA_Expiry.contains('&uarr;')?Time_left_for_SLA_Expiry.replace('&uarr;','&darr;'):Time_left_for_SLA_Expiry.replace('&darr;','&uarr;');
                Event_Type=Event_Type.contains('&uarr;')?Event_Type.replace('&uarr;','&darr;'):Event_Type.replace('&darr;','&uarr;');
                CLAtime=CLAtime.contains('&uarr;')?CLAtime.replace('&uarr;','&darr;'):CLAtime.replace('&darr;','&uarr;');
                
            }

        }
         else{
        sortorder=sortcon;
      }
        system.debug('Atul Singhal----------------------1');
        if(sortcon=='def')
            {
             system.debug('manish----------------------1'+sortcon);
            caseList.clear();
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Start_Event__c,Time_left_for_SLA_Expiry__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate ,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.core_license__c  from Case c  where    c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true order by c.Case_Severity__c,c.Status_priority__c,c.lastmodifieddate desc,c.createddate Limit 100];


for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{
if((casedefaultlist[i].Case_Severity__c == casedefaultlist[j].Case_Severity__c) &&(casedefaultlist[i].Status_priority__c == casedefaultlist[j].Status_priority__c) && (casedefaultlist[i].lastmodifieddate == casedefaultlist[j].lastmodifieddate))
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].SLA_Expiry_Time__c < casedefaultlist[j].responsiveness__r[0].SLA_Expiry_Time__c))||(casedefaultlist[i].responsiveness__r.size()<casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
else if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[i].responsiveness__r.size() == casedefaultlist[j].responsiveness__r.size()))&&(casedefaultlist[i].responsiveness__r[0].SLA_Expiry_Time__c == casedefaultlist[j].responsiveness__r[0].SLA_Expiry_Time__c))||(casedefaultlist[i].responsiveness__r.size()==casedefaultlist[j].responsiveness__r.size()))
{
if((((casedefaultlist[i].casemilestones.size()>0)&& ( casedefaultlist[j].casemilestones.size()>0))&&((casedefaultlist[i].casemilestones[0].Targetdate.gettime()- datetime.now().gettime()) < (casedefaultlist[j].casemilestones[0].Targetdate.gettime()-datetime.now().gettime())))||(casedefaultlist[i].casemilestones.size()<casedefaultlist[j].casemilestones.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
}

}
}
}   

for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
            
}
     OwnerName = 'Owner Name';
        Severity='Case Severity';
        Priority='Priority';
        CreatedDate='Date/Time Opened';
        LastModifiedDate='Last Modified Date';
        Status='Status';
        Subject='Subject';
        CaseNumber='Case #';
        AccName='Account Name';
        PsftCaseId='Psft CaseId';
        CoreLicense = 'Core License';
         Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';

            }

           else if(sortcon=='psftcid')
        {
            system.debug('Manish Srivastava----------------------2');
            caseList.clear();
            if(PsftCaseId.contains('&uarr;'))            
            {
            for(Case cs : [SELECT c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.Account.Name,c.owner.id, c.CaseNumber,c.Owner.Name,c.CreatedDate,c.LastModifiedDate ,
c.Priority, c.Subject,c.Primary_Group_Name__c,  c.Status,c.case_age__c,  Case_Severity__c,  ContactId, OwnerId,c.Status_Number__c, c.Core_License__c FROM Case c  WHERE c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  ORDER By Psft_Case_Id__c Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
                
                caseList.add(cw);
                }
                PsftCaseId='Psft CaseId &darr;';                
            }

            else if(PsftCaseId.contains('&darr;'))
            {
            for(Case cs : [SELECT Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),Psft_Case_Id__c,account.name, CaseNumber, Subject,CreatedDate,LastModifiedDate,Priority, Status,Owner.Name,Owner.id, Core_License__c,case_age__c,  Case_Severity__c, Primary_Group_Name__c, ContactId, OwnerId,c.Status_Number__c FROM Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true  ORDER By Psft_Case_Id__c desc Limit 25]) {
                CaseWrapper cw=new CaseWrapper(cs);

                caseList.add(cw);
                }
                PsftCaseId='Psft CaseId &uarr;';
            }
            else
            {
                system.debug('Atul Singhal----------------------3');
                for(Case cs : [SELECT Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),Psft_Case_Id__c,account.name,owner.id,  CaseNumber,CreatedDate,LastModifiedDate,Priority,Owner.Name, Subject, Status, Case_Severity__c, Primary_Group_Name__c, ContactId, OwnerId,c.Status_Number__c, c.Core_License__c,c.case_age__c FROM Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true  ORDER By Psft_Case_Id__c Limit 100]) {
                    CaseWrapper cw=new CaseWrapper(cs);
                    
                    caseList.add(cw);
                }
                PsftCaseId='Psft CaseId &darr;';
            }
            OwnerName = 'Owner Name';
        Severity='Case Severity';
        Priority='Priority';
        CreatedDate='Date/Time Opened';
        LastModifiedDate='Last Modified Date';
        Status='Status';
        Subject='Subject';
        CaseNumber='Case #';
        AccName='Account Name';
        CoreLicense='Core License';
         Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
        }

            
  else if(sortcon=='cas')
        {
            system.debug('Atul Singhal----------------------2');
            caseList.clear();
            if(CaseNumber.contains('&uarr;'))            
            {
            for(Case cs : [SELECT c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.Account.Name,c.owner.id, c.CaseNumber,c.Owner.Name,c.CreatedDate,c.LastModifiedDate,c.case_age__c,
c.Priority, c.Subject,c.Primary_Group_Name__c,  c.Status,  Case_Severity__c,  ContactId, OwnerId,c.Status_Number__c, c.Core_License__c FROM Case c  WHERE c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  ORDER By casenumber Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
              
                caseList.add(cw);
                }
                CaseNumber='Case # &darr;';                
            }

            else if(CaseNumber.contains('&darr;'))
            {
            for(Case cs : [SELECT Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),Psft_Case_Id__c,account.name, CaseNumber, Subject,CreatedDate,LastModifiedDate,Priority, Status,Owner.Name,Owner.id,c.case_age__c,   Case_Severity__c, Primary_Group_Name__c, Core_License__c, ContactId, OwnerId,c.Status_Number__c FROM Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c AND c.IsClosed != true  ORDER By casenumber desc Limit 25]) {
                CaseWrapper cw=new CaseWrapper(cs);
          
                caseList.add(cw);
                }
                CaseNumber='Case # &uarr;';
            }
            else
            {
                system.debug('Atul Singhal----------------------3');
                for(Case cs : [SELECT Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),Psft_Case_Id__c,account.name,owner.id,  CaseNumber,CreatedDate,LastModifiedDate,Priority,Owner.Name, Subject, Status, Case_Severity__c, Primary_Group_Name__c, ContactId, OwnerId,c.Status_Number__c,c.Core_License__c,c.case_age__c FROM Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true  ORDER By casenumber Limit 100]) {
                    CaseWrapper cw=new CaseWrapper(cs);
                  
                    caseList.add(cw);
                }
                CaseNumber='Case # &darr;';
            }
            OwnerName = 'Owner Name';
        Severity='Case Severity';
        Priority='Priority';
        CreatedDate='Date/Time Opened';
        LastModifiedDate='Last Modified Date';
        Status='Status';
        Subject='Subject';
        //CaseNumber='Case #';
        AccName='Account Name';
        PsftCaseId='Psft CaseId';
        CoreLicense='Core License';
         Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';

        }
         else if(sortcon == 'acc'  )
        {
            caseList.clear();
            if(OwnerName.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,account.name,c.owner.id, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Core_License__c, c.Case_Severity__c,c.casenumber,c.Priority,c.Primary_Group_Name__c,  c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true order by owner.Name Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
             
                caseList.add(cw);
            }


                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Owner.Name Limit 100];
                OwnerName= 'Owner Name &darr;';
            }

            else if(OwnerName.contains('&darr;'))
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,c.Owner.id,  c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Core_License__c, c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true order by Owner.Name desc Limit 100]) {
               CaseWrapper cw=new CaseWrapper(cs);
              
                caseList.add(cw);
                }


                //caseList =[select Id,Psft_Case_Id__c,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Owner.Name desc Limit 100];
                OwnerName= 'Owner Name &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.Primary_Group_Name__c,c.owner.id, c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Core_License__c, c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true order by Owner.Name Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
             
                caseList.add(cw);
                }


                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Owner.Name Limit 100];
                OwnerName= 'Owner Name &darr;';

                
                
            }
            AccName='Account Name';
            PsftCaseId='Psft CaseId';

            //OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
             LastModifiedDate='Last Modified Date';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            CoreLicense='Core License';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
        }  
        else if(sortcon=='acn')
        {
            caseList.clear();
            if(AccName.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.Primary_Group_Name__c,c.Owner.id, c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c,c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true ORDER By c.account.name Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
              
                caseList.add(cw);
            }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,LastModifiedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Case_Severity__c Limit 100];
              AccName  = 'Account Name &darr;';                
            }

            else if(AccName.contains('&darr;'))
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,c.Owner.id,  c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c,c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c  and  c.IsClosed != true ORDER By c.account.name desc Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
           
                caseList.add(cw);
            }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Case_Severity__c desc Limit 100];
                AccName  = 'Account Name &uarr;';
            }
            else
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,c.Owner.id,  c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c,c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true ORDER By c.account.name Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
            
                caseList.add(cw);
            }


                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Case_Severity__c Limit 100];
                AccName  = 'Account Name &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
              LastModifiedDate='Last Modified Date';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            //AccName='Account Name';
            PsftCaseId='Psft CaseId';
            CoreLicense='Core License';
 Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
            }

        
         

          
        else if(sortcon=='sev')
        {
            caseList.clear();
            if(Severity.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name,c.Primary_Group_Name__c,c.Owner.id,  c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c,c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true ORDER By Case_Severity__c Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
          
                caseList.add(cw);
            }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,LastModifiedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Case_Severity__c Limit 100];
                Severity= 'Case Severity &darr;';                
            }

            else if(Severity.contains('&darr;'))
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.Name,c.Owner.id, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true ORDER By Case_Severity__c desc Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
           
                caseList.add(cw);
            }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Case_Severity__c desc Limit 100];
                Severity= 'Case Severity &uarr;';
            }
            else
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.Owner.id, c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true ORDER By Case_Severity__c Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
              
                caseList.add(cw);
            }


                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Case_Severity__c Limit 100];
                Severity= 'Case Severity &darr;';
            }
            OwnerName = 'Owner Name';
            //Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            LastModifiedDate='Last Modified Date';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            AccName='Account Name';
            PsftCaseId='Psft CaseId';
            CoreLicense='Core License';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';

            }
       
        else if(sortcon=='crdt')
        {
            caseList.clear();
            if(CreatedDate.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.Name, c.Owner.id, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority, c.Status_Number__c,c.case_age__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true  ORDER By CreatedDate Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
        
                caseList.add(cw);
                }

                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By CreatedDate Limit 100];
                CreatedDate='Date/Time Opened &darr;';                
            }

            else if(CreatedDate.contains('&darr;'))
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Owner.id,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true  ORDER By CreatedDate desc Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
              
                caseList.add(cw);
                }

                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,LastModifiedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By CreatedDate desc Limit 100];
                CreatedDate='Date/Time Opened &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,c.subject,c.Owner.Name, c.status,c.owner.id,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true  ORDER By Priority Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
              
                caseList.add(cw);
                }

                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By CreatedDate Limit 100];
                CreatedDate='Date/Time Opened &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            //CreatedDate='Date/Time Opened';
              LastModifiedDate='Last Modified Date';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            AccName='Account Name';
            PsftCaseId='Psft CaseId';
            CoreLicense='Core License';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';


        }
        else if(sortcon=='lmdt')
        {
        system.debug('-----------manish sortcon crdt---------------' + sortcon);
            caseList.clear();
            if( LastModifiedDate.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c  and  c.IsClosed != true  ORDER By LastModifiedDate desc Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
           

                caseList.add(cw);
                }

                
               LastModifiedDate ='Last Modified Date &darr;';                
            }

            else if(LastModifiedDate.contains('&darr;'))
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true  ORDER By LastModifiedDate asc Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
             

                caseList.add(cw);
                }

                 LastModifiedDate='Last Modified Date &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c  and  c.IsClosed != true  ORDER By LastModifiedDate desc Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
            

                caseList.add(cw);
                }

                 LastModifiedDate='Last Modified Date &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            AccName='Account Name';
            PsftCaseId='Psft CaseId';
            CoreLicense='Core License';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';

        }


        else if(sortcon=='sta')
        {
            caseList.clear();
            if(Status.contains('&uarr;'))            
            {
                 for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c , c.subject,c.Owner.Name, c.status,c.Owner.id,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c,c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  ORDER By Status Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
       
                caseList.add(cw);
                }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Status Limit 100];
                Status='Status &darr;';                
            }

            else if(Status.contains('&darr;'))
            {
                 for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.Name, c.status, c.Owner.id,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  ORDER By Status desc Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
    
                caseList.add(cw);
                }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,LastModifiedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Status desc Limit 100];
                Status='Status &uarr;';
            }
            else
            {
                 for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.Owner.id,c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  ORDER By Status Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
    
                caseList.add(cw);
                }


                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Status Limit 100];
                Status='Status &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
             LastModifiedDate='Last Modified Date';
            //Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            AccName='Account Name';
            PsftCaseId='Psft CaseId';
            CoreLicense='Core License';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';


        }
        else if(sortcon=='sub')
        {
            caseList.clear();
            if(Subject.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c,c.Owner.id,c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  ORDER By subject Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
         
                caseList.add(cw);
                }


               // caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By subject Limit 100];
                Subject='Subject &darr;';                
            }

            else if(Subject.contains('&darr;'))
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.id,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  ORDER By subject desc Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
            
                caseList.add(cw);
                }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By subject desc Limit 100];
                Subject='Subject &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name,c.Primary_Group_Name__c,c.Owner.id,  c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.Core_License__c, c.casenumber,c.Priority,c.case_age__c, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  ORDER By subject Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
             
                caseList.add(cw);
                }


                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By subject Limit 100];
                Subject='Subject &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
             LastModifiedDate='Last Modified Date';
            Status='Status';
            //Subject='Subject';
            CaseNumber='Case #';
            AccName='Account Name';
            PsftCaseId='Psft CaseId';
            CoreLicense='Core License';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';


        }
       /* else if(sortcon=='cas')
        {
            caseList.clear();
            if(CaseNumber.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,c.account.name, c.subject,c.Owner.Name,c.Primary_Group_Name__c,  c.status,c.CreatedDate,c.Case_Severity__c,c.Owner.id,c.casenumber,c.Priority, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c AND c.Primary_Group_Name__c  = :curUser.Primary_Group__c and c.IsClosed != true  ORDER By casenumber Limit 100]) {
                CaseWrapper cw=new CaseWrapper();
              cw.a=cs;
                caseList.add(cw);
                }


               // caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                CaseNumber='Case # &darr;';                
            }

            else if(CaseNumber.contains('&darr;'))
            {
            for(Case cs : [select c.Id,c.account.name, c.subject,c.Owner.Name,c.Owner.id,c.Primary_Group_Name__c,  c.status,c.CreatedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c AND c.Primary_Group_Name__c  = :curUser.Primary_Group__c and c.IsClosed != true  ORDER By casenumber desc Limit 100]) {
                CaseWrapper cw=new CaseWrapper();
              cw.a=cs;
                caseList.add(cw);
                }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                CaseNumber='Case # &uarr;';
            }
            else
            {
            for(Case cs : [select c.Id,c.account.name,c.Primary_Group_Name__c,  c.subject,c.Owner.Name, c.status,c.Owner.id,c.CreatedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c AND c.Primary_Group_Name__c  = :curUser.Primary_Group__c and c.IsClosed != true  ORDER By casenumber Limit 100]) {
                CaseWrapper cw=new CaseWrapper();
              cw.a=cs;
                caseList.add(cw);
                }


                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                CaseNumber='Case # &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccName='Account Name';

        }*/
 
 
  else if(sortcon=='age')
 {
           caseList.clear();
            if(Age.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where  c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true ORDER By Case_Age__c Limit 100]) {
               CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
                }

 Age='Age &darr;';                
            }

            else if(Age.contains('&darr;'))
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Core_License__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true  ORDER By Case_Age__c desc Limit 100]) {
                CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
                }


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                Age='Age &uarr;';
            }
            else
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Core_License__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and  c.IsClosed != true ORDER By Case_Age__c Limit 100]) {
             
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);

   
                }


                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                Age='Age &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';       
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
CaseNumber='Case #';

 }   
 else if(sortcon=='sla')
 {
  caseList.clear();
            if(SLA_Expiry_time.contains('&uarr;'))            
            {
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where   c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].SLA_Expiry_Time__c < casedefaultlist[j].responsiveness__r[0].SLA_Expiry_Time__c))||(casedefaultlist[i].responsiveness__r.size()<casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   


 SLA_Expiry_time='SLA Expiry Time &darr;';                
            }

            else if(SLA_Expiry_time.contains('&darr;'))
            {
                      list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where   c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].SLA_Expiry_Time__c > casedefaultlist[j].responsiveness__r[0].SLA_Expiry_Time__c))||(casedefaultlist[i].responsiveness__r.size()>casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                SLA_Expiry_time='SLA Expiry Time &uarr;';
            }
            else
            {
                    list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where   c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].SLA_Expiry_Time__c < casedefaultlist[j].responsiveness__r[0].SLA_Expiry_Time__c))||(casedefaultlist[i].responsiveness__r.size()<casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   

                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                SLA_Expiry_time='SLA Expiry Time &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';       
Age='Age';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
CaseNumber='Case #';
 
 
 
 } 
 
 
 
 else if(sortcon=='tsla')
 {
  caseList.clear();
            if(Time_left_for_SLA_Expiry.contains('&uarr;'))            
            {
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where   c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if(((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[i].responsiveness__r.size() == casedefaultlist[j].responsiveness__r.size()))&&(casedefaultlist[i].responsiveness__r[0].Time_left_for_SLA_Expiry__c < casedefaultlist[j].responsiveness__r[0].Time_left_for_SLA_Expiry__c))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   


 Time_left_for_SLA_Expiry='Time Left for SLA Expiry &darr;';                
            }

            else if(Time_left_for_SLA_Expiry.contains('&darr;'))
            {
                      list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where  c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if(((casedefaultlist[j].responsiveness__r.size()>0) &&(casedefaultlist[i].responsiveness__r.size() == casedefaultlist[j].responsiveness__r.size()))&&(casedefaultlist[i].responsiveness__r[0].Time_left_for_SLA_Expiry__c > casedefaultlist[j].responsiveness__r[0].Time_left_for_SLA_Expiry__c))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
  for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                Time_left_for_SLA_Expiry='Time Left for SLA Expiry &uarr;';
            }
            else
            {
                    list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].SLA_Expiry_Time__c < casedefaultlist[j].responsiveness__r[0].SLA_Expiry_Time__c))||(casedefaultlist[i].responsiveness__r.size()<casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
  for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   

                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                Time_left_for_SLA_Expiry='Time Left for SLA Expiry &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';       
Age='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
CaseNumber='Case #';
 
 
 
 } 
 else if(sortcon=='evt')
 {
 caseList.clear();
            if(Event_Type.contains('&uarr;'))            
            {
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where  c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].Start_Event__c < casedefaultlist[j].responsiveness__r[0].Start_Event__c))||(casedefaultlist[i].responsiveness__r.size()<casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   


 Event_Type='Event Type &darr;';                
            }

            else if(Event_Type.contains('&darr;'))
            {
                      list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where  c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].Start_Event__c > casedefaultlist[j].responsiveness__r[0].Start_Event__c))||(casedefaultlist[i].responsiveness__r.size()>casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   


                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                Event_Type='Event Type &uarr;';
            }
            else
            {
                    list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where  c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].Start_Event__c < casedefaultlist[j].responsiveness__r[0].Start_Event__c))||(casedefaultlist[i].responsiveness__r.size()<casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   

                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                Event_Type='Event Type &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';       
Age='Age';
 SLA_Expiry_time='SLA Expiry Time';
Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 CLAtime='Closure/Escalate Time Remaining';
CaseNumber='Case #';
 
           
 }    
 else if(sortcon=='cla')
 {
  caseList.clear();
            if(CLAtime.contains('&uarr;'))            
            {
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where   c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if(((casedefaultlist[i].casemilestones.size()>0)&& ( casedefaultlist[j].casemilestones.size()>0))&&((casedefaultlist[i].casemilestones[0].Targetdate.gettime()- datetime.now().gettime()) > (casedefaultlist[j].casemilestones[0].Targetdate.gettime()-datetime.now().gettime())))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
else if(casedefaultlist[i].casemilestones.size()>casedefaultlist[j].casemilestones.size())
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   


CLAtime='Closure/Escalate Time Remaining &darr;';                
            }

            else if(CLAtime.contains('&darr;'))
            {
                      list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where   c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if(((casedefaultlist[i].casemilestones.size()>0)&& ( casedefaultlist[j].casemilestones.size()>0))&&((casedefaultlist[i].casemilestones[0].Targetdate.gettime()- datetime.now().gettime()) < (casedefaultlist[j].casemilestones[0].Targetdate.gettime()-datetime.now().gettime())))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
else if(casedefaultlist[i].casemilestones.size()<casedefaultlist[j].casemilestones.size())
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   

                //caseList =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
               CLAtime='Closure/Escalate Time Remaining &uarr;';
            }
            else
            {
                    list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Core_License__c  from Case c  where   c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true  Limit 100];

for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{

if(((casedefaultlist[i].casemilestones.size()>0)&& ( casedefaultlist[j].casemilestones.size()>0))&&((casedefaultlist[i].casemilestones[0].Targetdate.gettime()- datetime.now().gettime()) > (casedefaultlist[j].casemilestones[0].Targetdate.gettime()-datetime.now().gettime())))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
else if(casedefaultlist[i].casemilestones.size()>casedefaultlist[j].casemilestones.size())
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}

}
}
 for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
   

                //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                CLAtime='Closure/Escalate Time Remaining &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';       
Age='Age';
 SLA_Expiry_time='SLA Expiry Time';
Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
CaseNumber='Case #';
 
 
 }   
        
        else{
         system.debug('manish----------------------1'+sortcon);
        caseList.clear();
        for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.Account.Name,c.subject,c.Primary_Group_Name__c, c.Owner.Name, c.status,c.Owner.id,c.CreatedDate,c.LastModifiedDate,c.Case_Age__c,c.Case_Severity__c,c.Core_License__c,c.casenumber,c.Priority, c.Status_Number__c  from Case c  WHERE c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true order by c.Case_Severity__c,c.Status_Number__c,c.createddate Limit 100]) {
                CaseWrapper cw=new CaseWrapper(cs);
   
                caseList.add(cw);
            }

OwnerName = 'Owner Name';
        Severity='Case Severity';
        Priority='Priority';
        CreatedDate='Date/Time Opened';
         LastModifiedDate='Last Modified Date';
        Status='Status';
        Subject='Subject';
        CaseNumber='Case #';
        AccName='Account Name';
        PsftCaseId='Psft CaseId';
        CoreLicense='Core License';

           //caseList =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Owner.Name Limit 100];            
        }
         return null;
    }
    public void buildCaseSelectList(){
    curUser=[select id,Primary_Group__c from User where Id = :userInfo.getUserId()]; /* 'shirish.barsainya1@wipro.com']; */
        //caseList.clear();
        curUserPrimaryGroup=curUser.Primary_Group__c;
        statusList=new list<string>();
        statusList.add('Open - New');
        statusList.add('Open - Assigned');
        statusList.add('Open - Escalating');
        statusList.add('Open - Pend Dev');
        statusList.add('Open - On Hold');
        statusList.add('Open – Needs Attention');
        statusList.add('Open - Researching');
        statusList.add('Open - Chg Request');
        statusList.add('Open - PendChRq');
        statusList.add('Open - Pending User');
        /*Build a simple list of cases that user can select from. We need to use
        a wrapper class here so we can track what cases are selected */
        caseList = new List<CaseWrapper>();
       list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r where Stop_Time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated ,c.Core_License__c from Case c  where    c.Owner.Id != : userinfo.getUserID() and c.owner.name=:curUser.Primary_Group__c and c.IsClosed != true order by c.Case_Severity__c,c.Status_priority__c,c.lastmodifieddate,c.createddate Limit 100];


for(integer i = 0;i < casedefaultlist.size() ; i++)
{
for(integer j = i+1 ;j < casedefaultlist.size();j++)
{
if((casedefaultlist[i].Case_Severity__c == casedefaultlist[j].Case_Severity__c) &&(casedefaultlist[i].Status_priority__c == casedefaultlist[j].Status_priority__c) && (casedefaultlist[i].lastmodifieddate == casedefaultlist[j].lastmodifieddate))
{

if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[j].responsiveness__r.size()>0))&&(casedefaultlist[i].responsiveness__r[0].SLA_Expiry_Time__c < casedefaultlist[j].responsiveness__r[0].SLA_Expiry_Time__c))||(casedefaultlist[i].responsiveness__r.size()<casedefaultlist[j].responsiveness__r.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
else if((((casedefaultlist[i].responsiveness__r.size()>0) &&(casedefaultlist[i].responsiveness__r.size() == casedefaultlist[j].responsiveness__r.size()))&&(casedefaultlist[i].responsiveness__r[0].SLA_Expiry_Time__c == casedefaultlist[j].responsiveness__r[0].SLA_Expiry_Time__c))||(casedefaultlist[i].responsiveness__r.size()==casedefaultlist[j].responsiveness__r.size()))
{
if((((casedefaultlist[i].casemilestones.size()>0)&& ( casedefaultlist[j].casemilestones.size()>0))&&((casedefaultlist[i].casemilestones[0].Targetdate.gettime()- datetime.now().gettime()) < (casedefaultlist[j].casemilestones[0].Targetdate.gettime()-datetime.now().gettime())))||(casedefaultlist[i].casemilestones.size()<casedefaultlist[j].casemilestones.size()))
{
case c  = casedefaultlist[i];
casedefaultlist[i]=casedefaultlist[j];
casedefaultlist[j]= c;
}
}

}
}
}   

for(case cs : casedefaultlist)
{
 CaseWrapper aw = new CaseWrapper(cs);
           
            caseList.add(aw);
}
            
            
            
           
            system.debug('--build case--');
        }
    
 
    public void addSelectedCases() {
       // User curUser=[select id,Primary_Group__c from User where Id = :userInfo.getUserId()];
       List<CaseWrapper>  newList = new List<CaseWrapper>();
 //caseList.Clear();
        //Loop through the list of cases to see if any are selected
        system.debug('-manish srivastava----1');
            // List <case> try=new List<case>();
            integer flag=0;
            for(CaseWrapper aw : caseList){
            if(aw.selected == true){           
                aw.a.ownerid=UserInfo.getUserId();  
                update aw.a; 
                flag=1;
                                            }
            //newList.add(aw);
                                   
        }
        //Re-set case list so selected cases are not displayed in list
        if(flag==1)
        {
        caseList.Clear();
                buildCaseSelectList();
                }

       // caseList = newList;
        system.debug('-manish srivastava----4');
    }
 
    /*This is a wrapper class, it basically combines a boolean value which is linked to  a
    checkbox on the page, and a case.*/
    public class CaseWrapper{
        public Case a {get; set;}
        public Boolean selected {get; set;}
        public integer   timeremain{get;set;}
       public string SLAdatetime{get;set;}
       public string background{get;set;}
  public CaseWrapper(case c)
  {
  a=c;
  if(c.responsiveness__r.size()>0)
  {
  		if(c.responsiveness__r[0].SLA_Expiry_Time__c != null)
  SLAdatetime =c.responsiveness__r[0].SLA_Expiry_Time__c.format(); 
  }
  if(c.casemilestones.size()>0)
  {
  timeremain = (integer)((c.casemilestones[0].targetdate.gettime() - datetime.now().gettime() )/(60.0*60.0*1000.0));
  }
  if(c.Case_Severity__c=='1')
  {
  	background='/img/samples/flag_red.gif';
  }
  else if(c.Case_Severity__c=='2')
  {
  	background='/img/samples/flag_yellow.gif';
  }
  else
  {
  	background='';
  }
  }
    }
}