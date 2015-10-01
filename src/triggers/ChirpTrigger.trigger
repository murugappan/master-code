trigger ChirpTrigger on CHIRP_Ticket__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {


		new Triggers()
		.bind(Triggers.Evt.beforeinsert, new ChirpTriggerHandler.BeforeInsert())
		.manage();

}