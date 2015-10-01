trigger casechirpUpdate on CHIRP_Ticket__c (after insert) {

for(CHIRP_Ticket__c chirps: trigger.new){
if(chirps.Case__c != null){
Case_Chirp__c casechirp = new Case_Chirp__c();
casechirp.Case__c = chirps.Case__c;
casechirp.CHIRP_Ticket__c = chirps.Id;
insert casechirp;
}

}

}