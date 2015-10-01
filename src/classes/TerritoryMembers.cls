/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestTerritoryMembers
    @abstract       Unit Test TestTerritoryMembers
    @since          2008.0827
    @discussion     Test Class for TestTerritoryMembers
*/
public class TerritoryMembers {
    
    private final Account account;
    private List <TerritoryMember> members;

    public TerritoryMembers(ApexPages.StandardController controller)
    {
        this.account = (Account)controller.getRecord();
    }
    
    public List<TerritoryMember> getMembers()
    {
        Set <Id> gRecs = new Set<Id>();                
        for (AccountShare aShare : [SELECT AccountId, UserOrGroupId FROM AccountShare WHERE AccountId = :account.Id]) gRecs.Add(aShare.UserOrGroupId);
            
        Set <Id> terrRecs = new Set<Id>();                
        for (Group g : [SELECT RelatedId FROM Group WHERE Type='Territory' AND ID in :gRecs]) terrRecs.Add(g.RelatedID);  //Gets TerritoryID
                            
        Set <Id> sUserIds = new Set<Id>();
        for (Territory t : [SELECT ForecastUserId FROM Territory WHERE Exclude_from_TM_listing__c = false AND ID in :terrRecs]) sUserIds.add(t.ForecastUserId); //Gets TerritoryID that isn't Excluded

        List <TerritoryMember> members = new List<TerritoryMember>();
        for (User u: [SELECT Id, Name, UserRole.Name, SmallPhotoUrl, FullPhotoUrl FROM User WHERE isActive = true AND id in :sUserIds]) members.add(new TerritoryMember(account, u));

        return members;
    }


    public class TerritoryMember
    {
        private Account account;
        private User user;
        
        public Account getAccount() { return this.account; }
        public User getUser() { return this.user; }

        
        public TerritoryMember(Account a, User u)
        {
            account = a;
            user = u;
        }
    }
}