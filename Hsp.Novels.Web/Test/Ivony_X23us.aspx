<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Ivony_X23us.aspx.cs" Inherits="Test_Ivony_X23us" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>x23us</title>
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

         input[type='text'] { width: 602px; }

        #txtContent { width: 600px;height: 300px; }

        #form1 label { width: 75px;vertical-align: top;font-weight: bold; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div>
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button"/>
        <br/>
        <br/>
        <label>小说地址：</label>
        <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>
        <br/>
        <br/>
        <label>内容标签：</label>
        <asp:TextBox ID="txtLabel" runat="server"></asp:TextBox>
        <br/>
        <br/>
        <label>小说内容：</label>
        <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine"></asp:TextBox>
        <br/>
    </div>
</form>
</body>
</html>