using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hsp.Novels.Common
{
    /// <summary>
    /// DataTableToList<T>
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class DataTableToList<T>
    {
        private DataTable myDt;

        /// <summary>
        ///  构造函数
        /// </summary>
        /// <param name="dt">要转换的datatable</param>
        public DataTableToList(DataTable dt)
        {
            myDt = dt;
        }

        /// <summary>
        /// 将DataTable转成List实体类
        /// 设置实体类中属性为public和可写的属性
        /// </summary>
        /// <returns>List<T></returns>
        public List<T> ToList()
        {
            List<T> listT = new List<T>();
            if (myDt == null || myDt.Rows.Count == 0)
            {
                return listT;
            }
            Type objType = typeof(T);
            foreach (DataRow dr in myDt.Rows)
            {
                try
                {
                    object obj = System.Activator.CreateInstance(objType); //创建实例
                    foreach (System.Reflection.PropertyInfo pi in objType.GetProperties()) //遍历T类的所有属性
                    {
                        try
                        {
                            if (pi.PropertyType.IsPublic && pi.CanWrite && myDt.Columns.Contains(pi.Name))
                            //属性是否为public和可写
                            {
                                Type pType = Type.GetType(pi.PropertyType.FullName); //属性类型
                                var value = dr[pi.Name].ToString();
                                objType.GetProperty(pi.Name).SetValue(obj, Convert.ChangeType(value, pType), null); //赋值
                            }
                        }
                        catch
                        {
                        }
                    }
                    listT.Add((T)obj);
                }
                catch
                {
                }
            }
            return listT;
        }
    }
}
