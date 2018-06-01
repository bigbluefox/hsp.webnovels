using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Hsp.Novels.Model
{
    /// <summary>
    /// 站点实体
    /// </summary>
    public class WebSite
    {
        /// <summary>
        /// 站点编号
        /// </summary>
        [DataMember]
        public string Id { get; set; }

        /// <summary>
        /// 站点名称
        /// </summary>
        [DataMember]
        public string Name { get; set; }

        /// <summary>
        /// 站点地址
        /// </summary>
        [DataMember]
        public string Url { get; set; }

        /// <summary>
        /// 是否有效
        /// </summary>
        [DataMember]
        public int Valid { get; set; }

        /// <summary>
        /// 根据主键查询实体数据
        /// </summary>
        /// <PARAM NAME="id">主键编号</PARAM>
        /// <RETURNS></RETURNS>
        //public static WebSites Find(string id)
        //{
        //    return (WebSites)ActiveRecordBase.FindByPrimaryKey(typeof(WebSites), id);
        //}

    }
}
