/**
 * Created by ChrisPifer on 9/24/2020.
 */

// TODO(flow-migration): Invokes MembershipHandler on Membership__c trigger events to sync Primary_Contact__c with Membership_Contact_Role__c records and roll up primary memberships.
trigger MembershipTrigger on Membership__c (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {
    new MembershipHandler().run();
}