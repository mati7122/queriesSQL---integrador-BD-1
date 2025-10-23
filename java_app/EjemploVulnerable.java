/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.trabajointegradorbd1;

import java.sql.Statement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.Scanner;
import java.sql.Connection;

/**
 *
 * @author Matias
 */
public class EjemploVulnerable {

    public void ConexionVulnerable(String sql, Connection conexion) {
         try {
            Statement st = conexion.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            System.out.println("Consulta ejecutada: " + sql);
            
            int rows = 0;
            while (rs.next()) {
                rows++;
                System.out.printf("fila -> id:%d calle:%s ciudad:%s%n",
                                  rs.getLong("id"),
                                  rs.getString("calle"),
                                  rs.getString("ciudad"));
            }
            System.out.println("Total filas devueltas: " + rows);
            
            
        }
        catch(SQLException e) {
            e.printStackTrace();
            
        }
    }

   
}
