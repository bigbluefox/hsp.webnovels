<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test1.aspx.cs" Inherits="Test_Test1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>大书包（新）</title>
    <style type="text/css">
        input[type='text'] { width: 602px; }

        #txtContent { width: 600px;height: 60px; }

        #form1 label { width: 75px;vertical-align: top;font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button" />
        <br />
        <label>小说地址：</label>
        <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>
        <br />
         <label>小说内容：</label>
        <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" ></asp:TextBox>
        <br />
    
    </div>
    </form>
</body>
</html>
