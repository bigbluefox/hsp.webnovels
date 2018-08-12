using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Hsp.Novels.Common
{
    /// <summary>
    /// 文件帮助类
    /// </summary>
    public class FileHelper
    {
        #region 如果目录不存在，建立

        /// <summary>
        /// 如果目录不存在，建立
        /// </summary>
        /// <param name="dirName">目录名称</param>
        public static void FilePathCheck(string dirName)
        {
            var directoryName = Path.GetDirectoryName(dirName);
            if (directoryName == null) return;
            String path = directoryName.TrimEnd('\\');
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
        }

        #endregion

        #region 流文件下载

        public static void DownLoadold(string file, string name, string ext)
        {
            DownLoadold(file, name, ext, "IE");
        }

        /// <summary>
        ///     流文件下载
        /// </summary>
        /// <param name="file">文件物理路径</param>
        /// <param name="name">文件名称</param>
        /// <param name="ext">文件扩展名</param>
        /// <param name="browser">浏览器</param>
        public static void DownLoadold(string file, string name, string ext, string browser)
        {
            if (!File.Exists(file)) return;
            var strContentType = "";
            ext = ext.Trim('.'); // 清除扩展名的点号
            name = name.Replace(" ", "　");　// 替换文件名半角空格为全角空格
            switch (ext.ToUpper())
            {
                case "PDF":
                    strContentType = ContentType.PDF;
                    break;
                case "DOC":
                    strContentType = ContentType.DOC;
                    break;
                case "DOCX":
                    strContentType = ContentType.DOCX;
                    break;
                case "XLS":
                    strContentType = ContentType.XLS;
                    break;
                case "XLSX":
                    strContentType = ContentType.XLSX;
                    break;
                case "PPT":
                    strContentType = ContentType.PPT;
                    break;
                case "PPTX":
                    strContentType = ContentType.PPTX;
                    break;
                case "ET":
                    strContentType = ContentType.ET;
                    break;
                case "DPS":
                    strContentType = ContentType.DPS;
                    break;
                case "WPS":
                    strContentType = ContentType.WPS;
                    break;
                case "ZIP":
                    strContentType = ContentType.ZIP;
                    break;
                case "RAR":
                    strContentType = ContentType.RAR;
                    break;
                case "PNG":
                    strContentType = ContentType.PNG;
                    break;
                case "JPG":
                    strContentType = ContentType.JPG;
                    break;
                case "TXT":
                    strContentType = ContentType.TXT;
                    break;
                default:
                    strContentType = ContentType.DEFAULT;
                    break;
            }

            //InternetExplorer
            //Firefox
            //Chrome
            //IE
            //Safari

            var filename = HttpUtility.UrlEncode(name, Encoding.UTF8);
            filename = filename.Replace("+", "%20");

            //if (browser == "InternetExplorer" || browser == "IE")
            //{
            //}

            // 火狐、Safari浏览器不需将中文文件名进行编码格式转换
            if (browser == "Firefox" || browser == "Safari")
            {
                filename = name;
            }

            var fi = new FileInfo(file);
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.Buffer = false;
            HttpContext.Current.Response.AppendHeader("Content-Disposition", "attachment;filename=" + filename);
            HttpContext.Current.Response.AppendHeader("Content-Length", fi.Length.ToString());
            HttpContext.Current.Response.ContentType = strContentType;
            HttpContext.Current.Response.WriteFile(file);
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.End();
        }

        #endregion





    }
}
