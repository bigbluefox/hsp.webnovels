<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using Hsp.Novels.Common;

public class Handler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");

        var chapterUrl = context.Request.Params["chapterNovelUrl"] ?? "";
        var contentName = context.Request.Params["contentName"] ?? "";
        var headerName = context.Request.Params["headerName"] ?? "";
        var nextName = context.Request.Params["nextName"] ?? "";
        
        chapterUrl = HttpUtility.UrlDecode(chapterUrl);
        
        //url: url, contentName: contentName, headerName: headerName, nextName: nextName

        string html = "", chapterTitle = "", chapterContent = "", nextUrl = "";

        try
        {
            string url = chapterUrl;
            html = CrawlHelper.GetHtml(url);

            var exp = @"<div class=""novel"">([\s\S]*?)<div class=""nr_ad4"">";
            var contentCrawl = CrawlHelper.ContentFetch(html, exp);
            chapterContent = contentCrawl;

            #region 匹配a标签内容

            //var result = "";
            //var i = 0;
            ////exp = @"<a(.)*>";
            //exp = @"(?is)<a(?:(?!href=).)*href=(['""]?)(?<url>[^""\s>]*)\1[^>]*>(?<text>(?:(?!</?a\b).)*)</a>";
            //var regex = new Regex(exp, RegexOptions.IgnoreCase | RegexOptions.Multiline);
            //MatchCollection matches = regex.Matches(contentCrawl);
            //if (matches.Count > 0)
            //{
            //    foreach (Match item in matches)
            //    {
            //        var s = item.Groups[0].ToString();
            //        exp = @"<a[^>]*href=([""'])?(?<href>[^'""]+)\1[^>]*>";
            //        var match = Regex.Match(s, exp, RegexOptions.IgnoreCase);
            //        var href = match.Groups["href"].Value;
            //        if (href == "#") continue;

            //        exp = @"<a[^>]*title=([""'])?(?<title>[^'""]+)\1[^>]*>";
            //        match = Regex.Match(s, exp, RegexOptions.IgnoreCase);
            //        var title = match.Groups["title"].Value;

            //        i++;

            //        href = href.Replace("http://", "");
            //        href = href.Replace("//", "");
            //        href = "http://" + href;
            //        result += title + " * " + href + Environment.NewLine;

            //        //GetSohuContent(href);
            //    }
            //}

            #endregion

            //exp = @"<div class=""main-box clearfix business-news"" data-role=""main-panel"">([\s\S]*?)<li><span data-god-id=";
            //contentCrawl = CrawlHelper.ContentFetch(html, exp);

            #region 匹配P标签内容

            //result = "";
            //i = 0;
            //exp = @"<a(.)*>";
            //regex = new Regex(exp, RegexOptions.IgnoreCase | RegexOptions.Multiline);
            //matches = regex.Matches(contentCrawl);
            //if (matches.Count > 0)
            //{
            //    foreach (Match item in matches)
            //    {
            //        var s = item.Groups[0].ToString();
            //        exp = @"<a[^>]*href=([""'])?(?<href>[^'""]+)\1[^>]*>";
            //        var match = Regex.Match(s, exp, RegexOptions.IgnoreCase);
            //        var href = match.Groups["href"].Value;
            //        if (href == "#") continue;

            //        exp = @"<a[^>]*title=([""'])?(?<title>[^'""]+)\1[^>]*>";
            //        match = Regex.Match(s, exp, RegexOptions.IgnoreCase);
            //        var title = match.Groups["title"].Value;

            //        i++;

            //        href = href.Replace("http://", "");
            //        href = href.Replace("//", "");
            //        href = "http://" + href;
            //        result += title + " * " + href + Environment.NewLine;

            //        GetNewsContent(href);
            //    }
            //}

            #endregion

            //lblMessage.Text = i.ToString();
            //txtContent.Text = result;

        }
        catch (IOException ex)
        {
            html = ex.Message;
            //txtContent.Text = html;
        }
        catch (Exception ex)
        {
            html = ex.Message;
            //txtContent.Text = html;
        }
        finally
        {
        }

        context.Response.Write(chapterUrl + " * " + contentName + " * " + headerName + " * " + nextName + " * " + chapterContent);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}