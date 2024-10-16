# Process Annual Transactions Report

## Overview

This report processes annual payments for customers and creates related General Journal entries. It calculates payment amounts, fees, and taxes, and posts them to appropriate General Ledger (G/L) accounts.

The report is divided into three key areas:
1. **Dataset**: Fetches customer data and processes journal entries for each customer.
2. **Request Page**: Allows users to specify G/L accounts and document numbers.
3. **Triggers**: Handles actions before and after the report runs.

## Features
- **General Journal entries** for payments, fees, and taxes.
- **Filtering** by customer numbers.
- Optional posting of journal entries directly or through the General Journal page.

## Requirements
Ensure the following fields are set up:
- Expense G/L Account
- Fees Income G/L Account
- Tax G/L Account
- Payment G/L Account
- Document Number
- Journal Template and Batch Names in the **User Setup** table.

## Report Fields

| Field                 | Description                                               |
|-----------------------|-----------------------------------------------------------|
| `ExpenseGLAccount`     | G/L Account to post expense-related entries.              |
| `FeesIncomeGLAccount`  | G/L Account to post income from fees.                     |
| `TaxGLAccount`         | G/L Account to post tax amounts.                          |
| `PaymentGLAccount`     | G/L Account to post the payment amounts.                  |
| `DocumentNo`           | Document number used for the journal lines.               |
| `PostDirectly`         | Whether to post the journal lines immediately.            |

## Request Page Fields

When running the report, the following fields will be displayed for user input:
- **Expense G/L Account**: Linked to the "G/L Account" table, where Direct Posting is allowed.
- **Fees Income G/L Account**: Linked to the "G/L Account" table, where Direct Posting is allowed.
- **Tax G/L Account**: Linked to the "G/L Account" table, where Direct Posting is allowed.
- **Payment G/L Account**: Linked to the "G/L Account" table, where Direct Posting is allowed.
- **Document No**: Document number for journal entries.
- **Post Directly**: Checkbox to post entries automatically after creation.

## How to Create the Report

1. Create a new report in AL, using the report ID `50100` and name it `"Process Annual Transactions"`.
2. Define the **Customer** data item, which retrieves customer records.
3. Set up the fields and user input options in the `requestpage` section.
4. Use the `OnAfterGetRecord` trigger to create General Journal entries for each customer, based on the calculations for payment amounts, fees, and taxes.
5. Use the `OnPreReport` and `OnPostReport` triggers to handle validations and posting of entries.

## Journal Transactions in `OnAfterGetRecord`

The `OnAfterGetRecord` trigger is responsible for creating the General Journal lines for each customer, following these steps:

1. **Calculate Amounts**:
   - `CustPaymentAmt`: The base payment amount (e.g., 5000).
   - `CustCharge`: Calculated as 5% of `CustPaymentAmt`.
   - `CustTax`: Calculated as 15% of `CustPaymentAmt`.
   - `CustOutPayment`: Outstanding payment (e.g., 250).

2. **Create Journal Entries**:
   The following journal lines are created in sequence:

   - **Payment Journal Line**: 
     - Debits the customer's account for the `CustPaymentAmt` and credits the **Expense G/L Account**.
     - Description: "Annual Payment for <last year>".

   - **Fee Charge Journal Line**: 
     - Debits the customer's account for the sum of `CustOutPayment`, `CustCharge`, and `CustTax`, and credits the **Expense G/L Account**.
     - Description: "Annual Fee Charge for <last year>".

   - **Outstanding Payment Journal Line**: 
     - Debits the **Payment G/L Account** for the `CustOutPayment` and credits the **Expense G/L Account**.
     - Description: "Annual Outstanding payment for <last year>".

   - **Fee Income Journal Line**: 
     - Debits the **Fees Income G/L Account** for the `CustCharge` and credits the **Expense G/L Account**.
     - Description: "Annual Fee Charge for <last year>".

   - **Tax Journal Line**: 
     - Debits the **Tax G/L Account** for the `CustTax` and credits the **Expense G/L Account**.
     - Description: "Annual Fee Charge for <last year>".

3. **Insert Journal Lines**: Each journal line is inserted into the General Journal with fields like `"Journal Template Name"`, `"Journal Batch Name"`, `"Posting Date"`, `"Account Type"`, and `"Account No."` properly filled in.

## Posting
- In the `OnPostReport` trigger, the journal lines can either be displayed on the **General Journal** page for review or posted directly if the **Post Directly** option is selected.

---

## Error Handling

The following validations occur in the `OnPreReport` trigger:
- **G/L Accounts**: Ensure that all G/L account fields (Expense, Fees Income, Tax, Payment) are filled.
- **Document No**: Ensure a Document No is provided.
- **User Setup**: Ensure the Journal Template and Batch Names are filled for the current user.

If any validation fails, the report throws an error and stops execution.

## Conclusion

This report simplifies the process of creating and posting annual transactions for customers, with flexibility for user input and optional direct posting.
