public  class BBW_CaseList{ 
   public list<casetimewrapper> orgsortlist{get;set;}
public list<string> statusList{get; set;}
  public User curUser{get;set;}  
  
  
        public String OwnerName{get;set;}
        public String Severity{get;set;}
        public String Priority{get;set;}
        public String CreatedDate{get;set;}
        public String LastModifiedDate{get;set;}
        public String Status{get;set;}
        public String Subject{get;set;}
        public String CaseNumber{get;set;}
        public String AccountName{get;set;}
        public String TimeOpen{get;set;}
        public String sortcon;
        public string PsftCaseId{get;set;}
  public string Age{get;set;}
public string SLA_Expiry_time{get;set;}
public string Time_left_for_SLA_Expiry{get;set;}
public string Event_Type{get;set;}
public string CLAtime{get;set;}
string sortorder{get;set;}    
  //////////////////////// 
  public class casetimewrapper
  {
  public case ca{get;set;}
  public integer timeremain{get;set;}
  public string SLAdatetime{get;set;}
  public string background{get;set;}
  public casetimewrapper(case c)
  {
    
  ca=c;
  if(c.responsiveness__r.size()>0)
  {
    if(c.responsiveness__r[0].SLA_Expiry_Time__c != null)
  SLAdatetime =c.responsiveness__r[0].SLA_Expiry_Time__c.format(); 
  }
  if(c.casemilestones.size()>0)
  {
  timeremain = (integer)((c.casemilestones[0].targetdate.gettime() - datetime.now().gettime() )/(60.0*60.0*1000.0));
  }
  if(ca.Case_Severity__c=='1')
  {
    background='/img/samples/flag_red.gif';
  }
  else if(ca.Case_Severity__c=='2')
  {
    background='/img/samples/flag_yellow.gif';
  }
  else
  {
    background='';
  }
  }
  }
  
