@isTest
private class PublicKBSearchControllerTest {
static testmethod void PublicKBSearchControllerTest()
{
PublicKBSearchController controller = new PublicKBSearchController();
controller.catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                                FROM CategoryNode
                                                WHERE ParentId = Null
                                                ORDER BY MasterLabel DESC];
//controller.ArticleCategories = controller.catNodeList;
controller.product = controller.catNodeList.get(0).Id;
      controller.xythose = true;
      controller.learn = true;
      controller.angel = true;
      controller.cEVista = true;
      controller.getLearn();
      controller.setLearn(true);
      controller.setCEVista(true);
      controller.setAngel(true);
      controller.getAngel();
      controller.getCEVista();
      controller.setXythose(true);
      controller.getXythose();
      controller.setSearchText('test');
      controller.getSearchText();
       controller.getResults();
       controller.getItems();
       controller.doSearch();
       controller.Redirect();
       controller.getProduct();
       controller.setProduct('Angel');
       controller.getArticleCategories();
    //  controller.getArticleList();
     /* controller.size = 10;
      controller.pageNumber = 2;
      controller.totalPageNumber = 5;*/
}
}