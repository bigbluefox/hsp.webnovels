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
    /// 站点业务逻辑层
    /// </summary>
    public class WebBll
    {
        #region 获取小说站点分页数据

        /// <summary>
        /// 获取小说站点分页数据
        /// </summary>
        /// <param name="paramList">查询及分页参数</param>
        /// <returns></returns>
        public List<WebSites> PageWebList(Dictionary<string, string> paramList)
        {
            var list = new List<WebSites>();
            DataSet ds = WebDal.PageWebData(paramList);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                list = new DataTableToList<WebSites>(ds.Tables[0]).ToList();
            }
            return list;
        }

        #endregion

        #region 获取站点抓取参数实体

        /// <summary>
        /// 获取站点抓取参数实体
        /// </summary>
        /// <param name="webId">站点编号</param>
        /// <param name="novelId">小说编号</param>
        /// <returns></returns>
        public WebSites WebCrawlModel(string webId, string novelId)
        {
            WebSites web = null;
            DataSet ds = WebDal.WebCrawlData(webId, novelId);
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                web = new DataTableToList<WebSites>(ds.Tables[0]).ToList().FirstOrDefault();
            }
            return web;
        }

        #endregion


        #region 添加站点信息

        /// <summary>
        /// 添加站点信息
        /// </summary>
        /// <param name="model">站点实体</param>
        public void Add(WebSites model)
        {
            WebDal.Add(model);
        }

        #endregion

        #region 编辑站点数据

        /// <summary>
        /// 编辑站点数据
        /// </summary>
        /// <param name="model">站点实体</param>
        /// <returns></returns>
        public int Edit(WebSites model)
        {
            return WebDal.Edit(model);
        }

        #endregion

        #region 删除站点

        /// <summary>
        /// 删除站点
        /// </summary>
        /// <param name="id">站点编号</param>
        public int Delete(int id)
        {
            return WebDal.Delete(id);
        }

        #endregion

        #region 批量删除站点

        /// <summary>
        /// 批量删除站点
        /// </summary>
        /// <param name="ids">站点编号集合</param>
        public int BatchDelete(string ids)
        {
            return WebDal.BatchDelete(ids);
        }

        #endregion
    }
}
