public with sharing class PaymentTriggerHandler {

    public static void handleAfterInsertOrUpdate(List<Payment__c> newPayments, Map<Id, Payment__c> oldPaymentMap, Boolean isInsert, Boolean isUpdate) {
        Set<Id> enrollmentIds = new Set<Id>();

        for (Payment__c payment : newPayments) {
            Boolean isNewPaidPayment = isInsert && payment.Payment_Status__c == 'Paid';
            
            Boolean statusChangedToPaid = isUpdate 
                && payment.Payment_Status__c == 'Paid' 
                && oldPaymentMap != null 
                && oldPaymentMap.get(payment.Id).Payment_Status__c != 'Paid';

            if ((isNewPaidPayment || statusChangedToPaid) && payment.Enrollment__c != null) {
                enrollmentIds.add(payment.Enrollment__c);
            }
        }

        if (!enrollmentIds.isEmpty()) {
            updateEnrollmentStatusToActive(enrollmentIds);
        }
    }

    private static void updateEnrollmentStatusToActive(Set<Id> enrollmentIds) {
        List<Enrollment__c> enrollmentsToUpdate = [
            SELECT Id, Status__c 
            FROM Enrollment__c 
            WHERE Id IN :enrollmentIds
        ];

        for (Enrollment__c enrollment : enrollmentsToUpdate) {
            enrollment.Status__c = 'Active';
        }

        if (!enrollmentsToUpdate.isEmpty()) {
            update enrollmentsToUpdate;
        }
    }
}