/// <summary>
/// [planning]
/// Modules: 
/// </summary>
codeunit 5138640 "BET FN Purch Stats Entrs Mgt"
{
    Access = Public;

    trigger OnRun()
    begin
        RebuildWithSQL();
    end;

    /// <summary>
    /// RebuildWithSQL.
    /// </summary>
    procedure RebuildWithSQL()
    var
    // ODBCConnection_L: Automation;
    // PlanSetup_LT: Record "Planning Setup";
    // ConnectionString_L: Text[100];
    // Text001_L: Label 'Calculate order statistic...';
    // MSADO_Recordset: Automation;
    // MSADO_Fields: Automation;
    // MSADO_Field: Automation;
    // MSADO_Connection: Automation;
    // Window_L: Dialog;
    // ConnectionCreated_L: Boolean;
    begin

        // exit;     //### für Demo deaktiviert, damit generierte Statistikposten nicht gelöscht werden

        // Window_L.Open(Text001_L);

        // PlanSetup_LT.Get();

        // //### Abfrage über ODBC-Verbindung

        // //### aktuellen Server abfragen:
        // ConnectionString_L := StrSubstNo('DRIVER={SQL Server};Server=%1;', PlanSetup_LT."SQL Server");
        // //Server_LT.Reset();
        // //Server_LT.SetRange("My Server",true);
        // //Server_LT.FindFirst();
        // //ConnectionString_L := StrSubstNo('DRIVER={SQL Server};Server=%1;', Server_LT."Server Name");

        // //### aktuelle DB abfragen:
        // ConnectionString_L += StrSubstNo('Database=%1;', PlanSetup_LT."SQL Database");
        // //Session_LT.Reset();
        // //Session_LT.SetRange("My Session", true);
        // //Session_LT.FindFirst();
        // //ConnectionString_L += StrSubstNo('Database=%1;', Session_LT."Database Name");

        // //### User + Passwort:
        // ConnectionString_L += StrSubstNo('UID=%1;PWD=%2;', PlanSetup_LT."SQL User", PlanSetup_LT."SQL PW");

        // //### ODBC-Verbindung aufbauen:
        // Create(ODBCConnection_L, true, true);

        // ODBCConnection_L.ConnectionTimeout := 30;
        // ODBCConnection_L.CommandTimeout := 1800;
        // ODBCConnection_L.Open(ConnectionString_L, PlanSetup_LT."SQL User", PlanSetup_LT."SQL PW");

        // Commit(); //### alle Sperren aufheben

        // ODBCConnection_L.Execute('EXEC PL_RebuildOrderStatistic');     //### siehe Sportler
        // ODBCConnection_L.Close();

        // Window_L.Close();
    end;
}

