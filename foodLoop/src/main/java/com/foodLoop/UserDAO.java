package com.foodloop;

import java.sql.*;

public class UserDAO {

    // Method to insert a new user
    public boolean addUser(String name, String email, String password) {
        Connection connection = DatabaseConnection.getConnection();
        String query = "INSERT INTO user (name, email, password) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, name);
            statement.setString(2, email);
            statement.setString(3, password);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0; // Return true if user is added successfully
        } catch (SQLException e) {
            System.out.println("Error adding user: " + e.getMessage());
            return false;
        }
    }

    // Method to fetch user by email (for login functionality)
    public User getUserByEmail(String email) {
        Connection connection = DatabaseConnection.getConnection();
        String query = "SELECT * FROM user WHERE email = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, email);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                // Create a User object to hold the result
                User user = new User(
                        resultSet.getInt("id"),
                        resultSet.getString("name"),
                        resultSet.getString("email"),
                        resultSet.getString("password")
                );
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error fetching user: " + e.getMessage());
        }
        return null;
    }

    // Method to update user details
    public boolean updateUser(int id, String name, String email, String password) {
        Connection connection = DatabaseConnection.getConnection();
        String query = "UPDATE user SET name = ?, email = ?, password = ? WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, name);
            statement.setString(2, email);
            statement.setString(3, password);
            statement.setInt(4, id);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
            return false;
        }
    }

    // Method to delete user
    public boolean deleteUser(int id) {
        Connection connection = DatabaseConnection.getConnection();
        String query = "DELETE FROM user WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, id);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting user: " + e.getMessage());
            return false;
        }
    }
}
