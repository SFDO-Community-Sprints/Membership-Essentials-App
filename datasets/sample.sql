BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id INTEGER NOT NULL, 
	"First_Membership_Start_Date__c" VARCHAR(255), 
	"Last_Membership_Start_Date__c" VARCHAR(255), 
	"Membership_End_Date__c" VARCHAR(255), 
	"Membership_Status__c" VARCHAR(255), 
	"Membership_Type__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"ParentId" VARCHAR(255), 
	"Primary_Membership__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES(1,'2023-02-15','','2024-02-15','Current','Individual','Vickie Bowers Household','','');
INSERT INTO "Account" VALUES(2,'2022-11-15','','2023-11-15','Former','Individual','Doris Lam Household','','');
INSERT INTO "Account" VALUES(3,'2023-03-22','','2024-03-22','Current','Corporate','Zavala-Mcclure','','');
INSERT INTO "Account" VALUES(4,'2022-03-31','','2023-03-31','Lapsed','Corporate','Hoffman Ltd','','');
INSERT INTO "Account" VALUES(5,'2022-06-22','','2023-06-22','Lapsed','Corporate','Blackburn-Fleming','','7');
INSERT INTO "Account" VALUES(6,'2022-10-01','','2023-10-01','Former','Individual','Kelsey Lewis Household','','8');
INSERT INTO "Account" VALUES(7,'2022-12-29','','2023-12-29','Current','Corporate','Hays, Gonzales and Berry','','4');
INSERT INTO "Account" VALUES(8,'2022-08-16','','2023-08-16','Current','Individual','Autumn Leach Household','','5');
INSERT INTO "Account" VALUES(9,'2023-01-04','','2024-01-04','Current','Individual','Nathaniel Nichols Household','','19');
INSERT INTO "Account" VALUES(10,'2022-07-29','','2023-07-29','Former','Individual','Kathy Cole Household','','');
INSERT INTO "Account" VALUES(11,'2022-08-03','','2023-08-03','Former','Corporate','Olson LLC','','15');
INSERT INTO "Account" VALUES(12,'2022-10-26','','2023-10-26','Former','Corporate','Frazier, Pugh and Whitaker','','9');
INSERT INTO "Account" VALUES(13,'2022-04-20','','2023-04-20','Current','Corporate','Rice, Harrell and Cole','','');
INSERT INTO "Account" VALUES(14,'2022-07-02','','2023-07-02','Current','Corporate','Hinton Ltd','','10');
INSERT INTO "Account" VALUES(15,'2022-04-02','','2023-04-02','Former','Corporate','Middleton, Keller and Robbins','','');
INSERT INTO "Account" VALUES(16,'','','','','','Sample Account for Entitlements','','');
CREATE TABLE "Contact" (
	id INTEGER NOT NULL, 
	"DoNotCall" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"First_Membership_Start_Date__c" VARCHAR(255), 
	"HasOptedOutOfEmail" VARCHAR(255), 
	"HasOptedOutOfFax" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"Last_Membership_Start_Date__c" VARCHAR(255), 
	"Membership_End_Date__c" VARCHAR(255), 
	"Membership_Status__c" VARCHAR(255), 
	"Membership_Type__c" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	"ReportsToId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES(1,'False','Edwin','2023-03-22','False','False','Williamson','2023-03-22','2024-03-22','Current','Corporate','3','');
INSERT INTO "Contact" VALUES(2,'False','Gabrielle','2022-03-31','False','False','Schneider','2022-03-31','2023-03-31','Lapsed','Corporate','4','');
INSERT INTO "Contact" VALUES(3,'False','Rebecca','2022-04-02','False','False','Cisneros','2022-04-02','2023-04-02','Former','Corporate','15','');
INSERT INTO "Contact" VALUES(4,'False','Jesus','2022-06-22','False','False','Montes','2022-06-22','2023-06-22','Lapsed','Corporate','5','');
INSERT INTO "Contact" VALUES(5,'False','Kelsey','2022-10-01','False','False','Lewis','2022-10-01','2023-10-01','Former','Individual','6','');
INSERT INTO "Contact" VALUES(6,'False','Miguel','2022-10-26','False','False','Dudley','2022-10-26','2023-10-26','Former','Corporate','12','');
INSERT INTO "Contact" VALUES(7,'False','Terrance','2022-04-20','False','False','Holloway','2022-04-20','2023-04-20','Current','Corporate','13','');
INSERT INTO "Contact" VALUES(8,'False','Kristine','2022-07-02','False','False','Sandoval','2022-07-02','2023-07-02','Current','Corporate','14','');
INSERT INTO "Contact" VALUES(9,'False','Wyatt','2022-08-03','False','False','Levy','2022-08-03','2023-08-03','Former','Corporate','11','');
INSERT INTO "Contact" VALUES(10,'False','Heather','2022-12-29','False','False','Moon','2022-12-29','2023-12-29','Current','Corporate','7','');
INSERT INTO "Contact" VALUES(11,'False','Autumn','2022-08-16','False','False','Leach','2022-08-16','2023-08-16','Current','Individual','8','');
INSERT INTO "Contact" VALUES(12,'False','Nathaniel','2023-01-04','False','False','Nichols','2023-01-04','2024-01-04','Current','Individual','9','');
INSERT INTO "Contact" VALUES(13,'False','Vickie','2023-02-15','False','False','Bowers','2023-02-15','2024-02-15','Current','Individual','1','');
INSERT INTO "Contact" VALUES(14,'False','Doris','2022-11-15','False','False','Lam','2022-11-15','2023-11-15','Former','Individual','2','');
INSERT INTO "Contact" VALUES(15,'False','Kathy','2022-07-29','False','False','Cole','2022-07-29','2023-07-29','Former','Individual','10','');
CREATE TABLE "Membership_Contact_Role__c" (
	id INTEGER NOT NULL, 
	"Does_Not_Expire__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Is_Primary__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"Role__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Contact__c" VARCHAR(255), 
	"Membership__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Membership__c" (
	id INTEGER NOT NULL, 
	"Does_Not_Expire__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"Origin__c" VARCHAR(255), 
	"Primary__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Account__c" VARCHAR(255), 
	"Opportunity__c" VARCHAR(255), 
	"Primary_Contact__c" VARCHAR(255), 
	"Product__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Membership__c" VALUES(1,'False','2023-04-02','Cole Taylor Household-Individual Membership','Renewed','True','2022-04-02','Current','Individual','','','','');
INSERT INTO "Membership__c" VALUES(2,'False','2023-07-05','Whitney Singh Household-Individual Membership','Reacquired','True','2022-07-05','Former','Individual','','','','');
INSERT INTO "Membership__c" VALUES(3,'False','2024-01-07','Ryan Inc-Corporate Membership','New','True','2023-01-07','Former','Corporate','','','','');
INSERT INTO "Membership__c" VALUES(4,'False','2023-12-29','Hays, Gonzales and Berry-Corporate Membership','Reacquired','True','2022-12-29','Renewal','Corporate','7','','','');
INSERT INTO "Membership__c" VALUES(5,'False','2023-08-16','Autumn Leach Household-Individual Membership','New','True','2022-08-16','Renewal','Individual','8','','','');
INSERT INTO "Membership__c" VALUES(6,'False','2023-04-20','Rice, Harrell and Cole-Corporate Membership','Renewed','True','2022-04-20','Lapsed','Corporate','13','','','');
INSERT INTO "Membership__c" VALUES(7,'False','2023-06-22','Blackburn-Fleming-Corporate Membership','Renewed','True','2022-06-22','Renewal','Corporate','5','','','');
INSERT INTO "Membership__c" VALUES(8,'False','2023-10-01','Kelsey Lewis Household-Individual Membership','New','True','2022-10-01','Renewal','Individual','6','','','');
INSERT INTO "Membership__c" VALUES(9,'False','2023-10-26','Frazier, Pugh and Whitaker-Corporate Membership','New','True','2022-10-26','Renewal','Corporate','12','','','');
INSERT INTO "Membership__c" VALUES(10,'False','2023-07-02','Hinton Ltd-Corporate Membership','New','True','2022-07-02','Current','Corporate','14','','','');
INSERT INTO "Membership__c" VALUES(11,'False','2023-04-02','Middleton, Keller and Robbins-Corporate Membership','Reacquired','True','2022-04-02','Former','Corporate','15','','','');
INSERT INTO "Membership__c" VALUES(12,'False','2023-04-02','Latoya Cunningham Household-Individual Membership','Renewed','True','2022-04-02','Former','Individual','','','','');
INSERT INTO "Membership__c" VALUES(13,'False','2023-07-18','Olivia Gregory Household-Individual Membership','New','True','2022-07-18','Lapsed','Individual','','','','');
INSERT INTO "Membership__c" VALUES(14,'False','2023-07-29','Kathy Cole Household-Individual Membership','New','True','2022-07-29','Former','Individual','10','','','');
INSERT INTO "Membership__c" VALUES(15,'False','2023-08-03','Olson LLC-Corporate Membership','New','True','2022-08-03','Renewal','Corporate','11','','','');
INSERT INTO "Membership__c" VALUES(16,'False','2023-08-18','Beltran, Hebert and Hill-Corporate Membership','Renewed','True','2022-08-18','Renewal','Corporate','','','','');
INSERT INTO "Membership__c" VALUES(17,'False','2023-11-16','Bond-Lin-Corporate Membership','New','True','2022-11-16','Current','Corporate','','','','');
INSERT INTO "Membership__c" VALUES(18,'False','2024-02-11','Glen Crosby Household-Individual Membership','Reacquired','True','2023-02-11','Lapsed','Individual','','','','');
INSERT INTO "Membership__c" VALUES(19,'False','2024-01-04','Nathaniel Nichols Household-Individual Membership','New','True','2023-01-04','Renewal','Individual','9','','','');
INSERT INTO "Membership__c" VALUES(20,'False','2024-02-15','Vickie Bowers Household-Individual Membership','Reacquired','True','2023-02-15','Former','Individual','1','','','');
INSERT INTO "Membership__c" VALUES(21,'False','2023-11-15','Doris Lam Household-Individual Membership','Renewed','True','2022-11-15','Former','Individual','2','','','');
INSERT INTO "Membership__c" VALUES(22,'False','2024-03-22','Zavala-Mcclure-Corporate Membership','New','True','2023-03-22','Lapsed','Corporate','3','','','');
INSERT INTO "Membership__c" VALUES(23,'False','2023-03-31','Hoffman Ltd-Corporate Membership','Renewed','True','2022-03-31','Former','Corporate','4','','','');
INSERT INTO "Membership__c" VALUES(24,'False','2023-07-24','Jodi Castro Household-Individual Membership','New','True','2022-07-24','Former','Individual','','','','');
INSERT INTO "Membership__c" VALUES(25,'False','2023-08-17','Andre Smith Household-Individual Membership','Renewed','True','2022-08-17','Former','Individual','','','','');
CREATE TABLE "Opportunity" (
	id INTEGER NOT NULL, 
	"CloseDate" VARCHAR(255), 
	"IsPrivate" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"StageName" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	"ContactId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Opportunity" VALUES(1,'2022-07-29','False','Kathy Cole Household-Membership-2022-07-29','Closed Won','10','');
INSERT INTO "Opportunity" VALUES(2,'2022-08-03','False','Olson LLC-Membership-2022-08-03','Closed Won','11','');
INSERT INTO "Opportunity" VALUES(3,'2022-12-29','False','Hays, Gonzales and Berry-Membership-2022-12-29','Closed Won','7','');
INSERT INTO "Opportunity" VALUES(4,'2022-08-16','False','Autumn Leach Household-Membership-2022-08-16','Closed Won','8','');
INSERT INTO "Opportunity" VALUES(5,'2022-10-01','False','Kelsey Lewis Household-Membership-2022-10-01','Closed Won','6','');
INSERT INTO "Opportunity" VALUES(6,'2023-03-22','False','Zavala-Mcclure-Membership-2023-03-22','Closed Won','3','');
INSERT INTO "Opportunity" VALUES(7,'2022-03-31','False','Hoffman Ltd-Membership-2022-03-31','Closed Won','4','');
INSERT INTO "Opportunity" VALUES(8,'2023-01-04','False','Nathaniel Nichols Household-Membership-2023-01-04','Closed Won','9','');
INSERT INTO "Opportunity" VALUES(9,'2023-02-15','False','Vickie Bowers Household-Membership-2023-02-15','Closed Won','1','');
INSERT INTO "Opportunity" VALUES(10,'2022-11-15','False','Doris Lam Household-Membership-2022-11-15','Closed Won','2','');
INSERT INTO "Opportunity" VALUES(11,'2022-10-26','False','Frazier, Pugh and Whitaker-Membership-2022-10-26','Closed Won','12','');
INSERT INTO "Opportunity" VALUES(12,'2022-04-20','False','Rice, Harrell and Cole-Membership-2022-04-20','Closed Won','13','');
INSERT INTO "Opportunity" VALUES(13,'2022-07-02','False','Hinton Ltd-Membership-2022-07-02','Closed Won','14','');
INSERT INTO "Opportunity" VALUES(14,'2022-04-02','False','Middleton, Keller and Robbins-Membership-2022-04-02','Closed Won','15','');
INSERT INTO "Opportunity" VALUES(15,'2022-06-22','False','Blackburn-Fleming-Membership-2022-06-22','Closed Won','5','');
CREATE TABLE "OpportunityLineItem" (
	id INTEGER NOT NULL, 
	"Quantity" VARCHAR(255), 
	"Membership__c" VARCHAR(255), 
	"OpportunityId" VARCHAR(255), 
	"Product2Id" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "OpportunityLineItem" VALUES(1,'1.0','7','15','3');
INSERT INTO "OpportunityLineItem" VALUES(2,'1.0','8','5','1');
INSERT INTO "OpportunityLineItem" VALUES(3,'1.0','22','6','3');
INSERT INTO "OpportunityLineItem" VALUES(4,'1.0','23','7','3');
INSERT INTO "OpportunityLineItem" VALUES(5,'1.0','19','8','1');
INSERT INTO "OpportunityLineItem" VALUES(6,'1.0','4','3','3');
INSERT INTO "OpportunityLineItem" VALUES(7,'1.0','5','4','1');
INSERT INTO "OpportunityLineItem" VALUES(8,'1.0','20','9','1');
INSERT INTO "OpportunityLineItem" VALUES(9,'1.0','21','10','1');
INSERT INTO "OpportunityLineItem" VALUES(10,'1.0','14','1','1');
INSERT INTO "OpportunityLineItem" VALUES(11,'1.0','15','2','3');
INSERT INTO "OpportunityLineItem" VALUES(12,'1.0','9','11','3');
INSERT INTO "OpportunityLineItem" VALUES(13,'1.0','6','12','3');
INSERT INTO "OpportunityLineItem" VALUES(14,'1.0','10','13','3');
INSERT INTO "OpportunityLineItem" VALUES(15,'1.0','11','14','3');
CREATE TABLE "Product2" (
	id INTEGER NOT NULL, 
	"IsActive" VARCHAR(255), 
	"IsSerialized" VARCHAR(255), 
	"Name" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Product2" VALUES(1,'False','False','Individual Membership');
INSERT INTO "Product2" VALUES(2,'False','False','Houshold Membership');
INSERT INTO "Product2" VALUES(3,'False','False','Corporate Membership');
COMMIT;
