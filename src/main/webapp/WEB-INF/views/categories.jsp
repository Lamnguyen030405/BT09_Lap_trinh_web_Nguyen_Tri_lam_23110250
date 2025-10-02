<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Categories Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/">GraphQL Demo</a>
            <div class="navbar-nav">
                <a class="nav-link" href="/products">Products</a>
                <a class="nav-link active" href="/categories">Categories</a>
                <a class="nav-link" href="/users">Users</a>
                <a class="nav-link" href="/graphiql">GraphiQL</a>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <h2>Category Management</h2>
        
        <!-- Add Category Form -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Add New Category</h5>
            </div>
            <div class="card-body">
                <form id="addCategoryForm">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Name</label>
                                <input type="text" class="form-control" id="categoryName" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Image URL</label>
                                <input type="text" class="form-control" id="categoryImages">
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Add Category</button>
                </form>
            </div>
        </div>
        
        <!-- Categories Table -->
        <div class="card">
            <div class="card-header">
                <h5>Categories List</h5>
            </div>
            <div class="card-body">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Image</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="categoriesTableBody">
                        <!-- Categories will be loaded here -->
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
                    <h5 class="modal-title">Edit Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editCategoryForm">
                        <input type="hidden" id="editCategoryId">
                        <div class="mb-3">
                            <label class="form-label">Name</label>
                            <input type="text" class="form-control" id="editCategoryName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Image URL</label>
                            <input type="text" class="form-control" id="editCategoryImages">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="updateCategory()">Save changes</button>
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
        
        // Load all categories
        function loadCategories() {
            const query = `
                query {
                    getAllCategories {
                        id
                        name
                        images
                    }
                }
            `;
            
            graphqlQuery(query).done(function(response) {
                displayCategories(response.data.getAllCategories);
            }).fail(function(error) {
                console.error('Error loading categories:', error);
                alert('Failed to load categories');
            });
        }
        
        // Display categories in table
        function displayCategories(categories) {
            const tbody = $('#categoriesTableBody');
            tbody.empty();
            
            categories.forEach(category => {
                const imagePreview = category.images ? 
                    `<img src="${category.images}" style="max-width: 50px; max-height: 50px;">` : 
                    'No image';
                    
                const row = `
                    <tr>
                        <td>${category.id}</td>
                        <td>${category.name}</td>
                        <td>${imagePreview}</td>
                        <td>
                            <button class="btn btn-sm btn-warning" onclick="editCategory(${category.id})">Edit</button>
                            <button class="btn btn-sm btn-danger" onclick="deleteCategory(${category.id})">Delete</button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }
        
        // Add category
        $('#addCategoryForm').submit(function(e) {
            e.preventDefault();
            
            const mutation = `
                mutation($input: CategoryInput!) {
                    createCategory(input: $input) {
                        id
                        name
                        images
                    }
                }
            `;
            
            const input = {
                name: $('#categoryName').val(),
                images: $('#categoryImages').val()
            };
            
            graphqlQuery(mutation, { input }).done(function(response) {
                alert('Category added successfully!');
                $('#addCategoryForm')[0].reset();
                loadCategories();
            }).fail(function(error) {
                console.error('Error adding category:', error);
                alert('Failed to add category');
            });
        });
        
        // Edit category - show modal
        function editCategory(id) {
            const query = `
                query($id: ID!) {
                    getCategoryById(id: $id) {
                        id
                        name
                        images
                    }
                }
            `;
            
            graphqlQuery(query, { id: id.toString() }).done(function(response) {
                const category = response.data.getCategoryById;
                $('#editCategoryId').val(category.id);
                $('#editCategoryName').val(category.name);
                $('#editCategoryImages').val(category.images || '');
                
                $('#editModal').modal('show');
            });
        }
        
        // Update category
        function updateCategory() {
            const mutation = `
                mutation($id: ID!, $input: CategoryInput!) {
                    updateCategory(id: $id, input: $input) {
                        id
                        name
                        images
                    }
                }
            `;
            
            const input = {
                name: $('#editCategoryName').val(),
                images: $('#editCategoryImages').val()
            };
            
            const id = $('#editCategoryId').val();
            
            graphqlQuery(mutation, { id, input }).done(function(response) {
                alert('Category updated successfully!');
                $('#editModal').modal('hide');
                loadCategories();
            }).fail(function(error) {
                console.error('Error updating category:', error);
                alert('Failed to update category');
            });
        }
        
        // Delete category
        function deleteCategory(id) {
            if (!confirm('Are you sure you want to delete this category?')) {
                return;
            }
            
            const mutation = `
                mutation($id: ID!) {
                    deleteCategory(id: $id)
                }
            `;
            
            graphqlQuery(mutation, { id: id.toString() }).done(function(response) {
                if (response.data.deleteCategory) {
                    alert('Category deleted successfully!');
                    loadCategories();
                } else {
                    alert('Failed to delete category');
                }
            }).fail(function(error) {
                console.error('Error deleting category:', error);
                alert('Failed to delete category');
            });
        }
        
        // Initialize on page load
        $(document).ready(function() {
            loadCategories();
        });
    </script>
</body>
</html>