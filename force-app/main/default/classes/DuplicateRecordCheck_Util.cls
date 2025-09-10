/**
 * Copied from unOfficial Salesforce: https://github.com/UnofficialSF/LightningFlowComponents
 * license information below

Copyright (c) 2018, Salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of Salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
                 
This license applies to all code in this LightningFlowComponents repository.

 * 
**/
public with sharing class DuplicateRecordCheck_Util {
    private final FindDuplicates findDuplicates;

    private DuplicateRecordCheck_Util(){
        FindDuplicatesFactory factory = FindDuplicatesFactory.getFactory();
        this.findDuplicates = factory.getFindDuplicates();
    }

    private static DuplicateRecordCheck_Util self = new DuplicateRecordCheck_Util();

    /**
    * @description Runs the duplicate rules on a particular record(s) to see if a duplicate record(s) exists.
    * @param List<Input> inputs 
    * @return List<Duplicate> 
    **/
    public static List<Duplicate> findDuplicates(List<sObject> records){
        // The documentation states that the max input array for the findDuplicates method is 50.
        // We are instantiating a new list to house the results in case we have to execute the method multiple times.
        List<FindDuplicates.FindDuplicatesResult> results = new List<FindDuplicates.FindDuplicatesResult>();
        List<sObject> listsObjectsToCheck = new List<sObject>();
        for(sObject record : records){
            listsObjectsToCheck.add(record);
            
            // Check to see if the list size equals 50.
            // If so, execute the findDuplicates method and clear the list.
            if(listsObjectsToCheck.size() == 50){
                results.addAll(self.findDuplicates.findDuplicates(listsObjectsToCheck));
                listsObjectsToCheck.clear();
            }
        }

        // Execute the findDuplicates method a final time.
        if(!listsObjectsToCheck.isEmpty()){
            results.addAll(self.findDuplicates.findDuplicates(listsObjectsToCheck));
        }

        // The mapIndexToDuplicate is a map where the key is the index and the value is the best Duplicate result (if any exist).
        Integer index = 0;
        Map<Integer,Duplicate> mapIndexToDuplicate = new Map<Integer,Duplicate>();
        for(FindDuplicates.FindDuplicatesResult find : results) {
            // Add the default Duplicate to the map, which is simply Duplicate.isDuplicate = FALSE.
            mapIndexToDuplicate.put(index,new Duplicate(FALSE,null,null,null));
            for(FindDuplicates.DuplicateResult result : find.getDuplicateResults) {
                // result has a bunch of information about the Duplicate Rule being applied.
                for(FindDuplicates.MatchResult match : result.getMatchResults) {
                    // match has a bunch of information about the Matching Rule being applied.
                    
                    // Instantiate a new list of Duplicates with the Duplicate from the map.
                    List<Duplicate> duplicates = new List<Duplicate>{mapIndexToDuplicate.get(index)};
                    for(FindDuplicates.MatchRecord record : match.getMatchRecords) {
                        Id recordId = record.getRecordId;
                        Double matchConfidence = record.getMatchConfidence == null ? 0 : record.getMatchConfidence;
                        String sObjectType = recordId.getSObjectType().getDescribe().getName();
                        duplicates.add(new Duplicate(TRUE,recordId,sObjectType,matchConfidence));
                    }
                    
                    // The Duplicate object implements the Comparable interface, so we are sorting the list in a specific way.
                    // The best Duplicate is the first object from the list because it has the highest matchConfidence.
                    duplicates.sort();
                    mapIndexToDuplicate.put(index,duplicates.remove(0));
                }
            }
            index++;
        }

        return mapIndexToDuplicate.values();
    }
}
