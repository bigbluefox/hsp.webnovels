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
    /// 小说抓取业务逻辑层
    /// </summary>
    public class NovelBll
    {
        #region 获取小说定义分页数据

        /// <summary>
        /// 获取小说定义分页数据
        /// </summary>
        /// <param name="paramList">查询及分页参数</param>
        /// <returns></returns>
        public List<Model.Novels> PageNovelList(Dictionary<string, string> paramList)
        {
            var list = new List<Model.Novels>();
            DataSet ds = NovelDal.PageNovelData(paramList);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                list = new DataTableToList<Model.Novels>(ds.Tables[0]).ToList();
            }
            return list;
        }

        #endregion

        #region 获取小说抓取参数实体

        /// <summary>
        /// 获取小说抓取参数实体
        /// </summary>
        /// <param name="webId">站点编号</param>
        /// <param name="novelId">小说编号</param>
        /// <returns></returns>
        public Model.Novels CrawlModel(string webId, string novelId)
        {
            Model.Novels model = null;
            DataSet ds = NovelDal.CrawlData(webId, novelId);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                model = new DataTableToList<Model.Novels>(ds.Tables[0]).ToList().FirstOrDefault();
            }
            return model;
        }

        #endregion

        #region 添加小说信息

        /// <summary>
        /// 添加小说信息
        /// </summary>
        /// <param name="model">小说实体</param>
        public int Add(Model.Novels model)
        {
            return NovelDal.Add(model);
        }

        #endregion

        #region 编辑小说数据

        /// <summary>
        /// 编辑小说数据
        /// </summary>
        /// <param name="model">小说实体</param>
        /// <returns></returns>
        public int Edit(Model.Novels model)
        {
            return NovelDal.Edit(model);
        }

        #endregion

        #region 删除小说

        /// <summary>
        /// 删除小说
        /// </summary>
        /// <param name="id">小说编号</param>
        public int Delete(string id)
        {
            return NovelDal.Delete(id);
        }

        #endregion

        #region 批量删除小说

        /// <summary>
        /// 批量删除小说
        /// </summary>
        /// <param name="ids">小说编号集合</param>
        public int BatchDelete(string ids)
        {
            return NovelDal.BatchDelete(ids);
        }

        #endregion
    }
}
