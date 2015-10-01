@isTest
private class ArticleScheduleTest{
    static testMethod void arsTest() {
        test.starttest();
        ArticleSchedule artsch = new ArticleSchedule();
        String schedule = '0 0 23 * * ?';
        system.schedule('Article Schedule', schedule, artsch);
        test.stoptest();
    }
}