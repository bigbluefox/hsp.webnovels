using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI;
using Hsp.Novels.Bll;
using Hsp.Novels.Common;
using Hsp.Novels.Model;

public partial class Test_Test1 : Page
{
    /// <summary>
    ///     章节业务逻辑处理
    /// </summary>
    protected ChapterBll ChapterBll = new ChapterBll();

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Button1_Click(object sender, EventArgs e)
    {
        //var linkLabel = "#list dd a"; // 目录标签
        //var contentLabel = "#content"; // 小说内容标签

        // 1909小说网
        var linkLabel = ".body ul.dirlist li a"; // 目录标签
        var contentLabel = "#chaptercontent"; // 小说内容标签

        var chapterTemplate = "第$2章";

        var webUrl = "https://www.sklhjx.com";
        var novelUrl = "https://www.sklhjx.com/skxs/73880/";
        var novelId = "556144DC-C02F-440E-A4E8-2404D6F8E88F"; // 抗战之超级帝国
        var urlCombine = 1; // 1：网站+章节地址，2：小说+章节地址

        novelUrl = this.txtTitle.Text;

        if (webUrl.EndsWith("/")) webUrl = webUrl.Trim().TrimEnd('/');
        if (novelUrl.EndsWith("/")) novelUrl = novelUrl.Trim().TrimEnd('/');

        var cra = new WebRequestHelper();

        //<h1 class=""oneline"">(.+)</h1><div class=""yd_text2"">(.|\n)*?</div>
        var html = cra.HttpGet(novelUrl, "");

        // 获取小说名字
        var ma_name = Regex.Match(html, @"<meta name=""keywords"".+content=""(.+)"">");//@"<meta name=""keywords"".+content=""(.+)""/>"
        var name = ma_name.Groups[1].Value.Split(',')[0];

        // 获取章节目录
        //var reg_chuangmulu = new Regex(@"<div class=""mulu"">(.|\n)*?</ul>");
        var reg_mulu = new Regex(@"<div id=""list"">(.|\n)*?</dl>");
        var mat_mulu = reg_mulu.Match(html);
        var mulu = mat_mulu.Groups[0].ToString();

        // 匹配a标签里面的url
        var tmpreg = new Regex("<a[^>]+?href=\"([^\"]+)\"[^>]*>([^<]+)</a>", RegexOptions.Compiled);
        var sMC = tmpreg.Matches(mulu);
        if (sMC.Count != 0)
        {
            //循环目录url，获取正文内容
            for (var i = 0; i < sMC.Count; i++)
            {
                //sMC[i].Groups[1].Value
                //0是<a href="http://www.23us.so/files/article/html/13/13655/5638725.html">第一章 泰山之巅</a> 
                //1是http://www.23us.so/files/article/html/13/13655/5638725.html
                //2是第一章 泰山之巅

                // 获取章节标题
                var title = sMC[i].Groups[2].Value;

                // 获取文章内容
                var url = sMC[i].Groups[1].Value;
                var strChapterUrl = url; // 章节地址
                if (url.IndexOf("http", StringComparison.Ordinal) == -1)
                {
                    if (!url.StartsWith("/")) url = "/" + url;
                    url = "https://www.51xunyue.com" + url;
                }
                var html_z = cra.HttpGet(url, "");

                // 获取小说名字,章节中也可以查找名字
                //Match ma_name = Regex.Match(html, @"<meta name=""keywords"".+content=""(.+)"" />");
                //string name = ma_name.Groups[1].Value.ToString().Split(',')[0];

                // 获取标题,通过分析h1标签也可以得到章节标题
                //string title = html_z.Replace("<h1>", "*").Replace("</h1>", "*").Split('*')[1];

                // 获取正文
                var reg = new Regex(@"<div class=""yd_text2"">(.|\n)*?</div>");
                var mc = reg.Matches(html_z);
                var mat = reg.Match(html_z);
                var content =
                    mat.Groups[0].ToString()
                        .Replace("<div class=\"yd_text2\">", "")
                        .Replace("</div>", "")
                        .Replace("&nbsp;", "")
                        .Replace("<br />", Environment.NewLine);

                content = Utility.ClearHTML(content);

                // txt文本输出
                //var path = AppDomain.CurrentDomain.BaseDirectory.Replace("\\", "/") + "Txt/";
                //Novel(title + Environment.NewLine + content, name, "");

                #region 小说内容保存

                title = title.Replace("。", " ").Replace("，", " ").Replace("  ", " ");
                var firstChar = title.Substring(0, 1);
                var expFirst = "([○零一二三四五六七八九十百千\\d]{1,})";
                var isTitle = firstChar == "第";
                if (!isTitle)
                {
                    var isTitleChar = TextHelper.ContentExtract(firstChar, expFirst);
                    if (isTitleChar.Length > 0) isTitle = true;
                }

                if (title.IndexOf("百合子") > -1)
                {
                    var p = "百合子";
                }

                if (isTitle)
                {
                    var chapterIdx = 0;
                    var titleContent = title;
                    string expTitle = "([第]{0,1})([○零一二三四五六七八九十百千\\d]{1,})([节章]{0,1}[ ]{0,2}[：:]{0,1})([\\s\\S]*?)";
                    var titleChapter = TextHelper.ContentExtract(title, expTitle); // 标题章节数字
                    if (!string.IsNullOrEmpty(titleChapter))
                    {
                        titleChapter = titleChapter.Replace(Environment.NewLine, "&");
                        titleChapter = titleChapter.Split('&')[0];

                        titleContent = title.Replace(titleChapter, ""); // 标题名称（除去章节数字）

                        var expChineseDig = "([○零一二三四五六七八九十百千]{1,})";
                        var strChineseChapter = TextHelper.ContentExtract(titleChapter, expChineseDig); // 章节中文数字 
                        strChineseChapter = strChineseChapter.Replace(Environment.NewLine, "&");
                        strChineseChapter = strChineseChapter.Split('&')[0];

                        if (strChineseChapter.Length == 0)
                        {
                            // 阿拉伯数字
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
                        if (titleChapter.IndexOf("第", StringComparison.Ordinal) == -1)
                        {
                            titleChapter = titleChapter.TrimEnd(' ').TrimEnd(' ');
                            titleChapter = "第" + titleChapter + "节";
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

                }

                #endregion

                //txtTitle.Text = name;
                //txtContent.Text = content;
            }
        }


    }


    private void button1_Click(object sender, EventArgs e)
    {
        //string[] vTestText = { 
        //"十二点五六", 
        //"一亿零一万零五", 
        //"四万万", 
        //"九十八亿七千六百五十四万三千二百一十",
        //"五元一角四分", "壹佰元整",
        //"三千五百万",
        //"九块二毛"};
        //foreach (string vText in vTestText)
        //{
        //    Console.WriteLine("DecodeMoneyCn(\"{0}\")={1}", vText,
        //        TextHelper.DecodeMoneyCn(vText));
        //}

        //输出
        //DecodeMoneyCn("十二点五六")=2.56
        //DecodeMoneyCn("一亿零一万零五")=100010005
        //DecodeMoneyCn("四万万")=400000000
        //DecodeMoneyCn("九十八亿七千六百五十四万三千二百一十")=9876543210
        //DecodeMoneyCn("五元一角四分")=5.14
        //DecodeMoneyCn("壹佰元整")=100
        //DecodeMoneyCn("三千五百万")=35000000
        //DecodeMoneyCn("九块二毛")=9.2
        //DecodeMoneyCn("一兆")=1000000000000
    }

    /// <summary>
    /// 创建文本
    /// </summary>
    /// <param name="content">内容</param>
    /// <param name="name">名字</param>
    /// <param name="path">路径</param>
    public void Novel(string content, string name, string path)
    {
        var rootPath = "/Novels/";

        if (string.IsNullOrEmpty(path))
        {
            path = Server.MapPath(rootPath);
        }

        string Log = content + Environment.NewLine;
        //创建文件夹，如果不存在就创建file文件夹
        if (Directory.Exists(path) == false)
        {
            Directory.CreateDirectory(path);
        }

        //判断文件是否存在，不存在则创建
        if (!System.IO.File.Exists(path + name + ".txt"))
        {
            FileStream fs1 = new FileStream(path + name + ".txt", FileMode.Create, FileAccess.Write);//创建写入文件 
            StreamWriter sw = new StreamWriter(fs1);
            sw.WriteLine(Log);//开始写入值
            sw.Close();
            fs1.Close();
        }
        else
        {
            FileStream fs = new FileStream(path + name + ".txt" + "", FileMode.Append, FileAccess.Write);
            StreamWriter sr = new StreamWriter(fs);
            sr.WriteLine(Log);//开始写入值
            sr.Close();
            fs.Close();
        }
    }
}