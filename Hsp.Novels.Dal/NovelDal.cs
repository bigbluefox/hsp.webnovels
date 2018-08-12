using System;
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
    /// 小说抓取数据服务层
    /// </summary>
    public class NovelDal
    {
        #region 获取小说定义分页数据

        /// <summary>
        /// 获取小说定义分页数据
        /// </summary>
        /// <param name="paramList">查询及分页参数</param>
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

            var strNovelId = paramList.ContainsKey("NovelId") ? (paramList["NovelId"] ?? "") : "";
            if (!string.IsNullOrEmpty(strNovelId))
            {
                strNovelId = Utility.MASK(strNovelId);
                strQry += string.Format(@" AND (n.Id = '{0}')", strNovelId);
            }

            #endregion

            string strSql = string.Format(@"
            ;WITH PageTb AS (
                SELECT ROW_NUMBER() OVER (ORDER BY n.Title) RowNumber, n.*, s.Name AS WebName 
                , s.ContentName, s.HeaderName, s.NextName, s.NextTitle
                FROM dbo.WebSites s
                INNER JOIN dbo.Novels n ON n.WebId = s.Id
                WHERE (1 = 1){2}
            )
            SELECT *, (SELECT COUNT(*) FROM dbo.Chapters WHERE NovelId = a.Id) AS ChildCount  
            FROM PageTb a
            CROSS JOIN (SELECT MAX(RowNumber) AS RecordCount FROM PageTb) AS b 
            WHERE (a.RowNumber BETWEEN {0} AND {1});
            ", iMinPage, iMaxPage, strQry);
            return DbHelperSql.Query(strSql);
        }

        #endregion

        #region 根据编号获取小说数据

        /// <summary>
        /// 根据编号获取小说数据
        /// </summary>
        /// <param name="novelId">小说编号</param>
        /// <returns></returns>
        public static DataSet NovelData(string novelId)
        {
            string strSql = string.Format(@"SELECT * FROM dbo.Novels WHERE (Id = '{0}');", novelId);
            return DbHelperSql.Query(strSql);
        }

        #endregion

        #region 获取小说抓取参数数据

        /// <summary>
        /// 获取小说抓取参数数据
        /// </summary>
        /// <param name="webId">站点编号</param>
        /// <param name="novelId">小说编号</param>
        /// <returns></returns>
        public static DataSet CrawlData(string webId, string novelId)
        {
            string strSql = string.Format(@"
            SELECT n.Title, w.ContentName, w.HeaderName, w.NextName, w.NextTitle, NextTb.Chapter AS CurrentChapter
            , CASE WHEN LEN(NextTb.NextUrl) > 0 THEN NextTb.NextUrl ELSE n.StartUrl END AS NextUrl
            , CASE WHEN ISNULL(NextTb.ChapterIdx, 0) > 0 THEN NextTb.ChapterIdx ELSE n.StartChapterIdx END AS StartChapterIdx
            , ISNULL(n.ChapterChar, '第$2章') AS ChapterChar, ISNULL(n.ChapterType, 0) AS ChapterType
            , w.UrlCombine, n.NovelUrl, w.WebUrl, w.AnnotationType, w.LineSign
            FROM dbo.WebSites w
            INNER JOIN dbo.Novels n ON n.WebId = w.Id
            LEFT OUTER JOIN (SELECT TOP (1) NovelId, ISNULL(NextUrl, '') AS NextUrl, Chapter, ChapterIdx FROM Chapters WHERE NovelId = '{1}' ORDER BY CreateTime DESC) AS NextTb ON NextTb.NovelId = n.Id
            WHERE (w.Id = '{0}') AND (n.Id = '{1}')", webId, novelId);
            return DbHelperSql.Query(strSql);
        }

        #endregion

        #region 添加小说数据

        /// <summary>
        /// 添加小说数据
        /// </summary>
        /// <remarks>创建人：李海玉   创建时间：2018-06-02</remarks>
        /// <param name="model">小说实体</param>
        /// <returns></returns>
        public static int Add(Model.Novels model)
        {
            string strSql = string.Format
                (@"INSERT INTO Novels
                    (WebId, Title, NovelUrl, StartUrl, LatestChapter, Author, TypeId, Status, StartChapterIdx, ChapterChar, ChapterType) 
                    VALUES ('{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}', '{9}', '{10}');"
                 , model.WebId, model.Title, model.NovelUrl, model.StartUrl, model.LatestChapter, model.Author, model.TypeId
                 , model.Status, model.StartChapterIdx, model.ChapterChar, model.ChapterType);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

        //SELECT     TOP (200) Id, WebId, Title, NovelUrl, StartUrl, LatestChapter, Author
        //    , TypeId, Status, RecentUpdate, ChapterCount, CreateTime, ChapterChar, StartChapterIdx, ChapterType
        //FROM         Novels

        #region 编辑小说数据

        /// <summary>
        /// 编辑小说数据
        /// </summary>
        /// <param name="model">小说实体</param>
        /// <returns></returns>
        public static int Edit(Model.Novels model)
        {
            string strSql = string.Format
                (@"UPDATE Novels SET WebId='{1}', Title='{2}', NovelUrl='{3}', StartUrl='{4}', LatestChapter='{5}', Author='{6}'
                , TypeId='{7}', Status='{8}', StartChapterIdx='{9}', ChapterChar='{10}', ChapterType='{11}' WHERE (Id = '{0}');"
                 , model.Id, model.WebId, model.Title, model.NovelUrl, model.StartUrl, model.LatestChapter, model.Author
                 , model.TypeId, model.Status, model.StartChapterIdx, model.ChapterChar, model.ChapterType);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

        #region 删除小说数据

        /// <summary>
        /// 删除小说数据
        /// </summary>
        /// <param name="id">小说编号</param>
        /// <returns></returns>
        public static int Delete(string id)
        {
            string strSql = string.Format(@"DELETE FROM dbo.Novels WHERE (Id = '{0}');", id);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

        #region 批量删除小说

        /// <summary>
        /// 批量删除小说
        /// </summary>
        /// <param name="ids">小说编号集合</param>
        /// <returns></returns>
        public static int BatchDelete(string ids)
        {
            ids = ids.Trim().Replace(" ", "").Replace(",", "','");
            string strSql = string.Format(@"DELETE FROM dbo.Novels WHERE (Id IN ('{0}'));", ids);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

    }
}
