tableextension 50100 "CSD User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50100; "Journal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(50101; "Journal Batch Name"; code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
    }


    var
        myInt: Integer;
}