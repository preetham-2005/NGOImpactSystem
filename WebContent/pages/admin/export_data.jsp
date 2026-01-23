<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="com.ngo.model.User" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Export Data</title>
</head>
<body>

<h1>Export Data Page ✅</h1>

<table border="1" cellpadding="10">
<tr>
    <th>ID</th>
    <th>Username</th>
    <th>Role</th>
    <th>Email</th>
</tr>

<%
    List<User> users = (List<User>) request.getAttribute("users");
    if(users != null){
        for(User u : users){
%>
<tr>
    <td><%=u.getUserId() %></td>
    <td><%=u.getUsername() %></td>
    <td><%=u.getRole() %></td>
    <td><%=u.getEmail() %></td>
</tr>
<%
        }
    }
%>

</table>

</body>
</html>
