@isTest(seeAllData=true)
public class ContactRoleDeleteTest {

    static testMethod void UnitPositiveTest() {
    Profile p = [select id from profile where id='00e70000000rsum'];
    user u2 =[select id, Name,contactId from user where isactive=true  and profileid = :p.id limit 1 ];         
        
    Account ac=TestMethodUtility.createAccount();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        insert ac;
        
        Contact_Role__c crr = [select id,Expire_Role__c,Role__c from Contact_Role__c where Expire_Role__c=False and role__c='LEARN (Bb) - Admin' limit 1];
       
        
    
        System.runas(u2) {
       try{
         
       delete crr;
       }
    catch (dmlexception e){
        
         system.assert(e.getMessage().contains('You are not permitted to delete admin contact role'),
         e.getMessage() );
      }
    }
    }
}