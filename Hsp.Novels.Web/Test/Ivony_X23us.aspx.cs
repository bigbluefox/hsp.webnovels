using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Hsp.Novels.Bll;
using Hsp.Novels.Common;
using Hsp.Novels.Model;
using Ivony.Html;
using Ivony.Html.Parser;

public partial class Test_Ivony_X23us : System.Web.UI.Page
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
        //var novelId = "556144DC-C02F-440E-A4E8-2404D6F8E88F"; // 小说编号，我在唐朝有套房，抗战之超级兵锋

        // 参数定义

        //var linkLabel = ".mulu a"; // 目录标签
        //var contentLabel = ".yd_text2"; // 小说内容标签
        //var webUrl = "https://www.51xunyue.com";
        //var chapterTemplate = "第$2章";

        //var linkLabel = ".chapterlist dd a"; // 目录标签
        //var contentLabel = "#content"; // 小说内容标签
        //var webUrl = "https://www.x23us.la";
        //var chapterTemplate = "第$2章";
        //var urlCombine = 2; // 1：网站+章节地址，2：小说+章节地址

        //var novelUrl = "https://www.x23us.la/html/103/103118/";
        //var htmlUrl = novelUrl;
        //// https://www.x23us.la/html/409/409479/2180623.html

        // 时空小说网
        //var linkLabel = "#list dd a"; // 目录标签
        //var contentLabel = "#content"; // 小说内容标签

        // 1909小说网
        var linkLabel = ".body ul.dirlist li a"; // 目录标签
        var contentLabel = "#chaptercontent"; // 小说内容标签



        var chapterTemplate = "第$2章";

        var webUrl = "https://www.sklhjx.com";
        var novelUrl = "https://www.sklhjx.com/skxs/75525/";
        var novelId = "D60A14CD-4226-4A15-A250-D44C468BC332"; // 抗战之超级帝国
        var urlCombine = 1; // 1：网站+章节地址，2：小说+章节地址

        var encoding = "gbk"; // utf-8

        //"text/html; charset=gbk"

        novelUrl = this.txtTitle.Text;
        contentLabel = this.txtLabel.Text;

        if (webUrl.EndsWith("/")) webUrl = webUrl.Trim().TrimEnd('/');

        try
        {
            //从指定的地址加载html文档
            IHtmlDocument html = new JumonyParser().LoadDocument(novelUrl);

            var content1 = html.Find(contentLabel).FirstOrDefault().InnerHtml();
            //this.txtContent.Text = content1;

            //var b = content1;

            //查找id=contents下的小说正文内容
            string content = "", strSourceContent = "";

            try
            {
                content = content1;
                //content = sourceChild.Find(contentLabel).FirstOrDefault().InnerHtml();
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



                content = content.Replace("<br><br>", "<br>").Replace("<br>", Environment.NewLine);
                content = content.Replace("<br /><br />", "<br />").Replace("<br />", Environment.NewLine);

                //content = Utility.ClearHTML(content);
                content = content.Trim();
            }
            catch (Exception ex)
            {
                content = ex.Message;
            }

            this.txtContent.Text = content;

            return;
            

//在客户端，读写json对象可以使用”.”操作符或”["key”]”，json字符串转换为json对象使用eval()函数。
//在服务 端，由.net对象转换json字符串优先使用JsonConvert对象的SerializeObject方法，定制输出json字符串使用LINQ to JSON。由json字符串转换为.net对象优先使用JsonConvert对象的DeserializeObject方法，然后也可以使用LINQ to JSON。
//根据所需调用方法就行。不过也可以用Newtonsoft.Json这个dll文件，如果转换数组的话就用
 
//1 JObject json = (JObject)JsonConvert.DeserializeObject(str);
//2         JArray array = (JArray)json["article"];
//3  foreach (var jObject in array)
//4         {
//5           //赋值属性
//6 }



            #region 小说名称处理

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
            name = name.Replace("最新章节", "");

            #endregion

            // 获取章节目录及地址
            //var lLinks = html.Find(".L");//获取所有class=L的td标签
            //foreach (var lLink in lLinks)//循环class=L的td
            //{ 
            //  //lLink值 例如：<td class="L"><a href="http://www.23us.so/files/article/html/13/13655/5638724.html">楔子</a></td>  
            //}

            // 根据类获取
            var aLinks = html.Find(linkLabel);//获取所有class=L下的a标签

            if (aLinks == null) return;
            var links = aLinks as IList<IHtmlElement> ?? aLinks.ToList();
            txtTitle.Text = links.Count().ToString();

            if (novelUrl.EndsWith("/")) novelUrl = novelUrl.Trim().TrimEnd('/');

            foreach (var aLink in links)
            {
                #region 小说地址处理

                //aLink值 <a href="http://www.23us.so/files/article/html/13/13655/5638724.html">楔子</a>
                string title = aLink.InnerText();// 章节标题，楔子 
                string url = aLink.Attribute("href").Value();//http://www.23us.so/files/article/html/13/13655/5638724.html

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
                IHtmlDocument sourceChild = new JumonyParser().LoadDocument(url, System.Text.Encoding.GetEncoding(encoding));

                ////查找id=contents下的小说正文内容
                //string content = "", strSourceContent = "";

                //try
                //{
                //    content = sourceChild.Find(contentLabel).FirstOrDefault().InnerHtml();
                //    strSourceContent = content;

                //    content = content.Replace("&nbsp;", "").Replace("nbsp;", "");
                //    content = content.Replace("&amp;", "");
                //    content = content.Replace("　　", "");
                //    content = content.Replace("\r", "").Replace("\n", "");
                //    content = content.Replace("\0", "");
                //    content = content.Replace("()", "");

                //    content = Utility.RegexReplace("&#([\\d]{1,})[;]?", content, "");
                //    content = Utility.RegexReplace("{([\\s\\S]*?)]", content, "");
                //    content = Utility.RegexReplace("<script[^>]*>([\\s\\S]*?)</script>", content, "");
                //    //content = RegexReplace("([Pp][Ss][\\d]?.)([\\s\\S]*?)$", content, "");

                //    content = content.Replace("??", "");
                //    content = content.Replace("readx();", "");
                //    content = content.Replace("(未完待续。)", "");
                //    content = content.Replace("<>一秒记住【爱^去^小^说^网.】，为您提供精彩小说阅读。", "");
                //    //content = content.Replace("", "");
                //    content = content.Replace("<>天才壹秒記住『→網.』，為您提供精彩小說閱讀。", "");

                //    content = content.Replace("66续续", "陆陆续续");



                //    content = content.Replace("<br><br>", "<br>").Replace("<br>", Environment.NewLine);
                //    content = content.Replace("<br /><br />", "<br />").Replace("<br />", Environment.NewLine);
                
                //    //content = Utility.ClearHTML(content);
                //    content = content.Trim();
                //}
                //catch (Exception ex)
                //{
                //    content = ex.Message;
                //}

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


                    }

                    // 第$2章
                    if (chapterIdx > 0)
                    {
                        titleChapter = chapterTemplate.Replace("$2", chapterIdx.ToString());
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
        }
        catch (Exception ex)
        {
            var p = ex.Message;
            var pp = p;
            this.txtContent.Text = ex.Message;
            //throw;
        }

    }


}