<%@ WebHandler Language="C#" Class="NovelHandler" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using Hsp.Novels.Bll;
using Hsp.Novels.Model;

/// <summary>
///   小说抓取一般处理程序
/// </summary>
public class NovelHandler : IHttpHandler, IRequiresSessionState
{
    /// <summary>
    ///   小说业务逻辑处理
    /// </summary>
    protected NovelBll NovelBll = new NovelBll();

    #region 获取小说信息分页列表信息

    /// <summary>
    ///   获取小说信息分页列表信息
    /// </summary>
    /// <param name="context"></param>
    private void GetNovelPageList(HttpContext context)
    {
        var strTitle = context.Request.Params["qname"] ?? "";
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
        var json = "{\"total\":" + (list.Count > 1? list[0].RecordCount : 0) + ",\"rows\":" + js + "}";

        context.Response.Write(json);
    }

    #endregion

    #region 删除小说

    /// <summary>
    ///   删除小说
    /// </summary>
    /// <param name="context"></param>
    private void Delete(HttpContext context)
    {
        var rst = "";
        var strId = context.Request.Params["ID"] ?? ""; // 小说编号
        if (string.IsNullOrEmpty(strId)) return;

        var i = NovelBll.Delete(strId);
        if (i > 0)
        {
            rst = "{\"success\":true,\"Message\": \"小说『" + strId + "』删除成功！\"}";
        }
        else
        {
            rst = "{\"success\":false,\"Message\": \"小说删除失败！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

    #region 批量删除小说

    /// <summary>
    ///   批量删除小说
    /// </summary>
    /// <param name="context"></param>
    private void BatchDelete(HttpContext context)
    {
        var rst = "";
        var strIds = context.Request.Params["IDs"] ?? ""; // 小说编号
        if (string.IsNullOrEmpty(strIds)) return;

        var i = NovelBll.BatchDelete(strIds);
        if (i > 0)
        {
            rst = "{\"success\":true,\"Message\": \"小说『" + strIds + "』批量删除成功！\"}";
        }
        else
        {
            rst = "{\"success\":false,\"Message\": \"小说批量删除失败！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

    #region 获取小说抓取参数

    /// <summary>
    ///   获取小说抓取参数
    /// </summary>
    /// <param name="context"></param>
    private void GetNovelCrawl(HttpContext context)
    {
        var strWebId = context.Request.Params["webId"] ?? "";
        var strNovelId = context.Request.Params["novelId"] ?? "";
        if (strWebId.Length > 0) strWebId = strWebId.Trim();
        if (strNovelId.Length > 0) strNovelId = strNovelId.Trim();

        var model = NovelBll.CrawlModel(strWebId, strNovelId);
        var json = new JavaScriptSerializer().Serialize(model);
        context.Response.Write(json);
    }

    #endregion

    #region ProcessRequest

    /// <summary>
    ///   ProcessRequest
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
            //小说信息列表
            case "LIST":
                GetNovelPageList(context);
                break;

            // 小说数据保存
            case "SAVE":
                NovelSave(context);
                break;    

            // 删除小说信息
            case "DELETE":
                Delete(context);
                break;

            // 批量删除小说
            case "BATCHDELETE":
                BatchDelete(context);
                break;

            //获取小说抓取参数
            case "CRAWL":
                GetNovelCrawl(context);
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

    #region 小说数据保存

    /// <summary>
    /// 小说数据保存
    /// </summary>
    /// <param name="context"></param>
    private void NovelSave(HttpContext context)
    {
        var rst = "";
        var strNovelId = context.Request.Params["ID"] ?? ""; // 小说编号
        var strWebId = context.Request.Params["WebId"] ?? ""; // 站点编号
        var strTitle = context.Request.Params["Title"] ?? ""; // 小说名称
        var strNovelUrl = context.Request.Params["NovelUrl"] ?? ""; // 小说地址  
        var strStartUrl = context.Request.Params["StartUrl"] ?? ""; // 起始章节地址       
        var strAuthor = context.Request.Params["Author"] ?? ""; // 作者
        var strChapterChar = context.Request.Params["ChapterChar"] ?? "第$2章"; // 章节模板，默认“第$2章”
        var strStartChapterIdx = context.Request.Params["StartChapterIdx"] ?? "1"; // 起始章节数字，默认1
        var strChapterType = context.Request.Params["ChapterType"] ?? "0"; // 章节处理类型，默认0

        //SELECT     TOP (200) Id, WebId, Title, NovelUrl, StartUrl, LatestChapter, Author, TypeId
        //, Status, RecentUpdate, ChapterCount, CreateTime, ChapterChar, StartChapterIdx, ChapterType
        //FROM         Novels

        try
        {
            string rstType;
            Novels model = new Novels();
            model.WebId = strWebId;
            model.Title = strTitle;
            model.NovelUrl = strNovelUrl;
            model.StartUrl = strStartUrl;
            model.Author = strAuthor;
            model.ChapterChar = strChapterChar;
            model.StartChapterIdx = string.IsNullOrEmpty(strStartChapterIdx) ? 1 : Int32.Parse(strStartChapterIdx);
            model.ChapterType = string.IsNullOrEmpty(strChapterType) ? 0 : Int32.Parse(strChapterType); ;

            var i = 0; // 数据添加/编辑影响行数
            if (string.IsNullOrEmpty(strNovelId))
            {
                // 添加小说数据
                rstType = "添加";
                model.Id = Guid.NewGuid().ToString().ToUpper();
                i = NovelBll.Add(model);
            }
            else
            {
                // 修改小说数据
                rstType = "修改";
                model.Id = strNovelId;
                i = NovelBll.Edit(model);
            }

            if (i > 0)
            {
                rst = "{\"success\":true,\"Message\": \"小说『" + model.Title + "』" + rstType + "成功！\"}";
            }
            else
            {
                rst = "{\"success\":false,\"Message\": \"小说『" + model.Title + "』" + rstType + "失败！\"}";
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