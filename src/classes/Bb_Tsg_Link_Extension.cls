public with sharing class Bb_Tsg_Link_Extension {


	public List<Bb_Tsg_Link__c> links {get;set;}
	
	public Bb_Tsg_Link_Extension(ApexPages.StandardSetController controller) 
	{

	}
	
		   
    public List<Bb_Tsg_Link__c> getTsgLinks()
    {
    	List<Bb_Tsg_Link__c> TsgLinks = new List<Bb_Tsg_Link__c>();
    	Tsglinks = [SELECT Name, URI__c FROM Bb_Tsg_Link__c Order By Name];
    	
    	return Tsglinks;
    	
    }
    
    
    
}