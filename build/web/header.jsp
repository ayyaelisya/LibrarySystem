<style>
    body {
        
       
        
        margin-top: 80px; 
        font-family: Arial, sans-serif;
    }
    .navbar {
        background-color: #001f3f; 
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 30px;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 70px;
        z-index: 1000;
        box-sizing: border-box;
        box-shadow: 0 4px 10px rgba(0,0,0,0.3);
    }
    .nav-brand {
        color: #4CAF50 !important; 
        font-size: 24px;
        font-weight: bold;
        text-decoration: none;
        letter-spacing: 1px;
    }
    .nav-brand:hover {
        color: #66BB6A !important;
    }
    .nav-menu {
        display: flex;
        gap: 10px;
    }
    .navbar a {
        color: #f2f2f2;
        text-align: center;
        padding: 12px 18px;
        text-decoration: none;
        font-size: 16px;
        border-radius: 5px;
        transition: 0.3s ease;
    }
    .nav-menu a:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: white;
    }
    .logout-btn {
        background-color: #d9534f; 
        color: white !important;
        font-size: 18px;
        padding: 10px 15px;
        border-radius: 5px;
        display: flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
    }
    .logout-btn:hover {
        background-color: #c9302c !important;
        transform: translateY(-2px);
    }
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<div class="navbar">
    <a href="DashboardServlet" class="nav-brand">LMS-Connect</a>

    <div class="nav-menu">
        <a href="DashboardServlet">Dashboard</a>
        <a href="BookServlet">Manage Books</a>
        <a href="BorrowServlet">Borrow Book</a>
        <a href="ReturnServlet">Return Book</a>
    </div>

    <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Logout">
    <i class="fas fa-sign-out-alt"></i>
</a>
</div>