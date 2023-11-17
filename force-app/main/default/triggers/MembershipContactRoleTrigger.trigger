/**
 * Created by MHumpolec on 6/30/2021.
 */

trigger MembershipContactRoleTrigger on Membership_Contact_Role__c (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {
    new MembershipContactRoleHandler().run();
}