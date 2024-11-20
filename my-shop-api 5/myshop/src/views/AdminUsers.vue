<template>
  <Admin />
  <div class="user-table">
    <h1>Manage Users</h1>
    <button v-if="!showAddUserForm" @click="showAddUserForm = true" class="add-new">Add New</button>

    <div v-if="showAddUserForm || isEditingUser" class="user-form">
      <h2>{{ isEditingUser ? 'Edit User' : 'Add a New User' }}</h2>
      <form @submit.prevent="isEditingUser ? updateUser() : addUser()">
        <div>
          <label for="name">Name:</label>
          <input type="text" v-model="newUser.fullName" required />
        </div>
        <div>
          <label for="email">Email:</label>
          <input type="email" v-model="newUser.email" required />
        </div>
        <div v-if="!isEditingUser">
          <label for="password">Password:</label>
          <input type="password" v-model="newUser.password" required />
        </div>
        <div>
          <label for="role">Role:</label>
          <select v-model="newUser.role" required>
            <option value="ROLE_ADMIN">ROLE_ADMIN</option>
            <option value="ROLE_USER">ROLE_USER</option>
          </select>
        </div>
        <button type="submit">
          {{ isEditingUser ? 'Update' : 'Save' }}
        </button>
        <button @click="cancelEdit" v-if="isEditingUser">Cancel</button>
        <button @click="cancelAdd" v-if="!isEditingUser">Cancel</button>
      </form>
    </div>

    <table v-if="paginatedUsers.length > 0">
      <thead>
        <tr>
          <th>Name</th>
          <th>Email</th>
          <th>Roles</th>
          <th>ID</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in paginatedUsers" :key="user.id">
          <td>{{ user.fullName || 'Name not available' }}</td>
          <td>{{ user.email }}</td>
          <td>{{ user.roles && user.roles.length > 0 ? user.roles.join(', ') : 'Roles not available' }}</td>
          <td>{{ user.id }}</td>
          <td>
            <button @click="editUser(user)" class="edit">Edit</button>
            <button @click="deleteUser(user.id)" class="delete">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-else>
      <p>No users available</p>
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
      users: [],
      user: null,
      showAddUserForm: false,
      isEditingUser: false,
      newUser: {
        fullName: '',
        email: '',
        password: '',
        role: 'ROLE_USER',
      },
      editingUserId: null,
      currentPage: 1,
      itemsPerPage: 10,
    };
  },
  computed: {
    paginatedUsers() {
      const startIndex = (this.currentPage - 1) * this.itemsPerPage;
      const endIndex = startIndex + this.itemsPerPage;
      return this.users.slice(startIndex, endIndex);
    },
    totalPages() {
      return Math.ceil(this.users.length / this.itemsPerPage);
    },
  },
  methods: {
    fetchUsers() {
      const token = localStorage.getItem('token');
      fetch('http://localhost/api/users', {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
        .then((response) => response.json())
        .then((data) => {
          this.users = data['hydra:member'];
          this.fetchCurrentUser();
        })
        .catch((err) => {
          console.error('Error loading users', err);
        });
    },
    fetchCurrentUser() {
      const token = localStorage.getItem('token');
      fetch('http://localhost/api/users/me', {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
        .then((response) => response.json())
        .then((data) => {
          this.user = data;
        })
        .catch((err) => {
          console.error('Error fetching current user data:', err);
        });
    },
    addUser() {
      const token = localStorage.getItem('token');
      const userData = {
        fullName: this.newUser.fullName,
        email: this.newUser.email,
        password: this.newUser.password,
        roles: [this.newUser.role],
      };
      fetch('http://localhost/api/users', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(userData),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error('Error adding user. Code: ' + response.status);
          }
          return response.json();
        })
        .then(() => {
          alert('User added successfully');
          this.cancelAdd();
          this.fetchUsers();
        })
        .catch((err) => {
          console.error('Error adding user:', err);
          alert('Error: ' + err.message);
        });
    },
    editUser(user) {
      this.isEditingUser = true;
      this.editingUserId = user.id;
      this.newUser = {
        fullName: user.fullName,
        email: user.email,
        role: user.roles[0],
      };
    },
    updateUser() {
      const token = localStorage.getItem('token');
      const userData = {
        fullName: this.newUser.fullName,
        email: this.newUser.email,
        roles: [this.newUser.role],
      };
      fetch(`http://localhost/api/users/${this.editingUserId}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(userData),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error('Error updating user. Code: ' + response.status);
          }
          return response.json();
        })
        .then(() => {
          alert('User updated successfully');
          this.resetUserForm();
          this.fetchUsers();
        })
        .catch((err) => {
          console.error('Error updating user:', err);
          alert('Error: ' + err.message);
        });
    },
    deleteUser(userId) {
      const token = localStorage.getItem('token');
      fetch(`http://localhost/api/users/${userId}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }).then((response) => {
        if (response.ok) {
          this.fetchUsers();
        } else {
          alert('Error deleting user');
        }
      });
    },
    resetUserForm() {
      this.newUser = { fullName: '', email: '', password: '', role: 'ROLE_USER' };
      this.showAddUserForm = false;
      this.isEditingUser = false;
      this.editingUserId = null;
    },
    cancelEdit() {
      this.resetUserForm();
    },
    cancelAdd() {
      this.resetUserForm();
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
    this.fetchUsers();
  },
};
</script>

<style scoped>
/* Table de gestion des utilisateurs */
.user-table {
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

th,
td {
  padding: 10px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background-color: #f4f4f4;
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
  background-color: #bbdefb;
  color: #1565c0;
}

button.edit:hover {
  background-color: #90caf9;
}

/* Bouton "Delete" */
button.delete {
  background-color: #ffcdd2;
  color: #c62828;
}

button.delete:hover {
  background-color: #ef9a9a;
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

/* Formulaire d'ajout/modification d'utilisateur */
.user-form {
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

.user-form div {
  margin-bottom: 15px;
}

.user-form button {
  background-color: #90caf9;
  color: #1565c0;
}

.user-form button:hover {
  background-color: #64b5f6;
}

.user-form button[type="submit"]:disabled {
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