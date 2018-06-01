using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Hsp.Novels.Common;
using Hsp.Novels.DbUtility;

namespace Hsp.Novels.Dal
{
    /// <summary>
    /// 小说抓取数据服务层
    /// </summary>
    public class NovelDal
    {
        #region 获取小说定义分页数据

        /// <summary>
        /// 获取小说定义分页数据
        /// </summary>
        /// <param name="paramList">分页参数</param>
        /// <returns></returns>
        public static DataSet PageNovelData(Dictionary<string, string> paramList)
        {
            string strQry = "";

            #region 分页及页码数据处理处理

            var pageIndex = int.Parse(paramList["PageIndex"] ?? "1");
            var pageSize = int.Parse(paramList["PageSize"] ?? "20");
            var iMinPage = (pageIndex - 1) * pageSize + 1;
            var iMaxPage = pageIndex * pageSize;

            #endregion

            #region 模糊查询

            var strTitle = paramList.ContainsKey("Title") ? (paramList["Title"] ?? "") : "";
            if (!string.IsNullOrEmpty(strTitle))
            {
                strTitle = Utility.MASK(strTitle);
                strQry += string.Format(@" AND (s.Name LIKE '%{0}%' OR n.Title LIKE '%{0}%')", strTitle);
            }

            #endregion

            #region 参数处理

            var strWebSiteId = paramList.ContainsKey("WebId") ? (paramList["WebId"] ?? "") : "";
            if (!string.IsNullOrEmpty(strWebSiteId))
            {
                strWebSiteId = Utility.MASK(strWebSiteId);
                strQry += string.Format(@" AND (n.WebId = '{0}')", strWebSiteId);
            }

            var strNovelId = paramList.ContainsKey("NovelI") ? (paramList["NovelI"] ?? "") : "";
            if (!string.IsNullOrEmpty(strNovelId))
            {
                strNovelId = Utility.MASK(strNovelId);
                strQry += string.Format(@" AND (n.Id = '{0}')", strNovelId);
            }

            #endregion

            string strSql = string.Format(@"
            ;WITH PageTb AS (
                SELECT ROW_NUMBER() OVER ( ORDER BY n.Title) RowNumber, n.*, s.Name AS WebName 
                FROM dbo.WebSites s
                INNER JOIN dbo.Novels n ON n.WebId = s.Id
                WHERE (1 = 1){2}
            )
            SELECT * 
            FROM PageTb a
            CROSS JOIN (SELECT MAX(RowNumber) AS RecordCount FROM PageTb) AS b 
            WHERE (a.RowNumber BETWEEN {0} AND {1});
            ", iMinPage, iMaxPage, strQry);
            return DbHelperSql.Query(strSql);
        }

        #endregion
    }
}
