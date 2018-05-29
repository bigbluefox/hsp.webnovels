using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Hsp.Novels.Common
{
    /// <summary>
    ///     提供用于计算指定文件哈希值的方法
    ///     <example>
    ///         例如计算文件的MD5值:
    ///         <code>
    ///   String hashMd5=HashHelper.ComputeMD5("MyFile.txt");
    /// </code>
    ///     </example>
    ///     <example>
    ///         例如计算文件的CRC32值:
    ///         <code>
    ///   String hashCrc32 = HashHelper.ComputeCRC32("MyFile.txt");
    /// </code>
    ///     </example>
    ///     <example>
    ///         例如计算文件的SHA1值:
    ///         <code>
    ///   String hashSha1 =HashHelper.ComputeSHA1("MyFile.txt");
    /// </code>
    ///     </example>
    /// </summary>
    public class HashHelper
    {
        /// <summary>
        ///     计算指定文件的MD5值
        ///     MD全称Message Digest，又称信息摘要算法，MD5从MD2/3/4演化而来，MD5散列长度通常是128位
        ///     ， 也是目前被大量广泛使用的散列算法之一，主要用于密码加密和文件校验等
        /// </summary>
        /// <param name="fileName">指定文件的完全限定名称</param>
        /// <returns>返回值的字符串形式</returns>
        public static string ComputeMD5(string fileName)
        {
            var hashMD5 = string.Empty;

            //检查文件是否存在，如果文件存在则进行计算，否则返回空值
            if (File.Exists(fileName))
            {
                using (var fs = new FileStream(fileName, FileMode.Open, FileAccess.Read))
                {
                    //计算文件的MD5值
                    var calculator = MD5.Create();
                    var buffer = calculator.ComputeHash(fs);
                    calculator.Clear();
                    //将字节数组转换成十六进制的字符串形式
                    var stringBuilder = new StringBuilder();
                    for (var i = 0; i < buffer.Length; i++)
                    {
                        stringBuilder.Append(buffer[i].ToString("x2"));
                    }
                    hashMD5 = stringBuilder.ToString();
                } //关闭文件流
            } //结束计算

            return hashMD5;
        } //ComputeMD5

        /// <summary>
        ///     计算流文件的MD5值
        /// </summary>
        /// <param name="ms"></param>
        /// <returns></returns>
        public static string ComputeMD5(MemoryStream ms)
        {
            //计算文件的MD5值
            var calculator = MD5.Create();
            var buffer = calculator.ComputeHash(ms);
            calculator.Clear();
            //将字节数组转换成十六进制的字符串形式
            var stringBuilder = new StringBuilder();
            for (var i = 0; i < buffer.Length; i++)
            {
                stringBuilder.Append(buffer[i].ToString("x2"));
            }
            return stringBuilder.ToString();
        }

        /// <summary>
        ///     计算指定文件的CRC32值
        ///     CRC全称Cyclic Redundancy Check，又叫循环冗余校验。它是一种散列函数（HASH，把任意长度的输入通过散列算法，最终变换成固定长度的摘要输出
        ///     ，其结果就是散列值，按照HASH算法，HASH具有单向性，不可逆性），用来检测或校验传输或保存的数据错误
        /// </summary>
        /// <param name="fileName">指定文件的完全限定名称</param>
        /// <returns>返回值的字符串形式</returns>
        public static string ComputeCRC32(string fileName)
        {
            var hashCRC32 = string.Empty;

            //检查文件是否存在，如果文件存在则进行计算，否则返回空值
            if (File.Exists(fileName))
            {
                using (var fs = new FileStream(fileName, FileMode.Open, FileAccess.Read))
                {
                    //计算文件的CSC32值
                    var calculator = new HashCrc32();
                    var buffer = calculator.ComputeHash(fs);
                    calculator.Clear();
                    //将字节数组转换成十六进制的字符串形式
                    var stringBuilder = new StringBuilder();
                    for (var i = 0; i < buffer.Length; i++)
                    {
                        stringBuilder.Append(buffer[i].ToString("x2"));
                    }

                    hashCRC32 = stringBuilder.ToString();
                } //关闭文件流
            }
            return hashCRC32;
        } //ComputeCRC32

        /// <summary>
        ///     计算指定文件的SHA1值
        ///     SHA全称Secure Hash Standard，又称安全哈希标准，SHA家族算法有SHA-1、SHA-224、SHA-256、SHA-384和SHA-512（后四者通常并称SHA2）
        ///     ，原理和MD4、MD5原理相似，SHA是由美国国家安全局（NSA）所设计，由美国国家标准与技术研究院（NIST）发布。
        ///     SHA可将一个最大2^64位（2305843009213693952字节）信息，转换成一串160位（20字节）的散列值（摘要信息），目前也是应用最广泛的HASH算法。
        /// </summary>
        /// <param name="fileName">指定文件的完全限定名称</param>
        /// <returns>返回值的字符串形式</returns>
        public static string ComputeSHA1(string fileName)
        {
            var hashSHA1 = string.Empty;

            //检查文件是否存在，如果文件存在则进行计算，否则返回空值
            if (File.Exists(fileName))
            {
                using (var fs = new FileStream(fileName, FileMode.Open, FileAccess.Read))
                {
                    //计算文件的SHA1值
                    var calculator = SHA1.Create();
                    var buffer = calculator.ComputeHash(fs);
                    calculator.Clear();
                    //将字节数组转换成十六进制的字符串形式
                    var stringBuilder = new StringBuilder();
                    for (var i = 0; i < buffer.Length; i++)
                    {
                        stringBuilder.Append(buffer[i].ToString("x2"));
                    }

                    hashSHA1 = stringBuilder.ToString();
                } //关闭文件流
            }

            return hashSHA1;
        } //ComputeSHA1

        /// <summary>
        ///     计算流文件的SHA1值
        /// </summary>
        /// <param name="ms"></param>
        /// <returns></returns>
        public static string ComputeSHA1(MemoryStream ms)
        {
            //计算文件的SHA1值
            var calculator = SHA1.Create();
            var buffer = calculator.ComputeHash(ms);
            calculator.Clear();
            //将字节数组转换成十六进制的字符串形式
            var stringBuilder = new StringBuilder();
            for (var i = 0; i < buffer.Length; i++)
            {
                stringBuilder.Append(buffer[i].ToString("x2"));
            }

            return stringBuilder.ToString();
        }
    }

    /// <summary>
    ///     提供 CRC32 算法的实现
    /// </summary>
    public class HashCrc32 : HashAlgorithm
    {
        public const uint DefaultPolynomial = 0xedb88320;
        public const uint DefaultSeed = 0xffffffff;
        private static uint[] defaultTable;
        private readonly uint seed;
        private readonly uint[] table;
        private uint hash;

        public HashCrc32()
        {
            table = InitializeTable(DefaultPolynomial);
            seed = DefaultSeed;
            Initialize();
        }

        public HashCrc32(uint polynomial, uint seed)
        {
            table = InitializeTable(polynomial);
            this.seed = seed;
            Initialize();
        }

        public sealed override void Initialize()
        {
            hash = seed;
        }

        protected override void HashCore(byte[] buffer, int start, int length)
        {
            hash = CalculateHash(table, hash, buffer, start, length);
        }

        protected override byte[] HashFinal()
        {
            var hashBuffer = UInt32ToBigEndianBytes(~hash);
            HashValue = hashBuffer;
            return hashBuffer;
        }

        public static uint Compute(byte[] buffer)
        {
            return ~CalculateHash(InitializeTable(DefaultPolynomial), DefaultSeed, buffer, 0, buffer.Length);
        }

        public static uint Compute(uint seed, byte[] buffer)
        {
            return ~CalculateHash(InitializeTable(DefaultPolynomial), seed, buffer, 0, buffer.Length);
        }

        public static uint Compute(uint polynomial, uint seed, byte[] buffer)
        {
            return ~CalculateHash(InitializeTable(polynomial), seed, buffer, 0, buffer.Length);
        }

        private static uint[] InitializeTable(uint polynomial)
        {
            if (polynomial == DefaultPolynomial && defaultTable != null)
            {
                return defaultTable;
            }
            var createTable = new uint[256];
            for (var i = 0; i < 256; i++)
            {
                var entry = (uint)i;
                for (var j = 0; j < 8; j++)
                {
                    if ((entry & 1) == 1)
                        entry = (entry >> 1) ^ polynomial;
                    else
                        entry = entry >> 1;
                }
                createTable[i] = entry;
            }
            if (polynomial == DefaultPolynomial)
            {
                defaultTable = createTable;
            }
            return createTable;
        }

        private static uint CalculateHash(uint[] table, uint seed, byte[] buffer, int start, int size)
        {
            var crc = seed;
            for (var i = start; i < size; i++)
            {
                unchecked
                {
                    crc = (crc >> 8) ^ table[buffer[i] ^ crc & 0xff];
                }
            }
            return crc;
        }

        private byte[] UInt32ToBigEndianBytes(uint x)
        {
            return new[] { (byte)((x >> 24) & 0xff), (byte)((x >> 16) & 0xff), (byte)((x >> 8) & 0xff), (byte)(x & 0xff) };
        }
    } //end class: Crc32
}