 /////////////////// 
 map<id,milestonetype>milestonemap = new  map<id,milestonetype>([select id,name from milestonetype where name like '%Closure%']);  
    public  BBW_CaseList(ApexPages.StandardSetController controller) {
    orgsortlist = new List<casetimewrapper>();
    system.debug('----constructor sortcon1-------'+sortcon);
    orgsortlist.clear();
     
        OwnerName = 'Owner Name';
        Severity='Case Severity';
        Priority='Priority';
        CreatedDate='Date/Time Opened';
        LastModifiedDate='Last Modified Date';
        Status='Status';
        Subject='Subject';
        CaseNumber='Case #';
        AccountName='Account Name';
        PsftCaseId='Psft CaseId';
  Age ='Age';
  TimeOpen = 'Time Open';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
        curUser=[select id,Primary_Group__c from User where Id = :userInfo.getUserId()]; /* 'shirish.barsainya1@wipro.com']; */
     
            
            
/*statusList=new list<string>();
statusList.add('Open - New');
statusList.add('Open - Assigned');
statusList.add('Open - Escalating');
statusList.add('Open - Pend Dev');
statusList.add('Open - On Hold');
statusList.add('Open – Needs Attention');
statusList.add('Open - Researching');
statusList.add('Open - Chg Request');
statusList.add('Open - PendChRq');
statusList.add('Open - Pending User');*/
//integer i=0;
list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.Time_Open__c,c.IsEscalated  from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false order by c.Case_Severity__c,c.Status_priority__c,c.lastmodifieddate desc,c.createddate Limit 100];
/*for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c  from Case c  where   c.owner.id=:userInfo.getUserId()  c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null  and   c.IsClosed = false order by c.Case_Severity__c,c.Status_priority__c,c.lastmodifieddate,c.createddate Limit 100]) {
                orgsortlist.add(cs);
            } */

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

for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}
        system.debug('----constructor sortcon1-------'+sortcon);
            }  



         
   /*
public List<Case> getCases() {
  return orgsortlist;
}            
public void setCases(List<Case> orgsortlist){
this.orgsortlist=orgsortlist;
}*/
          
        public Pagereference updatelist(){
        system.debug('-----------Atul--------------First');
        curUser=[select id,Primary_Group__c from User where Id = :userInfo.getUserId()]; /* 'shirish.barsainya1@wipro.com']; */
     
            orgsortlist.clear();
            
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
          system.debug('sortorder---'+sortorder);     
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
                AccountName=AccountName.contains('&uarr;')?AccountName.replace('&uarr;','&darr;'):AccountName.replace('&darr;','&uarr;');
                LastModifiedDate=LastModifiedDate.contains('&uarr;')?LastModifiedDate.replace('&uarr;','&darr;'):LastModifiedDate.replace('&darr;','&uarr;');
                PsftCaseId=PsftCaseId.contains('&uarr;')?PsftCaseId.replace('&uarr;','&darr;'):PsftCaseId.replace('&darr;','&uarr;');
                TimeOpen=TimeOpen.contains('&uarr;')?TimeOpen.replace('&uarr;','&darr;'):TimeOpen.replace('&darr;','&uarr;');
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
      system.debug('sort---'+sortcon+' '+sortorder);     
        system.debug('-----------Atul---------------' + sortcon);
        //if(sortcon == null)
            //sortcon = 'on';
            if(sortcon=='def')
            {
             system.debug('-----------manish sortcon def---------------' + sortcon);
            orgsortlist.clear();
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false order by c.Case_Severity__c,c.Status_priority__c,c.lastmodifieddate,c.createddate Limit 100];
/*for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated  from Case c  where   c.owner.id=:userInfo.getUserId()  c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null  and   c.IsClosed = false order by c.Case_Severity__c,c.Status_priority__c,c.lastmodifieddate,c.createddate Limit 100]) {
                orgsortlist.add(cs);
            } */

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

for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}

            PsftCaseId='Psft CaseId';

             OwnerName = 'Owner Name';
        Severity='Case Severity';
        Priority='Priority';
        CreatedDate='Date/Time Opened';
        LastModifiedDate='Last Modified Date';
        Status='Status';
        Subject='Subject';
        CaseNumber='Case #';
        AccountName='Account Name';
          Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
            
            }
            else if(sortcon == 'psftcid'  )
        {
        system.debug('-----------manish sortcon acc---------------' + sortcon);
            orgsortlist.clear();
            if(PsftCaseId.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Time_Open__c  from Case c  where  c.owner.id=:userInfo.getUserId()  /*c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null  and  c.Status in : statusList */  and  c.IsClosed = false order by Psft_Case_Id__c Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
            }


                
                PsftCaseId= 'Psft CaseId &darr;';
            }

            else if(PsftCaseId.contains('&darr;'))
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where  c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */  and  c.IsClosed = false order by Psft_Case_Id__c desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                
                PsftCaseId= 'Psft CaseId &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false  order by Psft_Case_Id__c Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                
                PsftCaseId= 'Psft CaseId &darr;';

                
                
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            LastModifiedDate='Last Modified Date';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            AccountName='Account Name';
              Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
        
            }   
            
            
              
        else if(sortcon == 'acc'  )
        {
        system.debug('-----------manish sortcon acc---------------' + sortcon);
            orgsortlist.clear();
            if(OwnerName.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where  c.owner.id=:userInfo.getUserId()  /*c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null  and  c.Status in : statusList */  and  c.IsClosed = false order by Owner.Name Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
            }


                
                OwnerName= 'Owner Name &darr;';
            }

            else if(OwnerName.contains('&darr;'))
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c ,Case_Age__c,IsEscalated, c.Time_Open__c from Case c  where  c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */  and  c.IsClosed = false order by Owner.Name desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                
                OwnerName= 'Owner Name &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false  order by Owner.Name Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                
                OwnerName= 'Owner Name &darr;';

                
                
            }
            //OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            LastModifiedDate='Last Modified Date';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            AccountName='Account Name';
            PsftCaseId='Psft CaseId';
              Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';

        
            }   
        else if(sortcon=='sev')
        {
        system.debug('-----------manish sortcon sev---------------' + sortcon);
            orgsortlist.clear();
            if(Severity.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c, c.subject,c.account.name,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where  owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and  /* c.Case_Severity__c!=null */  and  c.IsClosed = false ORDER By Case_Severity__c Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
            }


                //orgsortlist =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Case_Severity__c Limit 100];
                Severity= 'Case Severity &darr;';                
            }

            else if(Severity.contains('&darr;'))
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.account.name,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where   owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false  ORDER By Case_Severity__c desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
            }


                
                Severity= 'Case Severity &uarr;';
            }
            else
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.account.name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c   from Case c  where  c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false   ORDER By Case_Severity__c Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
            }


                
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
            AccountName='Account Name';
            PsftCaseId='Psft CaseId';
              Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';


        }
        else if(sortcon=='acn')
        {
        system.debug('-----------manish sortcon acn---------------' + sortcon);
            orgsortlist.clear();
            if(AccountName.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By c.account.name Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }
                
                AccountName='Account Name &darr;';                
            }
            else if(AccountName.contains('&darr;'))
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By c.account.name desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                
                AccountName='Account Name &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Time_Open__c    from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By c.account.name Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }

                
                AccountName='Account Name &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            //Priority='Priority';
            CreatedDate='Date/Time Opened';
            LastModifiedDate='Last Modified Date';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            //AccountName='Account Name';
            PsftCaseId='Psft CaseId';
  Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';

            
        }
        else if(sortcon=='crdt')
        {
        system.debug('-----------manish sortcon crdt---------------' + sortcon);
            orgsortlist.clear();
            if(CreatedDate.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false   ORDER By CreatedDate Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }

                
                CreatedDate='Date/Time Opened &darr;';                
            }

            else if(CreatedDate.contains('&darr;'))
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,  c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By CreatedDate desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }

                 CreatedDate='Date/Time Opened &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false   ORDER By CreatedDate Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }

                 CreatedDate='Date/Time Opened &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            //CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            AccountName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';
              Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';


        }
        
        else if(sortcon=='lmdt')
        {
        system.debug('-----------manish sortcon crdt---------------' + sortcon);
            orgsortlist.clear();
            if( LastModifiedDate.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,  c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false   ORDER By LastModifiedDate desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }

                
               LastModifiedDate ='Last Modified Date &darr;';                
            }

            else if(LastModifiedDate.contains('&darr;'))
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,  c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By LastModifiedDate asc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }

                 LastModifiedDate='Last Modified Date &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,  c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By LastModifiedDate desc  Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
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
            AccountName='Account Name';
            PsftCaseId='Psft CaseId';
               Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';

        }

        else if(sortcon=='sta')
        {
        system.debug('-----------manish sortcon sta---------------' + sortcon);
            orgsortlist.clear();
            if(Status.contains('&uarr;'))            
            {
                 for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */  and  c.IsClosed = false ORDER By Status Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                  Status='Status &darr;';                
            }

            else if(Status.contains('&darr;'))
            {
                 for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By Status desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                 Status='Status &uarr;';
            }
            else
            {
                 for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Time_Open__c     from Case c  where  c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By Status Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


               Status='Status &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            //Status='Status';
            Subject='Subject';
            CaseNumber='Case #';
            AccountName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';


        }
        else if(sortcon=='sub')
        {
        system.debug('-----------manish sortcon sub---------------' + sortcon);
            orgsortlist.clear();
            if(Subject.contains('&uarr;'))            
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,  c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By subject Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


               Subject='Subject &darr;';                
            }

            else if(Subject.contains('&darr;'))
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,  c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By subject desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                  Subject='Subject &uarr;';
            }
            else
            {
                for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.account.name,c.Psft_Case_Id__c, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Time_Open__c     from Case c  where c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By subject Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                Subject='Subject &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            //Subject='Subject';
            CaseNumber='Case #';
            AccountName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';


        }
        else if(sortcon=='cas')
        {
        system.debug('-----------manish sortcon cas---------------' + sortcon);
            orgsortlist.clear();
            if(CaseNumber.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Time_Open__c     from Case c  where  c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By casenumber Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }

 CaseNumber='Case # &darr;';                
            }

            else if(CaseNumber.contains('&darr;'))
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Time_Open__c     from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false  ORDER By casenumber desc Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                //orgsortlist =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                CaseNumber='Case # &uarr;';
            }
            else
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated,c.Time_Open__c     from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By casenumber Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                //orgsortlist =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                CaseNumber='Case # &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccountName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';
             Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';


        }
        
        
 /* mmelse if(sortcon=='age')
 {
           orgsortlist.clear();
            if(Age.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Case_Age__c,c.IsEscalated  from Case c  where  c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ /* mm and  c.IsClosed = false ORDER By Case_Age__c Limit 100]) { mm */
       //m         orgsortlist.add(new casetimewrapper(cs));
       //m         }

 //m Age='Age &darr;';                
    //m        }

    //m        else if(Age.contains('&darr;'))
    //m        {
     //m       for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false  ORDER By Case_Age__c desc Limit 100]) {
       //m         orgsortlist.add(new casetimewrapper(cs));
               //m } mm */

                //orgsortlist =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
     //m           Age='Age &uarr;';
        //m    }
       //m     else
        //m    {
         //m   for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By Case_Age__c Limit 100]) {
          //m      orgsortlist.add(new casetimewrapper(cs));
          //m      }


                //orgsortlist =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
