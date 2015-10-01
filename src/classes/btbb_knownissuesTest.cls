@isTest
Private class  btbb_knownissuesTest {

    static testMethod void  btbb_knownissue()
    {
    Profile p = [select id from profile where name='System Administrator'];
    User user = TestMethodUtility.createUser(p);
    insert user;
    BTBB_KBCategory__c bb = new BTBB_KBCategory__c(Name='test btbb' ,CurrencyIsoCode='GBP',CategoryName__c='Learn');
    insert bb;
    system.Runas(user)
     {
    btbb_knownissues ps = new btbb_knownissues();
        ps.getFullName();
        ps.getUserDefaultProduct();
        ps.defaultProductSelect();
        ps.getProduct();
        ps.selectProduct();
        ps.getDefaultProduct();
        ps.getKnownIssues();
        ps.selectMajor();
        ps.product='Learn';
        list<selectoption> tempop= ps.versions;
        List<SelectOption> temp = ps.Products;
        
       }
    }
  }