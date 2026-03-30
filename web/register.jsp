<%
    // Semak jika bukan superadmin, tendang keluar ke index atau login
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    } else if (!"superadmin".equals(role)) {
        response.sendRedirect("DashboardServlet"); // Admin biasa tak boleh register orang lain
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Library Register</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="auth-container">
    <h2>📚 Register an Account for Admin</h2>

    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="message error"><%= errorMessage %></div>
    <% } %>

    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% if (successMessage != null) { %>
        <div class="message success"><%= successMessage %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" onsubmit="return validatePassword()">
        <input type="text" name="username" placeholder="Enter username" required>

         <div class="input-group">
    <input type="password" id="password" name="password" placeholder="Enter password" required>
    <span class="toggle-icon" onclick="togglePassword('password', this)">
        <i class="fa-solid fa-eye-slash"></i>
    </span>
</div>

<div id="password-criteria" class="criteria-list" style="display:none;">
    <p id="length" class="invalid">✖ Minimum 8 characters</p>
    <p id="uppercase" class="invalid">✖ One uppercase letter</p>
    <p id="lowercase" class="invalid">✖ One lowercase letter</p>
    <p id="number" class="invalid">✖ One number</p>
    <p id="special" class="invalid">✖ One special character (@$!%*?&.#_-)</p>
</div>

<div class="input-group">
    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
    <span class="toggle-icon" onclick="togglePassword('confirmPassword', this)">
        <i class="fa-solid fa-eye-slash"></i>
    </span>
</div>


        <div id="passwordError" class="message error" style="display:none;"></div>

       <div class="button-group" style="display: flex; gap: 10px; margin-top: 15px;">
    <button type="submit" style="flex: 1;">Register</button>
    
    <button type="button" 
            onclick="window.location.href='DashboardServlet'" 
            class="btn-secondary" 
            style="flex: 1; background-color: #6c757d;">
        Go to Dashboard
    </button>
</div>
    </form>
</div>

<script>
// 1. Fungsi Toggle Mata
function togglePassword(inputId, icon) {
    const input = document.getElementById(inputId);
    const eyeIcon = icon.querySelector("i");
    if (input.type === "password") {
        input.type = "text";
        eyeIcon.classList.replace("fa-eye-slash", "fa-eye");
    } else {
        input.type = "password";
        eyeIcon.classList.replace("fa-eye", "fa-eye-slash");
    }
}

// 2. Element Selector
const passwordInput = document.getElementById("password");
const criteriaList = document.getElementById("password-criteria");

// 3. Tunjukkan senarai bila mula klik/taip
passwordInput.addEventListener("focus", function() {
    criteriaList.style.display = "block";
});

// 4. LOGIK LIVE CHECKING (Gantikan kod lama anda dengan ini)
passwordInput.addEventListener("input", function() {
    const val = passwordInput.value;
    const requirements = [
        { id: "length", regex: /.{8,}/, text: "Minimum 8 characters" },
        { id: "uppercase", regex: /[A-Z]/, text: "One uppercase letter" },
        { id: "lowercase", regex: /[a-z]/, text: "One lowercase letter" },
        { id: "number", regex: /[0-9]/, text: "One number" },
        { id: "special", regex: /[@$!%*?&.#_\-]/, text: "One special character" }
    ];

    requirements.forEach(req => {
        const element = document.getElementById(req.id);
        if (req.regex.test(val)) {
            element.classList.remove("invalid");
            element.classList.add("valid");
            element.innerHTML = "✔ " + req.text;
        } else {
            element.classList.remove("valid");
            element.classList.add("invalid");
            element.innerHTML = "✖ " + req.text;
        }
    });
});

// 5. Sorok semula jika dah valid atau kosong bila klik luar
passwordInput.addEventListener("blur", function() {
    const val = passwordInput.value;
    const strongPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#_\-]).{8,}$/;
    if (strongPattern.test(val) || val === "") {
        criteriaList.style.display = "none";
    }
});

// 6. Final Validation semasa tekan butang Register
function validatePassword() {
    const password = document.getElementById("password").value;
    const confirmPassword = document.getElementById("confirmPassword").value;
    const errorBox = document.getElementById("passwordError");
    const strongPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#_\-]).{8,}$/;

    if (!strongPattern.test(password)) {
        errorBox.style.display = "block";
        errorBox.textContent = "Please fulfill all password requirements.";
        return false;
    }
    if (password !== confirmPassword) {
        errorBox.style.display = "block";
        errorBox.textContent = "Passwords do not match.";
        return false;
    }
    return true;
}
</script>
</body>
</html>