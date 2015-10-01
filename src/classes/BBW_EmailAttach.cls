global class BBW_EmailAttach {
@future
    public static void addAttachment(Set<ID> emailID,Map<ID,ID> actmap){
        List<Attachment> AttachmentList1=new List<Attachment>();
        if(emailID != null && emailID.size() > 0){ 
            for(List<Attachment> att : [select Id,Name,Body,ContentType,IsPrivate,OwnerId,ParentId from Attachment where ParentID IN: emailID]) {
                for(Attachment att1 : att){
                    Attachment attachment = new Attachment();
                    attachment.Body = att1.Body;
                    attachment.ContentType = att1.ContentType;
                    attachment.IsPrivate = att1.IsPrivate;
                    attachment.Name = att1.Name;
                    attachment.OwnerId = att1.OwnerId;
                    attachment.ParentId = actmap.get(att1.ParentID);
                    AttachmentList1.add(attachment);
                }
            }
        }        
        insert AttachmentList1;
    }
    
    static testmethod void BBW_EmailAttachtest(){
    
    Account ac = new Account();
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = new Contact();
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.AccountID = ac.ID;
    
    insert c1;
    
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'ANGEL';
    insert cr;    
    
    Asset aset = new Asset();
    aset.Name = 'Test Asset 111';
    aset.Core_License__c = cr.ID;
    aset.AccountID = ac.ID;
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    insert aset;
    
    Case cassoftsol = new Case();        //for angel software solutions
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    cassoftsol.assetID = aset.ID;
    insert cassoftsol;
    
    Map<ID,ID> actmap = new Map<ID,ID>();
    actmap.put(cassoftsol.ID,cassoftsol.ID);
    Set<ID> casID = new Set<ID>();
    casID.add(cassoftsol.ID);
    
    Attachment a  = new Attachment();
    a.Name = 'test.txt';
    a.Body = Blob.valueof('Test');
    a.ParentId = cassoftsol.ID;
    insert a;
    
    BBW_EmailAttach.addAttachment(casID,actmap);
    }
}