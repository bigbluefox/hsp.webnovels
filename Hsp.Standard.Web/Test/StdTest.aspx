<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StdTest.aspx.cs" Inherits="Test_StdTest" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>标准抓取测试</title>
    <script src="../Scripts/jquery/jquery-3.4.1.js"></script>
    <script src="../Scripts/jquery/jquery-migrate-3.0.1.js"></script>
    <style type="text/css">
        textarea,
        input[type='text'],
        input[type='submit'] { width: 100%; }

        select, textarea
        , input[type='text']
        , input[type='button']
        , input[type='submit'] { border: 1px solid #a4bed4 !important; }

        input[type="button"]
        , input[type='submit'] {
            cursor: pointer;
            height: 24px;
            width: 100%;
        }

        #txtContent {
            height: 450px;
            margin-top: 5px;
        }

        #form1 label {
            font-weight: bold;
            vertical-align: top;
            width: 75px;
        }
    </style>

    <script type="text/javascript">
        $(function() {
            $("textarea").attr("placeholder", "抓取内容");
        });
    </script>

</head>
<body>
<form id="form1" runat="server">
    <div>
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button"/>

        <br/>
        <%--<label>抓取内容：</label>--%>
        <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine"></asp:TextBox>
        <br/>
    </div>
</form>
</body>
</html>