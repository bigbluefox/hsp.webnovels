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
        /// <param name="paramList">分页参数</param>
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

    }
}
