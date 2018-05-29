using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml;

namespace Hsp.Novels.Common
{
    /// <summary>
    ///     实用工具类
    /// </summary>
    public class Utility
    {
        #region 错误日志处理方法

        /// <summary>
        ///     错误日志处理方法
        /// </summary>
        /// <param name="t">日志标题</param>
        /// <param name="c">日之内容</param>
        public static void WriteLog(string t, string c)
        {
            var isWriteLog = ConfigurationManager.AppSettings["IsWriteLog"];

            if (string.IsNullOrEmpty(isWriteLog) || isWriteLog.Trim() == "0")
            {
                return;
            }

            try
            {
                var logPath = ConfigurationManager.AppSettings["LogFilePath"];
                if (!File.Exists(logPath))
                {
                    var sw1 = File.CreateText(logPath);
                    var str = t + c + " " + DateTime.Now;
                    sw1.WriteLine(str + "\n");
                    sw1.Close();
                }
                else
                {
                    var sw = File.AppendText(logPath);
                    var str = t + c + " " + DateTime.Now;
                    sw.WriteLine(str + "\n");
                    sw.Close();
                }
            }
            catch (Exception)
            {
                //throw;
            }
        }

        #endregion

        #region  防SQL注入

        /// <summary>
        ///     防SQL注入
        /// </summary>
        /// <param name="inStr">The in STR.</param>
        /// <returns></returns>
        public static string MASK(string inStr)
        {
            var sqlExp =
                new Regex(
                    @"(and |exec |insert |select |delete |update | count|drop |table|%| chr| mid| master|truncate | char|declare |'|--|xp_)");
            return sqlExp.Replace(inStr, "");
        }

        #endregion

        #region 配置文件键值处理

        /// <summary>
        ///     配置文件键值处理
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        public void SetConfigurationValue(string key, string value)
        {
            try
            {
                var config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
                config.AppSettings.Settings[key].Value = value;
                config.Save();
            }
            catch (Exception ex)
            {
                //throw;
            }
        }

        #endregion

        #region XML解析为IList对象

        /// <summary>
        ///     XML解析为IList对象
        /// </summary>
        /// <typeparam name="TEntity"></typeparam>
        /// <param name="xml"></param>
        /// <returns></returns>
        public IList<TEntity> ToOjbects<TEntity>(string xml)
            where TEntity : class, new()
        {
            IList<TEntity> entities = new List<TEntity>();
            var dom = new XmlDocument();
            dom.LoadXml(xml);

            var entity = default(TEntity);
            var type = entity.GetType();
            var root = dom.DocumentElement;
            XmlElement ele = null;
            foreach (XmlNode item in root.ChildNodes)
            {
                entity = new TEntity();
                ele = (XmlElement)item;
                foreach (var pInfo in type.GetProperties())
                {
                    pInfo.SetValue(entity, ele[pInfo.Name].InnerText, null);
                }
                entities.Add(entity);
            }

            return entities;
        }

        /// <summary>
        ///     还原XML文件中的标识符
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string DecodeXMLTag(string text)
        {
            return text.Replace("&amp;", "&").Replace("&lt;", "<").Replace("&gt;", ">").Replace("&quot;", "\"")
                .Replace("&copy;", "©").Replace("&reg;", "®");
        }

        #endregion

        #region 清理字符串HTML代码

        /// <summary>
        ///     清理字符串HTML代码
        /// </summary>
        /// <param name="strHtml"></param>
        /// <returns></returns>
        public static string ClearHTML(string strHtml)
        {
            strHtml = strHtml.Replace("&nbsp;", "").Replace("\n", "").Replace("&lt;", "<").Replace("&gt;", ">");
            //.Replace("&lt;", "＜").Replace("&gt;", "＞");
            //strHtml = strHtml.Replace("@#", "");

            string[] aryReg =
            {
                @"<script[^>]*?>.*?</script>",
                @"<(\/\s*)?!?((\w+:)?\w+)(\w+(\s*=?\s*(([""''])(\\[""''tbnr]|[^\7])*?\7|\w+)|.{0})|\s)*?(\/\s*)?>",
                @"([\r])[\s]+",
                @"&(quot|#34);",
                @"&(amp|#38);",
                @"&(lt|#60);",
                @"&(gt|#62);",
                @"&(nbsp|#160);",
                @"&(iexcl|#161);",
                @"&(cent|#162);",
                @"&(pound|#163);",
                @"&(copy|#169);",
                @"&#(\d+);",
                @"-->",
                @"<!--.*"
            };

            string[] aryRep =
            {
                "",
                "",
                "",
                "\"",
                "&",
                "＜",
                "＞",
                " ",
                "\xa1", //chr(161),
                "\xa2", //chr(162),
                "\xa3", //chr(163),
                "\xa9", //chr(169),
                "",
                "\r",
                ""
            };

            string newReg = aryReg[0];
            string strOutput = strHtml;
            for (int i = 0; i < aryReg.Length; i++)
            {
                var regex = new Regex(aryReg[i], RegexOptions.IgnoreCase);
                strOutput = regex.Replace(strOutput, aryRep[i]);
            }

            strOutput.Replace("<", "");
            strOutput.Replace(">", "");
            strOutput.Replace("\r", "");

            var objRegExp = new Regex("<(.|\n)+?>");
            strOutput = objRegExp.Replace(strHtml, "");
            return strOutput;
        }

        #endregion
    }
}