//m               Age='Age &darr;';
//m            }
/* mm            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccountName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId'; mm */       
//m SLA_Expiry_time='SLA Expiry Time';
//m Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
//m Event_Type='Event Type';
//m CLAtime='Closure/Escalate Time Remaining';
//m CaseNumber='Case #';

//m }  
 
else if(sortcon=='tim')
 {
           orgsortlist.clear();
            if(TimeOpen.contains('&uarr;'))            
            {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Case_Age__c,c.IsEscalated, c.Time_Open__c  from Case c  where  c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By Case_Age__c Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }

 TimeOpen='Time Open &darr;';                
           }

            else if(TimeOpen.contains('&darr;'))
           {
            for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and /*  c.Case_Severity__c!=null */ and  c.IsClosed = false  ORDER By Case_Age__c desc Limit 100]) {
               orgsortlist.add(new casetimewrapper(cs));
                } 

                //orgsortlist =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
               Age='Age &uarr;';
            }
            else
           {
         for(Case cs : [select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1),c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,Case_Age__c,IsEscalated, c.Time_Open__c  from Case c  where c.owner.id=:userInfo.getUserId() /*  c.Primary_Group_Name__c=:curUser.Primary_Group__c and   c.Case_Severity__c!=null */ and  c.IsClosed = false ORDER By Case_Age__c Limit 100]) {
                orgsortlist.add(new casetimewrapper(cs));
                }


                //orgsortlist =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
               TimeOpen='Time Open &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccountName='Account Name';
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
  orgsortlist.clear();
            if(SLA_Expiry_time.contains('&uarr;'))            
            {
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c     from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}


 SLA_Expiry_time='SLA Expiry Time &darr;';                
            }

            else if(SLA_Expiry_time.contains('&darr;'))
            {
                      list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c     from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}


                //orgsortlist =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                SLA_Expiry_time='SLA Expiry Time &uarr;';
            }
            else
            {
                    list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c     from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}

                //orgsortlist =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                SLA_Expiry_time='SLA Expiry Time &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccountName='Account Name';
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
  orgsortlist.clear();
            if(Time_left_for_SLA_Expiry.contains('&uarr;'))            
            {
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c     from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}


 Time_left_for_SLA_Expiry='Time Left for SLA Expiry &darr;';                
            }

            else if(Time_left_for_SLA_Expiry.contains('&darr;'))
            {
                      list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c     from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}


                //orgsortlist =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                Time_left_for_SLA_Expiry='Time Left for SLA Expiry &uarr;';
            }
            else
            {
                    list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c    from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}

                //orgsortlist =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                Time_left_for_SLA_Expiry='Time Left for SLA Expiry &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccountName='Account Name';
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
 orgsortlist.clear();
            if(Event_Type.contains('&uarr;'))            
            {
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c     from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}


 Event_Type='Event Type &darr;';                
            }

            else if(Event_Type.contains('&darr;'))
            {
                      list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated,c.Time_Open__c     from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}


                //orgsortlist =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
                Event_Type='Event Type &uarr;';
            }
            else
            {
                    list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated, c.Time_Open__c  from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}

                //orgsortlist =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                Event_Type='Event Type &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccountName='Account Name';
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
  orgsortlist.clear();
            if(CLAtime.contains('&uarr;'))            
            {
           list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated, c.Time_Open__c  from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}


