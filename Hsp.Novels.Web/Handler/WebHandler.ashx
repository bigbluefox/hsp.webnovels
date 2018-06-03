<%@ WebHandler Language="C#" Class="WebHandler" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using Hsp.Novels.Bll;

/// <summary>
/// 站点数据一般处理程序
/// </summary>
public class WebHandler : IHttpHandler, IRequiresSessionState
{
    /// <summary>
    ///     小说站点业务逻辑处理
    /// </summary>
    protected WebBll WebBll = new WebBll();
    
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

        switch (strOperation.ToUpper())
        {
            //获取站点列表信息
            case "LIST":
                GetPageList(context);
                break;

            // 删除站点
            case "DELETE":
                Delete(context);
                break;

            // 批量删除
            case "BATCHDELETE":
                BatchDelete(context);
                break;

            //获取站点抓取参数
            case "CRAWL":
                GetWebCrawl(context);
                break;               
                
                

            default:
                break;
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }

    #endregion


    #region 获取站点分页列表信息

    /// <summary>
    ///     获取站点分页列表信息
    /// </summary>
    /// <param name="context"></param>
    private void GetPageList(HttpContext context)
    {
        var strName = context.Request.Params["qname"] ?? "";
        var strStart = context.Request.Params["sdate"] ?? "";
        var strEnd = context.Request.Params["edate"] ?? "";
        if (strName.Length > 0) strName = strName.Trim();
        if (strStart.Length > 0) strStart = strStart.Trim();
        if (strEnd.Length > 0) strEnd = strEnd.Trim();

        var pageSize = context.Request.Params["pageSize"] ?? "10";
        var pageNumber = context.Request.Params["pageNumber"] ?? "1";

        if (string.IsNullOrEmpty(pageSize)) pageSize = "10";
        if (string.IsNullOrEmpty(pageNumber)) pageNumber = "1";

        var paramList = new Dictionary<string, string>
            {
                {"Title", strName},
                {"WebId", ""},
                {"SDate", strStart},
                {"EDate", strEnd},
                {"PageSize", pageSize},
                {"PageIndex", pageNumber}
            };

        var list = WebBll.PageWebList(paramList);
        var js = new JavaScriptSerializer().Serialize(list);

        //需要返回的数据有总记录数和行数据  
        var json = "{\"total\":" + (list.Count > 0 ? list[0].RecordCount : 0) + ",\"rows\":" + js + "}";

        context.Response.Write(json);
    }

    #endregion

    #region 删除站点

    /// <summary>
    ///     删除站点
    /// </summary>
    /// <param name="context"></param>
    private void Delete(HttpContext context)
    {
        var rst = "";
        var strId = context.Request.Params["ID"] ?? ""; // 站点编号
        if (string.IsNullOrEmpty(strId)) return;

        var i = WebBll.Delete(int.Parse(strId));
        if (i > 0)
        {
            rst = "{\"success\":true,\"Message\": \"站点『" + strId + "』删除成功！\"}";
        }
        else
        {
            rst = "{\"success\":false,\"Message\": \"站点删除失败！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

    #region 批量删除站点

    /// <summary>
    ///     批量删除站点
    /// </summary>
    /// <param name="context"></param>
    private void BatchDelete(HttpContext context)
    {
        var rst = "";
        var strIds = context.Request.Params["IDs"] ?? "";// 站点编号
        if (string.IsNullOrEmpty(strIds)) return;

        var i = WebBll.BatchDelete(strIds);
        if (i > 0)
        {
            rst = "{\"success\":true,\"Message\": \"站点『" + strIds + "』批量删除成功！\"}";
        }
        else
        {
            rst = "{\"success\":false,\"Message\": \"站点批量删除失败！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

    #region 获取站点抓取参数

    /// <summary>
    ///     获取站点抓取参数
    /// </summary>
    /// <param name="context"></param>
    private void GetWebCrawl(HttpContext context)
    {
        var strWebId = context.Request.Params["webId"] ?? "";
        var strNovelId = context.Request.Params["novelId"] ?? "";
        if (strWebId.Length > 0) strWebId = strWebId.Trim();
        if (strNovelId.Length > 0) strNovelId = strNovelId.Trim();

        var model = WebBll.WebCrawlModel(strWebId, strNovelId);
        var json = new JavaScriptSerializer().Serialize(model);
        context.Response.Write(json);
    }

    #endregion

}