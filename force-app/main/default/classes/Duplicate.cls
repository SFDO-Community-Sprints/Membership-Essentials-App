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
public with sharing class Duplicate implements Comparable{
    @AuraEnabled
    public Boolean isDuplicate;

    @AuraEnabled
    public Id duplicateRecordId;

    @AuraEnabled
    public String duplicatesObjectType;

    @TestVisible
    private Double matchConfidence;

    public Duplicate(Boolean isDuplicate, Id duplicateRecordId, String duplicatesObjectType, Double matchConfidence){
        this.isDuplicate = isDuplicate;
        this.duplicateRecordId = duplicateRecordId;
        this.duplicatesObjectType = duplicatesObjectType;
        this.matchConfidence = matchConfidence;
    }

    /**
    * @description Comparable method that sorts the objects in decsending order based on matchConfidence (nulls last)
    * @param Object compareTo 
    * @return Integer 
    **/
    public Integer compareTo(Object compareTo){
        Duplicate that = (Duplicate)compareTo;
        if(this.matchConfidence == that.matchConfidence) return 0;
        if(this.matchConfidence == null) return 1;
        if(that.matchConfidence == null) return -1;
        return (this.matchConfidence < that.matchConfidence) ? 1 : -1;
    }
}
