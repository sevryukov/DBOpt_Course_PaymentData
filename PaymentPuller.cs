using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Threading;

namespace BalanceCounter
{
    class PaymentPuller
    {
        const int periodInSeconds = 5;
        const int minimumRowsCollected = 0;
        const int maximumRowsNonstop = 1000;
        const int rowsCollectedAtOnce = 100;
        const int timesCollected = 5;

        static bool NonStop(SqlCommand cmd)
        {
            cmd.CommandText = "SELECT COUNT(*) FROM PaymentDataTemp.dbo.Payment";
            SqlDataReader read = cmd.ExecuteReader();
            int rows = 0;
            if (read.Read())
            {
                rows = read.GetInt32(0);
            }
            read.Close();
            return maximumRowsNonstop < rows;
        }

        static void Main(string[] args)
        {
            SqlConnection sqlConnection1 = new SqlConnection("Data Source=BUBRICK-ПК;Integrated Security=True");
            SqlCommand cmd = new SqlCommand();
            SqlDataReader reader;
            sqlConnection1.Open();
            cmd.CommandType = CommandType.Text;
            cmd.Connection = sqlConnection1;

            for (int times = 0; times < timesCollected; times++)
            {
                cmd.CommandText = "SELECT COUNT(*) FROM PaymentDataTemp.dbo.Payment";
                reader = cmd.ExecuteReader();
                bool cont = false;
                if (reader.Read())
                {
                    cont = minimumRowsCollected <= reader.GetInt32(0);
                }
                reader.Close();
                if (cont)
                {
                    do
                    {
                        cmd.CommandText = "INSERT INTO PaymentData.dbo.Payment SELECT TOP(" + rowsCollectedAtOnce + ") NEWID(), Amount, Category, Project, " +
                            "Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, " +
                            "Number FROM PaymentDataTemp.dbo.Payment;";
                        SqlTransaction transaction = sqlConnection1.BeginTransaction("Insert Transaction");
                        cmd.Transaction = transaction;
                        try
                        {
                            Stopwatch sw2 = new Stopwatch();
                            sw2.Start();
                            cmd.ExecuteNonQuery();
                            transaction.Commit();
                            Console.WriteLine("Insertion Completed! Took " + sw2.ElapsedMilliseconds + " ms");
                            sw2.Stop();
                            SqlTransaction transaction2 = sqlConnection1.BeginTransaction("Delete Transaction");
                            try
                            {
                                Stopwatch sw = new Stopwatch();
                                sw.Start();
                                cmd.CommandText = "DELETE TOP(" + rowsCollectedAtOnce + ") FROM PaymentDataTemp.dbo.Payment;";
                                cmd.Transaction = transaction2;
                                cmd.ExecuteNonQuery();
                                transaction2.Commit();
                                Console.WriteLine("Deletion Completed! Took " + sw.ElapsedMilliseconds + " ms");
                                sw.Stop();
                            }
                            catch
                            {
                                transaction2.Rollback();
                                Console.WriteLine("Deletion Failed!");
                            }
                        }
                        catch
                        {
                            transaction.Rollback();
                            Console.WriteLine("Insertion Failed!");
                        }
                    } while (NonStop(cmd));
                    sqlConnection1.Close();
                    Thread.Sleep(1000 * periodInSeconds);
                }
            }
        }
    }
}
