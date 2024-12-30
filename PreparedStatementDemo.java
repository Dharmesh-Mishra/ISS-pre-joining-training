package p1;

import java.sql.*;
import java.util.logging.*;
import java.util.Scanner;
public class PreparedStatementDemo {
	private static Logger logger=Logger.getLogger(PreparedStatementDemo.class.getName());
	public static void main(String [] args) {
		Scanner sc=new Scanner (System.in);
		try {
			//System.out.println("Enter Customer ID: ");
			logger.info("Enter Customer ID: ");
			int customerID=sc.nextInt();
			try (Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/iss_training", "root", "root")){
				logger.info("Database connection established");		
				String sqlQuery="Select * from Orders where customer_id=?";
				try(PreparedStatement ps=con.prepareStatement(sqlQuery)){
					ps.setInt(1, customerID);
					try(ResultSet rs=ps.executeQuery()){
						logger.info("Running Procedure");
						while(rs.next()) {
							int orderID=rs.getInt("order_id");
							int prodID=rs.getInt("product_id");
							int quantity=rs.getInt("quantity");
							Date date=rs.getDate("order_date");
							logger.info("Order ID = " + orderID + "\n Product ID = "+prodID + "\n Quantity = "+ quantity + "\nOrder Date = " + date);
						}
					}
				}
			}
		}
			catch(SQLException e) {
				logger.severe("DATABASE ERROR : "+ e.getMessage());
			}catch(Exception e) {
				logger.severe(" ERROR : "+ e.getMessage());
			}
			finally {
				sc.close();
			
		}
	}
}
