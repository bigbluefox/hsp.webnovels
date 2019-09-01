using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Hsp.Novels.Common;
using Ivony.Html;
using Ivony.Html.Parser;

public partial class Test_StdTest : System.Web.UI.Page
{
    private static Encoding encoding = Encoding.UTF8;

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        var isJson = true;
        // 1. 全国标准信息公共服务平台 
        // http://std.samr.gov.cn/
        //isJson = true;
        //var contentLabel = "table"; // 内容标签
        //var webSite = "http://std.samr.gov.cn";
        //var webUrl = "http://std.samr.gov.cn/noc/nocGB";
        //// 国家标准公告 
        //var jsonUrl = "http://std.samr.gov.cn/noc/search/nocGBPage?searchText=&sortOrder=asc&pageSize=15&pageNumber=1&_=1566962144462";

        // 2. 中国国家标准化管理委员会
        //isJson = false;
        // http://openstd.samr.gov.cn/bzgk/gb/std_list_type?p.p1=1&p.p90=circulation_date&p.p91=desc
        //var linkLabel = ".body ul.dirlist li a"; // 目录标签
        //var contentLabel = "table:last-child tbody:last-child tr"; // 内容标签
        //var webUrl = "http://openstd.samr.gov.cn/bzgk/gb/std_list_type?r=0.9307793780759421&page=3&pageSize=10&p.p1=1&p.p90=circulation_date&p.p91=desc";

        //3. 中国政府网
        //var webSite = "http://www.gov.cn";
        // http://www.gov.cn/fuwu/bzxxcx/bzh.htm
        //isJson = true;
        // 国家标准公告 
        var jsonUrl = "http://std.sacinfo.org.cn/gnoc/queryList?page=1&pageSize=999";
        //var jsonUrl = "http://std.sacinfo.org.cn/gnoc/queryAll";
        
        //2.1. 国家工程建设标准化信息网，使用ASP.NET组件分页，无法获取
        //isJson = false;
        //var contentLabel = "table:last-child tbody:last-child tr"; // 内容标签
        //var webUrl = "http://www.ccsn.gov.cn/bzgg/More.aspx?Class=004001";
        
        //2.2. 中华人民共和国住房和城乡建设部，静态页面
        //isJson = false;
        //var contentLabel = "table table table:last-child table tr"; // 内容标签
        //var webUrl = "http://www.mohurd.gov.cn/bzde/bzfbgg/index.html"; // index_2.html

        //2.3. 中国电力企业联合会
        isJson = false;
        //http://dls.cec.org.cn/zhongdianlianbiaozhun/
        //var contentLabel = ".gjzz_nr_lb ul li"; // 内容标签
        //var webUrl = "http://dls.cec.org.cn/zhongdianlianbiaozhun/index.html"; // index_2.html


        // 中国标准在线

        isJson = false;
        //http://dls.cec.org.cn/zhongdianlianbiaozhun/
        var contentLabel = ".news-list ul li"; // 内容标签
        var webUrl = "https://www.spc.org.cn/news/stdfile/f0"; // index_2.html


        // 公告分类：国家标准公告，行业标准备案公告，地方标准备案公告

