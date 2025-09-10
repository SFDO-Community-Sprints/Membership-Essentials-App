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

public with sharing class DuplicateRecordCheck_Invocable{
    /**
    * @description Contains the Invocable Method that runs the duplicate rules on a particular record(s) to see if a duplicate record(s) exists.
    * @param List<Input> inputs 
    * @return List<Duplicate> 
    **/
    @InvocableMethod(
        label='Check for Duplicate Records'
        description='Runs the duplicate rules on a particular record (or records) to see if a duplicate record (or records) exists.'
        category='Duplicate Record Check'
    )
    public static List<Output> findDuplicates(List<Input> inputs){

        List<sObject> listsObjectsToCheck = new List<sObject>();
        for(Input input : inputs){
            if(input.record != null) listsObjectsToCheck.add(input.record);
            if(input.records != null) listsObjectsToCheck.addAll(input.records);
        }

        List<Duplicate> duplicates = DuplicateRecordCheck_Util.findDuplicates(listsObjectsToCheck);

        List<Output> outputs = new List<Output>();
        for(Input input : inputs){
            Output output = new Output();
            if(input.record != null){
                output.duplicate = duplicates.remove(0);
            }

            if(input.records != null){
                output.duplicates = new List<Duplicate>();
                for(sObject record : input.records){
                    output.duplicates.add(duplicates.remove(0));
                }
            }

            outputs.add(output);
        }

        return outputs;
    }

    /**
    * @description Wrapper class for invocable inputs
    **/
    public class Input{
        @InvocableVariable(label='Single Record to Check for Duplicates')
        public sObject record;

        @InvocableVariable(label='Collection of Records to Check for Duplicates')
        public List<sObject> records;
    }

    /**
    * @description Wrapper class for invocable outputs
    **/
    public class Output{
        @InvocableVariable(label='Duplicate Result from Single Record')
        public Duplicate duplicate;

        @InvocableVariable(label='Duplicate Results from Collection of Records')
        public List<Duplicate> duplicates;
    }
}