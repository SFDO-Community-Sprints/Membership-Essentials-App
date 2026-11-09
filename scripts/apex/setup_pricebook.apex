// Org setup for Membership Essentials (issue #264). Run with: cci task run setup_pricebook --org <alias>
//
// 1. Activates the Standard Price Book.
// 2. Ensures the five sample membership products exist (matched by StockKeepingUnit).
// 3. Ensures each has an active entry in the Standard Price Book.
//
// Idempotent: a second run changes nothing. Existing products and existing entry prices are never
// overwritten, so the script is safe after load_sample_data and in orgs where data has been edited.
// Product values mirror datasets/default/default.dataset.sql; keep the two in step. The dataset
// carries each product's code in StockKeepingUnit (ProductCode is blank), and SKU is unique per
// org, so SKU is the match key.

// DPEV_Listener_Find_Price_Book_Entry looks the price book up by this exact name.
final String STANDARD_PRICEBOOK_NAME = 'Standard Price Book';

// StockKeepingUnit => { Name, Membership_Tier__c, Upgrade path code, Downgrade path code, standard price }
Map<String, List<Object>> specs = new Map<String, List<Object>>{
    'BSC' => new List<Object>{ 'Basic Membership',    3, 'STD', null,  75   },
    'STD' => new List<Object>{ 'Standard Membership', 1, 'PMR', 'BSC', 500  },
    'FAM' => new List<Object>{ 'Family Membership',   2, null,  null,  150  },
    'YTH' => new List<Object>{ 'Youth Membership',    4, 'STD', null,  50   },
    'PMR' => new List<Object>{ 'Premier Membership',  0, null,  'STD', 2500 }
};

// --- 1. Standard Price Book --------------------------------------------------------------------
List<Pricebook2> standardBooks = [SELECT Id, Name, IsActive FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
if (standardBooks.isEmpty()) {
    throw new IllegalArgumentException('setup_pricebook: this org has no standard price book.');
}
Pricebook2 standardBook = standardBooks[0];
if (standardBook.Name != STANDARD_PRICEBOOK_NAME) {
    throw new IllegalArgumentException('setup_pricebook: the standard price book is named "' + standardBook.Name
        + '", but the membership flows look it up as "' + STANDARD_PRICEBOOK_NAME + '".');
}
if (!standardBook.IsActive) {
    standardBook.IsActive = true;
    update standardBook;
}

// --- 2. Sample products ------------------------------------------------------------------------
Map<String, Product2> productsByCode = new Map<String, Product2>();
for (Product2 p : [SELECT Id, StockKeepingUnit FROM Product2 WHERE StockKeepingUnit IN :specs.keySet()]) {
    productsByCode.put(p.StockKeepingUnit, p);
}

List<Product2> newProducts = new List<Product2>();
for (String code : specs.keySet()) {
    if (productsByCode.containsKey(code)) {
        continue;
    }
    List<Object> spec = specs.get(code);
    newProducts.add(new Product2(
        Name = (String) spec[0],
        StockKeepingUnit = code,
        Family = 'Membership',
        IsActive = true,
        Membership_Tier__c = (Integer) spec[1],
        Term__c = 1,
        Term_Unit__c = 'Year',
        Renewal_Option__c = 'Renewable',
        Grace_Period__c = 30
    ));
}
if (!newProducts.isEmpty()) {
    insert newProducts;
    for (Product2 p : newProducts) {
        productsByCode.put(p.StockKeepingUnit, p);
    }

    // Paths are set only on products created here, so dataset or user values are left alone.
    List<Product2> pathUpdates = new List<Product2>();
    for (Product2 p : newProducts) {
        List<Object> spec = specs.get(p.StockKeepingUnit);
        String upgradeCode = (String) spec[2];
        String downgradeCode = (String) spec[3];
        if (upgradeCode == null && downgradeCode == null) {
            continue;
        }
        pathUpdates.add(new Product2(
            Id = p.Id,
            Upgrade_Path__c = upgradeCode == null ? null : productsByCode.get(upgradeCode).Id,
            Downgrade_Path__c = downgradeCode == null ? null : productsByCode.get(downgradeCode).Id
        ));
    }
    if (!pathUpdates.isEmpty()) {
        update pathUpdates;
    }
}

// --- 3. Standard price book entries ------------------------------------------------------------
Map<Id, PricebookEntry> entriesByProduct = new Map<Id, PricebookEntry>();
for (PricebookEntry e : [
    SELECT Id, Product2Id, IsActive FROM PricebookEntry
    WHERE Pricebook2Id = :standardBook.Id AND Product2Id IN :new Map<Id, Product2>(productsByCode.values()).keySet()
]) {
    entriesByProduct.put(e.Product2Id, e);
}

List<PricebookEntry> entriesToInsert = new List<PricebookEntry>();
List<PricebookEntry> entriesToActivate = new List<PricebookEntry>();
for (String code : specs.keySet()) {
    Product2 p = productsByCode.get(code);
    PricebookEntry existing = entriesByProduct.get(p.Id);
    if (existing == null) {
        entriesToInsert.add(new PricebookEntry(
            Pricebook2Id = standardBook.Id,
            Product2Id = p.Id,
            UnitPrice = (Integer) specs.get(code)[4],
            IsActive = true
        ));
    } else if (!existing.IsActive) {
        // The finder flow only matches active entries; the existing price is kept.
        entriesToActivate.add(new PricebookEntry(Id = existing.Id, IsActive = true));
    }
}
insert entriesToInsert;
update entriesToActivate;
