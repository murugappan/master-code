public class createKSO {
public Opportunity store {get;set;}
public list<KimbleOne__SalesOpportunity__c> ksoopp {get;set;}
public list<KimbleOne__ForecastStatus__c> forecastStatus {get;set;}      
    
    
    
    public createKSO(ApexPages.StandardController controller) {
    if(ApexPages.currentPage().getParameters().get('id') != null) {
    store = [Select id, Name, AccountId, StageName, Start_Date__c, KimbleCRMInt__BusinessUnit__c, RecordTypeId, RecordType.Name, Probability, CloseDate, CurrencyISOCode, Closed_Date__c, OwnerId, Owner.Name from Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    
    forecastStatus = [SELECT Id, KimbleOne__Probability__c FROM KimbleOne__ForecastStatus__c 
                      WHERE KimbleOne__Probability__c >=: store.Probability 
                      ORDER BY KimbleOne__Probability__c ASC LIMIT 1];
    }
    
    }
    
    
    public pagereference autorun(){
    
    ksoopp = [Select id, KimbleCRMInt__Opportunity__c, Name from KimbleOne__SalesOpportunity__c Where KimbleCRMInt__Opportunity__c =: store.Id];
    system.debug('ksoopp size'+ksoopp.size());
    
    if(ksoopp.size()==0){
    system.debug('Murugappan Alagappan');
    
    KimbleOne__SalesOpportunity__c kso = new KimbleOne__SalesOpportunity__c();
    kso.KimbleCRMInt__Opportunity__c = store.Id;
    if(store.AccountId != null){
        kso.KimbleOne__Account__c = store.AccountId;
    }
    kso.KimbleOne__ShortName__c = store.Name.left(60);
   
    
    kso.KimbleOne__InvoicingCurrencyISOCode__c = store.CurrencyISOCode;
    
    if(store.CloseDate != null){
        kso.KimbleOne__ResponseRequiredDate__c = store.CloseDate;
    }
    
    kso.KimbleOne__CloseDate__c = System.today();
    
    kso.OwnerId = store.OwnerId;
    
    kso.KimbleOne__ForecastStatus__c = forecastStatus[0].Id; 
    
    if(store.KimbleCRMInt__BusinessUnit__c == null && store.RecordType.Name == 'Blackboard Opportunity Transact'){
    KimbleOne__BusinessUnit__c TheDefaultBU;
         TheDefaultBU = [Select ID FROM KimbleOne__BusinessUnit__c WHERE Name = 'Transact'];  
         kso.KimbleOne__BusinessUnit__c = TheDefaultBU.Id;
    
    }
    
    else if(store.KimbleCRMInt__BusinessUnit__c == null && store.RecordType.Name != 'Blackboard Opportunity Transact'){
    KimbleOne__BusinessUnit__c TheDefaultBU;
         TheDefaultBU = [Select ID FROM KimbleOne__BusinessUnit__c WHERE Name = 'DCS (Domestic Consulting Services)'];  
         kso.KimbleOne__BusinessUnit__c = TheDefaultBU.Id;
    
    }
    
   
    
    else{
    
    kso.KimbleOne__BusinessUnit__c = store.KimbleCRMInt__BusinessUnit__c;
    
    }
    
    insert kso;
    //return new pagereference('/'+store.id).setredirect(true);
    }
    
     /*else{
      PageReference page2 = Page.createKSOMessage;
       page2.setRedirect(true);
       page2.GetParameters().Put('message', 'Kimble Sales Opportunity Exists!');
       return page2;
     
     }*/
    
    return new pagereference('/'+store.id).setredirect(true);
    
      
    }
    
  /*public void Init()
  {
  String message = ApexPages.CurrentPage().GetParameters().Get('message');

  if(message != 'null')
  {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, message));
    
  }
 } */
    
  

    
 
}