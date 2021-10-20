BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"Description" VARCHAR(255), 
	"BillingStreet" VARCHAR(255), 
	"BillingCity" VARCHAR(255), 
	"BillingState" VARCHAR(255), 
	"BillingPostalCode" VARCHAR(255), 
	"BillingCountry" VARCHAR(255), 
	"Phone" VARCHAR(255), 
	"Fax" VARCHAR(255), 
	"Website" VARCHAR(255), 
	"NumberOfEmployees" VARCHAR(255), 
	"AccountNumber" VARCHAR(255), 
	"Site" VARCHAR(255), 
	"Type" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES(1,'Test Organisation','','13th Street. 47 W 13th St','New York','NY','10011','United States','','','','','','','');
INSERT INTO "Account" VALUES(2,'Trust Foundation','','','','','','','','','','','','','');
CREATE TABLE "Contact" (
	id INTEGER NOT NULL, 
	"Salutation" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"Email" VARCHAR(255), 
	"Phone" VARCHAR(255), 
	"MobilePhone" VARCHAR(255), 
	"OtherPhone" VARCHAR(255), 
	"HomePhone" VARCHAR(255), 
	"Title" VARCHAR(255), 
	"Birthdate" VARCHAR(255), 
	"MailingStreet" VARCHAR(255), 
	"MailingCity" VARCHAR(255), 
	"MailingState" VARCHAR(255), 
	"MailingPostalCode" VARCHAR(255), 
	"MailingCountry" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES(1,'','Test','Contact','','','','','','','','','','','','','2');
INSERT INTO "Contact" VALUES(2,'Mr.','John','Smith','','','','','','','','','','','','','1');
INSERT INTO "Contact" VALUES(3,'Ms.','Jane','Smith','','','','','','','','','','','','','1');
CREATE TABLE "Membership_Contact_Role__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"Does_Not_Expire__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Is_Primary__c" VARCHAR(255), 
	"Role__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Contact__c" VARCHAR(255), 
	"Membership__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Membership_Contact_Role__c" VALUES(1,'Primary Member','False','','True','Employee','2021-05-21','Current','Corporate','2','1');
INSERT INTO "Membership_Contact_Role__c" VALUES(2,'Primary Member','False','','True','Employee','2021-05-21','Current','Corporate','1','2');
INSERT INTO "Membership_Contact_Role__c" VALUES(3,'Seconday Member','False','','False','Employee','2021-05-21','Current','Corporate','3','1');
CREATE TABLE "Membership__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"Does_Not_Expire__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Origin__c" VARCHAR(255), 
	"Primary__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Account__c" VARCHAR(255), 
	"Primary_Contact__c" VARCHAR(255), 
	"Opportunity__c" VARCHAR(255), 
	"Product__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Membership__c" VALUES(1,'Test Organisation Membership','False','2020-05-20','New','False','2021-05-21','Current','Corporate','1','2','2','3');
INSERT INTO "Membership__c" VALUES(2,'Trust Foundation Membership','False','2022-05-20','New','False','2021-05-21','Current','','2','1','1','1');
CREATE TABLE "Opportunity" (
	id INTEGER NOT NULL, 
	"Amount" VARCHAR(255), 
	"CloseDate" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"StageName" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Opportunity" VALUES(1,'100.0','2021-05-20','Trust Foundation Membership Opportunity','Closed Won','2');
INSERT INTO "Opportunity" VALUES(2,'200.0','2021-05-20','Test Organisation Membership','Closed Won','1');
CREATE TABLE "Pricebook2" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"IsActive" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Pricebook2" VALUES(1,'Standard Price Book','True');
CREATE TABLE "Product2" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"IsActive" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Product2" VALUES(1,'Bronze Membership','True');
INSERT INTO "Product2" VALUES(2,'Gold Membership','True');
INSERT INTO "Product2" VALUES(3,'Silver Membership','True');
COMMIT;
