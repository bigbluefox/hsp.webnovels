using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using log4net;

namespace Hsp.Novels.DbUtility
{
    /// <summary>
    /// ���ݷ��ʳ��������
    /// </summary>
    public abstract class DbHelperSql
    {
        //���ݿ������ַ���(web.config������)
        public static string ConnectionString = ConfigurationManager.AppSettings["ConnectionString"] ?? "";

        //������־
        public static ILog Logger;

        protected DbHelperSql()
        {
            //Logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            Logger = LogManager.GetLogger("SINOCAL");

            //private static readonly ILog logger = LogManager.GetLogger(typeof(DataHelper));

        }

        #region ���÷���

        public static int GetMaxId(string fieldName, string tableName)
        {
            string strsql = "select max(" + fieldName + ") + 1 from " + tableName;
            object obj = GetSingle(strsql);
            return obj == null ? 1 : int.Parse(obj.ToString());
        }

        public static bool Exists(string strSql)
        {
            object obj = GetSingle(strSql);
            int cmdresult;
            if ((Equals(obj, null)) || (Equals(obj, DBNull.Value)))
            {
                cmdresult = 0;
            }
            else
            {
                cmdresult = int.Parse(obj.ToString());
            }
            return cmdresult != 0;
        }

        public static bool Exists(string strSql, params SqlParameter[] cmdParms)
        {
            object obj = GetSingle(strSql, cmdParms);
            int cmdresult;
            if ((Equals(obj, null)) || (Equals(obj, DBNull.Value)))
            {
                cmdresult = 0;
            }
            else
            {
                cmdresult = int.Parse(obj.ToString());
            }
            return cmdresult != 0;
        }

        #endregion

        #region  ִ�м�SQL���

