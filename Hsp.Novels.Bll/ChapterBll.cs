using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Hsp.Novels.Common;
using Hsp.Novels.Dal;
using Hsp.Novels.Model;

namespace Hsp.Novels.Bll
{
    /// <summary>
    /// 章节业务逻辑层
    /// </summary>
    public class ChapterBll
    {
        #region 获取小说章节分页数据

        /// <summary>
        /// 获取小说章节分页数据
        /// </summary>
        /// <param name="paramList">查询及分页参数</param>
        /// <returns></returns>
        public List<Chapters> PageChapterList(Dictionary<string, string> paramList)
        {
            var list = new List<Chapters>();
            DataSet ds = ChapterDal.PageChapterData(paramList);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                list = new DataTableToList<Chapters>(ds.Tables[0]).ToList();
            }
            return list;
        }

        #endregion

        #region 根据小说编号获取小说章节数据

        /// <summary>
        /// 根据小说编号获取小说章节数据
        /// </summary>
        /// <param name="novelId">小说编号</param>
        /// <returns></returns>
        public List<Chapters> ChapterList(string novelId)
        {
            var list = new List<Chapters>();
            DataSet ds = ChapterDal.ChapterData(novelId);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                list = new DataTableToList<Chapters>(ds.Tables[0]).ToList();
            }
            return list;
        }

        #endregion

        #region 根据小说编号及章节地址获取小说章节数据

        /// <summary>
        /// 根据小说编号及章节地址获取小说章节数据
        /// </summary>
        /// <param name="novelId">小说编号</param>
        /// <param name="chapterUrl">章节地址</param>
        /// <returns></returns>
        public Chapters ChapterModel(string novelId, string chapterUrl)
        {
            Chapters model = null;
            DataSet ds = ChapterDal.ChapterData(novelId, chapterUrl);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                model = new DataTableToList<Chapters>(ds.Tables[0]).ToList().FirstOrDefault();
            }
            return model;
        }

        /// <summary>
        /// 根据章节编号获取章节数据
        /// </summary>
        /// <param name="chapterId">章节编号</param>
        /// <returns></returns>
        public Chapters ChapterModel(string chapterId)
        {
            Chapters model = null;
            DataSet ds = ChapterDal.ChapterDataByChapterId(chapterId);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                model = new DataTableToList<Chapters>(ds.Tables[0]).ToList().FirstOrDefault();
            }
            return model;
        }

        #endregion

        #region 添加章节信息

        /// <summary>
        /// 添加章节信息
        /// </summary>
        /// <param name="model">章节实体</param>
        public int Add(Chapters model)
        {
            return ChapterDal.Add(model);
        }

        #endregion

        #region 编辑章节数据

        /// <summary>
        /// 编辑章节数据
        /// </summary>
        /// <param name="model">章节实体</param>
        /// <returns></returns>
        public int Edit(Chapters model)
        {
            return ChapterDal.Edit(model);
        }

        #endregion

        #region 删除章节

        /// <summary>
        /// 删除章节
        /// </summary>
        /// <param name="id">章节编号</param>
        public int Delete(string id)
        {
            return ChapterDal.Delete(id);
        }

        #endregion

        #region 批量删除章节

        /// <summary>
        /// 批量删除章节
        /// </summary>
        /// <param name="ids">章节编号集合</param>
        public int BatchDelete(string ids)
        {
            return ChapterDal.BatchDelete(ids);
        }

        #endregion








        #region 清空小说内容

        /// <summary>
        /// 清空小说内容
        /// </summary>
        /// <param name="novelId">小说编号</param>
        public int ClearContent(string novelId)
        {
            return ChapterDal.ClearContent(novelId);
        }

        #endregion


        #region 清空小说数据

        /// <summary>
        /// 清空小说数据
        /// </summary>
        /// <param name="novelId">小说编号</param>
        public int ClearData(string novelId)
        {
            return ChapterDal.ClearData(novelId);
        }

        #endregion
    }
}
