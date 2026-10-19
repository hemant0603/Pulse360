@IsTest
private class PaymentTriggerTest {
    @TestSetup
    static void setupData() {
        Gym__c gym = new Gym__c(Name = 'Test Gym');
        insert gym;

        Member__c member = new Member__c(
            Name = 'Test Member',
            Gym__c = gym.Id,
            Phone__c = '9876543210'
        );
        insert member;

        Membership_Plan__c plan = new Membership_Plan__c(
            Name = 'Monthly Plan',
            Price__c = 1000,
            Duration__c = 1,
            Plan_Type__c = 'Monthly'
        );
        insert plan;

        Enrollment__c enrollment = new Enrollment__c(
            Name = 'Test Enrollment',
            Member__c = member.Id,
            Membership_Plan__c = plan.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addMonths(1),
            Status__c = 'Cancelled'
        );
        insert enrollment;
    }

    @IsTest
    static void testPaidPaymentOnInsert() {
        Member__c member = [SELECT Id FROM Member__c LIMIT 1];
        Enrollment__c enrollment = [SELECT Id FROM Enrollment__c LIMIT 1];

        Payment__c payment = new Payment__c(
            Name = 'Paid Payment',
            Member__c = member.Id,
            Enrollment__c = enrollment.Id,
            Amount__c = 1000,
            Payment_Status__c = 'Paid'
        );

        Test.startTest();
        insert payment;
        Test.stopTest();

        Enrollment__c updatedEnrollment = [SELECT Status__c FROM Enrollment__c WHERE Id = :enrollment.Id];
        Assert.areEqual('Active', updatedEnrollment.Status__c, 'Enrollment status did not transition to Active on insert.');
    }

    @IsTest
    static void testPaymentStatusChangedToPaid() {
        Member__c member = [SELECT Id FROM Member__c LIMIT 1];
        Enrollment__c enrollment = [SELECT Id FROM Enrollment__c LIMIT 1];

        Payment__c payment = new Payment__c(
            Name = 'Pending Payment',
            Member__c = member.Id,
            Enrollment__c = enrollment.Id,
            Amount__c = 1000,
            Payment_Status__c = 'Pending'
        );
        insert payment;

        Enrollment__c enrollmentBeforeUpdate = [SELECT Status__c FROM Enrollment__c WHERE Id = :enrollment.Id];
        Assert.areEqual('Cancelled', enrollmentBeforeUpdate.Status__c, 'Enrollment should remain Cancelled for a Pending payment.');
 
        Payment__c paymentToUpdate = [SELECT Id, Payment_Status__c, Enrollment__c FROM Payment__c WHERE Id = :payment.Id];
        paymentToUpdate.Payment_Status__c = 'Paid';

        Test.startTest();
        update paymentToUpdate;
        Test.stopTest();

        Enrollment__c updatedEnrollment = [SELECT Status__c FROM Enrollment__c WHERE Id = :enrollment.Id];
        Assert.areEqual('Active', updatedEnrollment.Status__c, 'Enrollment status did not transition to Active on update.');
    }
}
