using System.IO;
using System.Net;
using System.Text;

namespace Hsp.Novels.Common
{
    public class WebRequestHelper
    {
        /// <summary>
        /// HttpPost
        /// </summary>
        /// <param name="url"></param>
        /// <param name="postDataStr"></param>
        /// <returns></returns>
        public string HttpPost(string url, string postDataStr)
        {
            var cookie = new CookieContainer();
            var request = (HttpWebRequest) WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";
            request.ContentLength = Encoding.UTF8.GetByteCount(postDataStr);
            request.CookieContainer = cookie;
            var myRequestStream = request.GetRequestStream();
            var myStreamWriter = new StreamWriter(myRequestStream, Encoding.GetEncoding("gb2312"));
            myStreamWriter.Write(postDataStr);
            myStreamWriter.Close();

            var response = (HttpWebResponse) request.GetResponse();

            response.Cookies = cookie.GetCookies(response.ResponseUri);
            var myResponseStream = response.GetResponseStream();
            var myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
            var retString = myStreamReader.ReadToEnd();
            myStreamReader.Close();
            myResponseStream.Close();

            return retString;
        }

        /// <summary>
        /// HttpGet
        /// </summary>
        /// <param name="url"></param>
        /// <param name="postDataStr"></param>
        /// <returns></returns>
        public string HttpGet(string url, string postDataStr)
        {
            var request = (HttpWebRequest) WebRequest.Create(url + (postDataStr == "" ? "" : "?") + postDataStr);
            request.Method = "GET";
            HttpWebResponse response;
            request.ContentType = "text/html;charset=UTF-8";
            try
            {
                response = (HttpWebResponse) request.GetResponse();
            }
            catch (WebException ex)
            {
                response = (HttpWebResponse) request.GetResponse();
            }

            var myResponseStream = response.GetResponseStream();
            var myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
            var retString = myStreamReader.ReadToEnd();
            myStreamReader.Close();
            myResponseStream.Close();

            return retString;
        }
    }
}