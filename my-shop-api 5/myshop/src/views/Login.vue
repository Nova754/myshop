<template>
  <div class="login-container">
    <form @submit.prevent="handleLogin" class="login-form">
      <h1>Login</h1>
      <div class="formGroup">
        <label for="user_login" class="form-label">Email</label>
        <input v-model="email" type="email" placeholder="Email" required />
      </div>
      <div class="formGroup">
        <label for="user_password" class="form-label">Password</label>
        <input v-model="password" type="password" placeholder="Password" required />
      </div>
      <div class="formGroup">
        <button type="submit" class="login-button">Login</button>
      </div>
      <p class="register-text">
        Don’t have an account? <a href="/register" class="register-link">Register here</a>
      </p>
      <router-link class="forgot-password" to="/reset-password-request">
        Forgot password?
      </router-link>
    </form>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      email: "",
      password: "",
    };
  },
  methods: {
    handleLogin() {
      this.$store
        .dispatch("login", { email: this.email, password: this.password })
        .then(() => {
          this.$router.push("/admin/products");
        })
        .catch((err) => {
          alert("Login error: " + err.message);
        });
    },
  },
};
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  height: 100vh;
  background-color: #f9f9f9;
}

h1 {
  font-size: 24px;
  margin-bottom: 20px;
  color: #333;
}

.login-form {
  display: flex;
  flex-direction: column;
  width: 450px;
  height: 330px;
  padding: 20px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  text-align: center;
  justify-content: center;
  margin-top: 100px;
}

.formGroup {
  margin-bottom: 20px;
  text-align: left;
}

.form-label {
  display: block;
  font-weight: bold;
  margin-bottom: 5px;
  color: #333;
}

input {
  width: 95%;
  padding: 10px;
  border: 1px solid #f5f9fc;
  border-radius: 4px;
  background-color: #f5f9fc;
  color: #888;
  font-size: 14px;
  outline: none;
}

.login-button {
  width: 100%;
  padding: 10px;
  font-size: 16px;
  color: white;
  background-color: #898989;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.login-button:hover {
  background-color: #333;
}

.register-text {
  text-align: center;
  font-size: 14px;
  color: #888;
}

.register-link {
  color: #888;
  text-decoration: none;
}

.register-link:hover {
  text-decoration: underline;
}

.forgot-password {
  display: block;
  text-align: center;
  font-size: 14px;
  color: #888;
  text-decoration: none;
  cursor: pointer;
}

.forgot-password:hover {
  text-decoration: underline;
}
</style>