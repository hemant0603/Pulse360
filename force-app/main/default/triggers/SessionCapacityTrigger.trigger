trigger SessionCapacityTrigger on Session_Booking__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        SessionCapacityTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}