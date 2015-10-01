@istest
private class BBW_CaseAssignToTest {
static testmethod void BBW_CaseAssignToTest() {
profile pf =[select id from profile where name ='SRV - Support Tech' limit 1];
User testuser=[select id from user where profileid =:pf.id and isactive = true limit 1];

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
list<case> case_list= new list<case>();
Case cs=new Case();
cs.Status='Assigned' ;
cs.Description='this case has to be resolved';
cs.Type='abc';
cs.Subject='abc';
cs.Case_Severity__c='sev 1';
cs.Primary_Group_Name__c='Transact';
cs.AccountId=ac.id;
cs.Account=ac;
cs.Contact=ct;
cs.Functional_Area__c=fa.id;
cs.Module__c=m.id;
cs.Category__c=c.id;
case_list.add(cs);


Case cs1=new Case();
cs1.Status='Assigned' ;

cs1.Description='this case has to be resolved';
//cs.Product_Group__c='abc';
//cs.Asset='FIN AID IMPL PS 30K+';
cs1.Type='abc';
cs1.Subject='abc';
cs1.Case_Severity__c='sev 1';
cs1.Primary_Group_Name__c='Learn';
cs1.AccountId=ac.id;
cs1.Account=ac;
cs1.Contact=ct;
//cs.AssetID=a.ID;
cs1.Functional_Area__c=fa.id;
cs1.Module__c=m.id;
cs1.Category__c=c.id;
//cs.Owner.id=UserInfo.getUserId();
case_list.add(cs1);

Case cs2=new Case();
cs2.Status='Pending User' ;

cs2.Description='this case has to be resolved';
//cs.Product_Group__c='abc';
//cs.Asset='FIN AID IMPL PS 30K+';
cs2.Type='abc';
cs2.Subject='abc';
cs2.Case_Severity__c='sev 1';
cs2.Primary_Group_Name__c='Xythos';
cs2.AccountId=ac.id;
cs2.Account=ac;
cs2.Contact=ct;
//cs.AssetID=a.ID;
cs2.Functional_Area__c=fa.id;
cs2.Module__c=m.id;
cs2.Category__c=c.id;
//cs.Owner.id=UserInfo.getUserId();
case_list.add(cs2);

Case cs3=new Case();
cs3.Status='Escalated'; 
cs3.Description='this case has to be resolved';
//cs.Product_Group__c='abc';
//cs.Asset='FIN AID IMPL PS 30K+';
cs3.Type='abc';
cs3.Subject='abc';
cs3.Case_Severity__c='sev 1';
cs3.Primary_Group_Name__c='Xythos';
cs3.AccountId=ac.id;
cs3.Account=ac;
cs3.Contact=ct;
//cs.AssetID=a.ID;
cs3.Functional_Area__c=fa.id;
cs3.Module__c=m.id;
cs3.Category__c=c.id;
//cs.Owner.id=UserInfo.getUserId();
case_list.add(cs3);

insert case_list;

test.starttest();

system.currentpagereference().getParameters().put('id',cs.id);
ApexPages.StandardController testa = new ApexPages.StandardController(cs);
BBW_CaseAssignTo controller = new BBW_CaseAssignTo(testa);    



controller.SaveOwner();
controller.getRecName();
controller.setRecName('abc');
controller.Values();
controller.getQueueName();
controller.setusn('abc');
controller.getusn();

controller.getprg();
controller.setprg('abc');
controller.USValue();
controller.getRecordName();
controller.setprg('ALL');


system.currentpagereference().getParameters().put('id',cs1.id);

ApexPages.StandardController testa1 = new ApexPages.StandardController(cs1);
BBW_CaseAssignTo controller1 = new BBW_CaseAssignTo(testa1);
controller1.SaveOwner();

controller1.getRecName();
controller1.setRecName('abc');

controller1.Values();

controller1.getQueueName();
controller1.setusn('abc');
controller1.getusn();
controller1.getprg();
controller1.setprg('abc');
controller1.USValue();
controller1.getRecordName();
controller1.setprg('null');


system.currentpagereference().getParameters().put('id',cs2.id);

ApexPages.StandardController testa2 = new ApexPages.StandardController(cs2);
BBW_CaseAssignTo controller2 = new BBW_CaseAssignTo(testa2);
controller2.setusn(string.valueof(testuser.id));
controller2.SaveOwner();

controller2.getRecName();
controller2.setRecName('abc');

controller2.Values();

controller2.getQueueName();

controller2.getusn();
controller2.getprg();
controller2.setprg('abc');
controller2.USValue();
controller2.getRecordName();
controller2.setprg('null');


system.currentpagereference().getParameters().put('id',cs3.id);

ApexPages.StandardController testa3 = new ApexPages.StandardController(cs3);
BBW_CaseAssignTo controller3 = new BBW_CaseAssignTo(testa3);
controller3.SaveOwner();

controller3.getRecName();
controller3.setRecName('abc');

controller3.Values();

controller3.getQueueName();
controller3.setusn(string.valueof(testuser.id));
controller3.getusn();
controller3.getprg();
controller3.setprg('abc');
controller3.USValue();
controller3.getRecordName();
controller3.setprg('null');

Test.StopTest();

}
static testmethod void unitTestMoodleroomsPositiveScenerios(){
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
            BBW_CaseAssignTo controller = new BBW_CaseAssignTo(testhf);



  }
}
static testmethod void unitTestAnalyticsPositiveScenerios(){
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
            BBW_CaseAssignTo controller = new BBW_CaseAssignTo(testhf);



  }
}

static testmethod void unitTestxpLorPositiveScenerios(){
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
			cs.Module__c=m.id;
			cs.Primary_Group_Name__c='Moodlerooms';
		

			//cs.Owner.id=UserInfo.getUserId();
			insert cs;

			case cs1=new case();
			system.currentpagereference().getParameters().put('id',cs.id);
			ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
            BBW_CaseAssignTo controller = new BBW_CaseAssignTo(testhf);



  }
}

static testmethod void unitTestCE_VistaPositiveScenerios(){
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
			cl.Name='CE/Vista';
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
			cs.Primary_Group_Name__c='CE/Vista';
		

			//cs.Owner.id=UserInfo.getUserId();
			insert cs;

			case cs1=new case();
			system.currentpagereference().getParameters().put('id',cs.id);
			ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
            BBW_CaseAssignTo controller = new BBW_CaseAssignTo(testhf);



  }
}

static testmethod void unitTestCollaboratePositiveScenerios(){
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
            BBW_CaseAssignTo controller = new BBW_CaseAssignTo(testhf);



  }
}


}