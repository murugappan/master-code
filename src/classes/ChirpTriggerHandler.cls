/*************
@Author: Varghese George
@Name: ChirpTriggerHandler
@Namespace: System
@Desciption: Triggere Handler for the custom object Chirp Ticket(Chirp_Ticket__c)
@Created: 22nd July 2014
***************/

public class ChirpTriggerHandler 
{
   public static boolean isfirstrunBeforeInsert = true;

//Interface hnadler class for Before insert operation
   public class BeforeInsert implements Triggers.HandlerInterface {
      public void handle() {
            if(isfirstrunBeforeInsert)
            {
                ChirpTriggerHandler.CheckCaseforChirp(Trigger.new);
                if(isfirstrunBeforeInsert)
                {
                    isfirstrunBeforeInsert=false;
                }
            }
        }
      

    }
    
    /***************
    Check whether a Chirp already exists for the Case
    @Author: Varghese George
    @Name: CheckCaseforChirp
    @Argument: list<chirp_ticket__c> newlist 
    @Return: void 
    @Created: 23rd July 2014
    ***************/
    public static void CheckCaseforChirp(list<chirp_ticket__c> newlist)
     {
        set<Id> CaseIds = new set<Id>();
        for(chirp_ticket__c ch: newlist)
        {
            if(ch.Case__c!= null)
            CaseIds.add(ch.case__c);
        }

        if(CaseIds != null && caseIds.size()>0)
        {
            map<id,chirp_ticket__c> chirpmap= new map<id,chirp_ticket__c>([Select id,case__c from chirp_ticket__c 
                                                where case__c in :caseIds and id not in :newlist ]);

            if(chirpmap != null && chirpmap.size()>0)
            {
                set<id> casemapids= new set<id>();
                for(chirp_ticket__c cs: chirpmap.values())
                {
                    casemapids.add(cs.case__c);
                }
                for(chirp_ticket__c ch : newlist )
                {
                    if(casemapids.contains(ch.case__c))
                    {
                        ch.adderror('Cannot create CHIRP ticket as another CHIRP exists for the Case');
                    }
                }
            }                                     
        }
     }
   
}