trigger childChirpUpdate on CHIRP_Ticket__c (before insert, before update) {
    System.debug(Trigger.old);
    set<Id> parentSet = new Set<Id>();
    List<CHIRP_Ticket__c> chirpList = new List<CHIRP_Ticket__c>();
    Map<String, List<CHIRP_Ticket__c>> mapOfParentWithChirpList = new Map<String, List<CHIRP_Ticket__c>>();
    Map<String, CHIRP_Ticket__c> mapOfParentWithId = new Map<String, CHIRP_Ticket__c>();
    if(Trigger.IsInsert) {
        for(CHIRP_Ticket__c chirp:Trigger.new) {
            System.debug('chirp Parent Id >>>>>' + chirp.Parent_Ticket__c);
            if(chirp.Parent_Ticket__c != null) {
                //parentSet.add(chirp.Parent_Ticket__c);              
                if(!mapOfParentWithChirpList.containsKey(chirp.Parent_Ticket__c)) {
                    chirpList = new List<CHIRP_Ticket__c>();
                    chirpList.add(chirp);                            
                    mapOfParentWithChirpList.put(chirp.Parent_Ticket__c, chirpList);
                } else {
                    
                    mapOfParentWithChirpList.get(chirp.Parent_Ticket__c).add(chirp);
                }
            }
        }
    }
    if(Trigger.IsUpdate) {
        for(Integer i = 0; i < Trigger.New.size(); i++) {
                if(null != Trigger.New[i].Parent_Ticket__c 
                    && Trigger.New[i].Parent_Ticket__c != Trigger.Old[i].Parent_Ticket__c) {        
                    
                    //parentSet.add(Trigger.New[i].Parent_Ticket__c);
                    if(!mapOfParentWithChirpList.containsKey(Trigger.New[i].Parent_Ticket__c)) {
                        chirpList = new List<CHIRP_Ticket__c>();
                        chirpList.add(Trigger.New[i]);                            
                        mapOfParentWithChirpList.put(Trigger.New[i].Parent_Ticket__c, chirpList);
                    } else                          
                        mapOfParentWithChirpList.get(Trigger.New[i].Parent_Ticket__c).add(Trigger.New[i]);
                }
        }
        
        //Parent Chirp updated
        for(Integer i = 0; i < Trigger.New.size(); i++) {
            if(null != Trigger.New[i].Parent__c && Trigger.New[i].Parent__c == true &&
            ((Trigger.New[i].State__c != Trigger.Old[i].State__c) 
            || (Trigger.New[i].Status__c != Trigger.Old[i].Status__c)
            || (Trigger.New[i].Planned_Release_Date__c != Trigger.Old[i].Planned_Release_Date__c)))
                
                mapOfParentWithId.put(Trigger.New[i].id, Trigger.New[i]);
        
        }   
        
        
    }
    chirpList = new List<CHIRP_Ticket__c>();
    if(null != mapOfParentWithChirpList && mapOfParentWithChirpList.size() > 0) {
        
        for(CHIRP_Ticket__c chripParent : [Select Id, Status__c, State__c, Planned_Release_Date__c, Parent__c From CHIRP_Ticket__c where id IN :mapOfParentWithChirpList.keySet()]) {
            
            for(CHIRP_Ticket__c childChirp : mapOfParentWithChirpList.get(chripParent.Id)) {
                
                childChirp.Status__c = chripParent.Status__c;
                childChirp.State__c = chripParent.State__c;
                childChirp.Planned_Release_Date__c = chripParent.Planned_Release_Date__c;
            }
            chripParent.Parent__c = true;
            chirpList.add(chripParent);
        }
    }
    CHIRP_Ticket__c parentChirp;
    System.debug('mapOfParentWithId >>>>>'+ mapOfParentWithId);
    if(null != mapOfParentWithId && mapOfParentWithId.size() > 0) {
        
        for(CHIRP_Ticket__c chirpChild : [Select Id, Status__c, State__c, Planned_Release_Date__c, Parent_Ticket__c From CHIRP_Ticket__c where Parent_Ticket__c IN :mapOfParentWithId.keyset()]) {
            
            parentChirp = mapOfParentWithId.get(chirpChild.Parent_Ticket__c);
            chirpChild.Status__c = parentChirp.Status__c;
            chirpChild.State__c = parentChirp.State__c;
            chirpChild.Planned_Release_Date__c = parentChirp.Planned_Release_Date__c;
            chirpList.add(chirpChild);                        
            
        }
    }
    
    if(null != chirpList && chirpList.size() > 0) {
        
        update chirpList;
    }   

}