        try
        {
            if (isJson)
            {
                #region IsJson

                #region 1. 全国标准信息公共服务平台

                //{
                //    "C_TITLE": "关于批准发布《水质 石油类（紫外法）标准 样品》等16项国家标准样品的公告",
                //    "ISSUE_DATE": "2019-07-25",
                //    "NO": "2019年第8号",
                //    "PID": "7A28FA1A67F4F84E156A748A777F56A6",
                //    "id": "8F07DD166DF93443E05397BE0A0A17EA"
                //}

                //var rst = HttpPost(jsonUrl, "", Encoding.UTF8, "application/json;charset=UTF-8");

                //var b = rst;
                //if (!string.IsNullOrEmpty(rst))
                //{
                //    var dataResult = JsonHelper.JsonDeserialize<AnnouncementResult>(rst);
                //    var aa = dataResult.rows[0].C_TITLE;
                //    this.txtContent.Text = new JavaScriptSerializer().Serialize(dataResult.rows);
                //}

                //var durl = "http://std.sacinfo.org.cn/gnoc/queryInfo?id=667A20C2D5E1AD5E1146B8EE606C5416";
                ////var drst = HttpPost(durl, "", Encoding.UTF8, "application/json;charset=UTF-8");
                ////var d = drst;


                //var ddrst = HttpUitls.Get(durl);
                //var ddd = ddrst;


                //IHtmlDocument html = new JumonyParser().LoadDocument(durl);

                //// container

                //var content1 = html.Find(".container").FirstOrDefault().OuterHtml();

                //this.txtContent.Text = content1;

                #endregion

                //{
                //    "otherResultColumns": {

                //    },
                //    "id": "1029",
                //    "code": "2018年第8号",
                //    "noticeDate": "2018-05-18",
                //    "content": "关于批准发布《蜂产业项目运营管理规范》等11项国家标准化指导性技术文件的公告",
                //    "status": "1",
                //    "batch": "140",
                //    "remark": null,
                //    "content2": "国家市场监督管理总局、国家标准化管理委员会批准《蜂产业项目运营管理规范》等11项国家标准化指导性技术文件，现予以公布（见附件）。",
                //    "publishDept": "国家市场监督管理总局   国家标准委",
                //    "attFile": "/1526885017933.doc",
                //    "aesId": "89FE00F263A4FC584EB071CE14BB36A7"
                //}

                var rst = HttpPost(jsonUrl, "{page:1}");

                this.txtContent.Text = rst;

                #endregion
            }
            else
            {
                // 936 gb2312 Chinese Simplified (GB2312)
                //54936 GB18030 Chinese Simplified (GB18030)
                //65001 utf-8 Unicode (UTF-8)

                #region 2. 中国国家标准化管理委员会
                // 2. 中国国家标准化管理委员会 Encoding.GetEncoding("GB2312");
                // 2.2. 中华人民共和国住房和城乡建设部 Encoding.UTF8
                // 2.3. 中国电力企业联合会 Encoding.GetEncoding("GB2312");

                encoding = Encoding.GetEncoding("GB18030");

                //从指定的地址加载html文档
                IHtmlDocument html = new JumonyParser().LoadDocument(webUrl, encoding);
                //IHtmlDocument html = new JumonyParser().LoadDocument(webUrl);

                //var content1 = html.Find(contentLabel).FirstOrDefault().InnerHtml();
                //var content1 = html.Find(contentLabel).FirstOrDefault().InnerHtml();

                var table = html.Find(contentLabel).ToList();

                var htmls = "";
                foreach (var tr in table)
                {
                    htmls += tr.OuterHtml();
                }

                #endregion

                //var ddrst = HttpUitls.Get(webUrl);
                //htmls = ddrst;

                this.txtContent.Text = htmls;                
            }




        }
        catch (Exception)
        {
            
            throw;
        }

    }

    #region 凭证验证结果实体

    /// <summary>
    /// 获取凭证参数实体
    /// </summary>
    public class EnnTokenParams
    {
        /// <summary>
        /// 应用Id
        /// </summary>
        public string appId { get; set; }

        /// <summary>
        /// 应用密文串
        /// </summary>
        public string appSecret { get; set; }
    }


    /// <summary>
    /// 国家标准公告数据查询结构
    /// </summary>
    public class AnnouncementResult
    {
        /// <summary>
        /// 当前页码
        /// </summary>
        public int pageNumber { get; set; }

        /// <summary>
        /// 数据总量
        /// </summary>
        public int total { get; set; }

        /// <summary>
        /// 数据实体
        /// </summary>
        public List<NationalStandardsAnnouncement> rows { get; set; }
    }

    /// <summary>
    /// 国家标准公告
    /// http://std.samr.gov.cn/noc/nocGB
    /// URL: http://std.samr.gov.cn/noc/search/nocGBPage?searchText=&sortOrder=asc&pageSize=15&pageNumber=1&_=1566962144462
    /// </summary>
    public class NationalStandardsAnnouncement
    {
        /// <summary>
        /// 公告编号
        /// </summary>
        public string id { get; set; }

        /// <summary>
        /// 父级编号
        /// </summary>
        public string PID { get; set; }

        /// <summary>
        /// 公告号
        /// </summary>
        public string NO { get; set; }

        /// <summary>
        /// 公告标题
        /// </summary>
        public string C_TITLE { get; set; }

        /// <summary>
        /// 发布日期
        /// </summary>
        public string ISSUE_DATE { get; set; }

    }

    #endregion

    #region Post数据接口

    public static string HttpPost(string postUrl)
    {
        return HttpPost(postUrl, "");
    }

    /// <summary>
    ///     Post数据接口
    /// </summary>
    /// <param name="postUrl">接口地址</param>
    /// <param name="paramData">提交json数据</param>
    /// <param name="dataEncode">编码方式</param>
    /// <param name="contentType">内容类型</param>
    /// <returns></returns>
    public static string HttpPost(string postUrl, string paramData, Encoding dataEncode, string contentType)
    {
        string ret = string.Empty;
        try
        {
            byte[] byteArray = dataEncode.GetBytes(paramData); //转化
            var webReq = (HttpWebRequest)WebRequest.Create(new Uri(postUrl));
            webReq.Method = "POST";
            //webReq.ContentType = "application/x-www-form-urlencoded";
            webReq.ContentType = contentType;
            webReq.ContentLength = byteArray.Length;
            Stream dataStream = webReq.GetRequestStream();
            dataStream.Write(byteArray, 0, byteArray.Length); //写入参数
            dataStream.Close();
            var response = (HttpWebResponse)webReq.GetResponse();
            var sr = new StreamReader(response.GetResponseStream(), dataEncode);
            ret = sr.ReadToEnd();
            sr.Close();
            response.Close();
            dataStream.Close();
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
        return ret;
    }

    /// <summary>
    /// Post数据接口 (Json)
    /// </summary>
    /// <param name="url"></param>
    /// <param name="param"></param>
    /// <returns></returns>
    public static string HttpPost(string url, string param)
    {
        string strURL = url;
        System.Net.HttpWebRequest request;
        request = (System.Net.HttpWebRequest)WebRequest.Create(strURL);
        request.Method = "POST";
        request.ContentType = "application/json;charset=UTF-8";
        string paraUrlCoded = param;
        byte[] payload;
        payload = System.Text.Encoding.UTF8.GetBytes(paraUrlCoded);
        request.ContentLength = payload.Length;
        Stream writer = request.GetRequestStream();
        writer.Write(payload, 0, payload.Length);
        writer.Close();
        System.Net.HttpWebResponse response;
        response = (System.Net.HttpWebResponse)request.GetResponse();
        System.IO.Stream s;
        s = response.GetResponseStream();
        string StrDate = "";
        string strValue = "";
        StreamReader Reader = new StreamReader(s, Encoding.UTF8);
        while ((StrDate = Reader.ReadLine()) != null)
        {
            strValue += StrDate + "\r\n";
        }
        return strValue;
    }

    #endregion
}

