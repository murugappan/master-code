public class RT {
    /*
     * To Fetch a Record Type Id by API Name in Another Class Use 
     * Id id = RT.getId(#OBJECTNAME#.SObjectType, RT.Name.#RECORD_TYPE#);
     * Store the Record Type API Names In the List Below - They Can Be Any sObject Type.
     */
    public enum Name {
        
        Angel,
        Angel_Closed,
        Bb_Salesforce_Support,
        Collaborate,                
        Collaborate_Closed,
        End_User_Case_Open,
        End_User_Case_Closed,
        Learn,
        Learn_Closed,
        New_Support_Case,
        Transact,
        Transact_Closed,
        Xythos,
        Xythos_Closed,
        Known_Issue,
        Announcement,
        Moodlerooms, 
        Moodlerooms_Closed,
        Analytics,
        Analytics_closed,
        xpLor,
        xpLor_Closed
        
    }
    private static final String SEPARATOR = '::::';
    private static Map<String, Id> CACHE;
    /**
     * Get the Id that can be set on or compared with an SOBject's RecordTypeId field.
     * Backed by a cache of all record type ids for the duration of a request.
     */
    public static Id getId(SObjectType sobType, Name developerName) {
        if (CACHE == null) {
            CACHE = new Map<String, Id>();
            for (RecordType rt :  [
                    select Id, SObjectType, DeveloperName
                    from RecordType
                    where DeveloperName in :getNames()
                    ]) {
                CACHE.put(rt.SObjectType + SEPARATOR + rt.DeveloperName, rt.Id);
            }
        }
        return CACHE.get(String.valueOf(sobType) + SEPARATOR + developerName.name());
    }
    private static Set<String> getNames() {
        Set<String> names = new Set<String>();
        for (Name name : Name.values()) {
            names.add(name.name());
        }
        return names;
    }
}