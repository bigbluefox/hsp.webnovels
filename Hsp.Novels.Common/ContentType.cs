using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hsp.Novels.Common
{
    /// <summary>
    /// HTTP ContentType
    /// </summary>
    public class ContentType
    {
        // PDF|DOC|DOCX|XLS|XLSX|PPT|PPTX|ET|DPS|WPS|ZIP|RAR|PNG|JPG|TXT

        public const string ET = "application/octet-stream";

        public const string PDF = "application/pdf";
        public const string DOC = "application/msword";
        public const string XLS = "application/vnd.ms-excel";
        public const string PPT = "application/vnd.ms-powerpoint";
        public const string DPS = "application/octet-stream";
        public const string WPS = "application/octet-stream";
        public const string ZIP = "application/zip";
        public const string RAR = "application/x-rar";
        public const string PNG = "image/png";
        public const string JPG = "image/jpeg";
        public const string TXT = "text/plain";

        public const string DOCX = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        public const string XLSX = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        public const string PPTX = "application/vnd.openxmlformats-officedocument.presentationml.presentation";

        /// <summary>
        ///     默认文件
        /// </summary>
        public const string DEFAULT = "application/octet-stream";

        /// <summary>
        /// 视频文件
        /// </summary>
        public const string AVI = "video/x-msvideo";
        public const string FLV = "application/octet-stream";
        public const string MP4 = "application/octet-stream";
        public const string WMV = "application/octet-stream";

        // 音频文件
        public const string MID = "audio/mid";
        public const string MP3 = "audio/mpeg";
        public const string RM = "application/octet-stream";
        public const string APE = "application/octet-stream";
        public const string WMA = "application/octet-stream";
        public const string OGG = "application/octet-stream";
        public const string FLAC = "application/octet-stream";
    }
}
