﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Hsp.Novels.Common;
using Hsp.Novels.DbUtility;
using Hsp.Novels.Model;

namespace Hsp.Novels.Dal
{
    /// <summary>
    /// 站点数据服务层
    /// </summary>
    public class WebDal
    {
        #region 获取小说站点分页数据

        /// <summary>
        /// 获取小说站点分页数据
        /// </summary>
        /// <param name="paramList">查询及分页参数</param>
        /// <returns></returns>
        public static DataSet PageWebData(Dictionary<string, string> paramList)
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
                strQry += string.Format(@" AND (Name LIKE '%{0}%'", strTitle);
            }

            #endregion

            #region 参数处理

            var strWebSiteId = paramList.ContainsKey("WebId") ? (paramList["WebId"] ?? "") : "";
            if (!string.IsNullOrEmpty(strWebSiteId))
            {
                strWebSiteId = Utility.MASK(strWebSiteId);
                strQry += string.Format(@" AND (Id = '{0}')", strWebSiteId);
            }

            #endregion

            string strSql = string.Format(@"
            ;WITH PageTb AS (
                SELECT ROW_NUMBER() OVER (ORDER BY Name) RowNumber, *
                FROM dbo.WebSites
                WHERE (1 = 1){2}
            )
            SELECT *, (SELECT COUNT(*) FROM dbo.Novels WHERE WebId = a.Id) AS ChildNodeCount 
            FROM PageTb a
            CROSS JOIN (SELECT MAX(RowNumber) AS RecordCount FROM PageTb) AS b 
            WHERE (a.RowNumber BETWEEN {0} AND {1});
            ", iMinPage, iMaxPage, strQry);
            return DbHelperSql.Query(strSql);
        }

        #endregion

        /// <summary>
        /// 获取站点抓取参数
        /// </summary>
        /// <param name="webId">站点编号</param>
        /// <param name="novelId">小说编号</param>
        /// <returns></returns>
        public static DataSet WebCrawlData(string webId, string novelId)
        {
            string strSql = string.Format(@"
            SELECT w.Name + '.' + n.Title AS Name, w.ContentName, w.HeaderName, w.NextName, w.NextTitle, NextTb.Chapter AS CurrentChapter
            , CASE WHEN LEN(NextTb.NextUrl) > 0 THEN NextTb.NextUrl ELSE n.StartUrl END AS NextUrl
            FROM dbo.WebSites w
            INNER JOIN dbo.Novels n ON n.WebId = w.Id
            LEFT OUTER JOIN (SELECT TOP (1) NovelId, ISNULL(NextUrl, '') AS NextUrl, Chapter FROM Chapters WHERE NovelId = '{1}' ORDER BY CreateTime DESC) AS NextTb ON NextTb.NovelId = n.Id
            WHERE (w.Id = '{0}') AND (n.Id = '{1}')", webId, novelId);
            return DbHelperSql.Query(strSql);
        }

        #region 添加站点数据

        /// <summary>
        /// 添加站点数据
        /// </summary>
        /// <remarks>创建人：李海玉   创建时间：2018-06-02</remarks>
        /// <param name="model">站点实体</param>
        /// <returns></returns>
        public static int Add(WebSites model)
        {
            string strSql = string.Format
                (@"INSERT INTO WebSites
                    (Name, Url, ContentName, HeaderName, NextName, NextTitle) 
                    VALUES ('{0}', '{1}', '{2}', '{3}', '{4}', '{5}');"
                 , model.Name, model.Url, model.ContentName, model.HeaderName, model.NextName, model.NextTitle);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

        #region 编辑站点数据

        /// <summary>
        /// 编辑站点数据
        /// </summary>
        /// <param name="model">站点实体</param>
        /// <returns></returns>
        public static int Edit(WebSites model)
        {
            string strSql = string.Format
                (@"UPDATE WebSites SET Name='{1}', Url='{2}', ContentName='{3}', HeaderName='{4}', NextName='{5}', NextTitle='{6}', Valid='{7}'
                     WHERE (Id = '{0}');"
                    , model.Id, model.Name, model.Url, model.ContentName, model.HeaderName, model.NextName, model.NextTitle, model.Valid);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

        #region 删除站点数据

        /// <summary>
        /// 删除站点数据
        /// </summary>
        /// <param name="id">站点编号</param>
        /// <returns></returns>
        public static int Delete(int id)
        {
            string strSql = string.Format(@"DELETE FROM dbo.WebSites WHERE (Id = {0});", id);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

        #region 批量删除站点

        /// <summary>
        /// 批量删除站点
        /// </summary>
        /// <param name="ids">站点编号集合</param>
        /// <returns></returns>
        public static int BatchDelete(string ids)
        {
            string strSql = string.Format(@"DELETE FROM dbo.WebSites WHERE (Id IN ({0}));", ids);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion
    }
}
