@istest(seealldata=true)
public class knowledgeArticleWrapperPDFTest{
    
    static testMethod void testmethod1()
    {
        List<KnowledgeArticleVersion>  lkav=new List<KnowledgeArticleVersion>();
        list<knowledgearticlewrapperpdf> lkap= new list <knowledgearticlewrapperpdf> ();
            lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Known_Issue__kav' limit 10];
        lkap=QueryKnowledgeArticleListUtilityPDF.createList(lkav,'known_issue');
        if(lkap.size()>0)
        { 
            for(knowledgearticlewrapperpdf kp: lkap)
            {
                Datetime dt=kp.lastPublishedDate;
                string dat=kp.dataCategories;
                string versionsPDF=kp.versionsPDF;
                
            }
            lkap.sort();
        }
    }

}