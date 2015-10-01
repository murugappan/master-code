public class btbb_knownissuesearchcontroller {

        public List<Solution> KnownIssueArticles = new List<Solution>();
    
        public List<Solution> getArticles(){
        KnownIssueArticles = [Select SolutionName, SolutionNumber, Summary__c, Product__c, Major_Release__c, Version_s__c, Target_Release__c, Patch_Available__c, Support_Incident__r.Name From Solution Where RecordType.Name = 'Known Issue' and Status = 'Published' and isVisibleCustomerPortal__c = true LIMIT 1000];
        return KnownIssueArticles;
        }
    
    public btbb_knownissuesearchcontroller(){
        
    }
    static testMethod void btbb_knownissuesearccontrollertest()
    {
    btbb_knownissuesearchcontroller btbb_kisearch =new btbb_knownissuesearchcontroller();
    btbb_kisearch.getArticles();
    }
}