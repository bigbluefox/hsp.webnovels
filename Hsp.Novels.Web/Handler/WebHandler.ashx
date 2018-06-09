<%@ WebHandler Language="C#" Class="WebHandler" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using Hsp.Novels.Bll;
using Hsp.Novels.Model;

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

            // 站点保存
            case "SAVE":
                WebSave(context);
                break;  
                
            // 删除站点
            case "DELETE":
                Delete(context);
                break;

            // 批量删除
            case "BATCHDELETE":
                BatchDelete(context);
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

        var i = WebBll.Delete(strId);
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


    #region 站点数据保存

    /// <summary>
    /// 站点数据保存
    /// </summary>
    /// <param name="context"></param>
    private void WebSave(HttpContext context)
    {
        var rst = "";
        var strWebId = context.Request.Params["ID"] ?? ""; // 站点编号
        var strName = context.Request.Params["Name"] ?? ""; // 站点名称
        var strWebUrl = context.Request.Params["WebUrl"] ?? ""; // 站点地址        
        var strContentName = context.Request.Params["ContentName"] ?? ""; // 内容对象
        var strHeaderName = context.Request.Params["HeaderName"] ?? ""; // 标题对象
        var strNextName = context.Request.Params["NextName"] ?? ""; // 地址对象
        var strNextTitle = context.Request.Params["NextTitle"] ?? ""; // 下一章地址对象结束标识
        var isValid = int.Parse(context.Request.Params["Valid"] ?? "0"); // 是否有效
        var urlCombine = int.Parse(context.Request.Params["UrlCombine"] ?? "0"); // 是否有效
        
        // SELECT     TOP (200) Id, Name, WebUrl, Valid, ContentName, HeaderName, NextName, NextTitle, CreateTime
        //FROM         WebSites
        
        try
        {
            string rstType;
            WebSites model = new WebSites();
            model.Name = strName;
            model.WebUrl = strWebUrl;
            model.ContentName = strContentName;
            model.HeaderName = strHeaderName;
            model.NextName = strNextName;
            model.NextTitle = strNextTitle;
            model.Valid = isValid;
            model.UrlCombine = urlCombine;

            var i = 0; // 数据添加/编辑影响行数
            if (string.IsNullOrEmpty(strWebId))
            {
                // 添加站点数据
                rstType = "添加";
                model.Id = Guid.NewGuid().ToString().ToUpper();
                i = WebBll.Add(model);
            }
            else
            {
                // 修改站点数据
                rstType = "修改";
                model.Id = strWebId;
                i = WebBll.Edit(model);
            }

            if (i > 0)
            {
                rst = "{\"success\":true,\"Message\": \"站点『" + model.Name + "』" + rstType + "成功！\"}";
            }
            else
            {
                rst = "{\"success\":false,\"Message\": \"站点『" + model.Name + "』" + rstType + "失败！\"}";
            }
        }
        catch (Exception ex)
        {
            rst = "{\"success\":false,\"Message\": \"" + ex.Message.Replace('"', '\"') + "！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

}