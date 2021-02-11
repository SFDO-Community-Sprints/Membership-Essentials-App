/**
 * Created by ChrisPifer on 2/10/2021.
 */

public with sharing class MembershipHandler extends TriggerHandler{
    public override void afterInsert(){
        Set<Contact> contactList = new Set<Contact>();
        Set<Account> accountList = new Set<Account>();

        for(Membership__c m : (List<Membership__c>)Trigger.new){
            //Anything we can do to prevent this running every time?!
            m.Status__c =
        }
    }

}