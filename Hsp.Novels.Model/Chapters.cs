using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Hsp.Novels.Model
{
    /// <summary>
    /// 章节实体
    /// </summary>
    public class Chapters : BaseModel
    {
        /// <summary>
        /// 章节编号
        /// </summary>
        [DataMember]
        public string Id { get; set; }

        /// <summary>
        /// 小说编号
        /// </summary>
        [DataMember]
        public string NovelId { get; set; }

        /// <summary>
        /// 小说地址
        /// </summary>
        [DataMember]
        public string Url { get; set; }

        /// <summary>
        /// 下一章地址
        /// </summary>
        [DataMember]
        public string NextUrl { get; set; }

        /// <summary>
        /// 章节
        /// </summary>
        [DataMember]
        public string Chapter { get; set; }

        /// <summary>
        /// 章节索引号
        /// </summary>
        [DataMember]
        public int ChapterIndex { get; set; }

        /// <summary>
        /// 章节序号（中文）
        /// </summary>
        [DataMember]
        public string ChapterName { get; set; }

        /// <summary>
        /// 章节名称
        /// </summary>
        [DataMember]
        public string HeadWord { get; set; }

        /// <summary>
        /// 章节内容
        /// </summary>
        [DataMember]
        public string ChapterContent { get; set; }

        /// <summary>
        /// 章节字数
        /// </summary>
        [DataMember]
        public int WordCount { get; set; }

        /// <summary>
        /// 更新时间
        /// </summary>
        [DataMember]
        public DateTime UpdateTime { get; set; }

        /// <summary>
        /// 根据主键查询实体数据
        /// </summary>
        /// <PARAM NAME="id">主键编号</PARAM>
        /// <RETURNS></RETURNS>
        //public static Chapters Find(string id)
        //{
        //    return (Chapters)ActiveRecordBase.FindByPrimaryKey(typeof(Chapters), id);
        //}
    }
}
