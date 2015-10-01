/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          OpportunityExtension
    @abstract       extends standard Opportunity object to override edit() save() methods.
    @since          2011.0715
    @discussion     Class to extend Opportunity
*/
public with sharing class OpportunityExtension {  

    // Private Class variables
    private final Opportunity opp;

    // Boolean to direct users either, to the read only view, or to the edit view.
    private boolean editMode = false;

    // ---------------- GET/SET Methods ----------------

    // Returns the view mode.
    public boolean getEditMode() {return editMode;}    

 
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public OpportunityExtension(ApexPages.StandardController controller) {  
        this.opp = (Opportunity)controller.getRecord();
    }

    // Redirects to the Edit Mode
    public pageReference edit(){
        editMode = true;
        return null;
    }

    //Redirect to the View only mode, and save the Opportunity.
    public pageReference save(){
        try {
            update opp;
            editMode = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'The Opportunity has been updated. Refreshing the main Opportunity page after closing this window will ensure all of your changes are saved.'));
        } catch(Exception e){
            ApexPages.addMessages(e);
        }
        return null;
    }
}