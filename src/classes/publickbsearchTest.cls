@isTest
private class publickbsearchTest{

static testmethod void publickbsearchTest()
{


//system.currentpagereference().getParameters().put('id',cs1.id);
//ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
publickbsearch controller = new publickbsearch();        
controller.loadDefaultProduct();
controller.loadDefaultDataCategories();
controller.loadArticleTypes();

controller.updateArticleType();
controller.updateReleases();
controller.updateVersionBuild();
controller.updateSubCategory();
controller.updateTypes();
controller.updateServicePack();
controller.updateFirstFix();
controller.updateSubCategoryFinal();
controller.refreshSearchResult();
controller.loadSize();
controller.redirect();
controller.previous();
controller.next();
controller.getNextRequired();
controller.getPrevRequired();
controller.printKBSearch();
controller.exportToPDF();
controller.exportToExcel();
}  
      
}