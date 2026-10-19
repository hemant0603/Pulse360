
public with sharing class ExpiringMembershipsController {

    @AuraEnabled(cacheable=true)
    public static List<Enrollment__c> getExpiringEnrollments() {

        Date today = Date.today();
        Date inSevenDays = today.addDays(7);

        return [
            SELECT Id, Member__c, End_Date__c, Member__r.Name, Member__r.Phone__c, Membership_Plan__r.Name
            FROM Enrollment__c
            WHERE End_Date__c >= :today AND End_Date__c <= :inSevenDays AND Status__c != 'Cancelled'
            WITH USER_MODE
            ORDER BY End_Date__c ASC
            LIMIT 100
        ];
    }
}
