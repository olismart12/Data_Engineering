
using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;
public partial class StoredProcedures
{
    [SqlProcedure]
    public static void CreatePackage(
        SqlString packageName,
        SqlString packagedescription,
        SqlDateTime startDate,
        SqlDateTime endDate,
        SqlDecimal advertisedPrice,
        SqlString advertisedCurrency,
        SqlInt32 employeeId,
        SqlInt32 gracePeriod,
        out SqlInt32 packageId)
    {
        packageId = SqlInt32.Null;

        try
        {
            using (SqlConnection conn = new SqlConnection("context connection=true"))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Package (Name, Description, Start_Date, End_Date, Advertised_Price, Advertised_Currency, Employee_ID, Grace_Period) " +
                    "VALUES (@packageName, @description, @startDate, @endDate, @advertisedPrice, @advertisedCurrency, @employeeId, @gracePeriod); " +
                    "SELECT SCOPE_IDENTITY();", conn))
                {
                    cmd.Parameters.AddWithValue("@packageName", packageName);
                    cmd.Parameters.AddWithValue("@description", packagedescription);
                    cmd.Parameters.AddWithValue("@startDate", startDate);
                    cmd.Parameters.AddWithValue("@endDate", endDate);
                    cmd.Parameters.AddWithValue("@advertisedPrice", advertisedPrice);
                    cmd.Parameters.AddWithValue("@advertisedCurrency", advertisedCurrency);
                    cmd.Parameters.AddWithValue("@employeeId", employeeId);
                    cmd.Parameters.AddWithValue("@gracePeriod", gracePeriod);

                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        packageId = new SqlInt32(Convert.ToInt32(result));
                    }
                }
            }
        }
        catch (Exception ex)
        {
            SqlContext.Pipe.Send("Error: " + ex.Message);
        }
    }
}

