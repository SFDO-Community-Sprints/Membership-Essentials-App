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
public with sharing virtual class FindDuplicates {
    
    /**
    * @description Mimics the shape of the Datacloud FindDuplicates method, and instantiates custom classes so that the results can be more easily processed.
    * @param List<SObject> records 
    * @return List<FindDuplicatesResult>
    **/
    public virtual List<FindDuplicatesResult> findDuplicates(List<SObject> records){
        try {
            List<Datacloud.FindDuplicatesResult> findDuplicateResults = Datacloud.FindDuplicates.findDuplicates(records);
            
            List<FindDuplicatesResult> results = new List<FindDuplicatesResult>();
            for(Datacloud.FindDuplicatesResult find : findDuplicateResults) {
                List<DuplicateResult> duplicateResults = new List<DuplicateResult>();
                for(Datacloud.DuplicateResult result : find.getDuplicateResults()) {
                    List<MatchResult> matchResults = new List<MatchResult>();
                    for(Datacloud.MatchResult match : result.getMatchResults()) {
                        List<MatchRecord> matchRecords = new List<MatchRecord>();
                        for(Datacloud.MatchRecord record : match.getMatchRecords()) {
                            matchRecords.add(new MatchRecord(record.getRecord().Id,record.getMatchConfidence()));
                        }
                        matchResults.add(new MatchResult(matchRecords));
                    }
                    duplicateResults.add(new DuplicateResult(matchResults));
                }
                results.add(new FindDuplicatesResult(duplicateResults));
            }
            return results;
        } catch (Exception ex) {
            throw new FindDuplicatesException(ex.getMessage());
        }
    }

    /**
    * @description Wrapper class for FindDuplicatesResult to mimic the shape of https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Datacloud_FindDuplicatesResult.htm
    **/
    public class FindDuplicatesResult{
        public List<DuplicateResult> getDuplicateResults;

        public FindDuplicatesResult(List<DuplicateResult> results) {
            this.getDuplicateResults = results;
        }
    }

    /**
    * @description Wrapper class for DuplicateResult to mimic the shape of https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Datacloud_DuplicateResult.htm
    **/
    public class DuplicateResult{
        public List<MatchResult> getMatchResults;

        public DuplicateResult(List<MatchResult> matches){
            this.getMatchResults = matches;
        }
    }

    /**
    * @description Wrapper class for MatchResult to mimic the shape of https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Datacloud_MatchResult.htm
    **/
    public class MatchResult{
        public List<MatchRecord> getMatchRecords;

        public MatchResult(List<MatchRecord> records){
            this.getMatchRecords = records;
        }
    }

    /**
    * @description Wrapper class for MatchResult to mimic the shape of https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Datacloud_MatchRecord.htm
    **/
    public class MatchRecord{
        public Id getRecordId;
        public Double getMatchConfidence;

        public MatchRecord(Id recordId, Double matchConfidence){
            this.getRecordId = recordId;
            this.getMatchConfidence = matchConfidence;
        }
    }

    /**
    * @description So we can throw exceptions
    **/
    public class FindDuplicatesException extends Exception{}
}
