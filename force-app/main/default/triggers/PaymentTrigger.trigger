trigger PaymentTrigger on Payment__c (after insert, after update) {
    if (Trigger.isAfter) {
        PaymentTriggerHandler.handleAfterInsertOrUpdate(
            Trigger.new, 
            Trigger.oldMap, 
            Trigger.isInsert, 
            Trigger.isUpdate
        );
    }
}