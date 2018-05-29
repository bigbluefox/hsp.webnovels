using System.Collections;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Caching;

namespace Hsp.Novels.Common
{
    /// <summary>
    /// 缓存相关的操作类
    /// </summary>
    public class DataCache
    {
        #region 缓存相关的操作类

        /// <summary>
        /// 获取当前应用程序指定CacheKey的Cache值
        /// </summary>
        /// <param name="cacheKey"></param>
        /// <returns></returns>
        public static object GetCache(string cacheKey)
        {
            Cache objCache = HttpRuntime.Cache;
            return objCache[cacheKey];
        }

        /// <summary>
        /// 设置当前应用程序指定CacheKey的Cache值
        /// </summary>
        /// <param name="cacheKey"></param>
        /// <param name="objObject"></param>
        public static void SetCache(string cacheKey, object objObject)
        {
            Cache objCache = HttpRuntime.Cache;
            objCache.Insert(cacheKey, objObject);
        }

        /// <summary>
        /// 移除当前应用程序指定CacheKey的Cache值
        /// </summary>
        /// <param name="cacheKey"></param>
        public static void ClearCache(string cacheKey)
        {
            Cache objCache = HttpRuntime.Cache;
            objCache.Remove(cacheKey);
        }

        #endregion

        #region 缓存调用示例

        /// <summary>
        /// 缓存调用示例
        /// </summary>
        /// <returns></returns>
        public static DataSet GetCourses()
        {
            DataSet ds;
            object oTemp = HttpContext.Current.Cache["Course"];
            if (oTemp == null)
            {
                ds = new DataSet();
                //HttpContext.Current.Cache.Add();
            }
            else
            {
                ds = (DataSet)oTemp;
            }
            return ds;
        }

        #endregion

        #region CheckCache

        public static bool BCheckCache(string strKey, int iDataCacheFlag)
        {
            bool bDataCacheFlag = false;
            if (DataCacheHashTable.Instance().Contains(strKey))
            {
                int iHashCacheFlag = int.Parse(DataCacheHashTable.Instance()[strKey].ToString());
                if (iDataCacheFlag == iHashCacheFlag)
                {
                    bDataCacheFlag = true;
                }
                else
                {
                    ClearCache(strKey);
                    DataCacheHashTable.Instance()[strKey] = iHashCacheFlag;
                }
            }
            else
            {
                ClearCache(strKey);
                DataCacheHashTable.Instance().Add(strKey, iDataCacheFlag);
            }
            return bDataCacheFlag;
        }
    }

        #endregion

    #region Nested type: DataCacheHashTable

    public abstract class DataCacheHashTable
    {
        private static Hashtable _instance;

        public static Hashtable Instance()
        {
            return _instance ?? (_instance = new Hashtable());
        }
    }

    #endregion
}
