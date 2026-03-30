<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Official Receipt - Library System</title>
    <style>
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: url('assets/images/libs.png'); 
            background-size: cover;
            min-height: 100vh; 
            padding: 40px 20px; 
        }

        .books-decoration { position: absolute; font-size: 3.5em; opacity: 0.8; animation: float 5s ease-in-out infinite; z-index: 1; }
        @keyframes float { 0%, 100% { transform: translateY(0px); } 50% { transform: translateY(-15px); } }
        .book-1 { top: 60px; left: 30px; }
        .book-2 { top: 200px; right: 40px; animation-delay: 0.5s; }

        h1 { color: #fff; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); text-align: center; font-size: 2.2em; margin-bottom: 20px; position: relative; z-index: 10; }

        .receipt-container { 
            width: 100%; 
            max-width: 450px; 
            margin: 0 auto; 
            background: #fff; 
            padding: 40px; 
            border-radius: 4px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            position: relative;
            z-index: 10;
            border-top: 10px solid #f6c23e; 
        }

        .receipt-container::after {
            content: "";
            position: absolute;
            bottom: -10px; left: 0; right: 0;
            height: 10px;
            background: linear-gradient(-45deg, transparent 5px, #fff 5px), 
                        linear-gradient(45deg, transparent 5px, #fff 5px);
            background-size: 10px 10px;
        }

        .receipt-header {
            text-align: center;
            border-bottom: 2px dashed #cbd5e1;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }

        .receipt-header h3 { color: #1e293b; letter-spacing: 1px; margin-bottom: 5px; }
        .receipt-header p { font-size: 0.85em; color: #64748b; margin: 2px 0; }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 0.95em;
        }

        .label { font-weight: 700; color: #475569; text-transform: uppercase; font-size: 0.75em; }
        .value { color: #1e293b; text-align: right; font-weight: 500; }

        .fine-section {
            margin-top: 25px;
            padding-top: 15px;
            border-top: 2px dashed #cbd5e1;
        }

        .fine-total {
            font-size: 1.5em;
            font-weight: 800;
            color: #dc2626; 
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-print {
            display: block;
            width: 100%;
            margin-top: 30px;
            padding: 12px;
            background: #133C55;
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-print:hover { background: #1e293b; transform: translateY(-2px); }

        .back-link { text-align: center; margin-top: 30px; }
        .back-link a { text-decoration: none; color: #fff; font-weight: bold; background: rgba(0,0,0,0.3); padding: 8px 15px; border-radius: 20px; }

        @media print {
            .btn-print, .back-link, .books-decoration { display: none; }
            body { background: white; padding: 0; }
            .receipt-container { box-shadow: none; border: 1px solid #eee; margin-top: 50px; }
        }
    </style>
</head>
<body>

<div class="books-decoration book-1">📚</div>
<div class="books-decoration book-2">📖</div>

<h1>TRANSACTION COMPLETE</h1>

<div class="receipt-container">
    <div class="receipt-header">
        <h3>OFFICIAL RECEIPT</h3>
        <p><strong>LMS Connect</strong></p>
        <p>Date: <%= new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm").format(new java.util.Date()) %></p>
    </div>

    <div class="receipt-row">
        <span class="label">Borrow ID:</span>
        <span class="value">#<%= request.getAttribute("r_borrowId") %></span>
    </div>

    <div class="receipt-row">
        <span class="label">User ID:</span>
        <span class="value"><%= request.getAttribute("r_userId") %></span>
    </div>

    <div class="receipt-row">
        <span class="label">Name:</span>
        <span class="value"><%= request.getAttribute("r_userName") %></span>
    </div>

    <div class="receipt-row">
        <span class="label">Email:</span>
        <span class="value"><%= request.getAttribute("r_userEmail") %></span>
    </div>

    <div class="receipt-row">
        <span class="label">Book Title:</span>
        <span class="value"><%= request.getAttribute("r_title") %></span>
    </div>

    <div class="fine-section">
        <div class="fine-total">
            <span class="label" style="font-size: 0.5em; color: #dc2626;">Total Late Fine</span>
            <span class="value">RM <%= request.getAttribute("r_fine") %></span>
        </div>
    </div>

    <p style="text-align: center; font-size: 0.8em; color: #64748b; margin-top: 20px;">
        * Please keep this receipt for your records.
    </p>

    <button class="btn-print" onclick="window.print()">Print Receipt</button>
</div>

<div class="back-link">
    <a href="ReturnServlet">⬅ Back to Records</a>
</div>

</body>
</html>