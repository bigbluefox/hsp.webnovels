<%@ WebHandler Language="C#" Class="ChapterHandler" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using Hsp.Novels.Bll;
using Hsp.Novels.Model;

/// <summary>
/// 章节数据一般处理程序
/// </summary>
public class ChapterHandler : IHttpHandler, IRequiresSessionState
{


    /// <summary>
    ///     章节业务逻辑处理
    /// </summary>
    protected ChapterBll ChapterBll = new ChapterBll();

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
            //获取章节信息列表信息
            case "LIST":
                GetChapterPageList(context);
                break;

            // 删除章节信息
            case "DELETE":
                Delete(context);
                break;

            // 批量删除
            case "BATCHDELETE":
                BatchDelete(context);
                break;

            // 章节保存
            case "SAVE":
                ChapterSave(context);
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

    #region 获取章节信息分页列表信息

    /// <summary>
    ///     获取章节信息分页列表信息
    /// </summary>
    /// <param name="context"></param>
    private void GetChapterPageList(HttpContext context)
    {
        var strTitle = context.Request.Params["qname"] ?? "";
        var strNovelId = context.Request.Params["novelId"] ?? "";
        var strChapterId = context.Request.Params["ChapterId"] ?? "";
        if (strTitle.Length > 0) strTitle = strTitle.Trim();
        if (strNovelId.Length > 0) strNovelId = strNovelId.Trim();
        if (strChapterId.Length > 0) strChapterId = strChapterId.Trim();

        var pageSize = context.Request.Params["pageSize"] ?? "10";
        var pageNumber = context.Request.Params["pageNumber"] ?? "1";

        if (string.IsNullOrEmpty(pageSize)) pageSize = "10";
        if (string.IsNullOrEmpty(pageNumber)) pageNumber = "1";

        var paramList = new Dictionary<string, string>
            {
                {"Title", strTitle},
                {"NovelId", strNovelId},
                {"ChapterId", strChapterId},
                {"PageSize", pageSize},
                {"PageIndex", pageNumber}
            };

        var list = ChapterBll.PageChapterList(paramList);
        var js = new JavaScriptSerializer().Serialize(list);

        //需要返回的数据有总记录数和行数据  
        var json = "{\"total\":" + (list.Count > 0 ? list[0].RecordCount : 0) + ",\"rows\":" + js + "}";

        context.Response.Write(json);
    }

    #endregion


    #region 删除章节

    /// <summary>
    ///     删除章节
    /// </summary>
    /// <param name="context"></param>
    private void Delete(HttpContext context)
    {
        var rst = "";
        var strId = context.Request.Params["ID"] ?? ""; // 章节编号
        if (string.IsNullOrEmpty(strId)) return;

        var i = ChapterBll.Delete(int.Parse(strId));
        if (i > 0)
        {
            rst = "{\"success\":true,\"Message\": \"章节『" + strId + "』删除成功！\"}";
        }
        else
        {
            rst = "{\"success\":false,\"Message\": \"章节删除失败！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

    #region 批量删除章节

    /// <summary>
    ///     批量删除章节
    /// </summary>
    /// <param name="context"></param>
    private void BatchDelete(HttpContext context)
    {
        var rst = "";
        var strIds = context.Request.Params["IDs"] ?? "";// 章节编号
        if (string.IsNullOrEmpty(strIds)) return;

        var i = ChapterBll.BatchDelete(strIds);
        if (i > 0)
        {
            rst = "{\"success\":true,\"Message\": \"章节『" + strIds + "』批量删除成功！\"}";
        }
        else
        {
            rst = "{\"success\":false,\"Message\": \"章节批量删除失败！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

    #region 章节数据保存

    /// <summary>
    /// 章节数据保存
    /// </summary>
    /// <param name="context"></param>
    private void ChapterSave(HttpContext context)
    {
        var rst = "";
        var strChapterId = context.Request.Params["ID"] ?? ""; // 章节编号
        var strNovelId = context.Request.Params["NovelId"] ?? ""; // 小说编号
        var strChapterUrl = context.Request.Params["ChapterUrl"] ?? ""; // 章节地址
        var strNextUrl = context.Request.Params["NextUrl"] ?? ""; // 下一章地址
        var strChapter = context.Request.Params["Chapter"] ?? ""; // 章节
        var strContent = context.Request.Params["Content"] ?? ""; // 章节内容
        var iWordCount = int.Parse(context.Request.Params["WordCount"] ?? "0"); // 章节字数

        //NovelId, Url, NextUrl, Chapter, Content, WordCount

        if (!string.IsNullOrEmpty(strChapterUrl)) strChapterUrl = HttpUtility.UrlDecode(strChapterUrl);
        if (!string.IsNullOrEmpty(strNextUrl)) strNextUrl = HttpUtility.UrlDecode(strNextUrl);
        if (!string.IsNullOrEmpty(strChapter)) strChapter = HttpUtility.UrlDecode(strChapter);
        if (!string.IsNullOrEmpty(strContent)) strContent = HttpUtility.UrlDecode(strContent);
        
        try
        {
            string rstType;
            Chapters model = new Chapters();
            model.NovelId = strNovelId;
            model.Url = strChapterUrl;
            model.NextUrl = strNextUrl;
            model.Chapter = strChapter;
            model.Content = strContent;
            model.WordCount = iWordCount;

            var i = 0;
            if (string.IsNullOrEmpty(strChapterId))
            {
                // 添加章节栏目数据
                rstType = "添加";
                //model.ChapterID = Guid.NewGuid().ToString().ToUpper();
                //model.Password = model.DefalutPwd;
                i = ChapterBll.Add(model);
            }
            else
            {
                // 修改章节栏目数据
                rstType = "修改";
                model.Id = strChapterId;
                i = ChapterBll.Edit(model);
            }

            if (i > 0)
            {
                rst = "{\"success\":true,\"Message\": \"章节『" + model.ChapterName + "』" + rstType + "成功！\"}";
            }
            else
            {
                rst = "{\"success\":false,\"Message\": \"章节『" + model.ChapterName + "』" + rstType + "失败！\"}";
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