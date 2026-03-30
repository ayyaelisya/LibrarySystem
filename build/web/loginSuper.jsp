<%
    if (session.getAttribute("username") != null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return; 
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Library Login</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="auth-container">
    <h2>📚 Super Admin Login</h2>

    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="message error"><%= errorMessage %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/superLogin" method="post">
        <input type="text" name="username" placeholder="Enter username" required>

        <div class="input-group">
            <input type="password" id="password" name="password" placeholder="Enter password" required>
            <span class="toggle-icon" onclick="togglePassword('password', this)">
                <i class="fa-solid fa-eye-slash"></i>
            </span>
        </div>

        <button type="submit">Login as Super Admin</button>
    </form>

    <div class="footer">
        <p>You're an admin ? <a href="login.jsp">Login here</a></p>
    </div>
</div>

<script>
function togglePassword(inputId, icon) {
    const input = document.getElementById(inputId);
    const eyeIcon = icon.querySelector("i");

    if (input.type === "password") {
        input.type = "text";
        eyeIcon.classList.remove("fa-eye-slash");
        eyeIcon.classList.add("fa-eye");
    } else {
        input.type = "password";
        eyeIcon.classList.remove("fa-eye");
        eyeIcon.classList.add("fa-eye-slash");
    }
}
</script>

</body>
</html>