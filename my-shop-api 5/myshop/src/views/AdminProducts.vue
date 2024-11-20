<template>
  <Admin />
  <div class="product-table">
  <h1>Manage Products</h1>
  <button
       v-if="!showAddProductForm"
       @click="showAddProductForm = true"
       class="add-new"
  >
       Add New
  </button>
  <div v-if="showAddProductForm" class="product-form">
  <h2>Add a New Product</h2>
  <form @submit.prevent="addProduct">
  <div>
  <label for="name">Name:</label>
  <input type="text" v-model="newProduct.name" required />
  </div>
  <div>
  <label for="description">Description:</label>
  <textarea v-model="newProduct.description" required></textarea>
  </div>
  <div>
  <label for="price">Price:</label>
  <input
             type="number"
             v-model.number="newProduct.price"
             @change="validatePrice"
             required
           />
  </div>
  <div>
  <label for="image">Image:</label>
  <input type="file" @change="handleFileChange" accept="image/*" />
  </div>
  <button type="submit" :disabled="newProduct.price < 0">
           Save Product
  </button>
  <button type="button" @click="cancelAddProduct">Cancel</button>
  </form>
  </div>
  <div v-if="editedProduct" class="product-form">
  <form @submit.prevent="updateProduct">
  <div>
  <label for="name">Product Name:</label>
  <input type="text" v-model="editedProduct.name" required />
  </div>
  <div>
  <label for="description">Description:</label>
  <textarea v-model="editedProduct.description" required></textarea>
  </div>
  <div>
  <label for="price">Price:</label>
  <input
             type="number"
             v-model.number="editedProduct.price"
             @change="validateEditedPrice"
             required
           />
  </div>
  <div>
  <label for="image">Change Image (Optional):</label>
  <input type="file" @change="handleFileChange" accept="image/*" />
  </div>
  <button type="submit" :disabled="editedProduct.price < 0">
           Save Changes
  </button>
  <button @click="cancelEdit">Cancel</button>
  </form>
  </div>
  <table>
  <thead>
  <tr>
  <th>Product</th>
  <th>Description</th>
  <th>ID</th>
  <th>Price</th>
  <th>Category</th>
  <th>Actions</th>
  </tr>
  </thead>
  <tbody>
  <tr v-for="product in paginatedProducts" :key="product.id">
  <td>{{ product.name }}</td>
  <td>{{ product.description }}</td>
  <td>{{ product.id }}</td>
  <td>{{ product.price }} €</td>
  <td>{{ product.category || "Undefined" }}</td>
  <td>
  <button @click="editProduct(product)">Edit</button>
  <button class="delete" @click="deleteProduct(product.id)">Delete</button>
  </td>
  </tr>
  </tbody>
  </table>
  <div class="pagination">
  <button @click="prevPage" :disabled="currentPage === 1">
         Previous page
  </button>
  <span>Page {{ currentPage }} of {{ totalPages }}</span>
  <button @click="nextPage" :disabled="currentPage === totalPages">
         Next page
  </button>
  </div>
  </div>
  </template>
  <script>
  import Admin from "../components/Admin.vue";
  export default {
   components: {
     Admin,
   },
   data() {
     return {
       products: [],
       currentPage: 1,
       itemsPerPage: 10,
       showAddProductForm: false,
       showEditProductForm: false,
       newProduct: {
         name: "",
         description: "",
         price: 0,
       },
       editedProduct: null,
     };
   },
   computed: {
     paginatedProducts() {
       const startIndex = (this.currentPage - 1) * this.itemsPerPage;
       const endIndex = startIndex + this.itemsPerPage;
       return this.products.slice(startIndex, endIndex);
     },
     totalPages() {
       return Math.ceil(this.products.length / this.itemsPerPage);
     },
   },
   methods: {
     fetchProducts() {
       const token = localStorage.getItem("token");
       fetch("http://localhost/api/products", {
         headers: { Authorization: `Bearer ${token}` },
       })
         .then((response) => response.json())
         .then((data) => {
           this.products = data["hydra:member"];
         })
         .catch((err) => console.error("Error loading products", err));
     },
     addProduct() {
       if (this.newProduct.price < 0) {
         alert("Price cannot be negative");
         return;
       }
       const token = localStorage.getItem("token");
       fetch("http://localhost/api/products", {
         method: "POST",
         headers: {
           Authorization: `Bearer ${token}`,
           "Content-Type": "application/json",
         },
         body: JSON.stringify(this.newProduct),
       })
         .then((response) => {
           if (!response.ok)
             throw new Error(`Error adding product: ${response.status}`);
           return response.json();
         })
         .then(() => {
           alert("Product added successfully");
           this.cancelAddProduct();
           this.fetchProducts();
         })
         .catch((err) => alert(`Error: ${err.message}`));
     },
     editProduct(product) {
       this.editedProduct = { ...product };
       this.showEditProductForm = true;
     },
     updateProduct() {
       if (this.editedProduct.price < 0) {
         alert("Price cannot be negative");
         return;
       }
       const token = localStorage.getItem("token");
       fetch(`http://localhost/api/products/${this.editedProduct.id}`, {
         method: "PUT",
         headers: {
           Authorization: `Bearer ${token}`,
           "Content-Type": "application/json",
         },
         body: JSON.stringify(this.editedProduct),
       })
         .then((response) => {
           if (!response.ok)
             throw new Error(`Error updating product: ${response.status}`);
           return response.json();
         })
         .then(() => {
           alert("Product updated successfully");
           this.showEditProductForm = false;
           this.fetchProducts();
         })
         .catch((err) => alert(`Error: ${err.message}`));
     },
     deleteProduct(productId) {
       const token = localStorage.getItem("token");
       fetch(`http://localhost/api/products/${productId}`, {
         method: "DELETE",
         headers: { Authorization: `Bearer ${token}` },
       }).then((response) => {
         if (response.ok) this.fetchProducts();
         else alert("Error deleting product");
       });
     },
     validatePrice() {
       if (this.newProduct.price < 0) this.newProduct.price = 0;
     },
     validateEditedPrice() {
       if (this.editedProduct.price < 0) this.editedProduct.price = 0;
     },
     cancelEdit() {
       this.showEditProductForm = false;
       this.editedProduct = null;
     },
     cancelAddProduct() {
       this.showAddProductForm = false;
       this.newProduct = { name: "", description: "", price: 0 };
     },
     nextPage() {
       if (this.currentPage < this.totalPages) {
         this.currentPage++;
       }
     },
     prevPage() {
       if (this.currentPage > 1) {
         this.currentPage--;
       }
     },
   },
   created() {
     this.fetchProducts();
   },
  };
  </script>
  <style scoped>
  .product-table {
   max-width: 95%;
   margin: auto;
   font-family: Arial, sans-serif;
  }
  table {
   width: 100%;
   border-collapse: collapse;
   margin-top: 20px;
   table-layout: fixed;
  }
  th {
   padding: 10px;
   text-align: left;
   border-bottom: 1px solid #ddd;
   overflow: hidden;
   word-wrap: break-word;
   background-color: #f4f4f4;
  }
  td {
   padding: 10px;
   text-align: left;
   border-bottom: 1px solid #ddd;
   overflow: hidden;
   word-wrap: break-word;
  }
  th:nth-child(2),
  td:nth-child(2) {
   width: 30%;
  }
  th:nth-child(1),
  td:nth-child(1),
  th:nth-child(3),
  td:nth-child(3),
  th:nth-child(4),
  td:nth-child(4),
  th:nth-child(5),
  td:nth-child(5),
  th:nth-child(6),
  td:nth-child(6) {
   width: 14%;
  }
  button {
   padding: 8px 12px;
   margin-right: 5px;
   border: none;
   cursor: pointer;
   color: white;
   border-radius: 4px;
   font-size: 14px;
   font-weight: bold;
   transition: background-color 0.3s ease, color 0.3s ease;
  }
  button:hover {
   color: white;
  }
  .add-new {
  float: right;
  margin: 10px;
  background-color: #e0e0e0; /* Gris clair */
  color: #757575; /* Gris pour le texte */
  cursor: not-allowed; /* Curseur désactivé */
  border: 1px solid #bdbdbd; /* Bordure gris moyen */
}
.add-new:hover {
  background-color: #e0e0e0; /* Pas de changement au survol */
  color: #757575;
}
  button:nth-child(1) {
   background-color: #bbdefb;
   color: #1565c0;
  }
  button:nth-child(1):hover {
   background-color: #90caf9;
  }
  .delete {
   background-color: #ffcdd2;
   color: #c62828;
  }
  .delete {
   background-color: #ef9a9a;
  }
  .pagination button {
   padding: 5px 10px;
   border: 1px solid #ddd;
   background: #333;
   cursor: pointer;
   color: white;
   margin-top: 10px;
  }
  .pagination button:disabled {
   background: #e9ecef;
   cursor: not-allowed;
   color: #999;
  }
  .product-form {
   display: flex;
   flex-direction: column;
   width: 30%;
   padding: 20px;
   background-color: white;
   border-radius: 8px;
   box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
   margin: 100px auto;
   text-align: left;
  }
  .product-form div {
   margin-bottom: 15px;
  }
  .product-form button {
   background-color: #999;
   color: white;
  }
  .product-form button:hover {
   background-color: #333;
  }
  .product-form button[type="submit"]:disabled {
   background-color: #f0f0f0;
   color: #bdbdbd;
   cursor: not-allowed;
  }
  </style>