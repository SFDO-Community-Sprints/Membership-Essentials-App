/**
 * Invocable adapter for Calculate_Membership_Term_End_Date.
 *
 * Architecture F2 exception: Salesforce rejects Subflow elements in platform-event-triggered
 * flows. The DPEV listeners therefore call this action, which starts the shared autolaunched
 * Flow. All configuration, validation, and date arithmetic remain in that Flow.
 * TODO(flow-migration): Replace this adapter with Subflow elements when Salesforce supports
 * them in platform-event-triggered flows.
 */
public with sharing class MembershipTermEndAction {
    public class Request {
        @InvocableVariable(label='Reference Date' description='The caller chooses the date from which to advance the term.')
        public Date referenceDate;
        @InvocableVariable(label='Term' description='A positive whole number of term units.')
        public Decimal term;
        @InvocableVariable(label='Term Unit' description='Day, Week, Month, or Year.')
        public String termUnit;
    }

    public class Result {
        @InvocableVariable(label='End Date')
        public Date endDate;
        @InvocableVariable(label='Is Valid')
        public Boolean isValid;
        @InvocableVariable(label='Error Message')
        public String errorMessage;
    }

    @InvocableMethod(label='Calculate Membership Term End Date'
        description='Runs the shared term-end Flow for listeners that cannot contain a Subflow element.')
    public static List<Result> calculate(List<Request> requests) {
        List<Map<String, Object>> inputs = new List<Map<String, Object>>();
        for (Request request : requests) {
            inputs.add(new Map<String, Object>{
                'ReferenceDate' => request.referenceDate,
                'Term' => request.term,
                'TermUnit' => request.termUnit
            });
        }
        // Invoke the interviews as one batch so Flow bulkifies the settings lookup. Starting
        // Flow.Interview instances in a loop would consume one SOQL query per request.
        Invocable.Action action = Invocable.Action.createCustomAction('flow', 'Calculate_Membership_Term_End_Date');
        action.setInvocations(inputs);
        List<Result> results = new List<Result>();
        for (Invocable.Action.Result flowResult : action.invoke()) {
            Result result = new Result();
            result.isValid = false;
            if (flowResult.isSuccess()) {
                Map<String, Object> outputs = flowResult.getOutputParameters();
                // Flow Date outputs are exposed as midnight-UTC Datetime values by this API.
                // Use the UTC date so the running user's timezone cannot shift the result.
                Object endDate = outputs.get('EndDate');
                result.endDate = endDate instanceof Datetime ? ((Datetime) endDate).dateGmt() : (Date) endDate;
                result.isValid = (Boolean) outputs.get('IsValid');
                result.errorMessage = (String) outputs.get('ErrorMessage');
            } else {
                // The listener logs this error and marks its own MFS Failed. An exception
                // affecting the entire action is handled by the listener's fault connector.
                result.errorMessage = String.valueOf(flowResult.getErrors());
            }
            results.add(result);
        }
        return results;
    }
}
