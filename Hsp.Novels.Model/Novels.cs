using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Hsp.Novels.Model
{
    /// <summary>
    /// 小说实体
    /// </summary>
    public class Novels : BaseModel
    {
        /// <summary>
        /// 小说编号
        /// </summary>
        [DataMember]
        public string Id { get; set; }

        /// <summary>
        /// 站点编号
        /// </summary>
        [DataMember]
        public string WebId { get; set; }

        /// <summary>
        /// 小说标题
        /// </summary>
        [DataMember]
        public string Title { get; set; }

        /// <summary>
        /// 小说地址
        /// </summary>
        [DataMember]
        public string Url { get; set; }

        /// <summary>
        /// 起始章节地址
        /// </summary>
        [DataMember]
        public string StartUrl { get; set; }

        /// <summary>
        /// 作者
        /// </summary>
        [DataMember]
        public string Author { get; set; }

        /// <summary>
        /// 类型
        /// </summary>
        [DataMember]
        public int TypeId { get; set; }

        /// <summary>
        /// 状态
        /// </summary>
        [DataMember]
        public int Status { get; set; }

        /// <summary>
        /// 内容对象名称，如“.yd_text2 p”
        /// </summary>
        [DataMember]
        public string ContentName { get; set; }

        /// <summary>
        /// 标题内容对象，如“.oneline”
        /// </summary>
        [DataMember]
        public string HeaderName { get; set; }

        /// <summary>
        /// 下一页地址对象，如“.pereview a:last-child”
        /// </summary>
        [DataMember]
        public string NextName { get; set; }

        /// <summary>
        /// 下一页按钮包含的名称，如“下一页”
        /// </summary>
        [DataMember]
        public string NextTitle { get; set; }

        /// <summary>
        /// 地址是否需要组合？章节地址需要跟小说地址组合
        /// </summary>
        [DataMember]
        public int UrlCombine { get; set; }

        /// <summary>
        /// 根据主键查询实体数据
        /// </summary>
        /// <PARAM NAME="id">主键编号</PARAM>
        /// <RETURNS></RETURNS>
        //public static Novels Find(string id)
        //{
        //    return (Novels)ActiveRecordBase.FindByPrimaryKey(typeof(Novels), id);
        //}


        /// <summary>
        /// 站点名称
        /// </summary>
        [DataMember]
        public string WebName { get; set; }

    }
}
