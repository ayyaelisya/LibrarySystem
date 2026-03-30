<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>

<%
    // Mengelakkan caching supaya butang 'Back' browser tidak menunjukkan data selepas logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Semak jika session username tidak wujud
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return; 
    }

    // --- BAHAGIAN TARIK DATA DARI DASHBOARDSERVLET ---
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    int total = (stats != null && stats.containsKey("total")) ? stats.get("total") : 0;
    int borrowed = (stats != null && stats.containsKey("borrowed")) ? stats.get("borrowed") : 0;
    int available = (stats != null && stats.containsKey("available")) ? stats.get("available") : 0;
    int overdue = (stats != null && stats.containsKey("overdue")) ? stats.get("overdue") : 0;
    // ------------------------------------------------
%>

<!DOCTYPE html>
<html>
<head>
    <title>Library System Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body { background: url('assets/images/libs.png'); background-size: cover; }
        .card-box { padding: 20px; border-radius: 15px; transition: 0.3s; color: white; text-align: center; cursor: pointer; }
        .card-box:hover { transform: translateY(-5px); filter: brightness(1.1); }
        .bg-crud { background-color: #4e73df; }
        .bg-borrow { background-color: #1cc88a; }
        .bg-return { background-color: #f6c23e; }
    </style>
</head>

<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center">Library Management System</h2>

    <div class="row mb-5">
        <div class="col-md-4">
            <div class="card-box bg-crud" onclick="location.href='BookServlet'">
                <h3>CRUD Page</h3>
                <p>Manage & Edit Book List</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-box bg-borrow" onclick="location.href='BorrowServlet'">
                <h3>Borrow Book</h3>
                <p>Register New Loans</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-box bg-return" onclick="location.href='ReturnServlet'">
                <h3>Return & Fine</h3>
                <p>Calculate Fines & Returns</p>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8 mx-auto bg-white p-4 shadow-sm rounded">
            <h4 class="text-center">System Statistics</h4>
            <canvas id="libraryChart"></canvas>
        </div>
    </div>
</div>

<script>
    const ctx = document.getElementById('libraryChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar', 
        data: {
            labels: ['Total Books', 'Borrowed', 'Available', 'Overdue'],
            datasets: [{
                label: 'System Data (Real-time)',
                // Guna variable Java yang kita tangkap kat atas tadi
                data: [<%= total %>, <%= borrowed %>, <%= available %>, <%= overdue %>], 
                backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#e74a3b']
            }]
        },
        options: {
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
</script>

<jsp:include page="header.jsp" />
</body>
</html>