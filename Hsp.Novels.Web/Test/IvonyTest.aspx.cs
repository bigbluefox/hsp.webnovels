using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Hsp.Novels.Bll;
using Hsp.Novels.Common;
using Hsp.Novels.Model;
using Ivony.Html;
using Ivony.Html.Parser;

public partial class Test_IvonyTest : System.Web.UI.Page
{
    /// <summary>
    ///     章节业务逻辑处理
    /// </summary>
    protected ChapterBll ChapterBll = new ChapterBll();

    protected void Page_Load(object sender, EventArgs e)
    {

    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        //var cra = new WebRequestHelper();

        //<h1 class=""oneline"">(.+)</h1><div class=""yd_text2"">(.|\n)*?</div>
        //var html = cra.HttpGet("", "");

        var name = ""; // 小说名称
        var novelId = "26C90CA3-DA1E-42ED-A144-EFE2610A0650"; // 小说编号

        // 参数定义

        var linkLabel = ".mulu a"; // 目录标签
        var contentLabel = ".yd_text2"; // 小说内容标签
        var webUrl = "https://www.51xunyue.com";

        var chapterTemplate = "第$2章";


        var htmlUrl =
            "https://www.51xunyue.com/novels_info/kai-zhao-fang-che-hui-da-tang/a24c77042041da16c34d28a50a909cf3/";


        htmlUrl = "https://www.cn8118.com/0/10770/2284092.html";


        try
        {
            //从指定的地址加载html文档
            IHtmlDocument html = new JumonyParser().LoadDocument(htmlUrl);

            #region 小说名称

            //var aLinks = html.Find("meta"); //获取所有的meta标签
            //foreach (var aLink in aLinks)
            //{
            //    if (aLink.Attribute("name").Value() == "keywords")
            //    {
            //        name = aLink.Attribute("content").Value(); //无疆,无疆最新章节,无疆全文阅读
            //    }
            //}

            name = html.Find("meta[name=keywords]").FirstOrDefault().Attribute("content").Value();
            name = name.Split(',')[0]; // 小说名称

            #endregion

            // 获取章节目录及地址
            //var lLinks = html.Find(".L");//获取所有class=L的td标签
            //foreach (var lLink in lLinks)//循环class=L的td
            //{ 
            //  //lLink值 例如：<td class="L"><a href="http://www.23us.so/files/article/html/13/13655/5638724.html">楔子</a></td>  
            //}


            // 根据类获取
            var aLinks = html.Find(linkLabel);//获取所有class=L下的a标签
            foreach (var aLink in aLinks)
            {
                //aLink值 <a href="http://www.23us.so/files/article/html/13/13655/5638724.html">楔子</a>
                string title = aLink.InnerText();// 章节标题，楔子 
                string url = aLink.Attribute("href").Value();//http://www.23us.so/files/article/html/13/13655/5638724.html

                #region 小说地址处理

                var strChapterUrl = url; // 章节地址
                if (url.IndexOf("http", StringComparison.Ordinal) == -1)
                {
                    if (webUrl.EndsWith("/")) webUrl = webUrl.Trim().TrimEnd('/');
                    if (!url.StartsWith("/")) url = "/" + url;
                    url = webUrl + url;
                }

                #endregion

                //根据章节的url，获取章节页面的html
                IHtmlDocument sourceChild = new JumonyParser().LoadDocument(url, System.Text.Encoding.GetEncoding("utf-8"));

                //查找id=contents下的小说正文内容
                string content = sourceChild.Find(contentLabel).FirstOrDefault().InnerHtml().Replace("&nbsp;", "").Replace("<br />", System.Environment.NewLine);
                content = Utility.ClearHTML(content);

                //txt文本输出
                //string path = AppDomain.CurrentDomain.BaseDirectory.Replace("\\", "/") + "Txt/";
                //Novel(title + Environment.NewLine + content, name, path);


                #region 小说内容保存

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
                string expTitle = "([第]{0,1})([○零一二三四五六七八九十百千\\d]{1,})([节章]{0,1}[：:。 ]{0,2})([\\s\\S]*?)";
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

                    if (string.IsNullOrEmpty(titleContent)) titleContent = titleContent.Trim();
                    //if (titleChapter.IndexOf("第", StringComparison.Ordinal) == -1)
                    //{
                    //    titleChapter = titleChapter.TrimEnd(' ').TrimEnd(' ');
                    //    titleChapter = "第" + titleChapter + "节";
                    //}

                    // 第$2章
                    if (chapterIdx > 0)
                    {
                        titleChapter = chapterTemplate.Replace("$2", chapterIdx.ToString());
                    }
                }

                Chapters model = new Chapters();
                model.NovelId = novelId;
                model.ChapterUrl = strChapterUrl;
                model.NextUrl = "";
                model.Chapter = titleChapter + " " + titleContent;
                model.Content = content;
                model.WordCount = content.Length;
                model.ChapterIdx = chapterIdx;

                ChapterBll.Add(model);

                #endregion

            }
        }
        catch (Exception ex)
        {
            var p =ex.Message;
            var pp = p;
            //throw;
        }







        // 根据ID获取
        //var chapterLink = html.Find("#at a");//查找id=at下的所有a标签
        //foreach (var i in chapterLink)//这里循环的就是a标签
        //{
        //    //aLink值 例如：<a href="http://www.23us.so/files/article/html/13/13655/5638724.html">楔子</a> 
        //    string title = i.InnerText();//楔子
        //    string url = i.Attribute("href").Value();//http://www.23us.so/files/article/html/13/13655/5638724.html 
        //}





    }
}