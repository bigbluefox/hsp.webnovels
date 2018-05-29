using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Hsp.Novels.Common
{
    /// <summary>
    ///     内容抓取帮助类
    /// </summary>
    public class CrawlHelper
    {
        /// <summary>
        /// 获取Url地址HTML内容
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static string GetHtml(string url)
        {
            string htmlCode = "";
            HttpWebRequest webRequest = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(url);
            webRequest.Timeout = 30000;
            webRequest.Method = "GET";
            webRequest.UserAgent = "Mozilla/4.0";
            webRequest.Headers.Add("Accept-Encoding", "gzip, deflate");

            HttpWebResponse webResponse = (System.Net.HttpWebResponse)webRequest.GetResponse();
            //获取目标网站的编码格式
            string contentype = webResponse.Headers["Content-Type"];
            Regex regex = new Regex("charset\\s*=\\s*[\\W]?\\s*([\\w-]+)", RegexOptions.IgnoreCase);

            System.IO.Stream streamReceive = null;

            try
            {
                streamReceive = webResponse.GetResponseStream();

                if (webResponse.ContentEncoding.ToLower() == "gzip")//如果使用了GZip则先解压
                {
                    //using (System.IO.Stream streamReceive = webResponse.GetResponseStream()){}

                    if (streamReceive != null)
                        using (var zipStream = new System.IO.Compression.GZipStream(streamReceive, System.IO.Compression.CompressionMode.Decompress))
                        {
                            //匹配编码格式
                            if (regex.IsMatch(contentype))
                            {
                                Encoding ending = Encoding.GetEncoding(regex.Match(contentype).Groups[1].Value.Trim());
                                using (StreamReader sr = new System.IO.StreamReader(zipStream, ending))
                                {
                                    htmlCode = sr.ReadToEnd();
                                }
                            }
                            else
                            {
                                using (StreamReader sr = new System.IO.StreamReader(zipStream, Encoding.UTF8))
                                {
                                    htmlCode = sr.ReadToEnd();
                                }
                            }
                        }
                }
                else
                {
                    //using (System.IO.Stream streamReceive = webResponse.GetResponseStream()){}
                    if (streamReceive != null)
                        using (System.IO.StreamReader sr = new System.IO.StreamReader(streamReceive, Encoding.Default))
                        {
                            htmlCode = sr.ReadToEnd();
                        }
                }
            }
            catch (Exception)
            {

                throw;
            }
            finally
            {
                if (streamReceive != null)
                    streamReceive.Dispose();
            }

            return htmlCode;
        }


        /// <summary>
        ///     内容获取
        /// </summary>
        /// <param name="content">内容</param>
        /// <param name="exp">正则表达式</param>
        /// <returns></returns>
        public static string ContentFetch(string content, string exp)
        {
            var matches = Regex.Matches(content, exp, RegexOptions.IgnoreCase | RegexOptions.Multiline);
            return matches.Cast<Match>().Aggregate("", (current, nextMatch) => current + nextMatch.Groups[1].Value.Trim());

            //foreach (Match nextMatch in matches)
            //{
            //    s += nextMatch.Groups[1].Value.Trim();
            //}
            //return s;
        }

        /// <summary>
        ///     内容清除
        /// </summary>
        /// <param name="content"></param>
        /// <param name="exp"></param>
        /// <returns></returns>
        public static string ContentCleanup(string content, string exp)
        {
            var regex = new Regex(exp, RegexOptions.IgnoreCase);
            var matches = regex.Matches(content);
            if (matches.Count > 0)
            {
                foreach (Match item in matches)
                {
                    var strReplace = item.Groups[0].ToString();
                    content = content.Replace(strReplace, "");
                }
            }

            if (content.Length > 0)
            {
                content = content.Replace("\n\r\n\r", "\n\r");
            }
            return content;
        }

        /// <summary>
        ///     清除HTML标签
        /// </summary>
        /// <param name="html">The html.</param>
        /// <returns></returns>
        public static string StripHtml(string html)
        {
            var strOutput = html;

            var scriptRegExp = new Regex("<scr" + "ipt[^>.]*>[\\s\\S]*?</sc" + "ript>",
                RegexOptions.IgnoreCase & RegexOptions.Compiled & RegexOptions.Multiline &
                RegexOptions.ExplicitCapture);
            strOutput = scriptRegExp.Replace(strOutput, "");

            var styleRegex = new Regex("<style[^>.]*>[\\s\\S]*?</style>",
                RegexOptions.IgnoreCase & RegexOptions.Compiled & RegexOptions.Multiline &
                RegexOptions.ExplicitCapture);
            strOutput = styleRegex.Replace(strOutput, "");

            var objRegExp = new Regex("<(.|\\n)+?>",
                RegexOptions.IgnoreCase & RegexOptions.Compiled & RegexOptions.Multiline);
            strOutput = objRegExp.Replace(strOutput, "");

            objRegExp = new Regex("<[^>]+>", RegexOptions.IgnoreCase & RegexOptions.Compiled & RegexOptions.Multiline);
            strOutput = objRegExp.Replace(strOutput, "");

            strOutput = strOutput.Replace("&lt;", "<");
            strOutput = strOutput.Replace("&gt;", ">");
            strOutput = strOutput.Replace("&nbsp;", " ");

            strOutput = strOutput.Replace("&#34;", "\"");

            return strOutput;
        }
    }
}
