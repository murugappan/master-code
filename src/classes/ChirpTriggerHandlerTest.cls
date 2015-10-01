/*************
@Author: Varghese George
@Name: ChirpTriggerHandlerTest
@Namespace: System
@Description: Test Class for ChirpTriggerHandler class
@Created: 30th July 2014
***************/

@isTest
private class ChirpTriggerHandlerTest {
	
	@isTest static void UnitTestForPositiveTestCase() {
		case c = new case(subject='testsubject',Case_Severity__c='3',description='testdescription');
		insert c;
	    Chirp_Ticket__c ch=TestMethodUtility.CreateChripTicket();
	    ch.Case__c=c.id;
	    Database.SaveResult Result= Database.insert(ch,true);
	    system.assert(Result.isSuccess()==true,'Assertion did not pass');

	}
	
	@isTest static void UnitTestForNegativeTestCase() {
		case c = new case(subject='testsubject',Case_Severity__c='3',description='testdescription');
		insert c;
		system.debug('Case -- '+c.id);
	    Chirp_Ticket__c ch=TestMethodUtility.CreateChripTicket();
	    ch.Case__c=c.id;
	    insert ch;
	    ChirpTriggerHandler.isfirstrunBeforeInsert=true; 
	    Chirp_Ticket__c ch2=TestMethodUtility.CreateChripTicket();
	    ch2.Case__c=c.id;
	    Database.SaveResult Result2= Database.insert(ch2,false);
	    system.debug('Result2 -- '+Result2.isSuccess());
	    system.assert(Result2.isSuccess()==False,'Assertion did not pass: ChirpTriggerHandler failed');
	}
	
}