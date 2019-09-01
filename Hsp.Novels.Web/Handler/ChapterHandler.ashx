<%@ WebHandler Language="C#" Class="ChapterHandler" %>

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using Hsp.Novels.Bll;
using Hsp.Novels.Common;
using Hsp.Novels.Model;
using Ivony.Html;
using Ivony.Html.Parser;

/// <summary>
/// 章节数据一般处理程序
/// </summary>
public class ChapterHandler : IHttpHandler, IRequiresSessionState
{
    /// <summary>
    ///   小说业务逻辑处理
    /// </summary>
    protected NovelBll NovelBll = new NovelBll();
    
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

            // 抓取小说内容
            case "CRAWLCONTENT":
                CrawlContent(context);
                break;

            // 清空小说内容
            case "CLEARCONTENT":
                ClearContent(context);
                break;

            // 清空小说数据
            case "CLEARDATA":
                ClearData(context);
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

        Debug.Assert(string.IsNullOrEmpty(strId), "『章节编号』参数为空！"); 
        
        if (string.IsNullOrEmpty(strId)) return;

        var i = ChapterBll.Delete(strId);
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

        Debug.Assert(string.IsNullOrEmpty(strIds), "『章节编号集合』参数为空！"); 
        
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
        //var strNovelId = context.Request.Params["NovelId"] ?? ""; // 小说编号
        //var strChapterUrl = context.Request.Params["ChapterUrl"] ?? ""; // 章节地址
        //var strNextUrl = context.Request.Params["NextUrl"] ?? ""; // 下一章地址
        var strChapter = context.Request.Params["Chapter"] ?? ""; // 章节
        var strContent = context.Request.Params["Content"] ?? ""; // 章节内容
        //var iWordCount = int.Parse(context.Request.Params["WordCount"] ?? "0"); // 章节字数
        //var iChapterIdx = int.Parse(context.Request.Params["ChapterIdx"] ?? "0"); // 章节字数
        var iValidChapter = int.Parse(context.Request.Params["ValidChapter"] ?? "0"); // 有效章节
        
        // var params = {
        //    NovelId: novelId,
        //    ChapterUrl: encodeURIComponent($("#txtChapterUrl").val()),
        //    NextUrl: encodeURIComponent(nextUrl),
        //    Chapter: encodeURIComponent(txtChapter),
        //    Content: encodeURIComponent(content),
        //    WordCount: contents.length,
        //    ChapterIdx: $("#txtStartChapterIdx").val()
        //    //,ChapterName: "", //HeadWord: ""
        //};       
        
        //if (!string.IsNullOrEmpty(strChapterUrl)) strChapterUrl = HttpUtility.UrlDecode(strChapterUrl);
        //if (!string.IsNullOrEmpty(strNextUrl)) strNextUrl = HttpUtility.UrlDecode(strNextUrl);
        if (!string.IsNullOrEmpty(strChapter)) strChapter = HttpUtility.UrlDecode(strChapter);
        if (!string.IsNullOrEmpty(strContent)) strContent = HttpUtility.UrlDecode(strContent);
        
