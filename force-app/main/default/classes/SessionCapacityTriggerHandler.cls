public with sharing class SessionCapacityTriggerHandler {
    
    public static void handleBeforeInsert(List<Session_Booking__c> newBookings) {
        Set<Id> sessionIds = new Set<Id>();

        for (Session_Booking__c booking : newBookings) {
            if (booking.Training_Session__c != null) {
                sessionIds.add(booking.Training_Session__c);
            }
        }

        if (sessionIds.isEmpty()) {
            return;
        }

        Map<Id, Training_Session__c> sessionMap = new Map<Id, Training_Session__c>(
            [SELECT Id, Max_Capacity__c, Current_Bookings__c 
             FROM Training_Session__c 
             WHERE Id IN :sessionIds]
        );

        for (Session_Booking__c booking : newBookings) {
            Training_Session__c session = sessionMap.get(booking.Training_Session__c);
            
            if (session != null && session.Current_Bookings__c >= session.Max_Capacity__c) {
                booking.addError('This session is fully booked.');
            }
        }
    }
}