public with sharing class loginissuecontroller {

	private final LoginIssues__c mysObject;
    public boolean success{get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public loginissuecontroller(ApexPages.StandardController stdController) {
        this.mysObject = (LoginIssues__c)stdController.getRecord();
        success=false;
    }

    public void save()
    {
       try{

            insert mysObject;
            success=true;
        } 
        catch(Exception e)
        {
            String error = e.getMessage();
            success=false;
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));
        }
    }
}