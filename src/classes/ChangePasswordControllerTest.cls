@isTest(seeallData=True)

public Without Sharing class ChangePasswordControllerTest
{
    public static TestMethod void testMethod1()
    {
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        System.assertEquals(controller.changePassword(),null);  
                             
    }
}