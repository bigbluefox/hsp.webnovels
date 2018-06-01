<%@ WebHandler Language="C#" Class="NovelHandler" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using Hsp.Novels.Bll;

/// <summary>
/// 小说抓取一般处理程序
/// </summary>
public class NovelHandler : IHttpHandler {

    /// <summary>
    ///     小说业务逻辑处理
    /// </summary>
    protected NovelBll NovelBll = new NovelBll();

    #region ProcessRequest

    /// <summary>
    /// ProcessRequest
    /// </summary>
    /// <param name="context"></param>
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Cache.SetNoStore();

        var strOperation = context.Request.Params["OPERATION"] ?? context.Request.Params["OP"];
        if (string.IsNullOrEmpty(strOperation)) strOperation = context.Request.Form["OPERATION"];
        if (string.IsNullOrEmpty(strOperation)) return;

        switch (strOperation.ToUpper().Trim())
        {
            //获取小说信息列表信息
            case "NOVELLIST":
                GetNovelPageList(context);
                break;

            //// 删除小说信息
            //case "DELETE":
            //    Delete(context);
            //    break;

            //// 批量删除
            //case "BATCHDELETE":
            //    BatchDelete(context);
            //    break;

            default:
                break;
        }

    }

    public bool IsReusable
    {
        get { return false; }
    }

    #endregion

    #region 获取小说信息分页列表信息

    /// <summary>
    ///     获取小说信息分页列表信息
    /// </summary>
    /// <param name="context"></param>
    private void GetNovelPageList(HttpContext context)
    {
        var strTitle = context.Request.Params["title"] ?? "";
        var strWebId = context.Request.Params["webId"] ?? "";
        var strNovelId = context.Request.Params["novelId"] ?? "";
        if (strTitle.Length > 0) strTitle = strTitle.Trim();
        if (strWebId.Length > 0) strWebId = strWebId.Trim();
        if (strNovelId.Length > 0) strNovelId = strNovelId.Trim();

        var pageSize = context.Request.Params["pageSize"] ?? "10";
        var pageNumber = context.Request.Params["pageNumber"] ?? "1";

        if (string.IsNullOrEmpty(pageSize)) pageSize = "10";
        if (string.IsNullOrEmpty(pageNumber)) pageNumber = "1";

        var paramList = new Dictionary<string, string>
            {
                {"Title", strTitle},
                {"WebId", strWebId},
                {"NovelI", strNovelId},
                {"PageSize", pageSize},
                {"PageIndex", pageNumber}
            };

        var list = NovelBll.PageNovelList(paramList);
        var js = new JavaScriptSerializer().Serialize(list);

        //需要返回的数据有总记录数和行数据  
        var json = "{\"total\":" + list[0].RecordCount + ",\"rows\":" + js + "}";

        context.Response.Write(json);
    }

    #endregion
}