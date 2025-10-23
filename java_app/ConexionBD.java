/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.trabajointegradorbd1;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author Matias
 */
public class ConexionBD {
    private static final String URL = "jdbc:mysql://localhost:3306/test2";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";
    
    public static Connection getConnection() {
        Connection conexion = null;
        
        try {
            // Establecer la conexión
            conexion = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conexión exitosa a la base de datos");
        } catch (SQLException e) {
            System.out.println("Error al conectar con la base de datos.");
            e.printStackTrace();
            
        }
        return conexion;
    }
}