public class HttpUitls
{
    public static string Get(string Url)
    {
        //System.GC.Collect();
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url);
        request.Proxy = null;
        request.KeepAlive = false;
        request.Method = "GET";
        request.ContentType = "application/json; charset=UTF-8";
        request.AutomaticDecompression = DecompressionMethods.GZip;

        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        Stream myResponseStream = response.GetResponseStream();
        StreamReader myStreamReader = new StreamReader(myResponseStream, Encoding.UTF8);
        string retString = myStreamReader.ReadToEnd();

        myStreamReader.Close();
        myResponseStream.Close();

        if (response != null)
        {
            response.Close();
        }
        if (request != null)
        {
            request.Abort();
        }

        return retString;
    }

    public static string Post(string Url, string Data, string Referer)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url);
        request.Method = "POST";
        request.Referer = Referer;
        byte[] bytes = Encoding.UTF8.GetBytes(Data);
        request.ContentType = "application/x-www-form-urlencoded";
        request.ContentLength = bytes.Length;
        Stream myResponseStream = request.GetRequestStream();
        myResponseStream.Write(bytes, 0, bytes.Length);

        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        StreamReader myStreamReader = new StreamReader(response.GetResponseStream(), Encoding.UTF8);
        string retString = myStreamReader.ReadToEnd();

        myStreamReader.Close();
        myResponseStream.Close();

        if (response != null)
        {
            response.Close();
        }
        if (request != null)
        {
            request.Abort();
        }
        return retString;
    }

}