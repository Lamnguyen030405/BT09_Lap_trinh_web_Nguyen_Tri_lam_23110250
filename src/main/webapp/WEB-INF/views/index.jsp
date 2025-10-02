<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GraphQL Lab - Product Management</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .tabs {
            display: flex;
            background: #f5f5f5;
            border-bottom: 2px solid #ddd;
        }
        
        .tab {
            flex: 1;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            background: #f5f5f5;
            border: none;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        .tab:hover {
            background: #e0e0e0;
        }
        
        .tab.active {
            background: white;
            border-bottom: 3px solid #667eea;
            font-weight: bold;
            color: #667eea;
        }
        
        .content {
            padding: 30px;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
            animation: fadeIn 0.5s;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        input, textarea, select {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border 0.3s;
        }
        
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: transform 0.2s;
            margin-right: 10px;
        }
        
        .btn:hover {
            transform: scale(1.05);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background: #667eea;
            color: white;
            font-weight: bold;
        }
        
        tr:hover {
            background: #f5f5f5;
        }
        
        .btn-edit, .btn-delete {
            padding: 5px 15px;
            border-radius: 3px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            margin-right: 5px;
        }
        
        .btn-edit {
            background: #4CAF50;
            color: white;
        }
        
        .btn-delete {
            background: #f44336;
            color: white;
        }
        
        .loading {
            text-align: center;
            padding: 20px;
            color: #667eea;
            font-size: 18px;
        }
        
        .error {
            background: #f44336;
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
        }
        
        .success {
            background: #4CAF50;
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🚀 GraphQL Product Management</h1>
            <p>Quản lý sản phẩm với GraphQL + Spring Boot 3</p>
        </header>
        
        <div class="tabs">
            <button class="tab active" onclick="showTab('products')">📦 Sản phẩm</button>
            <button class="tab" onclick="showTab('categories')">📂 Danh mục</button>
            <button class="tab" onclick="showTab('users')">👥 Người dùng</button>
        </div>
        
        <div class="content">
            <!-- PRODUCTS TAB -->
            <div id="products" class="tab-content active">
                <h2>Quản lý Sản phẩm</h2>
                
                <div class="form-group">
                    <button class="btn" onclick="loadProducts()">Tất cả sản phẩm</button>
                    <button class="btn btn-secondary" onclick="loadProductsSorted()">Sắp xếp theo giá</button>
                </div>
                
                <div class="form-group">
                    <label>Lọc theo danh mục:</label>
                    <select id="categoryFilter" onchange="filterByCategory()">
                        <option value="">-- Chọn danh mục --</option>
                    </select>
                </div>
                
                <div id="productsList"></div>
                
                <h3 style="margin-top: 30px;">Thêm sản phẩm mới</h3>
                <form id="productForm" onsubmit="createProduct(event)">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Tên sản phẩm: *</label>
                            <input type="text" id="productname" required>
                        </div>
                        <div class="form-group">
                            <label>Số lượng: *</label>
                            <input type="number" id="quantity" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Giá: *</label>
                            <input type="number" step="0.01" id="unitprice" required>
                        </div>
                        <div class="form-group">
                            <label>Giảm giá (%):</label>
                            <input type="number" step="0.01" id="discount" value="0">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Mô tả: *</label>
                        <textarea id="description" rows="3" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Hình ảnh URL:</label>
                            <input type="text" id="images">
                        </div>
                        <div class="form-group">
                            <label>Danh mục:</label>
                            <select id="cateid">
                                <option value="">-- Chọn danh mục --</option>
                            </select>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-success">Thêm sản phẩm</button>
                </form>
            </div>
            
            <!-- CATEGORIES TAB -->
            <div id="categories" class="tab-content">
                <h2>Quản lý Danh mục</h2>
                
                <button class="btn" onclick="loadCategories()">Tải danh sách</button>
                
                <div id="categoriesList"></div>
                
                <h3 style="margin-top: 30px;">Thêm danh mục mới</h3>
                <form id="categoryForm" onsubmit="createCategory(event)">
                    <div class="form-group">
                        <label>Tên danh mục: *</label>
                        <input type="text" id="catename" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Icon URL:</label>
                        <input type="text" id="icon">
                    </div>
                    
                    <div class="form-group">
                        <label>User ID:</label>
                        <input type="number" id="userid">
                    </div>
                    
                    <button type="submit" class="btn btn-success">Thêm danh mục</button>
                </form>
            </div>
            
            <!-- USERS TAB -->
            <div id="users" class="tab-content">
                <h2>Quản lý Người dùng</h2>
                
                <button class="btn" onclick="loadUsers()">Tải danh sách</button>
                
                <div id="usersList"></div>
                
                <h3 style="margin-top: 30px;">Thêm người dùng mới</h3>
                <form id="userForm" onsubmit="createUser(event)">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Username: *</label>
                            <input type="text" id="username" required>
                        </div>
                        <div class="form-group">
                            <label>Password: *</label>
                            <input type="password" id="password" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Họ tên:</label>
                            <input type="text" id="fullname">
                        </div>
                        <div class="form-group">
                            <label>Email:</label>
                            <input type="email" id="email">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Số điện thoại:</label>
                            <input type="text" id="phone">
                        </div>
                        <div class="form-group">
                            <label>Role ID:</label>
                            <input type="number" id="roleid" value="2">
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-success">Thêm người dùng</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        const GRAPHQL_URL = 'http://localhost:8092/graphql';
        
        // Tab switching
        function showTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(tc => tc.classList.remove('active'));
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            
            document.getElementById(tabName).classList.add('active');
            event.target.classList.add('active');
            
            if (tabName === 'products') {
                loadProducts();
                loadCategoriesForSelect();
            } else if (tabName === 'categories') {
                loadCategories();
            } else if (tabName === 'users') {
                loadUsers();
            }
        }
        
        // GraphQL Query Helper
        async function graphqlQuery(query, variables = {}) {
            try {
                const response = await fetch(GRAPHQL_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ query, variables })
                });
                
                const result = await response.json();
                if (result.errors) {
                    throw new Error(result.errors[0].message);
                }
                return result.data;
            } catch (error) {
                console.error('GraphQL Error:', error);
                showMessage('error', 'Lỗi: ' + error.message);
                throw error;
            }
        }
        
        // ========== PRODUCT FUNCTIONS ==========
        async function loadProducts() {
            document.getElementById('productsList').innerHTML = '<div class="loading">Đang tải...</div>';
            
            const query = `
                query {
                    getAllProducts {
                        productid
                        productname
                        quantity
                        unitprice
                        discount
                        description
                        images
                        status
                        category {
                            cateid
                            catename
                        }
                    }
                }
            `;
            
            try {
                const data = await graphqlQuery(query);
                displayProducts(data.getAllProducts);
            } catch (error) {
                document.getElementById('productsList').innerHTML = '<div class="error">Không thể tải dữ liệu</div>';
            }
        }
        
        async function loadProductsSorted() {
            document.getElementById('productsList').innerHTML = '<div class="loading">Đang tải...</div>';
            
            const query = `
                query {
                    getProductsSortedByPrice {
                        productid
                        productname
                        quantity
                        unitprice
                        discount
                        description
                        category {
                            catename
                        }
                    }
                }
            `;
            
            try {
                const data = await graphqlQuery(query);
                displayProducts(data.getProductsSortedByPrice);
            } catch (error) {
                document.getElementById('productsList').innerHTML = '<div class="error">Không thể tải dữ liệu</div>';
            }
        }
        
        async function filterByCategory() {
            const cateid = document.getElementById('categoryFilter').value;
            if (!cateid) {
                loadProducts();
                return;
            }
            
            document.getElementById('productsList').innerHTML = '<div class="loading">Đang tải...</div>';
            
            const query = `
                query($cateid: Int!) {
                    getProductsByCategory(cateid: $cateid) {
                        productid
                        productname
                        quantity
                        unitprice
                        discount
                        description
                        category {
                            catename
                        }
                    }
                }
            `;
            
            try {
                const data = await graphqlQuery(query, { cateid: parseInt(cateid) });
                displayProducts(data.getProductsByCategory);
            } catch (error) {
                document.getElementById('productsList').innerHTML = '<div class="error">Không thể tải dữ liệu</div>';
            }
        }
        
        function displayProducts(products) {
            if (!products || products.length === 0) {
                document.getElementById('productsList').innerHTML = '<p>Không có sản phẩm nào</p>';
                return;
            }
            
            let html = '<table><thead><tr>';
            html += '<th>ID</th><th>Tên</th><th>Số lượng</th><th>Giá</th><th>Giảm giá</th><th>Danh mục</th><th>Hành động</th>';
            html += '</tr></thead><tbody>';
            
            products.forEach(p => {
                html += `<tr>
                    <td>${p.productid}</td>
                    <td>${p.productname}</td>
                    <td>${p.quantity}</td>
                    <td>${p.unitprice.toLocaleString()} VNĐ</td>
                    <td>${p.discount || 0}%</td>
                    <td>${p.category ? p.category.catename : 'N/A'}</td>
                    <td>
                        <button class="btn-edit" onclick="editProduct(${p.productid})">Sửa</button>
                        <button class="btn-delete" onclick="deleteProduct(${p.productid})">Xóa</button>
                    </td>
                </tr>`;
            });
            
            html += '</tbody></table>';
            document.getElementById('productsList').innerHTML = html;
        }
        
        async function createProduct(event) {
            event.preventDefault();
            
            const input = {
                productname: document.getElementById('productname').value,
                quantity: parseInt(document.getElementById('quantity').value),
                unitprice: parseFloat(document.getElementById('unitprice').value),
                discount: parseFloat(document.getElementById('discount').value) || 0,
                description: document.getElementById('description').value,
                images: document.getElementById('images').value || null,
                status: 1,
                cateid: document.getElementById('cateid').value ? parseInt(document.getElementById('cateid').value) : null
            };
            
            const mutation = `
                mutation($input: ProductInput!) {
                    createProduct(input: $input) {
                        productid
                        productname
                    }
                }
            `;
            
            try {
                await graphqlQuery(mutation, { input });
                showMessage('success', 'Thêm sản phẩm thành công!');
                document.getElementById('productForm').reset();
                loadProducts();
            } catch (error) {
                showMessage('error', 'Không thể thêm sản phẩm');
            }
        }
        
        async function deleteProduct(id) {
            if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;
            
            const mutation = `
                mutation($id: ID!) {
                    deleteProduct(id: $id)
                }
            `;
            
            try {
                await graphqlQuery(mutation, { id: id.toString() });
                showMessage('success', 'Xóa sản phẩm thành công!');
                loadProducts();
            } catch (error) {
                showMessage('error', 'Không thể xóa sản phẩm');
            }
        }
        
        // ========== CATEGORY FUNCTIONS ==========
        async function loadCategories() {
            document.getElementById('categoriesList').innerHTML = '<div class="loading">Đang tải...</div>';
            
            const query = `
                query {
                    getAllCategories {
                        cateid
                        catename
                        icon
                        userid
                    }
                }
            `;
            
            try {
                const data = await graphqlQuery(query);
                displayCategories(data.getAllCategories);
            } catch (error) {
                document.getElementById('categoriesList').innerHTML = '<div class="error">Không thể tải dữ liệu</div>';
            }
        }
        
        async function loadCategoriesForSelect() {
            const query = `
                query {
                    getAllCategories {
                        cateid
                        catename
                    }
                }
            `;
            
            try {
                const data = await graphqlQuery(query);
                const categories = data.getAllCategories;
                
                const selects = ['categoryFilter', 'cateid'];
                selects.forEach(selectId => {
                    const select = document.getElementById(selectId);
                    select.innerHTML = '<option value="">-- Chọn danh mục --</option>';
                    categories.forEach(cat => {
                        select.innerHTML += `<option value="${cat.cateid}">${cat.catename}</option>`;
                    });
                });
            } catch (error) {
                console.error('Cannot load categories for select');
            }
        }
        
        function displayCategories(categories) {
            if (!categories || categories.length === 0) {
                document.getElementById('categoriesList').innerHTML = '<p>Không có danh mục nào</p>';
                return;
            }
            
            let html = '<table><thead><tr>';
            html += '<th>ID</th><th>Tên</th><th>Icon</th><th>User ID</th><th>Hành động</th>';
            html += '</tr></thead><tbody>';
            
            categories.forEach(c => {
                html += `<tr>
                    <td>${c.cateid}</td>
                    <td>${c.catename}</td>
                    <td>${c.icon || 'N/A'}</td>
                    <td>${c.userid || 'N/A'}</td>
                    <td>
                        <button class="btn-delete" onclick="deleteCategory(${c.cateid})">Xóa</button>
                    </td>
                </tr>`;
            });
            
            html += '</tbody></table>';
            document.getElementById('categoriesList').innerHTML = html;
        }
        
        async function createCategory(event) {
            event.preventDefault();
            
            const input = {
                catename: document.getElementById('catename').value,
                icon: document.getElementById('icon').value || null,
                userid: document.getElementById('userid').value ? parseInt(document.getElementById('userid').value) : null
            };
            
            const mutation = `
                mutation($input: CategoryInput!) {
                    createCategory(input: $input) {
                        cateid
                        catename
                    }
                }
            `;
            
            try {
                await graphqlQuery(mutation, { input });
                showMessage('success', 'Thêm danh mục thành công!');
                document.getElementById('categoryForm').reset();
                loadCategories();
                loadCategoriesForSelect();
            } catch (error) {
                showMessage('error', 'Không thể thêm danh mục');
            }
        }
        
        async function deleteCategory(id) {
            if (!confirm('Bạn có chắc muốn xóa danh mục này?')) return;
            
            const mutation = `
                mutation($id: ID!) {
                    deleteCategory(id: $id)
                }
            `;
            
            try {
                await graphqlQuery(mutation, { id: id.toString() });
                showMessage('success', 'Xóa danh mục thành công!');
                loadCategories();
            } catch (error) {
                showMessage('error', 'Không thể xóa danh mục');
            }
        }
        
        // ========== USER FUNCTIONS ==========
        async function loadUsers() {
            document.getElementById('usersList').innerHTML = '<div class="loading">Đang tải...</div>';
            
            const query = `
                query {
                    getAllUsers {
                        id
                        username
                        fullname
                        email
                        phone
                        roleid
                        status
                    }
                }
            `;
            
            try {
                const data = await graphqlQuery(query);
                displayUsers(data.getAllUsers);
            } catch (error) {
                document.getElementById('usersList').innerHTML = '<div class="error">Không thể tải dữ liệu</div>';
            }
        }
        
        function displayUsers(users) {
            if (!users || users.length === 0) {
                document.getElementById('usersList').innerHTML = '<p>Không có người dùng nào</p>';
                return;
            }
            
            let html = '<table><thead><tr>';
            html += '<th>ID</th><th>Username</th><th>Họ tên</th><th>Email</th><th>Phone</th><th>Role</th><th>Hành động</th>';
            html += '</tr></thead><tbody>';
            
            users.forEach(u => {
                html += `<tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.fullname || 'N/A'}</td>
                    <td>${u.email || 'N/A'}</td>
                    <td>${u.phone || 'N/A'}</td>
                    <td>${u.roleid}</td>
                    <td>
                        <button class="btn-delete" onclick="deleteUser(${u.id})">Xóa</button>
                    </td>
                </tr>`;
            });
            
            html += '</tbody></table>';
            document.getElementById('usersList').innerHTML = html;
        }
        
        async function createUser(event) {
            event.preventDefault();
            
            const input = {
                username: document.getElementById('username').value,
                password: document.getElementById('password').value,
                fullname: document.getElementById('fullname').value || null,
                email: document.getElementById('email').value || null,
                phone: document.getElementById('phone').value || null,
                roleid: parseInt(document.getElementById('roleid').value) || 2,
                status: 1
            };
            
            const mutation = `
                mutation($input: UserInput!) {
                    createUser(input: $input) {
                        id
                        username
                    }
                }
            `;
            
            try {
                await graphqlQuery(mutation, { input });
                showMessage('success', 'Thêm người dùng thành công!');
                document.getElementById('userForm').reset();
                loadUsers();
            } catch (error) {
                showMessage('error', 'Không thể thêm người dùng');
            }
        }
        
        async function deleteUser(id) {
            if (!confirm('Bạn có chắc muốn xóa người dùng này?')) return;
            
            const mutation = `
                mutation($id: ID!) {
                    deleteUser(id: $id)
                }
            `;
            
            try {
                await graphqlQuery(mutation, { id: id.toString() });
                showMessage('success', 'Xóa người dùng thành công!');
                loadUsers();
            } catch (error) {
                showMessage('error', 'Không thể xóa người dùng');
            }
        }
        
        // ========== UTILITY FUNCTIONS ==========
        function showMessage(type, message) {
            const div = document.createElement('div');
            div.className = type;
            div.textContent = message;
            div.style.position = 'fixed';
            div.style.top = '20px';
            div.style.right = '20px';
            div.style.zIndex = '1000';
            div.style.minWidth = '300px';
            
            document.body.appendChild(div);
            
            setTimeout(() => {
                div.remove();
            }, 3000);
        }
        
        // Load initial data
        window.onload = function() {
            loadProducts();
            loadCategoriesForSelect();
        };
    </script>
</body>
</html>