CLAtime='Closure/Escalate Time Remaining &darr;';                
            }

            else if(CLAtime.contains('&darr;'))
            {
                      list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated, c.Time_Open__c  from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}


                //orgsortlist =[select Id,RecordType.Name, subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber desc Limit 100];
               CLAtime='Closure/Escalate Time Remaining &uarr;';
            }
            else
            {
                    list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated, c.Time_Open__c  from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false  Limit 100];

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
  for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}

                //orgsortlist =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By casenumber Limit 100];
                CLAtime='Closure/Escalate Time Remaining &darr;';
            }
            OwnerName = 'Owner Name';
            Severity='Case Severity';
            Priority='Priority';
            CreatedDate='Date/Time Opened';
            Status='Status';
            Subject='Subject';
            AccountName='Account Name';
            LastModifiedDate='Last Modified Date';
            PsftCaseId='Psft CaseId';       
Age='Age';
 SLA_Expiry_time='SLA Expiry Time';
Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
CaseNumber='Case #';
 
 
 }   
   else
        {
        orgsortlist.clear();
 list<case> casedefaultlist=[select c.Id,(select id,SLA_Expiry_Time__c,Time_left_for_SLA_Expiry__c,Start_Event__c from Responsiveness__r  where stop_time__c = null limit 1),(select id,TargetResponseInHrs,TargetDate from case.casemilestones where MilestoneTypeId in :milestonemap.keyset() and IsCompleted=false  limit 1), c.Psft_Case_Id__c,c.account.name, c.subject,c.Owner.Name, c.status,c.CreatedDate,c.LastModifiedDate,c.Case_Severity__c,c.casenumber,c.Priority, c.Status_Number__c,c.Status_priority__c,c.Case_Age__c,c.IsEscalated, c.Time_Open__c  from Case c  where   c.owner.id=:userInfo.getUserId() /* c.Primary_Group_Name__c=:curUser.Primary_Group__c and  c.Case_Severity__c!=null */ and c.IsClosed = false order by c.Case_Severity__c,c.Status_priority__c,c.lastmodifieddate,c.createddate Limit 100];

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

for(case c : casedefaultlist)
{
orgsortlist.add(new casetimewrapper(c));
}

OwnerName = 'Owner Name';
        Severity='Case Severity';
        Priority='Priority';
        CreatedDate='Date/Time Opened';
        Status='Status';
        Subject='Subject';
        CaseNumber='Case #';
        AccountName='Account Name';
        LastModifiedDate='Last Modified Date';
        PsftCaseId='Psft CaseId';
          Age ='Age';
 SLA_Expiry_time='SLA Expiry Time';
 Time_left_for_SLA_Expiry='Time Left for SLA Expiry';
 Event_Type='Event Type';
 CLAtime='Closure/Escalate Time Remaining';
            //orgsortlist =[select Id, RecordType.Name,subject,Owner.Name, OwnerId, status,CreatedDate,Case_Severity__c,casenumber,Priority, Status_Number__c  from Case WHERE ID IN: o2 ORDER By Owner.Name Limit 100];            
        }
        
        return null;
    }  
 }