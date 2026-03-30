<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.book.model.Borrow" %>

<!DOCTYPE html>
<html>
<head>
    <title>Return Books - Library System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { 
            background: url('assets/images/libs.png'); 
            background-size: cover;
            background-attachment: fixed;
            min-height: 100vh;
        }
        .main-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 50px;
        }
        h2 { color: #133C55; font-weight: 700; margin-bottom: 25px; text-align: center; }
        .table-container { background: white; border-radius: 15px; overflow: hidden; }
        th { background-color: #f6c23e !important; color: #333; }
        .fine-badge { padding: 5px 12px; border-radius: 20px; font-weight: bold; }
        .fine-none { background: #dcfce7; color: #166534; }
        .fine-late { background: #fee2e2; color: #991b1b; }
        .btn-return {
            background: linear-gradient(135deg, #f6c23e, #f4b400);
            border: none;
            color: black;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-return:hover { transform: scale(1.05); background: #f4b400; }
    </style>
</head>
<body>
    
<jsp:include page="header.jsp" />

<div class="container">
    <div class="main-card shadow">
        <h2>RECORDS OF BOOKS TO BE RETURNED</h2>

        <% if (request.getParameter("message") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ✅ <%= request.getParameter("message") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="table-container shadow-sm">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>Borrow ID</th>
                        <th>User ID</th>
                        <th>Name</th> 
                        <th>Email</th> 
                        <th>Book ID</th>
                        <th>Due Date</th>
                        <th>Fine Amount</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
              <tbody>
    <% 
        List<com.book.model.Borrow> list = (List<com.book.model.Borrow>) request.getAttribute("activeBorrows");
        if (list != null && !list.isEmpty()) {
            for (com.book.model.Borrow b : list) {
                
              
                double fine = b.calculateFine(); 
                // ---------------------
    %>
    <tr>
        <td>#<%= b.getBorrowId() %></td>
        <td class="fw-bold"><%= b.getUserId() %></td>
        <td><%= b.getUserName() != null ? b.getUserName() : "N/A" %></td> 
        <td><%= b.getUserEmail() != null ? b.getUserEmail() : "N/A" %></td> 
        <td><%= b.getBookId() %></td>
        <td><%= b.getDueDate() %></td>
        <td>
            <% if (fine > 0) { %>
                <span class="fine-badge fine-late">RM <%= String.format("%.2f", fine) %></span>
            <% } else { %>
                <span class="fine-badge fine-none">No Fine</span>
            <% } %>
        </td>
        <td class="text-center">
           
            
            
            <form action="ReturnServlet" method="post" onsubmit="return confirmReturn('<%= b.getUserName() %>', <%= fine %>)">
                <input type="hidden" name="borrowId" value="<%= b.getBorrowId() %>">
                <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                <input type="hidden" name="fineAmount" value="<%= fine %>">

                <input type="hidden" name="userId" value="<%= b.getUserId() %>">
                <input type="hidden" name="userName" value="<%= b.getUserName() %>">
                <input type="hidden" name="userEmail" value="<%= b.getUserEmail() %>">
                <input type="hidden" name="bookTitle" value=<%= b.getBookTitle() %>">

                <button type="submit" class="btn btn-return btn-sm shadow-sm">
                    🔄 Process Return
                </button>
            </form>
        </td>
    </tr>
    <% 
            }
        } else { 
    %>
    <tr>
        <td colspan="8" class="text-center py-4 text-muted">No active borrowings found.</td>
    </tr>
    <% } %>
</tbody>
            </table>
        </div>
        </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function confirmReturn(name, fine) {
        let msg = "Confirm return for: " + (name !== "null" ? name : "this record") + "?";
        if (fine > 0) {
            msg += "\n\n⚠️ NOTE: Fine of RM " + fine.toFixed(2) + " must be collected!";
        }
        return confirm(msg);
    }
</script>

</body>
</html>