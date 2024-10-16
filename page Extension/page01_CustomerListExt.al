pageextension 50101 CustListExt extends "Customer List"
{
    layout
    {

    }

    actions
    {
        addlast(processing)
        {
            action("Process Annual Payments")
            {
                ApplicationArea = basic, suite;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Process Annual Payments';
                trigger OnAction()//Whenever the user clicks on the "Process Annual Payments" action
                var
                    cust: Record Customer;
                begin
                    cust.Reset();//clear any filters, keys, and ranges that may have been previously applied
                    cust.SetRange("No.", Rec."No.");//the first parameter describes the customer no field.Rec refers to the current record (the record that the user has selected in the "Customer List").
                    if cust.FindFirst() then// Findfirst find the first record that matches the filter(s) set on the record variable (cust).
                        Report.Run(Report::"Process Annual Transactions", true, false, cust);
                    //The first parameter is the ID of the report to run, in this case, the report "Process Annual Transactions".
                    //The second parameter (true):indicates whether the report should run in a modal dialog, which means it prevents the user from interacting with other parts of the application until the report is finished running.
                    //The third parameter (false): This flag indicates whether the report should be run without displaying a request page. false means that the request page will not be shown to the user.
                    //The fourth parameter (cust): This is the record variable (cust) that will be passed to the report as input data. It represents the filtered customer record (the selected customer) that should be processed by the report.
                end;
            }
        }
    }

    var
        myInt: Integer;
}