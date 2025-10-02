<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Users Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/">GraphQL Demo</a>
            <div class="navbar-nav">
                <a class="nav-link" href="/products">Products</a>
                <a class="nav-link" href="/categories">Categories</a>
                <a class="nav-link active" href="/users">Users</a>
                <a class="nav-link" href="/graphiql">GraphiQL</a>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <h2>User Management</h2>
        
        <!-- Add User Form -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Add New User</h5>
            </div>
            <div class="card-body">
                <form id="addUserForm">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="userFullname" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" id="userEmail" required>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" class="form-control" id="userPassword" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Phone</label>
                                <input type="text" class="form-control" id="userPhone">
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Categories</label>
                        <select multiple class="form-select" id="userCategories" size="5">
                            <!-- Categories will be loaded here -->
                        </select>
                        <small class="form-text text-muted">Hold Ctrl (Cmd on Mac) to select multiple categories</small>
                    </div>
                    <button type="submit" class="btn btn-primary">Add User</button>
                </form>
            </div>
        </div>
        
        <!-- Users Table -->
        <div class="card">
            <div class="card-header">
                <h5>Users List</h5>
            </div>
            <div class="card-body">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Categories</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="usersTableBody">
                        <!-- Users will be loaded here -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editUserForm">
                        <input type="hidden" id="editUserId">
                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="editUserFullname" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" id="editUserEmail" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password (leave empty to keep current)</label>
                            <input type="password" class="form-control" id="editUserPassword">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="text" class="form-control" id="editUserPhone">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Categories</label>
                            <select multiple class="form-select" id="editUserCategories" size="5">
                                <!-- Categories will be loaded here -->
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="updateUser()">Save changes</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const GRAPHQL_URL = '/graphql';
        
        function graphqlQuery(query, variables = {}) {
            return $.ajax({
                url: GRAPHQL_URL,
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ query, variables })
            });
        }
        
        // Load all users
        function loadUsers() {
            const query = `
                query {
                    getAllUsers {
                        id
                        fullname
                        email
                        phone
                        categories {
                            id
                            name
                        }
                    }
                }
            `;
            
            graphqlQuery(query).done(function(response) {
                displayUsers(response.data.getAllUsers);
            }).fail(function(error) {
                console.error('Error loading users:', error);
                alert('Failed to load users');
            });
        }
        
        // Display users in table
        function displayUsers(users) {
            const tbody = $('#usersTableBody');
            tbody.empty();
            
            users.forEach(user => {
                const categories = user.categories.map(c => c.name).join(', ') || 'None';
                
                const row = `
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.fullname}</td>
                        <td>${user.email}</td>
                        <td>${user.phone || 'N/A'}</td>
                        <td>${categories}</td>
                        <td>
                            <button class="btn btn-sm btn-warning" onclick="editUser(${user.id})">Edit</button>
                            <button class="btn btn-sm btn-danger" onclick="deleteUser(${user.id})">Delete</button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }
        
        // Load categories for dropdowns
        function loadCategories() {
            const query = `
                query {
                    getAllCategories {
                        id
                        name
                    }
                }
            `;
            
            graphqlQuery(query).done(function(response) {
                const categories = response.data.getAllCategories;
                const select1 = $('#userCategories');
                const select2 = $('#editUserCategories');
                
                select1.empty();
                select2.empty();
                
                categories.forEach(cat => {
                    select1.append(`<option value="${cat.id}">${cat.name}</option>`);
                    select2.append(`<option value="${cat.id}">${cat.name}</option>`);
                });
            });
        }
        
        // Add user
        $('#addUserForm').submit(function(e) {
            e.preventDefault();
            
            const mutation = `
                mutation($input: UserInput!) {
                    createUser(input: $input) {
                        id
                        fullname
                        email
                    }
                }
            `;
            
            const selectedCategories = $('#userCategories').val() || [];
            
            const input = {
                fullname: $('#userFullname').val(),
                email: $('#userEmail').val(),
                password: $('#userPassword').val(),
                phone: $('#userPhone').val(),
                categoryIds: selectedCategories
            };
            
            graphqlQuery(mutation, { input }).done(function(response) {
                alert('User added successfully!');
                $('#addUserForm')[0].reset();
                loadUsers();
            }).fail(function(error) {
                console.error('Error adding user:', error);
                alert('Failed to add user: ' + (error.responseJSON?.errors?.[0]?.message || 'Unknown error'));
            });
        });
        
        // Edit user - show modal
        function editUser(id) {
            const query = `
                query($id: ID!) {
                    getUserById(id: $id) {
                        id
                        fullname
                        email
                        phone
                        categories {
                            id
                        }
                    }
                }
            `;
            
            graphqlQuery(query, { id: id.toString() }).done(function(response) {
                const user = response.data.getUserById;
                $('#editUserId').val(user.id);
                $('#editUserFullname').val(user.fullname);
                $('#editUserEmail').val(user.email);
                $('#editUserPhone').val(user.phone || '');
                $('#editUserPassword').val('');
                
                // Select user's categories
                const categoryIds = user.categories.map(c => c.id.toString());
                $('#editUserCategories option').each(function() {
                    $(this).prop('selected', categoryIds.includes($(this).val()));
                });
                
                $('#editModal').modal('show');
            });
        }
        
        // Update user
        function updateUser() {
            const mutation = `
                mutation($id: ID!, $input: UserInput!) {
                    updateUser(id: $id, input: $input) {
                        id
                        fullname
                    }
                }
            `;
            
            const selectedCategories = $('#editUserCategories').val() || [];
            const password = $('#editUserPassword').val();
            
            const input = {
                fullname: $('#editUserFullname').val(),
                email: $('#editUserEmail').val(),
                password: password || 'dummy', // GraphQL requires password, but service ignores empty ones
                phone: $('#editUserPhone').val(),
                categoryIds: selectedCategories
            };
            
            const id = $('#editUserId').val();
            
            graphqlQuery(mutation, { id, input }).done(function(response) {
                alert('User updated successfully!');
                $('#editModal').modal('hide');
                loadUsers();
            }).fail(function(error) {
                console.error('Error updating user:', error);
                alert('Failed to update user');
            });
        }
        
        // Delete user
        function deleteUser(id) {
            if (!confirm('Are you sure you want to delete this user?')) {
                return;
            }
            
            const mutation = `
                mutation($id: ID!) {
                    deleteUser(id: $id)
                }
            `;
            
            graphqlQuery(mutation, { id: id.toString() }).done(function(response) {
                if (response.data.deleteUser) {
                    alert('User deleted successfully!');
                    loadUsers();
                } else {
                    alert('Failed to delete user');
                }
            }).fail(function(error) {
                console.error('Error deleting user:', error);
                alert('Failed to delete user');
            });
        }
        
        // Initialize on page load
        $(document).ready(function() {
            loadUsers();
            loadCategories();
        });
    </script>
</body>
</html>