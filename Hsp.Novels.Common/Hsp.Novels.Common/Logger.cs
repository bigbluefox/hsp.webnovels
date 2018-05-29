using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using log4net;

namespace Hsp.Novels.Common
{
    /// <summary>
    /// 日志操作帮助类
    /// </summary>
    public class Logger
    {

        private static readonly string path = ConfigurationManager.AppSettings["DAL"];
        private static ILog logger;

        public Logger()
        {
            logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        #region CreateObject

        //不使用缓存
        private static object CreateObjectNoCache(string path, string CacheKey)
        {
            try
            {
                object objType = Assembly.Load(path).CreateInstance(CacheKey);
                return objType;
            }
            catch (Exception ex)
            {
                //记录错误日志
                logger.Error(ex.Message);
                return null;
            }
        }

        //使用缓存
        private static object CreateObject(string path, string CacheKey)
        {
            object objType = DataCache.GetCache(CacheKey);
            if (objType == null)
            {
                try
                {
                    objType = Assembly.Load(path).CreateInstance(CacheKey);
                    DataCache.SetCache(CacheKey, objType); // 写入缓存
                }
                catch (Exception ex)
                {
                    //记录错误日志
                    logger.Error(ex.Message);
                }
            }
            return objType;
        }

        #endregion

    }
}
