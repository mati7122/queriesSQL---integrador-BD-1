/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.trabajointegradorbd1;

import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.ResultSet;

/**
 *
 * @author Matias
 */
public class EjemploSeguro {

    public void ConexionSegura(String sql, Connection conexion, String userInput) {
        try {
            PreparedStatement ps = conexion.prepareStatement(sql);

            ps.setString(1, userInput);

            System.out.println("Consulta preparada: " + sql + " (parametro = " + userInput + ")");

            ResultSet rs = ps.executeQuery();

            int rows = 0;

            while (rs.next()) {
                rows++;
                System.out.printf("fila -> id:%d calle:%s ciudad:%s%n",
                        rs.getLong("id"),
                        rs.getString("calle"),
                        rs.getString("ciudad"));
            }
            System.out.println("Total filas devueltas (seguro): " + rows);

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}
