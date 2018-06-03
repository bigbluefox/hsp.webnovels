using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Chapter : PageBase
{
    /// <summary>
    /// 站点编号
    /// </summary>
    protected string WebId { get; set; }

    /// <summary>
    /// 站点名称
    /// </summary>
    protected string WebName { get; set; }

    /// <summary>
    /// 小说编号
    /// </summary>
    protected string NovelId { get; set; }

    /// <summary>
    /// 小说名称
    /// </summary>
    protected string NovelName { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        WebId = Request.QueryString["webId"] ?? "";
        WebName = Request.QueryString["webName"] ?? "";
        NovelId = Request.QueryString["novelId"] ?? "";
        NovelName = Request.QueryString["novelName"] ?? "";
        if (Page.IsPostBack) return;
    }
}