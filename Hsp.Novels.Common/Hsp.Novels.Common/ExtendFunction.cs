using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hsp.Novels.Common
{
    /// <summary>
    /// 扩展方法
    /// </summary>
    [DebuggerStepThrough]
    public static class ExtendFunction
    {
        /// <summary>
        /// 检查该字符串为空性
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool IsNullOrEmpty(this string value)
        {
            return string.IsNullOrEmpty(value);
        }

        /// <summary>
        /// 将字符串转化为字符串数组
        /// </summary>
        public static string[] ToStrArray(this string value, char Separator)
        {
            if (value == null)
                return new string[0];
            value = value.Trim().TrimEnd(Separator);
            if (value.IsNullOrEmpty())
                return new string[0];
            else
                return value.Split(Separator);
        }

        /// <summary>
        /// 将数组转为字符形式
        /// </summary>
        /// <param name="strArray"></param>
        /// <param name="Separator"></param>
        /// <returns></returns>
        public static string ToString(this string[] strArray, char Separator)
        {
            string tempStr = "";
            foreach (string s in strArray)
                tempStr += s + Separator;
            return tempStr.Trim(Separator);
        }

        public static string Obj2Str(this object obj)
        {
            if (obj == null)
                return "";
            else
                return obj.ToString();
        }

        /// <summary>
        /// 将字符串转化为数字数组
        /// </summary>
        /// <param name="value"></param>
        /// <param name="separator"></param>
        /// <returns></returns>
        public static int[] ToIntArray(this string value, char separator)
        {
            string[] ss = value.ToStrArray(separator);

            List<int> list = new List<int>();
            foreach (string s in ss)
                if (s.IsNumber())
                    list.Add(s.ToInt());

            return list.ToArray();
        }

        /// <summary>
        /// 验证该字符是否是数字
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool IsNumber(this string value)
        {
            char[] chars = value.ToCharArray();

            bool b = true;
            foreach (char c in chars)
            {
                if (!char.IsNumber(c))
                {
                    b = false;
                    break;
                }
            }
            return b;
        }

        /// <summary>
        /// 将该字符串转化为数字
        /// 如果该字符串中含有非数字字符，返回0
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int ToInt(this string value)
        {
            if (value.IsNullOrEmpty())
                return 0;
            if (!value.IsNumber())
                return 0;

            try
            {
                return int.Parse(value);
            }
            catch
            {
                throw;
            }
        }

        public static decimal ToDecimal(this string value)
        {
            if (value.IsNullOrEmpty())
                return 0;
            if (!value.IsNumber())
                return 0;

            try
            {
                return decimal.Parse(value);
            }
            catch
            {
                throw;
            }
        }

        public static long ToLong(this string value)
        {
            if (value.IsNullOrEmpty())
                return 0;
            if (!value.IsNumber())
                return 0;
            try
            {
                return long.Parse(value);
            }
            catch
            {
                throw;
            }

        }



        /// <summary>
        /// 格式化为当地日期
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static DateTime? ToDate(this string value)
        {
            if (value.IsNullOrEmpty())
                return null;
            try
            {
                DateTimeFormatInfo df = new CultureInfo("zh-cn", false).DateTimeFormat;

                DateTime dt = Convert.ToDateTime(value, df);
                return dt;
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// 判定该是否为NULL
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static bool IsNull(this object obj)
        {
            if (obj == null)
                return true;
            if (obj.ToString() == "")
                return true;

            return false;
        }
    }
}
