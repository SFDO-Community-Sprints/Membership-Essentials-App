// TODO(flow-migration): Invokes ContactHandler on Contact trigger events to manage Membership_Contact_Role__c records when Contacts join or leave Accounts.
trigger ContactTrigger on Contact (
    before insert, after insert,
    before update, after update,
    before delete, after delete,
    after undelete) {
    new ContactHandler().run();
}