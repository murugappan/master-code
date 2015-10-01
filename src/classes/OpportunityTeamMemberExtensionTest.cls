@istest(SeeAllData=True)
Private class OpportunityTeamMemberExtensionTest{
    static testMethod void myUnitTest(){
    
    Account KAcc1 = new Account(Name = 'Account1');
    insert KAcc1;
            
    opportunity opp = new opportunity(name = 'nik', AccountId = KAcc1.Id, StageName='Won',CloseDate=Date.today());
    insert opp;
    OpportunityTeamMemberExtension myExtension = new OpportunityTeamMemberExtension(new ApexPages.StandardController(opp));
    myExtension.getTeamMemberAndAccessList();
   // List<OpportunityTeamMemberWrapper>  oppTeam = [select id from OpportunityTeamMemberWrapper  limit 10];
    //myExtension.setTeamMemberAndAccessList(oppTeam); 
     myExtension.saveOnly();
     myExtension.saveAndMore();
     myExtension.cancel();
     myExtension.setTeamMemberAndAccessList(myExtension.getTeamMemberAndAccessList());
     myExtension.getOpportunityAccessTypes();
     
    
  }
}