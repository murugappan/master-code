@istest
private class BBW_CaseHandOffTest
{
static testmethod void BBW_CaseHandOffTest()
{
Account ac=new Account();
ac.Name='bucknell university';
ac.BillingCity='abc';
ac.BillingCountry='USA';
ac.BillingPostalCode='abc';
ac.BillingState='abc';
ac.BillingStreet='abc';
insert ac;

Contact ct= new Contact ();
ct.AccountId=ac.id;
ct.Account=ac;
ct.LastName='abc';
insert ct;

Core_License__c cl=new Core_License__c();
cl.Name='Angel';
insert cl;

Asset a=new Asset();
a.Name='abc';
a.Core_License__c=cl.id;
a.AccountId=ac.id;
a.Contact=ct;
a.Account=ac;
insert a;

Module__c m=new  Module__c(); 
m.Name='abc'; 
m.Core_Licence__c=cl.id; 
insert m;

Functional_Area__c fa=new Functional_Area__c();
fa.Name='abc';
fa.Module__c=m.id;
insert fa;

Category__c c=new Category__c();
c.Name='abc';
c.Functional_Area__c=fa.id;
insert c;

Template__c t=new Template__c();
t.Name='abc';
insert t;

User_Lookup__c u=new User_Lookup__c();
u.User__c=UserInfo.getUserId() ;
insert u; 

Case cs=new Case();
cs.Status='Assigned' ;
cs.Description='this case has to be resolved';
//cs.Product_Group__c='abc';
//cs.Asset='FIN AID IMPL PS 30K+';
cs.Type='abc';cs.Subject='abc';
cs.Case_Severity__c='sev 1';
cs.AccountId=ac.id;
cs.Account=ac;
cs.Contact=ct;
cs.AssetID=a.ID;
cs.Functional_Area__c=fa.id;
cs.Module__c=m.id;
cs.Category__c=c.id;
//cs.Owner.id=UserInfo.getUserId();
insert cs;

Group gg = new Group(Name='Test group');
insert gg;

case cs1=new case();
system.currentpagereference().getParameters().put('id',cs.id);
ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
BBW_CaseHandOff controller = new BBW_CaseHandOff(testhf);        
controller.SaveOwner();
controller.getRecName();
controller.setRecName('abc');
controller.Values();
controller.getQueueName();
controller.getRecordName();
controller.GroupName=gg.id;
controller.UserComment='Test comment';
controller.SaveOwner();

}

static testmethod void unitTestAnalyticsPositiveScenerio(){

	 user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
	 system.runAs(sysuser){
     
			Account ac=new Account();
			ac.Name='bucknell university';
			ac.BillingCity='abc';
			ac.BillingCountry='USA';
			ac.BillingPostalCode='abc';
			ac.BillingState='abc';
			ac.BillingStreet='abc';
			insert ac;

			Contact ct= new Contact ();
			ct.AccountId=ac.id;
			ct.Account=ac;
			ct.LastName='abc';
			insert ct;

			Core_License__c cl=new Core_License__c();
			cl.Name='Analytics';
			insert cl;

			Asset a=new Asset();
			a.Name='abc';
			a.Core_License__c=cl.id;
			a.AccountId=ac.id;
			a.Contact=ct;
			a.Account=ac;
			insert a;

			Module__c m=new  Module__c(); 
			m.Name='abc'; 
			m.Core_Licence__c=cl.id; 
			insert m;

			Functional_Area__c fa=new Functional_Area__c();
			fa.Name='abc';
			fa.Module__c=m.id;
			insert fa;

			Category__c c=new Category__c();
			c.Name='abc';
			c.Functional_Area__c=fa.id;
			insert c;

			Template__c t=new Template__c();
			t.Name='abc';
			insert t;

			User_Lookup__c u=new User_Lookup__c();
			u.User__c=UserInfo.getUserId() ;
			insert u; 

			Case cs=new Case();
			cs.Status='new' ;
			cs.Description='this case has to be resolved';
			//cs.Product_Group__c='abc';
			//cs.Asset='FIN AID IMPL PS 30K+';
			cs.Type='abc';cs.Subject='abc';
			cs.Case_Severity__c='sev 1';
			cs.AccountId=ac.id;
			cs.Account=ac;
			cs.Contact=ct;
			cs.AssetID=a.ID;
			cs.Functional_Area__c=fa.id;
			cs.Module__c=m.id;
			cs.Category__c=c.id;
			cs.Primary_Group_Name__c='Analytics';
		

			//cs.Owner.id=UserInfo.getUserId();
			insert cs;

			case cs1=new case();
			system.currentpagereference().getParameters().put('id',cs.id);
			ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
			BBW_CaseHandOff controller = new BBW_CaseHandOff(testhf);  
            



	 }

}


static testmethod void unitTestxpLorPositiveScenerio(){

	 user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
	 system.runAs(sysuser){
     
			Account ac=new Account();
			ac.Name='bucknell university';
			ac.BillingCity='abc';
			ac.BillingCountry='USA';
			ac.BillingPostalCode='abc';
			ac.BillingState='abc';
			ac.BillingStreet='abc';
			insert ac;

			Contact ct= new Contact ();
			ct.AccountId=ac.id;
			ct.Account=ac;
			ct.LastName='abc';
			insert ct;

			Core_License__c cl=new Core_License__c();
			cl.Name='xpLor';
			insert cl;

			Asset a=new Asset();
			a.Name='abc';
			a.Core_License__c=cl.id;
			a.AccountId=ac.id;
			a.Contact=ct;
			a.Account=ac;
			insert a;

			Module__c m=new  Module__c(); 
			m.Name='abc'; 
			m.Core_Licence__c=cl.id; 
			insert m;

			Functional_Area__c fa=new Functional_Area__c();
			fa.Name='abc';
			fa.Module__c=m.id;
			insert fa;

			Category__c c=new Category__c();
			c.Name='abc';
			c.Functional_Area__c=fa.id;
			insert c;

			Template__c t=new Template__c();
			t.Name='abc';
			insert t;

			User_Lookup__c u=new User_Lookup__c();
			u.User__c=UserInfo.getUserId() ;
			insert u; 

			Case cs=new Case();
			cs.Status='new' ;
			cs.Description='this case has to be resolved';
			//cs.Product_Group__c='abc';
			//cs.Asset='FIN AID IMPL PS 30K+';
			cs.Type='abc';cs.Subject='abc';
			cs.Case_Severity__c='sev 3';
			cs.AccountId=ac.id;
			cs.Account=ac;
			cs.Contact=ct;
			cs.AssetID=a.ID;
			cs.Functional_Area__c=fa.id;
			cs.Module__c=m.id;
			cs.Category__c=c.id;
			cs.Primary_Group_Name__c='Moodlerooms';
		

			//cs.Owner.id=UserInfo.getUserId();
			insert cs;

			case cs1=new case();
			system.currentpagereference().getParameters().put('id',cs.id);
			ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
			BBW_CaseHandOff controller = new BBW_CaseHandOff(testhf);
			controller.RecName='xpLor';  
            controller.getQueueName();



	 }

}
static testmethod void unitTestMoodleroomsPositiveScenerio(){

	 user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
	 system.runAs(sysuser){
     
			Account ac=new Account();
			ac.Name='bucknell university';
			ac.BillingCity='abc';
			ac.BillingCountry='USA';
			ac.BillingPostalCode='abc';
			ac.BillingState='abc';
			ac.BillingStreet='abc';
			insert ac;

			Contact ct= new Contact ();
			ct.AccountId=ac.id;
			ct.Account=ac;
			ct.LastName='abc';
			insert ct;

			Core_License__c cl=new Core_License__c();
			cl.Name='Moodlerooms';
			insert cl;

			Asset a=new Asset();
			a.Name='abc';
			a.Core_License__c=cl.id;
			a.AccountId=ac.id;
			a.Contact=ct;
			a.Account=ac;
			insert a;

			Module__c m=new  Module__c(); 
			m.Name='abc'; 
			m.Core_Licence__c=cl.id; 
			insert m;

			Functional_Area__c fa=new Functional_Area__c();
			fa.Name='abc';
			fa.Module__c=m.id;
			insert fa;

			Category__c c=new Category__c();
			c.Name='abc';
			c.Functional_Area__c=fa.id;
			insert c;

			Template__c t=new Template__c();
			t.Name='abc';
			insert t;

			User_Lookup__c u=new User_Lookup__c();
			u.User__c=UserInfo.getUserId() ;
			insert u; 

			Case cs=new Case();
			cs.Status='new' ;
			cs.Description='this case has to be resolved';
			//cs.Product_Group__c='abc';
			//cs.Asset='FIN AID IMPL PS 30K+';
			cs.Type='abc';cs.Subject='abc';
			cs.Case_Severity__c='sev 1';
			cs.AccountId=ac.id;
			cs.Account=ac;
			cs.Contact=ct;
			cs.AssetID=a.ID;
			cs.Functional_Area__c=fa.id;
			cs.Module__c=m.id;
			cs.Category__c=c.id;
			cs.Primary_Group_Name__c='Moodlerooms';
		

			//cs.Owner.id=UserInfo.getUserId();
			insert cs;

			case cs1=new case();
			system.currentpagereference().getParameters().put('id',cs.id);
			ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
			BBW_CaseHandOff controller = new BBW_CaseHandOff(testhf);  
            



	 }

}

static testmethod void unitTestLearnPositiveScenerio(){

	 user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
	 system.runAs(sysuser){
     
			Account ac=new Account();
			ac.Name='bucknell university';
			ac.BillingCity='abc';
			ac.BillingCountry='USA';
			ac.BillingPostalCode='abc';
			ac.BillingState='abc';
			ac.BillingStreet='abc';
			insert ac;

			Contact ct= new Contact ();
			ct.AccountId=ac.id;
			ct.Account=ac;
			ct.LastName='abc';
			insert ct;

			Core_License__c cl=new Core_License__c();
			cl.Name='Learn';
			insert cl;

			Asset a=new Asset();
			a.Name='abc';
			a.Core_License__c=cl.id;
			a.AccountId=ac.id;
			a.Contact=ct;
			a.Account=ac;
			insert a;

			Module__c m=new  Module__c(); 
			m.Name='abc'; 
			m.Core_Licence__c=cl.id; 
			insert m;

			Functional_Area__c fa=new Functional_Area__c();
			fa.Name='abc';
			fa.Module__c=m.id;
			insert fa;

			Category__c c=new Category__c();
			c.Name='abc';
			c.Functional_Area__c=fa.id;
			insert c;

			Template__c t=new Template__c();
			t.Name='abc';
			insert t;

			User_Lookup__c u=new User_Lookup__c();
			u.User__c=UserInfo.getUserId() ;
			insert u; 

			Case cs=new Case();
			cs.Status='new' ;
			cs.Description='this case has to be resolved';
			//cs.Product_Group__c='abc';
			//cs.Asset='FIN AID IMPL PS 30K+';
			cs.Type='abc';cs.Subject='abc';
			cs.Case_Severity__c='sev 1';
			cs.AccountId=ac.id;
			cs.Account=ac;
			cs.Contact=ct;
			cs.AssetID=a.ID;
			cs.Functional_Area__c=fa.id;
			cs.Module__c=m.id;
			cs.Category__c=c.id;
			cs.Primary_Group_Name__c='Learn';
		

			//cs.Owner.id=UserInfo.getUserId();
			insert cs;

			case cs1=new case();
			system.currentpagereference().getParameters().put('id',cs.id);
			ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
			BBW_CaseHandOff controller = new BBW_CaseHandOff(testhf);
			controller.RecName='ALL';
			controller.getQueueName();  
            



	 }

}

static testmethod void unitTestCollaboratePositiveScenerio(){

	 user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
	 system.runAs(sysuser){
     
			Account ac=new Account();
			ac.Name='bucknell university';
			ac.BillingCity='abc';
			ac.BillingCountry='USA';
			ac.BillingPostalCode='abc';
			ac.BillingState='abc';
			ac.BillingStreet='abc';
			insert ac;

			Contact ct= new Contact ();
			ct.AccountId=ac.id;
			ct.Account=ac;
			ct.LastName='abc';
			insert ct;

			Core_License__c cl=new Core_License__c();
			cl.Name='Collaborate';
			insert cl;

			Asset a=new Asset();
			a.Name='abc';
			a.Core_License__c=cl.id;
			a.AccountId=ac.id;
			a.Contact=ct;
			a.Account=ac;
			insert a;

			Module__c m=new  Module__c(); 
			m.Name='abc'; 
			m.Core_Licence__c=cl.id; 
			insert m;

			Functional_Area__c fa=new Functional_Area__c();
			fa.Name='abc';
			fa.Module__c=m.id;
			insert fa;

			Category__c c=new Category__c();
			c.Name='abc';
			c.Functional_Area__c=fa.id;
			insert c;

			Template__c t=new Template__c();
			t.Name='abc';
			insert t;

			User_Lookup__c u=new User_Lookup__c();
			u.User__c=UserInfo.getUserId() ;
			insert u; 

			Case cs=new Case();
			cs.Status='new' ;
			cs.Description='this case has to be resolved';
			//cs.Product_Group__c='abc';
			//cs.Asset='FIN AID IMPL PS 30K+';
			cs.Type='abc';cs.Subject='abc';
			cs.Case_Severity__c='sev 1';
			cs.AccountId=ac.id;
			cs.Account=ac;
			cs.Contact=ct;
			cs.AssetID=a.ID;
			cs.Functional_Area__c=fa.id;
			cs.Module__c=m.id;
			cs.Category__c=c.id;
			cs.Primary_Group_Name__c='Collaborate';
		

			//cs.Owner.id=UserInfo.getUserId();
			insert cs;

			case cs1=new case();
			system.currentpagereference().getParameters().put('id',cs.id);
			ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
			BBW_CaseHandOff controller = new BBW_CaseHandOff(testhf);  
            



	 }

}

static testmethod void unitTestXythosPositiveScenerio(){

	 user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
	 system.runAs(sysuser){
     
			Account ac=new Account();
			ac.Name='bucknell university';
			ac.BillingCity='abc';
			ac.BillingCountry='USA';
			ac.BillingPostalCode='abc';
			ac.BillingState='abc';
			ac.BillingStreet='abc';
			insert ac;

			Contact ct= new Contact ();
			ct.AccountId=ac.id;
			ct.Account=ac;
			ct.LastName='abc';
			insert ct;

			Core_License__c cl=new Core_License__c();
			cl.Name='Xythos';
			insert cl;

			Asset a=new Asset();
			a.Name='abc';
			a.Core_License__c=cl.id;
			a.AccountId=ac.id;
			a.Contact=ct;
			a.Account=ac;
			insert a;

			Module__c m=new  Module__c(); 
			m.Name='abc'; 
			m.Core_Licence__c=cl.id; 
			insert m;

			Functional_Area__c fa=new Functional_Area__c();
			fa.Name='abc';
			fa.Module__c=m.id;
			insert fa;

			Category__c c=new Category__c();
			c.Name='abc';
			c.Functional_Area__c=fa.id;
			insert c;

			Template__c t=new Template__c();
			t.Name='abc';
			insert t;

			User_Lookup__c u=new User_Lookup__c();
			u.User__c=UserInfo.getUserId() ;
			insert u; 

			Case cs=new Case();
			cs.Status='new' ;
			cs.Description='this case has to be resolved';
			//cs.Product_Group__c='abc';
			//cs.Asset='FIN AID IMPL PS 30K+';
			cs.Type='abc';cs.Subject='abc';
			cs.Case_Severity__c='sev 1';
			cs.AccountId=ac.id;
			cs.Account=ac;
			cs.Contact=ct;
			cs.AssetID=a.ID;
			cs.Functional_Area__c=fa.id;
			cs.Module__c=m.id;
			cs.Category__c=c.id;
			cs.Primary_Group_Name__c='Xythos';
		

			//cs.Owner.id=UserInfo.getUserId();
			insert cs;

			case cs1=new case();
			system.currentpagereference().getParameters().put('id',cs.id);
			ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
			BBW_CaseHandOff controller = new BBW_CaseHandOff(testhf);  
            



	 }

}




}