public with sharing class LiveTranscriptTriggerHandler {
    public static Boolean hasRun {get{if (hasRun == null) return false; return hasRun;} private set;}
    public static Boolean hasAfterInsertRun {get{if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} private set;}
    public static Boolean hasBeforeInsertRun {get{if (hasBeforeInsertRun == null) return false; return hasBeforeInsertRun;} private set;}
        
        
        
    public void beforeInsert(map<id,LiveChatTranscript> newmap,list<LiveChatTranscript> newlist)
    {
        if(!hasBeforeInsertRun)
        {   
            map<id,chatcase__c> Chatcaselist= new map<id,chatcase__c>();
            set<id> Chatcaseidset= new set<id>();
            for(LiveChatTranscript lt:newlist) 
            {
                if(lt.ChatCase__c != null)
                {
                    Chatcaseidset.add(lt.chatcase__c);
                }
            }
            ChatCaseList=new map<id,chatcase__c>([Select id,(select id from cases__r),account__c from chatcase__c where id in:Chatcaseidset]);
            for(LiveChatTranscript lt:newlist)
            {
                if(ChatCaseList.keyset().contains(lt.chatcase__c))
                {
                    lt.AccountId=ChatCaseList.get(lt.chatcase__c).account__c;
                    if(ChatCaseList.get(lt.chatcase__c).cases__r != null && ChatCaseList.get(lt.chatcase__c).cases__r.size()>0)
                    {
                     lt.caseid=ChatCaseList.get(lt.chatcase__c).cases__r[0].id;
                    }
                }
            }
        }
    }   
    
    public void afterInsert(map<id,LiveChatTranscript> newmap)
    {   
        if (!hasAfterInsertRun)
        {
            map<id,enduser__c> Enduserlist = new map<id,enduser__c>();
            set<id> enduseridset= new set<id>();
            for(LiveChatTranscript lt: newmap.values())
            {
                if(lt.end_user__c != null)
                {
                    enduseridset.add(lt.end_user__c);
                }
            }
            Enduserlist=new map<id,enduser__c>([select id,Time_of_Last_Initiated_Chat__c from enduser__c where id in:enduseridset]);
            for(LiveChatTranscript lt: newmap.values())
            {
                if(Enduserlist.keyset().contains(lt.end_user__c))
                {
                    enduserlist.get(lt.end_user__c).Time_of_Last_Initiated_Chat__c=lt.StartTime;
                }
            }
            
            update(enduserlist.values());
        }
    }
       
}