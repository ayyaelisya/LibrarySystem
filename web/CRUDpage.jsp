<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.book.model.Book" %>

<html>
<head>
    
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"><!-- comment -->


<title>CRUD PAGE</title>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: url('assets/images/libs.png');
        min-height: 100vh;
        padding: 40px 20px;
    }

    h1 {
        color: #133C55;
        text-align: center;
        font-size: 2.5em;
        margin-bottom: 30px;
        position: relative;
        z-index: 10;
    }

    .books-decoration {
        position: absolute;
        font-size: 3.5em;
        opacity: 0.8;
        animation: float 5s ease-in-out infinite;
    }

    @keyframes float {
        0%, 100% { transform: translateY(0px); }
        50% { transform: translateY(-15px); }
    }

    .book-1 { top: 60px; left: 30px; animation-delay: 0s; }
    .book-2 { top: 200px; right: 40px; animation-delay: 0.5s; }
    .book-3 { bottom: 250px; left: 30px; animation-delay: 1s; }
    .book-4 { bottom: 130px; right: 40px; animation-delay: 1.5s; }

    .form-container {
        width: 100%;
        max-width: 700px;
        margin: 0 auto 30px;
        background: white;
        padding: 30px 40px;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
    }

    .form-group {
        display: flex;
        align-items: center;
        margin-bottom: 18px;
        gap: 15px;
    }

    .form-group label {
        font-weight: 700;
        color: #1e293b;
        font-size: 0.95em;
        min-width: 100px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    input {
        flex: 1;
        padding: 12px 15px;
        border-radius: 15px;
        border: 2px solid #cbd5e1;
        background: #f8fafc;
        color: #1e293b;
        font-size: 0.95em;
        transition: all 0.3s ease;
    }

    input:focus {
        outline: none;
        border-color: #0891b2;
        background: white;
        box-shadow: 0 0 10px rgba(8, 145, 178, 0.2);
    }

    input::placeholder {
        color: #94a3b8;
    }

    .button-group {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 25px;
        flex-wrap: wrap;
    }

    button {
        padding: 12px 30px;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        font-size: 0.95em;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
    }

    .add {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
    }

    .add:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
    }

    .update {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
    }

    .update:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
    }

    .delete {
        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: white;
    }

    .delete:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(239, 68, 68, 0.3);
    }

    .clear {
        background: linear-gradient(135deg, #fbbf24, #f59e0b);
        color: white;
    }

    .clear:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(251, 191, 36, 0.3);
    }

    button:active {
        transform: translateY(0);
    }

    .search-section {
        width: 100%;
        max-width: 700px;
        margin: 40px auto;
        text-align: center;
    }

    .search-label {
        font-weight: 700;
        color: #133C55;
        display: inline-block;
        margin-right: 15px;
        margin: 10px auto;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .search-container {
        display: flex;
        gap: 12px;
        justify-content: center;
        align-items: center;
    }

    .search-container input {
        width: 300px;
        padding: 12px 15px;
        border-radius: 15px;
        border: 2px solid #cbd5e1;
        background: white;
        color: #1e293b;
        font-size: 0.95em;
    }

    .search-container input:focus {
        outline: none;
        border-color: #0891b2;
        box-shadow: 0 0 10px rgba(8, 145, 178, 0.2);
    }

    .search-container button {
        background: #386FA4;
        color: white;
        padding: 12px 28px;
        margin: 0;
    }

    .search-container button:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(168, 85, 247, 0.3);
    }

    table {
        width: 100%;
        max-width: 900px;
        margin: 30px auto;
        border-collapse: collapse;
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
    }

    th {
        background: #84D2F6;
        color: black;
        padding: 16px;
        text-align: left;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 1px solid #0c3d66;
        border-right: 1px solid #0c3d66;
    }

    td {
        padding: 14px 16px;
        border-bottom: 1px solid #0c3d66;
        border-right: 1px solid #0c3d66;
        color: #1e293b;
    }

    tbody tr {
        transition: all 0.3s ease;
    }

    tbody tr:hover {
        background: #f0f9ff;
        cursor: pointer;
        transform: scale(1.01);
    }

    tr:last-child td {
        border-bottom: none;
    }

    .no-data {
        color: #64748b;
        font-style: italic;
        text-align: center;
    }

    .status-available { color: #059669; font-weight: bold; }
    .status-borrowed { color: #dc2626; font-weight: bold; }
    
    /* Error Message Style */
        .error-msg { background: #fee2e2; color: #b91c1c; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 5px solid #b91c1c; }
    
    
</style>
</head>

<body>
    
 <jsp:include page="header.jsp" />

<div class="books-decoration book-1">📕</div>
<div class="books-decoration book-2">📗</div>
<div class="books-decoration book-3">📘</div>
<div class="books-decoration book-4">📙</div>

<h1>CRUD PAGE</h1>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error-msg">
            <strong>Warning:</strong> <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <div class="form-container">
        <form action="BookServlet" method="post" id="bookForm">
            <input type="hidden" name="id" id="bookId">

            <div class="form-group">
                <label>Title:</label>
                <input type="text" name="title" id="title" placeholder="Enter book title" required minlength="2">
            </div>

            <div class="form-group">
                <label>Author:</label>
                <input type="text" name="author" id="author" placeholder="Enter author name" required>
            </div>

            <div class="form-group">
                <label>Price (RM):</label>
                <input type="number" step="0.01" name="price" id="price" placeholder="0.00" required min="0.01">
            </div>

            <div class="button-group">
                <button type="submit" class="add" name="action" value="insert" 
            onclick="return confirm('Are you sure you want to ADD this new book?')">
        ADD
    </button>

    <button type="submit" class="update" name="action" value="update" 
            onclick="return confirm('Are you sure you want to UPDATE this book details?')">
        UPDATE
    </button>

    <button type="submit" class="delete" name="action" value="delete" 
            onclick="return confirm('Are you sure you want to DELETE this book? This action cannot be undone.')">
        DELETE
    </button>

    <button type="reset" class="clear" onclick="clearForm()">CLEAR</button>
</div>
        </form>
    </div>

    <% List<Book> list = (List<Book>) request.getAttribute("list"); %>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Author</th>
                <th>Price</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <% if (list != null && !list.isEmpty()) {
                for (Book b : list) { %>
            <tr onclick="fillForm('<%=b.getId()%>', '<%=b.getTitle().replace("'", "\\'")%>', '<%=b.getAuthor().replace("'", "\\'")%>', '<%=b.getPrice()%>')">
                <td><%= b.getId() %></td>
                <td><%= b.getTitle() %></td>
                <td><%= b.getAuthor() %></td>
                <td>RM <%= String.format("%.2f", b.getPrice()) %></td>
                <td class="<%= b.getStatus().equalsIgnoreCase("Available") ? "status-available" : "status-borrowed" %>">
                    <%= b.getStatus() %>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="5" style="text-align:center; padding:20px;">No books found.</td></tr>
            <% } %>
        </tbody>
    </table>

  

    <script>
        function fillForm(id, title, author, price) {
            document.getElementById("bookId").value = id;
            document.getElementById("title").value = title;
            document.getElementById("author").value = author;
            document.getElementById("price").value = price;
        }

        function clearForm() {
            document.getElementById("bookId").value = "";
        }
    </script>
</body>
</html>