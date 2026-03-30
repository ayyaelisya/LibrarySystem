<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.book.model.Book" %>
<%@ page import="com.book.model.Borrow" %>

<html>
<head>
    
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"><!-- comment -->
    <title>Borrowing Counter - Library System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: url('assets/images/libs.png'); min-height: 100vh; padding: 40px 20px; }
        h1 { color: #133C55; text-align: center; font-size: 2.5em; margin-bottom: 30px; position: relative; z-index: 10; }
        
        .books-decoration { position: absolute; font-size: 3.5em; opacity: 0.8; animation: float 5s ease-in-out infinite; }
        @keyframes float { 0%, 100% { transform: translateY(0px); } 50% { transform: translateY(-15px); } }
        .book-1 { top: 60px; left: 30px; animation-delay: 0s; }
        .book-2 { top: 200px; right: 40px; animation-delay: 0.5s; }

        .form-container { width: 100%; max-width: 700px; margin: 0 auto 30px; background: white; padding: 30px 40px; border-radius: 20px; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1); }
        .form-group { display: flex; align-items: center; margin-bottom: 18px; gap: 15px; }
        .form-group label { font-weight: 700; color: #1e293b; font-size: 0.95em; min-width: 130px; text-transform: uppercase; letter-spacing: 0.5px; }
        
        input, select { flex: 1; padding: 12px 15px; border-radius: 15px; border: 2px solid #cbd5e1; background: #f8fafc; color: #1e293b; font-size: 0.95em; transition: all 0.3s ease; }
        input:focus, select:focus { outline: none; border-color: #0891b2; background: white; box-shadow: 0 0 10px rgba(8, 145, 178, 0.2); }

        .button-group { display: flex; gap: 15px; justify-content: center; margin-top: 25px; }
        button { padding: 12px 30px; border: none; border-radius: 25px; cursor: pointer; font-size: 0.95em; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; transition: all 0.3s ease; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15); }
        .add { background: linear-gradient(135deg, #10b981, #059669); color: white; }
        .add:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3); }

        table { width: 100%; max-width: 1100px; margin: 30px auto; border-collapse: collapse; background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1); }
        th { background: #84D2F6; color: black; padding: 16px; text-align: left; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid #0c3d66; border-right: 1px solid #0c3d66; }
        td { padding: 14px 16px; border-bottom: 1px solid #0c3d66; border-right: 1px solid #0c3d66; color: #1e293b; }
        
        .status-active { color: #dc2626; font-weight: bold; background: #fee2e2; padding: 4px 10px; border-radius: 10px; font-size: 0.85em; }
        .no-data { color: #64748b; font-style: italic; text-align: center; }
    </style>
</head>
<body>
    
<jsp:include page="header.jsp" />

<div class="books-decoration book-1">📚</div>
<div class="books-decoration book-2">📖</div>

<h1 style="text-align: center; margin-bottom: 20px;">BORROW MANAGEMENT</h1>

<% if (request.getAttribute("error") != null) { %>
    <div class="error-box">⚠️ <%= request.getAttribute("error") %></div>
<% } %>

<div class="form-container">
    <form action="BorrowServlet" method="post" onsubmit="return validateForm()">
        <div class="form-group">
            <label>User ID:</label>
            <input type="text" name="userId" id="userId" placeholder="Enter Borrower ID" required>
        </div>
<div class="form-group">
    <label>Name:</label>
    <input type="text" name="userName" placeholder="Enter Full Name" required>
</div>

<div class="form-group">
    <label>Email:</label>
    <input type="email" name="userEmail" placeholder="Enter Email Address" required>
</div>
        
        <div class="form-group">
            <label>Select Book:</label>
            <select name="bookId" id="bookId" required>
                <option value="">-- Choose Available Book --</option>
                <% 
                    List<Book> available = (List<Book>) request.getAttribute("availableBooks");
                    if (available != null) {
                        for (Book b : available) {
                %>
                    <option value="<%= b.getId() %>"><%= b.getTitle() %> (ID: <%= b.getId() %>)</option>
                <%      }
                    } 
                %>
            </select>
        </div>

        <div class="form-group">
            <label>Due Date:</label>
            <input type="date" name="dueDate" id="dueDate" required>
        </div>

        <div class="button-group" style="text-align: center;">
            <button type="submit" class="add">Confirm Borrowing</button>
            <button type="reset" style="background: #94a3b8;">Clear</button>
        </div>
    </form>
</div>

<h2 style="text-align: center; margin-top: 30px;">Active Borrowing Records</h2>
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Book Title</th>
            <th>Borrower ID</th>
            <th>Name</th> <th>Email</th> <th>Date</th>
            <th>Due Date</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <% 
            List<Borrow> activeList = (List<Borrow>) request.getAttribute("activeBorrows");
            if (activeList != null && !activeList.isEmpty()) {
                for (Borrow br : activeList) {
        %>
        <tr>
            <td><%= br.getBorrowId() %></td>
            <td><%= br.getBookTitle() %></td>
            <td><%= br.getUserId() %></td>
            <td><%= br.getUserName() %></td> <td><%= br.getUserEmail() %></td> <td><%= br.getBorrowDate() %></td>
            <td><%= br.getDueDate() %></td>
            <td><span style="color:red; font-weight:bold;"><%= br.getStatus() %></span></td>
        </tr>
        <%      } 
            } else { %>
        <tr><td colspan="8" style="text-align:center;">No active records.</td></tr> <% } %>
    </tbody>
</table>

     
<script>
    // 3. Set minimum date kepada hari ini (Admin tak boleh pilih tarikh semalam)
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('dueDate').setAttribute('min', today);

    // 4. Confirmation Function
    function validateForm() {
        const userId = document.getElementById('userId').value;
        const bookSelect = document.getElementById('bookId');
        const bookTitle = bookSelect.options[bookSelect.selectedIndex].text;

        if (confirm("Confirm loan for User: " + userId + "\nBook: " + bookTitle + "?")) {
            return true;
        }
        return false;
    }
</script>

</body>
</html>