        /// <summary>
        /// ִ��SQL��䣬����Ӱ��ļ�¼��
        /// </summary>
        /// <param name="sqlString">SQL���</param>
        /// <returns>Ӱ��ļ�¼��</returns>
        public static int ExecuteSql(string sqlString)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var cmd = new SqlCommand(sqlString, connection))
                {
                    try
                    {
                        connection.Open();
                        int rows = cmd.ExecuteNonQuery();
                        return rows;
                    }
                    catch (SqlException e)
                    {
                        connection.Close();
                        throw new Exception(e.Message);
                    }
                }
            }
        }

        /// <summary>
        /// ִ��SQL��䣬���������ִ�еȴ�ʱ��
        /// </summary>
        /// <param name="sqlString"></param>
        /// <param name="iTimes"></param>
        /// <returns></returns>
        public static int ExecuteSqlByTime(string sqlString, int iTimes)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var cmd = new SqlCommand(sqlString, connection))
                {
                    try
                    {
                        connection.Open();
                        cmd.CommandTimeout = iTimes;
                        int rows = cmd.ExecuteNonQuery();
                        return rows;
                    }
                    catch (SqlException e)
                    {
                        connection.Close();
                        Logger.Error(e.Message);
                        throw new Exception(e.Message);
                    }
                }
            }
        }

        /// <summary>
        /// ִ�ж���SQL��䣬ʵ�����ݿ�����
        /// </summary>
        /// <param name="sqlStringList">����SQL���</param>		
        public static void ExecuteSqlTran(ArrayList sqlStringList)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                var cmd = new SqlCommand();
                cmd.Connection = conn;
                SqlTransaction tx = conn.BeginTransaction();
                cmd.Transaction = tx;
                try
                {
                    for (int n = 0; n < sqlStringList.Count; n++)
                    {
                        string strsql = sqlStringList[n].ToString();
                        if (strsql.Trim().Length > 1)
                        {
                            cmd.CommandText = strsql;
                            cmd.ExecuteNonQuery();
                        }
                    }
                    tx.Commit();
                }
                catch (SqlException e)
                {
                    tx.Rollback();
                    Logger.Error(e.Message);
                    throw new Exception(e.Message);
                }
            }
        }

        /// <summary>
        /// ִ�д�һ���洢���̲����ĵ�SQL��䡣
        /// </summary>
        /// <param name="sqlString">SQL���</param>
        /// <param name="content">��������,����һ���ֶ��Ǹ�ʽ���ӵ����£���������ţ�����ͨ�������ʽ���</param>
        /// <returns>Ӱ��ļ�¼��</returns>
        public static int ExecuteSql(string sqlString, string content)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                var cmd = new SqlCommand(sqlString, connection);
                var myParameter = new SqlParameter("@content", SqlDbType.NText);
                myParameter.Value = content;
                cmd.Parameters.Add(myParameter);
                try
                {
                    connection.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows;
                }
                catch (SqlException e)
                {
                    Logger.Error(e.Message);
                    throw new Exception(e.Message);
                }
                finally
                {
                    cmd.Dispose();
                    connection.Close();
                }
            }
        }

        /// <summary>
        /// ִ�д�һ���洢���̲����ĵ�SQL��䡣
        /// </summary>
        /// <param name="sqlString">SQL���</param>
        /// <param name="content">��������,����һ���ֶ��Ǹ�ʽ���ӵ����£���������ţ�����ͨ�������ʽ���</param>
        /// <returns>Ӱ��ļ�¼��</returns>
        public static object ExecuteSqlGet(string sqlString, string content)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                var cmd = new SqlCommand(sqlString, connection);
                var myParameter = new SqlParameter("@content", SqlDbType.NText);
                myParameter.Value = content;
                cmd.Parameters.Add(myParameter);
                try
                {
                    connection.Open();
                    object obj = cmd.ExecuteScalar();
                    if ((Equals(obj, null)) || (Equals(obj, DBNull.Value)))
                    {
                        return null;
                    }
                    else
                    {
                        return obj;
                    }
                }
                catch (SqlException e)
                {
                    Logger.Error(e.Message);
                    throw new Exception(e.Message);
                }
                finally
                {
                    cmd.Dispose();
                    connection.Close();
                }
            }
        }

        /// <summary>
        /// �����ݿ������ͼ���ʽ���ֶ�(������������Ƶ���һ��ʵ��)
        /// </summary>
        /// <param name="strSql">SQL���</param>
        /// <param name="fs">ͼ���ֽ�,���ݿ���ֶ�����Ϊimage�����</param>
        /// <returns>Ӱ��ļ�¼��</returns>
        public static int ExecuteSqlInsertImg(string strSql, byte[] fs)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                var cmd = new SqlCommand(strSql, connection);
                var myParameter = new SqlParameter("@fs", SqlDbType.Image);
                myParameter.Value = fs;
                cmd.Parameters.Add(myParameter);
                try
                {
                    connection.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows;
                }
                catch (SqlException e)
                {
                    Logger.Error(e.Message);
                    throw new Exception(e.Message);
                }
                finally
                {
                    cmd.Dispose();
                    connection.Close();
                }
            }
        }

        /// <summary>
        /// ִ��һ�������ѯ�����䣬���ز�ѯ�����object����
        /// </summary>
        /// <param name="sqlString">�����ѯ������</param>
        /// <returns>��ѯ�����object��</returns>
        public static object GetSingle(string sqlString)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var cmd = new SqlCommand(sqlString, connection))
                {
                    try
                    {
                        connection.Open();
                        object obj = cmd.ExecuteScalar();
                        if ((Equals(obj, null)) || (Equals(obj, DBNull.Value)))
                        {
                            return null;
                        }
                        else
                        {
                            return obj;
                        }
                    }
                    catch (SqlException e)
                    {
                        connection.Close();
                        Logger.Error(e.Message);
                        throw new Exception(e.Message);
                    }
                }
            }
        }


        /// <summary>
        /// ִ�в�ѯ��䣬����SqlDataReader(ʹ�ø÷����м�Ҫ�ֹ��ر�SqlDataReader������)
        /// </summary>
        /// <param name="strSql">��ѯ���</param>
        /// <returns>SqlDataReader</returns>
        public static SqlDataReader ExecuteReader(string strSql)
        {
            var connection = new SqlConnection(ConnectionString);
            var cmd = new SqlCommand(strSql, connection);
            try
            {
                connection.Open();
                SqlDataReader myReader = cmd.ExecuteReader();
                return myReader;
            }
            catch (SqlException e)
            {
                throw new Exception(e.Message);
            }
            //finally //�����ڴ˹رգ����򣬷��صĶ����޷�ʹ��
            //{
            //	cmd.Dispose();
            //	connection.Close();
            //}	
        }

        /// <summary>
        /// ִ�в�ѯ��䣬����DataSet
        /// </summary>
        /// <param name="sqlString">��ѯ���</param>
        /// <returns>DataSet</returns>
        public static DataSet Query(string sqlString)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                var ds = new DataSet();
                try
                {
                    connection.Open();
                    var command = new SqlDataAdapter(sqlString, connection);
                    command.Fill(ds, "ds");
                }
                catch (SqlException e)
                {
                    Logger.Error(e.Message);
                    //throw new Exception(e.Message);
                }
                return ds;
            }
        }

        /// <summary>
        /// ִ�в�ѯ��䣬����DataSet, ���������ִ�еȴ�ʱ��
        /// </summary>
        /// <param name="sqlString"></param>
        /// <param name="iTimes"></param>
        /// <returns></returns>
        public static DataSet Query(string sqlString, int iTimes)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                var ds = new DataSet();
                try
                {
                    connection.Open();
                    var command = new SqlDataAdapter(sqlString, connection);
                    command.SelectCommand.CommandTimeout = iTimes;
                    command.Fill(ds, "ds");
                }
                catch (SqlException e)
                {
                    Logger.Error(e.Message);
                    throw new Exception(e.Message);
                }
                return ds;
            }
        }

        #endregion

        #region ִ�д�������SQL���

        /// <summary>
        /// ִ��SQL��䣬����Ӱ��ļ�¼��
        /// </summary>
        /// <param name="sqlString">SQL���</param>
        /// <param name="cmdParms"></param>
        /// <returns>Ӱ��ļ�¼��</returns>
        public static int ExecuteSql(string sqlString, params SqlParameter[] cmdParms)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    try
                    {
                        PrepareCommand(cmd, connection, null, sqlString, cmdParms);
                        int rows = cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                        return rows;
                    }
                    catch (SqlException E)
                    {
                        Logger.Error(E.Message);
                        throw new Exception(E.Message);
                    }
                }
            }
        }


        /// <summary>
        /// ִ�ж���SQL��䣬ʵ�����ݿ�����
        /// </summary>
        /// <param name="sqlStringList">SQL���Ĺ�ϣ��keyΪsql��䣬value�Ǹ�����SqlParameter[]��</param>
        public static void ExecuteSqlTran(Hashtable sqlStringList)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                using (SqlTransaction trans = conn.BeginTransaction())
                {
                    var cmd = new SqlCommand();
                    try
                    {
                        //ѭ��
                        foreach (DictionaryEntry myDe in sqlStringList)
                        {
                            string cmdText = myDe.Key.ToString();
                            var cmdParms = (SqlParameter[]) myDe.Value;
                            PrepareCommand(cmd, conn, trans, cmdText, cmdParms);
                            int val = cmd.ExecuteNonQuery();
                            cmd.Parameters.Clear();

                            trans.Commit();
                        }
                    }
                    catch (SqlException e)
                    {
                        trans.Rollback();
                        Logger.Error(e.Message);
                        throw new Exception(e.Message);
                    }
                }
            }
        }


        /// <summary>
        /// ִ��һ�������ѯ�����䣬���ز�ѯ�����object����
        /// </summary>
        /// <param name="sqlString">�����ѯ������</param>
        /// <param name="cmdParms"></param>
        /// <returns>��ѯ�����object��</returns>
        public static object GetSingle(string sqlString, params SqlParameter[] cmdParms)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    try
                    {
                        PrepareCommand(cmd, connection, null, sqlString, cmdParms);
                        object obj = cmd.ExecuteScalar();
                        cmd.Parameters.Clear();
                        if ((Equals(obj, null)) || (Equals(obj, DBNull.Value)))
                        {
                            return null;
                        }
                        else
                        {
                            return obj;
                        }
                    }
                    catch (SqlException e)
                    {
                        Logger.Error(e.Message);
                        throw new Exception(e.Message);
                    }
                }
            }
        }

        /// <summary>
        /// ִ�в�ѯ��䣬����SqlDataReader (ʹ�ø÷����м�Ҫ�ֹ��ر�SqlDataReader������)
        /// </summary>
        /// <param name="sqlString">��ѯ���</param>
        /// <param name="cmdParms"></param>
        /// <returns>SqlDataReader</returns>
        public static SqlDataReader ExecuteReader(string sqlString, params SqlParameter[] cmdParms)
        {
            var connection = new SqlConnection(ConnectionString);
            var cmd = new SqlCommand();
            try
            {
                PrepareCommand(cmd, connection, null, sqlString, cmdParms);
                SqlDataReader myReader = cmd.ExecuteReader();
                cmd.Parameters.Clear();
                return myReader;
            }
            catch (SqlException e)
            {
                Logger.Error(e.Message);
                throw new Exception(e.Message);
            }
            //finally //�����ڴ˹رգ����򣬷��صĶ����޷�ʹ��
            //{
            //	cmd.Dispose();
            //	connection.Close();
            //}	
        }

        /// <summary>
        /// ִ�в�ѯ��䣬����DataSet
        /// </summary>
        /// <param name="sqlString">��ѯ���</param>
        /// <param name="cmdParms"></param>
        /// <returns>DataSet</returns>
        public static DataSet Query(string sqlString, params SqlParameter[] cmdParms)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                var cmd = new SqlCommand();
                PrepareCommand(cmd, connection, null, sqlString, cmdParms);
                using (var da = new SqlDataAdapter(cmd))
                {
                    var ds = new DataSet();
                    try
                    {
                        da.Fill(ds, "ds");
                        cmd.Parameters.Clear();
                    }
                    catch (SqlException e)
                    {
                        Logger.Error(e.Message);
                        throw new Exception(e.Message);
                    }
                    return ds;
                }
            }
        }


        private static void PrepareCommand(SqlCommand cmd, SqlConnection conn, SqlTransaction trans, string cmdText,
                                           SqlParameter[] cmdParms)
        {
            if (conn.State != ConnectionState.Open)
                conn.Open();
            cmd.Connection = conn;
            cmd.CommandText = cmdText;
            if (trans != null)
                cmd.Transaction = trans;
            cmd.CommandType = CommandType.Text; //cmdType;
            if (cmdParms != null)
            {
                foreach (SqlParameter parameter in cmdParms)
                {
                    if ((parameter.Direction == ParameterDirection.InputOutput ||
                         parameter.Direction == ParameterDirection.Input) &&
                        (parameter.Value == null))
                    {
                        parameter.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(parameter);
                }
            }
        }

        #endregion

        #region �洢���̲���

        /// <summary>
        /// ִ�д洢����  (ʹ�ø÷����м�Ҫ�ֹ��ر�SqlDataReader������)
        /// </summary>
        /// <param name="storedProcName">�洢������</param>
        /// <param name="parameters">�洢���̲���</param>
        /// <returns>SqlDataReader</returns>
        public static SqlDataReader RunProcedure(string storedProcName, IDataParameter[] parameters)
        {
            var connection = new SqlConnection(ConnectionString);
            connection.Open();
            SqlCommand command = BuildQueryCommand(connection, storedProcName, parameters);
            command.CommandType = CommandType.StoredProcedure;
            SqlDataReader returnReader = command.ExecuteReader();
            //Connection.Close(); �����ڴ˹رգ����򣬷��صĶ����޷�ʹ��            
            return returnReader;
        }


        /// <summary>
        /// ִ�д洢����
        /// </summary>
        /// <param name="storedProcName">�洢������</param>
        /// <param name="parameters">�洢���̲���</param>
        /// <param name="tableName">DataSet����еı���</param>
        /// <returns>DataSet</returns>
        public static DataSet RunProcedure(string storedProcName, IDataParameter[] parameters, string tableName)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                var dataSet = new DataSet();
                connection.Open();
                var sqlDA = new SqlDataAdapter();
                sqlDA.SelectCommand = BuildQueryCommand(connection, storedProcName, parameters);
                sqlDA.Fill(dataSet, tableName);
                connection.Close();
                return dataSet;
            }
        }

        public static DataSet RunProcedure(string storedProcName, IDataParameter[] parameters, string tableName,
                                           int iTimes)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                var dataSet = new DataSet();
                connection.Open();
                var sqlDA = new SqlDataAdapter();
                sqlDA.SelectCommand = BuildQueryCommand(connection, storedProcName, parameters);
                sqlDA.SelectCommand.CommandTimeout = iTimes;
                sqlDA.Fill(dataSet, tableName);
                connection.Close();
                return dataSet;
            }
        }

        /// <summary>
        /// ִ�з�ҳ�洢����
        /// </summary>
        /// <param name="strSql"></param>
        /// <param name="iCurrentPage"></param>
        /// <param name="iPageSize"></param>
        /// <returns>DataSet</returns>
        public static DataSet GetPageRecordBySql(string strSql, int iCurrentPage, int iPageSize)
        {
            const string strStoreProcedure = "dbo.sp_GetPageData";
            var sqlParameter = new SqlParameter[3];
            sqlParameter[0] = new SqlParameter("@SQLSTR", strSql);
            sqlParameter[1] = new SqlParameter("@CURPAEG", iCurrentPage);
            sqlParameter[2] = new SqlParameter("@PAGESIZE", iPageSize);
            return RunProcedure(strStoreProcedure, sqlParameter, "PageRecords");
        }


        /// <summary>
        /// ���� SqlCommand ����(��������һ���������������һ������ֵ)
        /// </summary>
        /// <param name="connection">���ݿ�����</param>
        /// <param name="storedProcName">�洢������</param>
        /// <param name="parameters">�洢���̲���</param>
        /// <returns>SqlCommand</returns>
        private static SqlCommand BuildQueryCommand(SqlConnection connection, string storedProcName,
                                                    IDataParameter[] parameters)
        {
            var command = new SqlCommand(storedProcName, connection);
            command.CommandType = CommandType.StoredProcedure;
            foreach (SqlParameter parameter in parameters)
            {
                if (parameter != null)
                {
                    // ���δ����ֵ���������,���������DBNull.Value.
                    if ((parameter.Direction == ParameterDirection.InputOutput ||
                         parameter.Direction == ParameterDirection.Input) &&
                        (parameter.Value == null))
                    {
                        parameter.Value = DBNull.Value;
                    }
                    command.Parameters.Add(parameter);
                }
            }

            return command;
        }

        /// <summary>
        /// ִ�д洢���̣�����Ӱ�������		
        /// </summary>
        /// <param name="storedProcName">�洢������</param>
        /// <param name="parameters">�洢���̲���</param>
        /// <param name="rowsAffected">Ӱ�������</param>
        /// <returns></returns>
        public static int RunProcedure(string storedProcName, IDataParameter[] parameters, out int rowsAffected)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                SqlCommand command = BuildIntCommand(connection, storedProcName, parameters);
                rowsAffected = command.ExecuteNonQuery();
                var result = (int) command.Parameters["ReturnValue"].Value;
                //Connection.Close();
                return result;
            }
        }

        /// <summary>
        /// ���� SqlCommand ����ʵ��(��������һ������ֵ)	
        /// </summary>
        /// <param name="connection"></param>
        /// <param name="storedProcName">�洢������</param>
        /// <param name="parameters">�洢���̲���</param>
        /// <returns>SqlCommand ����ʵ��</returns>
        private static SqlCommand BuildIntCommand(SqlConnection connection, string storedProcName,
                                                  IDataParameter[] parameters)
        {
            SqlCommand command = BuildQueryCommand(connection, storedProcName, parameters);
            command.Parameters.Add(new SqlParameter("ReturnValue",
                                                    SqlDbType.Int, 4, ParameterDirection.ReturnValue,
                                                    false, 0, 0, string.Empty, DataRowVersion.Default, null));
            return command;
        }

        #endregion
    }
}