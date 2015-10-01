/*
Class:AttachmentView
Date:21.05.2013
*/
@isTest(seealldata=True)
private class AttachmentViewTest {

    static testMethod void myUnitTest() {
        
        Profile pf3= [select id from Profile where name = 'BTBB Profile'];
 
        User u3 = TestMethodUtility.createUser(pf3);
        u3.BTBB_KB_Default_Prod__c='ANGEL';
        insert u3;
        
        System.Runas(u3){
        
        
        
        
        Case_Attachment__c ca = TestMethodUtility.CreateAttachment();
        ca.Bucket_Name__c = 'Test';
        insert ca;
        
        ApexPages.CurrentPage().getParameters().put('id',ca.ID);
        ApexPages.StandardController controller = new ApexPages.StandardController(ca);
        AttachmentView ia = new AttachmentView(controller);
        ia.redirect();
       
        }
    
    }
}