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
    /// 章节数据服务层
    /// </summary>
    public class ChapterDal
    {
        #region 获取小说章节分页数据

        /// <summary>
        /// 获取小说章节分页数据
        /// </summary>
        /// <param name="paramList">查询及分页参数</param>
        /// <returns></returns>
        public static DataSet PageChapterData(Dictionary<string, string> paramList)
        {
            string strQry = "";

            #region 分页及页码数据处理处理

            var pageIndex = int.Parse(paramList["PageIndex"] ?? "1");
            var pageSize = int.Parse(paramList["PageSize"] ?? "20");
            var iMinPage = (pageIndex - 1) * pageSize + 1;
            var iMaxPage = pageIndex * pageSize;

            #endregion

            #region 参数处理

            var strNovelId = paramList.ContainsKey("NovelId") ? (paramList["NovelId"] ?? "") : "";
            if (!string.IsNullOrEmpty(strNovelId))
            {
                strNovelId = Utility.MASK(strNovelId);
                strQry += string.Format(@" AND (c.NovelId = '{0}')", strNovelId);
            }

            #endregion

            string strSql = string.Format(@"
            ;WITH PageTb AS (
                SELECT ROW_NUMBER() OVER (ORDER BY c.CreateTime DESC) RowNumber, c.* 
                FROM dbo.Novels n
                INNER JOIN dbo.Chapters c ON c.NovelId = n.Id
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

        #region 添加章节数据

        /// <summary>
        /// 添加章节数据
        /// </summary>
        /// <remarks>创建人：李海玉   创建时间：2018-06-02</remarks>
        /// <param name="model">章节实体</param>
        /// <returns></returns>
        public static int Add(Chapters model)
        {
            //NovelId, Url, NextUrl, Chapter, Content, WordCount

//            string strSql = string.Format
//                (@"INSERT INTO Chapters
//                    (NovelId, Url, NextUrl, Chapter, ChapterIndex, ChapterName, HeadWord, Content, WordCount) 
//                    VALUES ('{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}');"
//                 , model.NovelId, model.Url, model.NextUrl, model.Chapter, model.ChapterIndex, model.ChapterName, model.HeadWord, model.Content, model.WordCount);

            string strSql = string.Format
                (@"INSERT INTO Chapters
                    (NovelId, Url, NextUrl, Chapter, Content, WordCount) 
                    VALUES ('{0}', '{1}', '{2}', '{3}', '{4}', '{5}');"
                 , model.NovelId, model.Url, model.NextUrl, model.Chapter, model.Content, model.WordCount);

            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

//SELECT     TOP (200) Id, NovelId, Url, NextUrl, Chapter, ChapterIndex, ChapterName, HeadWord, Content, WordCount, UpdateTime
//FROM         Chapters

        #region 编辑章节数据

        /// <summary>
        /// 编辑章节数据
        /// </summary>
        /// <param name="model">章节实体</param>
        /// <returns></returns>
        public static int Edit(Chapters model)
        {
            string strSql = string.Format
                (@"UPDATE Chapters SET NovelId='{1}', Url='{2}', NextUrl='{3}', Chapter='{4}', ChapterIndex='{5}', ChapterName='{6}', HeadWord='{7}', Content='{8}', WordCount='{9}'
                     WHERE (Id = '{0}');"
                    , model.Id, model.NovelId, model.Url, model.NextUrl, model.Chapter, model.ChapterIndex, model.ChapterName, model.HeadWord, model.Content, model.WordCount);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

        #region 删除章节数据

        /// <summary>
        /// 删除章节数据
        /// </summary>
        /// <param name="id">章节编号</param>
        /// <returns></returns>
        public static int Delete(int id)
        {
            string strSql = string.Format(@"DELETE FROM dbo.Chapters WHERE (Id = {0});", id);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion

        #region 批量删除章节

        /// <summary>
        /// 批量删除章节
        /// </summary>
        /// <param name="ids">章节编号集合</param>
        /// <returns></returns>
        public static int BatchDelete(string ids)
        {
            string strSql = string.Format(@"DELETE FROM dbo.Chapters WHERE (Id IN ({0}));", ids);
            return DbHelperSql.ExecuteSql(strSql);
        }

        #endregion
    }
}
