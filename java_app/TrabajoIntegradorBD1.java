/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package com.mycompany.trabajointegradorbd1;
//import java.sql.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.Scanner;

/**
 *
 * @author Matias
 */
public class TrabajoIntegradorBD1 {

    public static void main(String[] args) {

        EjemploVulnerable ejemplo_1 = new EjemploVulnerable();
        EjemploSeguro ejemplo_2 = new EjemploSeguro();

        Scanner sc = new Scanner(System.in);

        System.out.println("Ingrese valor para 'calle': ");

        String userInput = sc.nextLine();

        String sqlStatement = "SELECT id, calle, numero, ciudad FROM domicilioFiscal WHERE numero = '" + userInput + "'"; // String para Statement
        String sqlPreparedStatement = "SELECT id, calle, numero, ciudad FROM domicilioFiscal WHERE numero = ?"; // String para PreparedStatemnt

        Connection conexion = ConexionBD.getConnection();

        //Ejemplo con conexión insegura
        //ejemplo_1.ConexionVulnerable(sqlStatement, conexion);

        //Ejemplo con conexión segura
        ejemplo_2.ConexionSegura(sqlPreparedStatement, conexion, userInput);
    }

}
