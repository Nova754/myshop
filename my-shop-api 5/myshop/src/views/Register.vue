<template>
  <div class="register">
    <div class="register-form">
      <h1>Sign Up</h1>
      <form @submit.prevent="handleRegister">
        <div class="form-group">
          <label for="fullName">Full Name</label>
          <input
            v-model="fullName"
            type="text"
            id="fullName"
            placeholder="Full Name"
            required
          />
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input
            v-model="email"
            type="email"
            id="email"
            placeholder="Email"
            required
          />
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input
            v-model="password"
            type="password"
            id="password"
            placeholder="Password"
            required
          />
        </div>
        <button type="submit">Sign Up</button>
      </form>
      <p class="login-link">
        Already have an account? <router-link to="/login">Log in here</router-link>
      </p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      fullName: '',
      email: '',
      password: '',
    };
  },
  methods: {
    handleRegister() {
      const token = localStorage.getItem('token');
      if (!token) {
        alert("You need to be logged in to create a new user.");
        return;
      }

      const newUser = {
        fullName: this.fullName.trim(),
        email: this.email.trim(),
        password: this.password.trim(),
      };

      fetch('http://localhost/api/users', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify(newUser),
      })
        .then((response) => {
          if (!response.ok) {
            return response.json().then((errorData) => {
              throw new Error(`Registration error. Details: ${JSON.stringify(errorData)}`);
            });
          }
          return response.json();
        })
        .then(() => {
          alert('Registration successful! You can now log in.');
          this.$router.push('/login');
        })
        .catch((err) => {
          console.error('Registration error:', err);
          alert(`Registration error: ${err.message}`);
        });
    },
  },
};
</script>

<style scoped>
.register {
  display: flex;
  justify-content: center;
  height: 100vh;
  background-color: #f9f9f9;
}
.register-form {
  width: 450px;
  height: 360px;
  margin: 100px auto;
  padding: 20px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
}

h1 {
  font-size: 24px;
  margin-bottom: 20px;
  color: #333;
}

form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-group {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  text-align: left;
}

label {
  font-size: 14px;
  font-weight: bold;
  margin-bottom: 5px;
}

input {
  width: 95%;
  padding: 10px;
  border: 1px solid #f5f9fc;
  border-radius: 4px;
  background-color: #f5f9fc;
  color: #898989;
  font-size: 14px;
  outline: none;
}

input:focus {
  border-color: #898989;
  box-shadow: 0 0 4px rgba(47, 47, 47, 0.25);
}

button {
  background-color: #767676;
  color: #fff;
  border: none;
  padding: 10px 15px;
  font-size: 16px;
  font-weight: normal;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #333;
}

.login-link {
  margin-top: 20px;
  font-size: 14px;
  color: #888;
  text-decoration: none;
}

.login-link a {
  color: #888;
  text-decoration: none;
}

.login-link a:hover {
  text-decoration: underline;
}
</style>