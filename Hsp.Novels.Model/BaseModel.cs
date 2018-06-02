using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Hsp.Novels.Model
{
    /// <summary>
    /// 实体基础类库
    /// </summary>
    public class BaseModel
    {
        #region 分页数据属性

        /// <summary>
        /// 记录行号
        /// </summary>
        [DataMember]
        public int RowNumber { get; set; }

        /// <summary>
        /// 记录总数
        /// </summary>
        [DataMember]
        public int RecordCount { get; set; }

        #endregion

        /// <summary>
        /// 子项数量
        /// </summary>
        [DataMember]
        public int ChildNodeCount { get; set; }
    }

    /// <summary>
    /// 分页基类
    /// </summary>
    public class PageModel
    {
        #region 分页属性

        /// <summary>
        /// 当前页面页码，从1开始
        /// </summary>
        public int PageIndex { get; set; }

        /// <summary>
        /// 页大小
        /// </summary>
        public int PageSize { get; set; }

        #endregion
    }
}
