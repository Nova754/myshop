<template>
  <div class="admin-dashboard">
    <h1>Admin Dashboard</h1>
    <nav>
      <router-link to="/admin/products" class="nav-link" aria-label="Manage Products">Products</router-link>
      <router-link to="/admin/categories" class="nav-link" aria-label="Manage Categories">Categories</router-link>
      <router-link to="/admin/users" class="nav-link" aria-label="Manage Users">Users</router-link>
    </nav>
  </div>
</template>

<script>
export default {
  name: "Admin",
};
</script>

<style scoped>
.admin-dashboard {
  text-align: center;
  font-family: 'Roboto', sans-serif;
  padding: 30px;
  background: linear-gradient(135deg, #eaeaea, #f5f5f5);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
  max-width: 100%;
  margin: 50px auto;
}

h1 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 30px;
}

nav {
  display: flex;
  justify-content: center;
  gap: 20px;
}

.nav-link {
  text-decoration: none;
  padding: 12px 25px;
  font-size: 1.1rem;
  font-weight: bold;
  color: white;
  background: #aaa;
  border-radius: 25px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}

.nav-link:hover {
  background: #aaa;
  transform: translateY(-2px);
}

.nav-link:active {
  background: #aaa;
  transform: scale(0.98);
}

body {
  background-color: #ecf0f3;
}
</style>