        try
        {
            string rstType;
            Chapters model = new Chapters();
            //if (!string.IsNullOrEmpty(strChapterId))
            //{
            //    model = ChapterBll.ChapterModel(strChapterId);
            //}
            //model.NovelId = strNovelId;
            //model.ChapterUrl = strChapterUrl;
            //model.NextUrl = strNextUrl;
            model.Chapter = strChapter;
            model.Content = strContent;
            //model.WordCount = iWordCount;
            //model.ChapterIdx = iChapterIdx;
            model.ValidChapter = iValidChapter;
            
            var i = 0;
            if (string.IsNullOrEmpty(strChapterId))
            {
                // 添加章节数据
                rstType = "添加";
                //i = ChapterBll.Add(model);
            }
            else
            {
                // 修改章节数据
                rstType = "修改";
                
                model.Id = strChapterId;
                i = ChapterBll.Edit(model);
            }

            if (i > 0)
            {
                rst = "{\"success\":true,\"Message\": \"章节『" + model.Chapter + "』" + rstType + "成功！\"}";
            }
            else
            {
                rst = "{\"success\":false,\"Message\": \"章节『" + model.Chapter + "』" + rstType + "失败！\"}";
            }
        }
        catch (Exception ex)
        {
            rst = "{\"success\":false,\"Message\": \"" + ex.Message.Replace('"', '\"') + "！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion    
    
    #region 抓取小说内容

    /// <summary>
    ///     抓取小说内容
    /// </summary>
    /// <param name="context"></param>
    private void CrawlContent(HttpContext context)
    {
        var rst = "";

        var strWebId = context.Request.Params["webId"] ?? ""; // 站点编号
        var strNovelId = context.Request.Params["novelId"] ?? ""; // 小说编号
        if (strWebId.Length > 0) strWebId = strWebId.Trim();
        if (strNovelId.Length > 0) strNovelId = strNovelId.Trim();

        //if (string.IsNullOrEmpty(strWebId))
        //{
        //    Debug.Assert(string.IsNullOrEmpty(strWebId), "『站点编号』参数为空！");
        //context.Response.Write("{\"success\":false,\"Message\": \"『站点编号』参数为空\"}");
        //    return;
        //}
        //if (string.IsNullOrEmpty(strNovelId))
        //{
        //    Debug.Assert(string.IsNullOrEmpty(strNovelId), "『小说编号』参数为空！");
        //context.Response.Write("{\"success\":false,\"Message\": \"『小说编号』参数为空\"}");
        //    return;
        //}

        //var novel = NovelBll.CrawlModel(strWebId, strNovelId);
        //if (GetValue(novel, ref rst)) return;
        
        var list = NovelBll.CrawlList(strWebId, strNovelId);

        foreach (var novel in list)
        {
            try
            {
                rst += CrawlContents(novel);
            }
            catch (Exception ex)
            {
                rst += "小说『" + novel.Title + "』抓取失败，原因：+ " + ex.Message.Replace('"', '\"') +"；";
            }
        }

        //rst = "{\"success\":true,\"Message\": \"小说『" + novel.Title + "』抓取成功！\"}";

        //var i = 0;// = ChapterBll.CrawlContent(strId);
        //if (i > 0)
        //{
        //    rst = "{\"success\":true,\"Message\": \"小说『" + strNovelId + "』删除成功！\"}";
        //}
        //else
        //{
        //    rst = "{\"success\":false,\"Message\": \"抓取小说内容失败！\"}";
        //}

        context.Response.Write("{\"success\":true,\"Message\": \"" + rst + "\"}");
    }

    /// <summary>
    /// 抓取小说内容
    /// </summary>
    /// <param name="novel">小说参数实体</param>
    /// <returns></returns>
    private string CrawlContents(Novels novel)
    {
        var rst = "";
        
        if (novel != null)
        {
            var linkLabel = novel.NextName; // 目录标签
            var contentLabel = novel.ContentName; // 内容标签
            var chapterTemplate = novel.ChapterChar; // 章节模板
            var webUrl = novel.WebUrl; // 网站地址
            var novelUrl = novel.NovelUrl; // 小说地址
            var novelId = novel.Id; // 小说编号
            var urlCombine = novel.UrlCombine; // 1：网站+章节地址，2：小说+章节地址
            var encoding = novel.Encoding; // 内容编码：utf-8, gbk

            if (webUrl.EndsWith("/")) webUrl = webUrl.Trim().TrimEnd('/');

            try
            {
                //从指定的地址加载html文档，https://github.com/Ivony/Jumony
                IHtmlDocument html = new JumonyParser().LoadDocument(novelUrl);

                #region 小说名称处理

                //var aLinks = html.Find("meta"); //获取所有的meta标签
                //foreach (var aLink in aLinks)
                //{
                //    if (aLink.Attribute("name").Value() == "keywords")
                //    {
                //        name = aLink.Attribute("content").Value(); //无疆,无疆最新章节,无疆全文阅读
                //    }
                //}

                //name = html.Find("meta[name=keywords]").FirstOrDefault().Attribute("content").Value();
                //name = name.Split(',')[0]; // 小说名称
                //name = name.Replace("最新章节", "");

                #endregion

                // 获取章节目录及地址
                //var lLinks = html.Find(".L");//获取所有class=L的td标签
                //foreach (var lLink in lLinks)//循环class=L的td
                //{ 
                //  //lLink值 例如：<td class="L"><a href="http://www.23us.so/files/article/html/13/13655/5638724.html">楔子</a></td>  
                //}

                // 根据类获取
                var aLinks = html.Find(linkLabel); //获取所有class=L下的a标签

                if (aLinks == null) return "抓取小说『" + novel.Title + "』链接地址为空！";
                var links = aLinks as IList<IHtmlElement> ?? aLinks.ToList();
                //txtTitle.Text = links.Count().ToString();

                if (novelUrl.EndsWith("/")) novelUrl = novelUrl.Trim().TrimEnd('/');

                foreach (var aLink in links)
                {
                    #region 小说地址处理

                    //aLink值 <a href="http://www.23us.so/files/article/html/13/13655/5638724.html">楔子</a>
                    string title = aLink.InnerText(); // 章节标题，楔子 
                    string url = aLink.Attribute("href").Value();
                    if (url == null) continue;
                    
                    if (url == "5529351.html")
                    {
                        var a = url;
                    }

                    var strChapterUrl = url; // 章节地址
                    if (url.IndexOf("http", StringComparison.Ordinal) == -1)
                    {
                        if (!url.StartsWith("/")) url = "/" + url;
                        if (urlCombine == 1)
                        {
                            url = webUrl + url;
                        }
                        else
                        {
                            url = novelUrl + url;
                        }
                    }

                    Chapters model = ChapterBll.ChapterModel(novelId, url);
                    if (model != null && model.Content.Length > 200) continue;

                    #endregion

                    #region 小说内容处理

                    //根据章节的url，获取章节页面的html
                    IHtmlDocument sourceChild = new JumonyParser().LoadDocument(url,
                        System.Text.Encoding.GetEncoding(encoding));

                    //查找id=contents下的小说正文内容
                    string content = "", strSourceContent = "";

                    try
                    {
                        content = sourceChild.Find(contentLabel).FirstOrDefault().InnerHtml();
                        //strSourceContent = content;

                        content = content.Replace("&nbsp;", "").Replace("nbsp;", "");
                        content = content.Replace("&amp;", "");
                        content = content.Replace("　　", "");
                        content = content.Replace("\r", "").Replace("\n", "");
                        content = content.Replace("\0", "");
                        content = content.Replace("()", "");

                        content = Utility.RegexReplace("&#([\\d]{1,})[;]?", content, "");
                        content = Utility.RegexReplace("{([\\s\\S]*?)]", content, "");
                        content = Utility.RegexReplace("<script[^>]*>([\\s\\S]*?)</script>", content, "");
                        //content = RegexReplace("([Pp][Ss][\\d]?.)([\\s\\S]*?)$", content, "");

                        content = content.Replace("??", "");
                        content = content.Replace("readx();", "");
                        content = content.Replace("(未完待续。)", "");
                        content = content.Replace("<>一秒记住【爱^去^小^说^网.】，为您提供精彩小说阅读。", "");
                        //content = content.Replace("", "");
                        content = content.Replace("<>天才壹秒記住『→網.』，為您提供精彩小說閱讀。", "");

                        content = content.Replace("66续续", "陆陆续续");
                        content = content.Replace("曰", "日");

                        content = content.Replace("<br><br>", "<br>").Replace("<br>", Environment.NewLine);
                        content = content.Replace("<br /><br />", "<br />").Replace("<br />", Environment.NewLine);

                        //content = Utility.ClearHTML(content);
                        content = content.Trim();
                    }
                    catch (Exception ex)
                    {
                        content = ex.Message;
                    }

                    //txt文本输出 "　　"
                    //string path = AppDomain.CurrentDomain.BaseDirectory.Replace("\\", "/") + "Txt/";
                    //Novel(title + Environment.NewLine + content, name, path);

                    #endregion

                    #region 小说标题处理

                    title = title.Replace("，", " ").Replace("  ", " ");
                    var firstChar = title.Substring(0, 1);
                    var expFirst = "([○零一二三四五六七八九十百千\\d]{1,})";
                    var isTitle = firstChar == "第";
                    if (!isTitle)
                    {
                        var isTitleChar = TextHelper.ContentExtract(firstChar, expFirst);
                        if (isTitleChar.Length > 0) isTitle = true;
                    }

                    if (!isTitle)
                    {
                        // 楔子：以色列历险
                        var isTitleChar = TextHelper.ContentExtract(title, "(楔子)");
                        if (isTitleChar.Length > 0) isTitle = true;
                    }

                    //if (title.IndexOf("百合子") > -1)
                    //{
                    //    var p = "百合子";
                    //}

                    if (!isTitle) continue; // 合格章节标题的内容才保存入库

                    var chapterIdx = 0;
                    var titleContent = title;
                    string expTitle = "([第]{0,1})([○零一二三四五六七八九十百千\\d]{1,})([节章]{0,1}[：:。, ]{0,2})([\\s\\S]*?)";
                    var titleChapter = TextHelper.ContentExtract(title, expTitle); // 标题章节数字

                    if (!string.IsNullOrEmpty(titleChapter))
                    {
                        titleChapter = titleChapter.Replace(Environment.NewLine, "&");
                        titleChapter = titleChapter.Split('&')[0];

                        titleContent = title.Replace(titleChapter, ""); // 标题名称（除去章节数字）
                        titleChapter = titleChapter.Replace("。", "").Replace("：", "");

                        var expChineseDig = "([○零一二三四五六七八九十百千]{1,})";
                        var strChineseChapter = TextHelper.ContentExtract(titleChapter, expChineseDig); // 章节中文数字 
                        strChineseChapter = strChineseChapter.Replace(Environment.NewLine, "&");
                        strChineseChapter = strChineseChapter.Split('&')[0];

                        if (strChineseChapter.Length == 0)
                        {
                            // 阿拉伯数字
                            titleChapter = TextHelper.ContentExtract(titleChapter, "([\\d]{1,})");
                            titleChapter = titleChapter.Replace(Environment.NewLine, "");
                            int.TryParse(titleChapter, out chapterIdx);
                        }
                        else
                        {
                            if (TextHelper.ContentExtract(strChineseChapter, "([十百千]{1,})").Length > 0)
                            {
                                chapterIdx = int.Parse(TextHelper.DecodeMoneyCn(strChineseChapter).ToString());
                            }
                            else
                            {
                                chapterIdx = int.Parse(TextHelper.DecodeSimpleCn(strChineseChapter));
                            }
                        }

                        if (!string.IsNullOrEmpty(titleContent))
                        {
                            titleContent = titleContent.Trim().TrimEnd('.');
                            titleContent = titleContent.TrimStart(','); // 标题前面的半角逗号清理

                            titleContent = titleContent.Replace("（新书求支持）", "");
                            titleContent = titleContent.Replace("（求收藏、求鲜花）", "");
                            titleContent = titleContent.Replace("（求收藏）", "");
                            titleContent = titleContent.Replace("（改）", "");

                            titleContent = titleContent.Replace("【求鲜花】", "");
                            titleContent = titleContent.Replace("【求首订】", "");
                            titleContent = titleContent.Replace("【鲜花】", "");

                            titleContent = titleContent.Replace("求订阅", "");
                            titleContent = titleContent.Replace("求全定", "");
                            titleContent = titleContent.Replace("求收藏", "");
                            titleContent = titleContent.Replace("求首订", "");

                            titleContent = titleContent.Replace("重复已修改", "");
                            titleContent = titleContent.Replace("补上昨天的", "");

                            titleContent = titleContent.Replace("【】", "").Replace("（）", "").Replace("()", "");

                            //（改）
                        }

                        // 第$2章
                        if (chapterIdx > 0)
                        {
                            titleChapter = chapterTemplate.Replace("$2", chapterIdx.ToString());
                        }

                        if (string.IsNullOrEmpty(titleChapter))
                        {
                            titleChapter = "第$2章".Replace("$2", chapterIdx.ToString());
                        }
                        
                    }

                    #endregion

                    #region 小说内容保存

                    if (model == null)
                    {
                        model = new Chapters();
                        model.NovelId = novelId;
                        model.ChapterUrl = url;
                        model.NextUrl = "";
                        model.Chapter = titleChapter + " " + titleContent;
                        model.ChapterName = titleChapter;
                        model.HeadWord = titleContent;
                        model.Content = content;
                        model.WordCount = content.Length;
                        model.ChapterIdx = chapterIdx;

                        ChapterBll.Add(model);
                    }
                    else
                    {
                        model.Chapter = titleChapter + " " + titleContent;
                        model.Content = content;
                        model.WordCount = content.Length;
                        model.ChapterIdx = chapterIdx;

                        ChapterBll.Edit(model);
                    }

                    #endregion
                }

                rst = "小说『" + novel.Title + "』抓取成功！";
                //rst = "{\"success\":true,\"Message\": \"小说『" + novel.Title + "』抓取成功！\"}";
            }
            catch (Exception ex)
            {
                rst = ex.Message.Replace('"', '\"');
            }
        }
        else
        {
            rst = "小说参数数据为空！}";
        }
        return rst;
    }

    #endregion


    #region 清空小说内容

    /// <summary>
    ///     清空小说内容
    /// </summary>
    /// <param name="context"></param>
    private void ClearContent(HttpContext context)
    {
        var rst = "";
        var strId = context.Request.Params["ID"] ?? ""; // 小说编号
        var strName = context.Request.Params["Name"] ?? ""; // 小说标题

        Debug.Assert(string.IsNullOrEmpty(strId), "『小说编号』参数为空！");

        if (string.IsNullOrEmpty(strId)) return;

        var i = ChapterBll.ClearContent(strId);
        if (i > 0)
        {
            rst = "{\"success\":true,\"Message\": \"小说『" + strName + "』内容清空成功！\"}";
        }
        else
        {
            rst = "{\"success\":false,\"Message\": \"清空小说内容失败！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

    #region 清空小说数据

    /// <summary>
    ///     清空小说数据
    /// </summary>
    /// <param name="context"></param>
    private void ClearData(HttpContext context)
    {
        var rst = "";
        var strId = context.Request.Params["ID"] ?? ""; // 小说编号
        var strName = context.Request.Params["Name"] ?? ""; // 小说标题

        Debug.Assert(string.IsNullOrEmpty(strId), "『小说编号』参数为空！");

        if (string.IsNullOrEmpty(strId)) return;

        var i = ChapterBll.ClearData(strId);
        if (i > 0)
        {
            rst = "{\"success\":true,\"Message\": \"小说『" + strName + "』数据清空成功！\"}";
        }
        else
        {
            rst = "{\"success\":false,\"Message\": \"清空小说数据失败！\"}";
        }

        context.Response.Write(rst);
    }

    #endregion

    
    
    
    
    
    
}