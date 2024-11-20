<template>
  <Admin />
  <div class="category-table">
    <h1>Manage Categories</h1>
    <button v-if="!showAddCategoryForm" @click="showAddCategoryForm = true" class="add-new">
      Add New
    </button>

    <div v-if="showAddCategoryForm || isEditingCategory" class="category-form">
      <h2>{{ isEditingCategory ? 'Edit Category' : 'Add a New Category' }}</h2>
      <form @submit.prevent="isEditingCategory ? updateCategory() : addCategory()">
        <div>
          <label for="name">Name:</label>
          <input type="text" v-model="newCategory.name" required />
        </div>
        <button type="submit">
          {{ isEditingCategory ? 'Update' : 'Save' }}
        </button>
        <button @click="cancelEdit" v-if="isEditingCategory">Cancel</button>
        <button @click="cancelAdd" v-if="!isEditingCategory">Cancel</button>
      </form>
    </div>

    <table v-if="paginatedCategories.length > 0">
      <thead>
        <tr>
          <th>Name</th>
          <th>ID</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="category in paginatedCategories" :key="category.id">
          <td>{{ category.name }}</td>
          <td>{{ category.id }}</td>
          <td>
            <button @click="editCategory(category)" class="edit">Edit</button>
            <button @click="deleteCategory(category.id)" class="delete">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-else>
      <p>No categories available</p>
    </div>

    <div class="pagination" v-if="totalPages > 1">
      <button @click="prevPage" :disabled="currentPage === 1">Previous page</button>
      <span>Page {{ currentPage }} of {{ totalPages }}</span>
      <button @click="nextPage" :disabled="currentPage === totalPages">Next page</button>
    </div>
  </div>
</template>

<script>
import Admin from '../components/Admin.vue';

export default {
  components: {
    Admin,
  },
  data() {
    return {
      categories: [],
      showAddCategoryForm: false,
      isEditingCategory: false,
      newCategory: {
        name: ''
      },
      editingCategoryId: null,
      currentPage: 1,
      itemsPerPage: 10,
    };
  },
  computed: {
    paginatedCategories() {
      const startIndex = (this.currentPage - 1) * this.itemsPerPage;
      const endIndex = startIndex + this.itemsPerPage;
      return this.categories.slice(startIndex, endIndex);
    },
    totalPages() {
      return Math.ceil(this.categories.length / this.itemsPerPage);
    },
  },
  methods: {
    fetchCategories() {
      const token = localStorage.getItem('token');
      fetch('http://localhost/api/categories', {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
        .then((response) => response.json())
        .then((data) => {
          this.categories = data['hydra:member'];
        })
        .catch((err) => {
          console.error('Error loading categories', err);
        });
    },
    addCategory() {
      const token = localStorage.getItem('token');
      fetch('http://localhost/api/categories', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(this.newCategory)
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error('Error adding category. Code: ' + response.status);
          }
          return response.json();
        })
        .then(() => {
          alert('Category added successfully');
          this.resetCategoryForm();
          this.fetchCategories();
        })
        .catch((err) => {
          console.error('Error adding category:', err);
          alert('Error: ' + err.message);
        });
    },
    editCategory(category) {
      this.isEditingCategory = true;
      this.editingCategoryId = category.id;
      this.newCategory = { ...category };
    },
    updateCategory() {
      const token = localStorage.getItem('token');
      fetch(`http://localhost/api/categories/${this.editingCategoryId}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(this.newCategory)
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error('Error updating category. Code: ' + response.status);
          }
          return response.json();
        })
        .then(() => {
          alert('Category updated successfully');
          this.resetCategoryForm();
          this.fetchCategories();
        })
        .catch((err) => {
          console.error('Error updating category:', err);
          alert('Error: ' + err.message);
        });
    },
    deleteCategory(categoryId) {
      const token = localStorage.getItem('token');
      fetch(`http://localhost/api/categories/${categoryId}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${token}`
        }
      }).then((response) => {
        if (response.ok) {
          this.fetchCategories();
        } else {
          alert('Error deleting category');
        }
      });
    },
    resetCategoryForm() {
      this.newCategory = { name: '' };
      this.showAddCategoryForm = false;
      this.isEditingCategory = false;
      this.editingCategoryId = null;
    },
    cancelEdit() {
      this.resetCategoryForm();
    },
    cancelAdd() {
      this.resetCategoryForm();
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
    this.fetchCategories();
  },
};
</script>

<style scoped>
/* Table de gestion des catégories */
.category-table {
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

th, td {
  padding: 10px;
  text-align: left;
  border-bottom: 1px solid #ddd;
  word-wrap: break-word;
}

th {
  background-color: #f4f4f4;
  overflow: hidden;
}

/* Boutons généraux */
button {
  padding: 8px 12px;
  margin-right: 5px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  font-weight: bold;
  color: white;
  transition: background-color 0.3s ease, color 0.3s ease;
}

button:hover {
  color: white;
  background-color: #333;
}

/* Bouton "Edit" */
button.edit {
  background-color: #bbdefb; /* Couleur principale pour Edit */
  color: #1565c0;
}

button.edit:hover {
  background-color: #90caf9; /* Couleur plus sombre au survol */
}

/* Bouton "Delete" */
button.delete {
  background-color: #ffcdd2; /* Couleur principale pour Delete */
  color: #c62828;
}

button.delete:hover {
  background-color: #ef9a9a; /* Couleur plus sombre au survol */
}

/* Bouton "Add New" désactivé */
.add-new {
  float: right;
  margin: 10px;
  background-color: #e0e0e0;
  color: #757575;
  cursor: not-allowed;
  border: 1px solid #bdbdbd;
}

.add-new:hover {
  background-color: #e0e0e0;
  color: #757575;
}

/* Formulaire d'ajout/modification de catégorie */
.category-form {
  display: flex;
  flex-direction: column;
  width: 30%;
  padding: 20px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  margin: 50px auto;
  text-align: left;
}

.category-form div {
  margin-bottom: 15px;
}

.category-form button {
  background-color: #90caf9;
  color: #1565c0;
}

.category-form button:hover {
  background-color: #64b5f6;
}

.category-form button[type="submit"]:disabled {
  background-color: #f0f0f0;
  color: #bdbdbd;
  cursor: not-allowed;
}

/* Pagination */
.pagination {
  margin: 20px 0;
  display: flex;
  justify-content: center;
  gap: 10px;
}

.pagination button {
  padding: 5px 10px;
  border: 1px solid #ddd;
  background-color: #333;
  color: white;
  cursor: pointer;
}

.pagination button:disabled {
  background-color: #e9ecef;
  color: #999;
  cursor: not-allowed;
}
</style>