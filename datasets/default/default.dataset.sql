BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id VARCHAR(255) NOT NULL, 
	"AccountNumber" VARCHAR(255), 
	"AccountSource" VARCHAR(255), 
	"AnnualRevenue" VARCHAR(255), 
	"BillingCity" VARCHAR(255), 
	"BillingCountry" VARCHAR(255), 
	"BillingGeocodeAccuracy" VARCHAR(255), 
	"BillingLatitude" VARCHAR(255), 
	"BillingLongitude" VARCHAR(255), 
	"BillingPostalCode" VARCHAR(255), 
	"BillingState" VARCHAR(255), 
	"BillingStreet" VARCHAR(255), 
	"CleanStatus" VARCHAR(255), 
	"Description" VARCHAR(255), 
	"DunsNumber" VARCHAR(255), 
	"Fax" VARCHAR(255), 
	"First_Membership_Start_Date__c" VARCHAR(255), 
	"Industry" VARCHAR(255), 
	"Jigsaw" VARCHAR(255), 
	"Last_Membership_Start_Date__c" VARCHAR(255), 
	"Membership_End_Date__c" VARCHAR(255), 
	"Membership_Status__c" VARCHAR(255), 
	"Membership_Type__c" VARCHAR(255), 
	"NaicsCode" VARCHAR(255), 
	"NaicsDesc" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"NumberOfEmployees" VARCHAR(255), 
	"Ownership" VARCHAR(255), 
	"Phone" VARCHAR(255), 
	"Rating" VARCHAR(255), 
	"ShippingCity" VARCHAR(255), 
	"ShippingCountry" VARCHAR(255), 
	"ShippingGeocodeAccuracy" VARCHAR(255), 
	"ShippingLatitude" VARCHAR(255), 
	"ShippingLongitude" VARCHAR(255), 
	"ShippingPostalCode" VARCHAR(255), 
	"ShippingState" VARCHAR(255), 
	"ShippingStreet" VARCHAR(255), 
	"Sic" VARCHAR(255), 
	"SicDesc" VARCHAR(255), 
	"Site" VARCHAR(255), 
	"TickerSymbol" VARCHAR(255), 
	"Tradestyle" VARCHAR(255), 
	"Type" VARCHAR(255), 
	"Website" VARCHAR(255), 
	"YearStarted" VARCHAR(255), 
	"DandbCompanyId" VARCHAR(255), 
	"OperatingHoursId" VARCHAR(255), 
	"ParentId" VARCHAR(255), 
	"Primary_Membership__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES('Account-1','','','','','','','','','','','','Pending','','','','','','','','','','','','','Existing Account','','','','','','','','','','','','','','','','','','','','','','','Account-2','');
INSERT INTO "Account" VALUES('Account-2','','','','','','','','','','','','Pending','','','','','','','','','','','','','Existing Parent Account','','','','','','','','','','','','','','','','','','','','','','','','');
CREATE TABLE "Contact" (
	id VARCHAR(255) NOT NULL, 
	"AssistantName" VARCHAR(255), 
	"AssistantPhone" VARCHAR(255), 
	"Birthdate" VARCHAR(255), 
	"CleanStatus" VARCHAR(255), 
	"Department" VARCHAR(255), 
	"Description" VARCHAR(255), 
	"DoNotCall" VARCHAR(255), 
	"Email" VARCHAR(255), 
	"EmailBouncedDate" VARCHAR(255), 
	"EmailBouncedReason" VARCHAR(255), 
	"Fax" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"First_Membership_Start_Date__c" VARCHAR(255), 
	"GenderIdentity" VARCHAR(255), 
	"HasOptedOutOfEmail" VARCHAR(255), 
	"HasOptedOutOfFax" VARCHAR(255), 
	"HomePhone" VARCHAR(255), 
	"Jigsaw" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"Last_Membership_Start_Date__c" VARCHAR(255), 
	"LeadSource" VARCHAR(255), 
	"MailingCity" VARCHAR(255), 
	"MailingCountry" VARCHAR(255), 
	"MailingGeocodeAccuracy" VARCHAR(255), 
	"MailingLatitude" VARCHAR(255), 
	"MailingLongitude" VARCHAR(255), 
	"MailingPostalCode" VARCHAR(255), 
	"MailingState" VARCHAR(255), 
	"MailingStreet" VARCHAR(255), 
	"Membership_End_Date__c" VARCHAR(255), 
	"Membership_Status__c" VARCHAR(255), 
	"Membership_Type__c" VARCHAR(255), 
	"MobilePhone" VARCHAR(255), 
	"OtherCity" VARCHAR(255), 
	"OtherCountry" VARCHAR(255), 
	"OtherGeocodeAccuracy" VARCHAR(255), 
	"OtherLatitude" VARCHAR(255), 
	"OtherLongitude" VARCHAR(255), 
	"OtherPhone" VARCHAR(255), 
	"OtherPostalCode" VARCHAR(255), 
	"OtherState" VARCHAR(255), 
	"OtherStreet" VARCHAR(255), 
	"Phone" VARCHAR(255), 
	"Pronouns" VARCHAR(255), 
	"Salutation" VARCHAR(255), 
	"Title" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	"IndividualId" VARCHAR(255), 
	"ReportsToId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES('Contact-1','','','','Pending','','','False','email@email.com','','','','Member','','','False','False','','','Testerson','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
CREATE TABLE "DandBCompany" (
	id VARCHAR(255) NOT NULL, 
	"DunsNumber" VARCHAR(255), 
	"Name" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Individual" (
	id VARCHAR(255) NOT NULL, 
	"LastName" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Membership__c" (
	id VARCHAR(255) NOT NULL, 
	PRIMARY KEY (id)
);
CREATE TABLE "OperatingHours" (
	id VARCHAR(255) NOT NULL, 
	"Name" VARCHAR(255), 
	"TimeZone" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Product2" (
	id VARCHAR(255) NOT NULL, 
	"Description" VARCHAR(255), 
	"DisplayUrl" VARCHAR(255), 
	"ExternalId" VARCHAR(255), 
	"Family" VARCHAR(255), 
	"Grace_Period__c" VARCHAR(255), 
	"IsActive" VARCHAR(255), 
	"IsSerialized" VARCHAR(255), 
	"Membership_Tier__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"ProductCode" VARCHAR(255), 
	"QuantityUnitOfMeasure" VARCHAR(255), 
	"Renewal_Option__c" VARCHAR(255), 
	"StockKeepingUnit" VARCHAR(255), 
	"Term_Unit__c" VARCHAR(255), 
	"Term__c" VARCHAR(255), 
	"Downgrade_Path__c" VARCHAR(255), 
	"Upgrade_Path__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Product2" VALUES('Product2-1','','','','','','True','False','','Basic Membership','','','One-Time','BSC','Year','1.0','','Product2-2');
INSERT INTO "Product2" VALUES('Product2-2','','','','','','True','False','','Standard Membership','','','One-Time','STD','Year','1.0','Product2-1','Product2-5');
INSERT INTO "Product2" VALUES('Product2-3','','','','','','True','False','','Family Membership','','','One-Time','FAM','Year','1.0','','');
INSERT INTO "Product2" VALUES('Product2-4','','','','','','True','False','','Youth Membership','','','One-Time','YTH','Year','1.0','','Product2-2');
INSERT INTO "Product2" VALUES('Product2-5','','','','','','True','False','','Premier Membership','','','One-Time','PMR','Year','1.0','Product2-2','');
COMMIT;
