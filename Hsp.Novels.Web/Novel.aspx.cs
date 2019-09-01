using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Novel : PageBase
{
    /// <summary>
    /// 站点编号
    /// </summary>
    protected string WebId { get; set; }

    /// <summary>
    /// 站点名称
    /// </summary>
    protected string WebName{ get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        WebId = Request.QueryString["webId"] ?? "";
        WebName = Request.QueryString["webName"] ?? "小说检索";
        if (Page.IsPostBack) return;
    }
}