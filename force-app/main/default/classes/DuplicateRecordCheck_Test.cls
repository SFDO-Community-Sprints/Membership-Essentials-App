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
@isTest
public class DuplicateRecordCheck_Test{
    
    private static final Integer NUMBER_OF_LOOPS = 51; // This should be at least 51 for full test coverage.
    private static final Id MATCHING_ID = '001000000000RGMRGM';
    private static final String OBJECT_NAME = 'Account';
    private static Boolean returnDuplicates = true;

    @isTest
    public static void Duplicate_Test(){
        FindDuplicatesFactory.stubFactory = new MockFindDuplicatesFactory();
        
        List<DuplicateRecordCheck_Invocable.Input> inputs = new List<DuplicateRecordCheck_Invocable.Input>();
        for(Integer i = 1; i <= NUMBER_OF_LOOPS; i++){
            DuplicateRecordCheck_Invocable.Input input = new DuplicateRecordCheck_Invocable.Input();
            input.record = new Account();
            input.records = new List<sObject>{new Account()};
            inputs.add(input);
        }

        System.Test.startTest();
        	List<DuplicateRecordCheck_Invocable.Output> outputs = DuplicateRecordCheck_Invocable.findDuplicates(inputs);
        System.Test.stopTest();

        System.assertEquals(NUMBER_OF_LOOPS, outputs.size());
        for(DuplicateRecordCheck_Invocable.Output output : outputs){
            System.assertEquals(TRUE, output.Duplicate.isDuplicate);
            System.assertEquals(MATCHING_ID, output.Duplicate.duplicateRecordId);
            System.assertEquals(OBJECT_NAME, output.Duplicate.duplicatesObjectType);

            for(Duplicate duplicate : output.duplicates){
                System.assertEquals(TRUE, duplicate.isDuplicate);
                System.assertEquals(MATCHING_ID, duplicate.duplicateRecordId);
                System.assertEquals(OBJECT_NAME, duplicate.duplicatesObjectType);
            }
        }
    }
    
    @isTest
    public static void Non_Duplicate_Test(){
        returnDuplicates = false;
        FindDuplicatesFactory.stubFactory = new MockFindDuplicatesFactory();

        List<DuplicateRecordCheck_Invocable.Input> inputs = new List<DuplicateRecordCheck_Invocable.Input>();
        for(Integer i = 1; i <= NUMBER_OF_LOOPS; i++){
	        DuplicateRecordCheck_Invocable.Input input = new DuplicateRecordCheck_Invocable.Input();
            input.record = new Account();
            inputs.add(input);
        }

        System.Test.startTest();
        	List<DuplicateRecordCheck_Invocable.Output> outputs = DuplicateRecordCheck_Invocable.findDuplicates(inputs);
        System.Test.stopTest();
        
        System.assertEquals(NUMBER_OF_LOOPS, outputs.size());
        for(DuplicateRecordCheck_Invocable.Output output : outputs){
            System.assertEquals(FALSE, output.Duplicate.isDuplicate);
            System.assertEquals(NULL, output.Duplicate.duplicateRecordId);
            System.assertEquals(NULL, output.Duplicate.duplicatesObjectType);
        }
    }

    @IsTest
    public static void Factory_Test(){
        try {
            List<sObject> records = new List<sObject>{new Account()};
            
            System.Test.startTest();
                FindDuplicatesFactory factory = FindDuplicatesFactory.getFactory();
                FindDuplicates findDuplicates = factory.getFindDuplicates();
                List<FindDuplicates.FindDuplicatesResult> duplicates = findDuplicates.findDuplicates(records);
            System.Test.stopTest();

            system.assertEquals(records.size(), duplicates.size());
        } catch (Exception ex) {
            system.debug(ex);
        }
    }

    @isTest
    public static void Comparable_Test(){
        List<Duplicate> duplicates = new List<Duplicate>();
        for(Integer i = 1; i <= NUMBER_OF_LOOPS; i++){
            if(i == 1){
                duplicates.add(new Duplicate(FALSE,null,null,null));
            } else {
                duplicates.add(new Duplicate(TRUE,null,null,i));
            }
        }
        duplicates.sort();
        
        Integer counter = NUMBER_OF_LOOPS;
        for(Duplicate duplicate : duplicates){
            if(counter == 1){
                system.assertEquals(null, duplicate.matchConfidence);
            } else {
                system.assertEquals(counter, duplicate.matchConfidence);
            }
            counter--;
        }
    }

    private class MockFindDuplicatesFactory extends FindDuplicatesFactory{
        MockFindDuplicatesFactory(){
            super();
        }

        public override FindDuplicates getFindDuplicates(){
            if(returnDuplicates){
                return new Dupe();
            } else {
                return new NotADupe();
            }
        }
    }

    private class Dupe extends FindDuplicates{
        
        public override List<FindDuplicatesResult> findDuplicates(List<SObject> records){
            List<FindDuplicatesResult> results = new List<FindDuplicatesResult>();

            for(Integer i = 1; i <= records.size(); i++){
                List<MatchRecord> matchRecords = new List<MatchRecord>{new MatchRecord((Id)MATCHING_ID,(Double)100.0)};
                List<MatchResult> matchResults = new List<MatchResult>{new MatchResult(matchRecords)};
                List<DuplicateResult> duplicateResults = new List<DuplicateResult>{new DuplicateResult(matchResults)};
                results.add(new FindDuplicatesResult(duplicateResults));
            }

            return results;
        }
        
    }

    private class NotADupe extends FindDuplicates{
        public override List<FindDuplicatesResult> findDuplicates(List<SObject> records){
            List<FindDuplicatesResult> results = new List<FindDuplicatesResult>();

            for(Integer i = 1; i <= records.size(); i++){
                List<MatchRecord> matchRecords = new List<MatchRecord>();
                List<MatchResult> matchResults = new List<MatchResult>{new MatchResult(matchRecords)};
                List<DuplicateResult> duplicateResults = new List<DuplicateResult>{new DuplicateResult(matchResults)};
                results.add(new FindDuplicatesResult(duplicateResults));
            }

            return results;
        }
    }
}
