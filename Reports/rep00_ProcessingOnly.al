report 50100 "Process Annual Transactions"
{
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {
            }
            trigger OnAfterGetRecord()
            var
                CustPaymentAmt: Decimal;
                CustOutPayment: Decimal;
                CustCharge: Decimal;
                CustTax: Decimal;
            begin

                CustPaymentAmt := 5000;
                CustCharge := CustPaymentAmt * 0.05;
                CustTax := CustPaymentamt * 0.15;
                CustOutPayment := 250;

                LineNo += 1;
                GenJnlln.Init();//make sure the record is empty
                GenJnlln."Journal Template Name" := UserSetup."Journal Template Name";
                GenJnlln."Journal Batch Name" := UserSetup."Journal Batch Name";
                GenJnlln."Line No." := LineNo;
                GenJnlln."Document No." := DocumentNo;
                GenJnlln."Posting Date" := TODAY;
                GenJnlln."Account Type" := GenJnlln."Account Type"::Customer;
                GenJnlln.Validate("Account No.", Customer."No.");//validate means to assign the account No. record to the customer No. record and runs the validate trigger on the "Account No." field
                GenJnlln.Description := 'Annual Payment for ' + Format(Date2DMY(CalcDate('-1Y', Today), 3));
                GenJnlln.Validate(Amount, -CustPaymentAmt);
                GenJnlln."Bal. Account Type" := GenJnlln."Bal. Account Type"::"G/L Account";
                GenJnlln."Bal. Account No." := ExpenseGLAccount;
                GenJnlln."Currency Code" := '';
                GenJnlln.Insert();

                LineNo += 1;
                GenJnlln.Init();//make sure the record is empty
                GenJnlln."Journal Template Name" := UserSetup."Journal Template Name";
                GenJnlln."Journal Batch Name" := UserSetup."Journal Batch Name";
                GenJnlln."Line No." := LineNo;
                GenJnlln."Document No." := DocumentNo;
                GenJnlln."Posting Date" := TODAY;
                GenJnlln."Account Type" := GenJnlln."Account Type"::Customer;
                GenJnlln.Validate("Account No.", Customer."No.");//validate means to assign the account No. record to the customer No. record and runs the validate trigger on the "Account No." field
                GenJnlln.Description := 'Annual Fee Charge for ' + Format(Date2DMY(CalcDate('-1Y', Today), 3));
                GenJnlln.Validate(Amount, (CustOutPayment + CustCharge + CustTax));
                GenJnlln."Bal. Account Type" := GenJnlln."Bal. Account Type"::"G/L Account";
                GenJnlln."Bal. Account No." := ExpenseGLAccount;
                GenJnlln."Currency Code" := '';
                GenJnlln.Insert();

                LineNo += 1;
                GenJnlln.Init();//make sure the record is empty
                GenJnlln."Journal Template Name" := UserSetup."Journal Template Name";
                GenJnlln."Journal Batch Name" := UserSetup."Journal Batch Name";
                GenJnlln."Line No." := LineNo;
                GenJnlln."Document No." := DocumentNo;
                GenJnlln."Posting Date" := TODAY;
                GenJnlln."Account Type" := GenJnlln."Account Type"::"G/L Account";
                GenJnlln.Validate("Account No.", PaymentGLAccount);//validate means to assign the account No. record to the customer No. record and runs the validate trigger on the "Account No." field
                GenJnlln.Description := 'Annual Outstanding payment for ' + Format(Date2DMY(CalcDate('-1Y', Today), 3));
                GenJnlln.Validate(Amount, -(CustOutPayment));
                GenJnlln."Bal. Account Type" := GenJnlln."Bal. Account Type"::"G/L Account";
                GenJnlln."Bal. Account No." := ExpenseGLAccount;
                GenJnlln."Currency Code" := '';
                GenJnlln.Insert();

                LineNo += 1;
                GenJnlln.Init();//make sure the record is empty
                GenJnlln."Journal Template Name" := UserSetup."Journal Template Name";
                GenJnlln."Journal Batch Name" := UserSetup."Journal Batch Name";
                GenJnlln."Line No." := LineNo;
                GenJnlln."Document No." := DocumentNo;
                GenJnlln."Posting Date" := TODAY;
                GenJnlln."Account Type" := GenJnlln."Account Type"::"G/L Account";
                GenJnlln.Validate("Account No.", FeesIncomeGLAccount);//validate means to assign the account No. record to the customer No. record and runs the validate trigger on the "Account No." field
                GenJnlln.Description := 'Annual Fee Charge for ' + Format(Date2DMY(CalcDate('-1Y', Today), 3));
                GenJnlln.Validate(Amount, -(CustCharge));
                GenJnlln."Bal. Account Type" := GenJnlln."Bal. Account Type"::"G/L Account";
                GenJnlln."Bal. Account No." := ExpenseGLAccount;
                GenJnlln."Currency Code" := '';
                GenJnlln.Insert();

                LineNo += 1;
                GenJnlln.Init();//make sure the record is empty
                GenJnlln."Journal Template Name" := UserSetup."Journal Template Name";
                GenJnlln."Journal Batch Name" := UserSetup."Journal Batch Name";
                GenJnlln."Line No." := LineNo;
                GenJnlln."Document No." := DocumentNo;
                GenJnlln."Posting Date" := TODAY;
                GenJnlln."Account Type" := GenJnlln."Account Type"::"G/L Account";
                GenJnlln.Validate("Account No.", TaxGLAccount);//validate means to assign the account No. record to the customer No. record and runs the validate trigger on the "Account No." field
                GenJnlln.Description := 'Annual Fee Charge for ' + Format(Date2DMY(CalcDate('-1Y', Today), 3));
                GenJnlln.Validate(Amount, -(CustTax));
                GenJnlln."Bal. Account Type" := GenJnlln."Bal. Account Type"::"G/L Account";
                GenJnlln."Bal. Account No." := ExpenseGLAccount;
                GenJnlln."Currency Code" := '';
                GenJnlln.Insert();



            end;

        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(ExpenseGLAccount; ExpenseGLAccount)
                    {
                        Caption = 'Expense GL Account';
                        ApplicationArea = basic, suite;
                        TableRelation = "G/L Account" where("Direct Posting" = const(true));
                    }
                    field(TaxGLAccount; TaxGLAccount)
                    {
                        Caption = 'Tax GL Account';
                        ApplicationArea = basic, suite;
                        TableRelation = "G/L Account" where("Direct Posting" = const(true));
                    }
                    field(FeesIncomeGLAccount; FeesIncomeGLAccount)
                    {
                        Caption = 'Fees Income GL Account';
                        ApplicationArea = basic, suite;
                        TableRelation = "G/L Account" where("Direct Posting" = const(true));
                    }
                    field(PaymentGLAccount; PaymentGLAccount)
                    {
                        Caption = 'Payment GL Account';
                        ApplicationArea = basic, suite;
                        TableRelation = "G/L Account" where("Direct Posting" = const(true));
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        Caption = 'Document No';
                        ApplicationArea = basic, suite;
                    }
                    field(PostDirectly; PostDirectly)
                    {
                        Caption = 'Post Directly';
                        ApplicationArea = basic, suite;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }
    trigger OnPreReport()
    begin
        if ExpenseGLAccount = '' then Error(StrSubstNo(RequiredErr, 'Expense GL Account'));
        if FeesIncomeGLAccount = '' then Error(StrSubstNo(RequiredErr, 'Fees Income GL Account'));
        if TaxGLAccount = '' then Error(StrSubstNo(RequiredErr, 'Tax GL Account'));
        if PaymentGLAccount = '' then Error(StrSubstNo(RequiredErr, 'Payment GL Account'));
        if DocumentNo = '' then Error(StrSubstNo(RequiredErr, 'Document No'));
        UserSetup.Get(UserId);
        UserSetup.TestField("Journal Template Name");
        UserSetup.TestField("Journal Batch Name");

        GenJnlln.Reset();//removes all filters
        GenJnlln.SetRange("Journal Template Name", UserSetup."Journal Template Name");
        GenJnlln.SetRange("Journal Batch Name", UserSetup."Journal Batch Name");
        IF GenJnlln.FindFirst() then//FindFirst finds the first record in a table.if its true to delete all records in the table
            GenJnlln.DeleteAll();//deletes all records in a table that are found in a specific range
    end;

    trigger OnPostReport()
    begin
        GenJnlln.Reset();//removes all filters
        GenJnlln.SetRange("Journal Template Name", UserSetup."Journal Template Name");
        GenJnlln.SetRange("Journal Batch Name", UserSetup."Journal Batch Name");
        IF GenJnlln.FindFirst() then begin
            if not PostDirectly then
                page.Run(page::"General Journal", GenJnlln)
            else
                codeunit.Run(codeunit::"Gen. Jnl.-Post Batch", GenJnlln);
        end;

    end;

    var
        ExpenseGLAccount: Code[20];
        FeesIncomeGLAccount: Code[20];
        TaxGLAccount: Code[20];
        PaymentGLAccount: Code[20];
        GenJnlln: Record "Gen. Journal Line";
        UserSetup: Record "User Setup";
        DocumentNo: code[20];
        PostDirectly: Boolean;
        LineNo: Integer;
        RequiredErr: Label 'Please enter the required %1,field';
}