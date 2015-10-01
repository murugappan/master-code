/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          OpportunityTeamMemberExtension
    @abstract       extends standard Opportunity object to override add Sales Team Members page.
    @since          2011.0715
    @discussion     Class to extend Opportunity TeamMember
*/
public without sharing class OpportunityTeamMemberExtension {  

    // Private Class variables
    private final Opportunity opportunity;
    private List<OpportunityTeamMemberWrapper> teamMemberAndAccessList;
    
    // ------------------------------------------------
    // GET/SET Methods
    // ------------------------------------------------
    public List<OpportunityTeamMemberWrapper> getTeamMemberAndAccessList() { return teamMemberAndAccessList; }
    
    public void setTeamMemberAndAccessList(List<OpportunityTeamMemberWrapper> teamMemberAndAccessList) { this.teamMemberAndAccessList = teamMemberAndAccessList; }

    //Lists the different Opportunity Access
    public List<SelectOption> getOpportunityAccessTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Read','Read Only'));
        options.add(new SelectOption('Write','Read/Write'));
        return options;
    }
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public OpportunityTeamMemberExtension(ApexPages.StandardController controller) {  
        this.opportunity = (Opportunity)controller.getRecord();
        teamMemberAndAccessList = new List<OpportunityTeamMemberWrapper>();
        for(Integer i = 0; i < 5; i++) teamMemberAndAccessList.add(new OpportunityTeamMemberWrapper(this.opportunity)); 
    }

    // ------------------------------------------------
    // NAVIGATION
    // ------------------------------------------------
    public pageReference saveOnly(){
        try {
            Boolean saveSuccess = doSave();
            if(saveSuccess == false) return null;
            
        } catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }

        PageReference opptyPage = new PageReference('/' + this.opportunity.id);
        opptyPage.setRedirect(true);
        return opptyPage;
    }

    public pageReference saveAndMore(){
        try {
            Boolean saveSuccess = doSave();
            if(saveSuccess == false ) return null;

        } catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        
        PageReference opptyPage = ApexPages.currentPage();
        opptyPage.setRedirect(true);
        return opptyPage;
    }

    public pageReference cancel(){
        PageReference opptyPage = new PageReference('/' + this.opportunity.id);
        opptyPage.setRedirect(true);
        return opptyPage;
    }



    // ------------------------------------------------
    // Private class methods
    // ------------------------------------------------
    private Boolean doSave(){
        //We need one map for the Team Members with Read Only access and Read/Write access
        Map<Id,OpportunityTeamMember> readOnlyTeamMembersToInsert = new Map<Id,OpportunityTeamMember>();
        Map<Id,OpportunityTeamMember> readWriteTeamMembersToInsert = new Map<Id,OpportunityTeamMember>();
        
        for(OpportunityTeamMemberWrapper teamMemberAndAccess:teamMemberAndAccessList)
        {
            if(teamMemberAndAccess.getOpportunityTeamMember().UserId != null)
            {
                //Role is required
                if(teamMemberAndAccess.getOpportunityTeamMember().TeamMemberRole == null) {
                    teamMemberAndAccess.getOpportunityTeamMember().TeamMemberRole.addError('You must enter a value.');
                    return false;
                }
                if(teamMemberAndAccess.getOpportunityAccess() == 'Write') readWriteTeamMembersToInsert.put(teamMemberAndAccess.getOpportunityTeamMember().UserId,teamMemberAndAccess.getOpportunityTeamMember());
                else readOnlyTeamMembersToInsert.put(teamMemberAndAccess.getOpportunityTeamMember().UserId,teamMemberAndAccess.getOpportunityTeamMember());
            }
        }
        
        insert readWriteTeamMembersToInsert.values();
        insert readOnlyTeamMembersToInsert.values();
        
        //Grant Read Write Access for selected team members
        List<OpportunityShare> opportunityShares = [SELECT Id, UserOrGroupId, OpportunityAccessLevel FROM OpportunityShare WHERE OpportunityId =: this.opportunity.Id AND UserOrGroupId IN : readWriteTeamMembersToInsert.keySet() AND RowCause = 'Team'];
        for(OpportunityShare opportunityShare:opportunityShares){
            opportunityShare.OpportunityAccessLevel = 'Edit';
        }
        update opportunityShares;
        return True;
    }


    
    // ------------------------------------------------
    // Wrapper Class for Team Members
    // ------------------------------------------------
    public class OpportunityTeamMemberWrapper
    {
        private OpportunityTeamMember teamMember;
        private String opportunityAccess;
        
        public OpportunityTeamMember getOpportunityTeamMember() { return this.teamMember; }
        public void setOpportunityTeamMember(OpportunityTeamMember teamMember) { this.teamMember=teamMember; }
    
        public String getOpportunityAccess() { return this.opportunityAccess; }
        public void setOpportunityAccess(String opportunityAccess) { this.opportunityAccess=opportunityAccess; }
        
        public OpportunityTeamMemberWrapper(Opportunity o)
        {
            this.teamMember = new OpportunityTeamMember(OpportunityId = o.Id);
            this.opportunityAccess = 'Read';
        }
    }
    
}