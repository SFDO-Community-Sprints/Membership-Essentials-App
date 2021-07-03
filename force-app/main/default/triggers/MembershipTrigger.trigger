/**
 * Created by ChrisPifer on 9/24/2020.
 */

trigger MembershipTrigger on Membership__c (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {
    new MembershipHandler().run(); 
}