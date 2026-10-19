@IsTest
private class SessionCapacityTriggerTest {
    @TestSetup
    static void setupData() {
        Gym__c gym = new Gym__c(Name = 'Test Gym');
        insert gym;

        Trainer__c trainer = new Trainer__c(
            Name = 'Test Trainer',
            Gym__c = gym.Id
        );
        insert trainer;

        Member__c member = new Member__c(
            Name = 'Test Member',
            Phone__c = '9876543210'
        );
        insert member;

        Training_Session__c session = new Training_Session__c(
            Name = 'Morning Workout',
            Trainer__c = trainer.Id,
            Max_Capacity__c = 2
        );
        insert session;
    }

    @IsTest
    static void testBookingWhenSpaceAvailable() {
        Member__c member = [SELECT Id FROM Member__c LIMIT 1];
        Training_Session__c session = [SELECT Id FROM Training_Session__c LIMIT 1];

        Session_Booking__c booking = new Session_Booking__c(
            Member__c = member.Id,
            Training_Session__c = session.Id
        );

        Test.startTest();
        insert booking;
        Test.stopTest();

        Assert.areNotEqual(null, booking.Id, 'Booking record creation failed when capacity was available.');
    }

    @IsTest
    static void testBookingWhenSessionIsFull() {
        Member__c member = [SELECT Id FROM Member__c LIMIT 1];
        Training_Session__c session = [SELECT Id, Max_Capacity__c FROM Training_Session__c LIMIT 1];

        session.Max_Capacity__c = 0;
        update session;

        Session_Booking__c booking = new Session_Booking__c(
            Member__c = member.Id,
            Training_Session__c = session.Id
        );

        Test.startTest();
       
        Database.SaveResult result = Database.insert(booking, false);
        Test.stopTest();
 
        Assert.isFalse(result.isSuccess(), 'The transaction should have failed due to max capacity constraint.');
        Assert.areEqual('This session is fully booked.', result.getErrors()[0].getMessage(), 'The validation message did not match expectations.');
    }
}
