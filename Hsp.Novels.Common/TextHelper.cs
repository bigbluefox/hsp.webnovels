using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Hsp.Novels.Common
{
    public class TextHelper
    {


        /// <summary>
        /// 正则表达式提取和替换内容
        /// </summary>
        public static string ContentExtract(string sour, string exp)
        {
            string result = "";
            //string str = "大家好! <User EntryTime='2010-10-7' Email='zhangsan@163.com'>张三</User> 自我介绍。";
            //Regex regex = new Regex(@"<User\s*EntryTime='(?<time>[\s\S]*?)'\s+Email='(?<email>[\s\S]*?)'>(?<userName>[\s\S]*?)</User>", RegexOptions.IgnoreCase);

            Regex regex = new Regex(exp, RegexOptions.IgnoreCase);

            MatchCollection matches = regex.Matches(sour);
            if (matches.Count > 0)
            {
                //string userName = match.Groups["userName"].Value; //获取用户名
                //string time = match.Groups["time"].Value; //获取入职时间
                //string email = match.Groups["email"].Value; //获取邮箱地址
                //string strFormat = String.Format("我是：{0}，入职时间：{1}，邮箱：{2}", userName, time, email);
                //result = regex.Replace(sour, strFormat); //替换内容
                //Console.WriteLine(result);

                foreach (Match item in matches)
                {
                    if (item.Groups[0].Value == "") continue;
                    result += item.Groups[0] + Environment.NewLine;
                }


            }
            return result; //结果：大家好！我是张三，入职时间：2010-10-7，邮箱：zhangsan@163.com 自我介绍。
        }

        /// <summary>
        /// 简单中文数字解析阿拉伯数字
        /// </summary>
        /// <param name="aText"></param>
        /// <returns></returns>
        public static string DecodeSimpleCn(string aText)
        {
            string num = "";
            aText = aText.Replace("○", "零");
            foreach (char vChar in aText)
            {
                int i = "零一二三四五六七八九".IndexOf(vChar);
                num += i.ToString();
            }

            return num;
        }

        /// <summary>
        /// 中文数字转阿拉伯数字
        /// </summary>
        /// <param name="aText"></param>
        /// <returns></returns>
        public static double DecodeMoneyCn(string aText)
        {
            aText = aText.Replace("亿亿", "兆");
            aText = aText.Replace("万万", "亿");
            aText = aText.Replace("点", "元");
            aText = aText.Replace("块", "元");
            aText = aText.Replace("毛", "角");
            double vResult = 0;
            double vNumber = 0; // 当前数字
            double vTemp = 0;
            int vDecimal = 0; // 是否出现小数点
            foreach (char vChar in aText)
            {
                int i = "零一二三四五六七八九".IndexOf(vChar);
                if (i < 0) i = "洞幺两三四五六拐八勾".IndexOf(vChar);
                if (i < 0) i = "零壹贰叁肆伍陆柒捌玖".IndexOf(vChar);
                if (i > 0)
                {
                    vNumber = i;
                    if (vDecimal > 0)
                    {
                        vResult += vNumber * Math.Pow(10, -vDecimal);
                        vDecimal++;
                        vNumber = 0;
                    }
                }
                else
                {
                    i = "元十百千万亿".IndexOf(vChar);
                    if (i < 0) i = "整拾佰仟万亿兆".IndexOf(vChar);
                    if (i == 5) i = 8;
                    if (i == 6) i = 12;
                    if (i > 0)
                    {
                        if (vNumber == 0.0) vNumber = 1.0;
                        if (i >= 4)
                        {
                            vTemp += vNumber;
                            if (vTemp == 0) vTemp = 1;
                            vResult += vTemp * Math.Pow(10, i);
                            vTemp = 0;
                        }
                        else vTemp += vNumber * Math.Pow(10, i);
                    }
                    else
                    {
                        i = "元角分".IndexOf(vChar);
                        if (i > 0)
                        {
                            vTemp += vNumber;
                            vResult += vTemp * Math.Pow(10, -i);
                            vTemp = 0;
                        }
                        else if (i == 0)
                        {
                            vTemp += vNumber;
                            vResult += vTemp;
                            vDecimal = 1;
                            vTemp = 0;
                        }
                    }
                    vNumber = 0;
                }
            }
            return vResult + vTemp + vNumber;
        }
    }
}
